#!/usr/bin/env bash
# Script 1 (ADR-006): Build and publish all FHIR packages to npm.cognovis.de.
#
# fhir-praxis-de is the orchestration hub. This script does NOT reimplement
# per-repo build/publish logic — it delegates to each sibling repo's existing,
# tested chain:
#   - IG repos (praxis, dental): scripts/build-package.sh (SUSHI) → publish tgz
#   - terminology repo:          scripts/build.sh (ETL) → scripts/publish.sh
#
# Driven by fhir-versions.lock.yaml, which lives in THIS repo (the orchestration
# hub, ADR-006/fpde-x8r), as the single source of truth for IG version pins.
#
# Idempotent: packages already on npm.cognovis.de at the pinned version are
# skipped (IG: authenticated `npm view`; terminology: publish.sh's own
# already-published check).
#
# Verify-and-refuse: if ANY in-scope sibling checkout fails its pre-publish
# guard (version mismatch OR dirty working tree), exits non-zero before
# publishing ANYTHING.
#
# Usage:
#   VERDACCIO_TOKEN=<token> ./scripts/release-fhir-packages.sh [--dry-run] [--allow-dirty]
#
# Environment:
#   VERDACCIO_TOKEN   Required. npm.cognovis.de auth token (raw token; the script
#                     base64-encodes "cognovis:<token>" for the temp .npmrc and
#                     also exports it as NODE_AUTH_TOKEN for the terminology
#                     publish.sh delegate).
#   CODE_ROOT         Optional. Parent dir of sibling repos. Default: parent of this repo.
#   LOCK_FILE / FHIR_LOCK_FILE  Optional. Path to fhir-versions.lock.yaml.
#                     Default: this repo's local copy (the hub).
#
# This script NEVER runs git commit, git tag, or git push.
# "Publishing" = npm publish to npm.cognovis.de ONLY.
#
# Release sequence (ADR-006):
#   0. Bump + commit version pins (fhir-sync-versions skill) — done BEFORE this script.
#   1. Run this script → FHIR packages live on npm.cognovis.de.
#   2. Run Script 2 (downstream SDK/codegen repo) → SDK + Aidbox (separate bead).
#   3. Run scripts/advance-package-list.sh → verify-on-npm, then advance the public
#      package-list.json pointer on fhir.cognovis.de (verify-before-write). This is
#      a SEPARATE explicit step — this script does NOT advance the pointer itself.
#   4. Optionally run scripts/build-local-ig.sh → IG Publisher HTML site for one IG.

set -euo pipefail

# Associative arrays (IG_REPO_DIR) require bash 4+. macOS ships bash 3.2 as
# /bin/bash; this script expects a modern bash (homebrew bash, or Linux).
if (( BASH_VERSINFO[0] < 4 )); then
  echo "ERROR: this script requires bash 4+ (found ${BASH_VERSION}). On macOS: brew install bash." >&2
  exit 1
fi

# ───────── Configuration ─────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CODE_ROOT="${CODE_ROOT:-$(dirname "$REPO_ROOT")}"
# Lock resolution (ADR-006/fpde-x8r: canonical home is THIS hub repo).
#   1. $LOCK_FILE / $FHIR_LOCK_FILE override
#   2. local hub copy ($REPO_ROOT/fhir-versions.lock.yaml) — canonical
#   3. legacy fhir-terminology-de sibling (transition fallback)
if [[ -z "${LOCK_FILE:-}" ]]; then
  LOCK_FILE="${FHIR_LOCK_FILE:-}"
fi
if [[ -z "$LOCK_FILE" ]]; then
  if [[ -f "$REPO_ROOT/fhir-versions.lock.yaml" ]]; then
    LOCK_FILE="$REPO_ROOT/fhir-versions.lock.yaml"
  else
    LOCK_FILE="$CODE_ROOT/fhir-terminology-de/fhir-versions.lock.yaml"
  fi
fi
TERM_REPO="$CODE_ROOT/fhir-terminology-de"
NPM_REGISTRY="https://npm.cognovis.de"
DRY_RUN=false
ALLOW_DIRTY=false
for arg in "$@"; do
  case "$arg" in
    --dry-run)     DRY_RUN=true ;;
    --allow-dirty) ALLOW_DIRTY=true ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

# Explicit IG id → sibling repo directory map. Avoids fragile prefix stripping
# that silently no-ops for ids outside the de.cognovis.fhir.* namespace
# (critique #3). Only ids listed here are treated as IG checkouts; any IG in the
# lock without a mapping is a hard error in verify-and-refuse.
declare -A IG_REPO_DIR=(
  [de.cognovis.fhir.praxis]="$CODE_ROOT/fhir-praxis-de"
  [de.cognovis.fhir.dental]="$CODE_ROOT/fhir-dental-de"
)

# ───────── Credentials ─────────
# Two auth modes:
#   (a) VERDACCIO_TOKEN set  -> write a temp .npmrc (CI / explicit token).
#   (b) no token             -> use the ambient ~/.npmrc (the normal local case;
#                               npm view/publish read it automatically). We verify
#                               it actually authenticates before proceeding.
if [[ -n "${VERDACCIO_TOKEN:-}" ]]; then
  NPMRC_TMP=$(mktemp)
  trap 'rm -f "$NPMRC_TMP"' EXIT
  {
    echo "//npm.cognovis.de/:_auth=$(printf '%s' "cognovis:${VERDACCIO_TOKEN}" | base64 | tr -d '\n')"
    echo "//npm.cognovis.de/:_authToken=${VERDACCIO_TOKEN}"
    echo "//npm.cognovis.de/:always-auth=true"
  } > "$NPMRC_TMP"
  export NPM_CONFIG_USERCONFIG="$NPMRC_TMP"
  export NODE_AUTH_TOKEN="$VERDACCIO_TOKEN"
else
  # Fall back to the ambient ~/.npmrc. Do NOT override NPM_CONFIG_USERCONFIG —
  # let npm read the user's existing config. Probe a known private package to
  # confirm the registry actually authenticates (a read-protected registry
  # would otherwise make every package look unpublished).
  if npm view de.cognovis.fhir.praxis version --registry "$NPM_REGISTRY" >/dev/null 2>&1; then
    echo "[release-fhir-packages] VERDACCIO_TOKEN not set — using ambient ~/.npmrc (authenticated)."
  else
    echo "ERROR: no VERDACCIO_TOKEN and ~/.npmrc does not authenticate to $NPM_REGISTRY." >&2
    echo "  Either run 'npm login --registry $NPM_REGISTRY' or pass VERDACCIO_TOKEN=<token>." >&2
    exit 1
  fi
fi

# ───────── Logging helpers ─────────
log()         { echo "[release-fhir-packages] $*"; }
log_ok()      { echo "[release-fhir-packages] OK    $*"; }
log_skip()    { echo "[release-fhir-packages] SKIP  $*"; }
log_pub()     { echo "[release-fhir-packages] PUB   $*"; }
log_note()    { echo "[release-fhir-packages] NOTE  $*"; }
log_err()     { echo "[release-fhir-packages] ERROR $*" >&2; }

# ───────── Helpers ─────────

# Returns 0 (true) if pkg@version is already published on the registry.
# Uses authenticated `npm view` against the temp .npmrc (critique #2) so that a
# read-protected Verdaccio still answers correctly instead of always reporting
# "not published".
is_published() {
  local pkg="$1" ver="$2" found
  found=$(npm view "$pkg@$ver" version --registry "$NPM_REGISTRY" --silent 2>/dev/null || true)
  [[ "$found" == "$ver" ]]
}

# Verify-and-refuse guard for a single git checkout: working tree must be clean
# (critique #5 — a dirty tree at the right version number would publish
# uncommitted content). Honors --allow-dirty for local iteration.
check_tree_clean() {
  local repo_dir="$1" label="$2"
  # Always validate the path is a real git checkout — even under --allow-dirty,
  # which only relaxes the dirty-tree check, not the is-it-git check (fail closed).
  if ! git -C "$repo_dir" rev-parse --git-dir >/dev/null 2>&1; then
    log_err "$label: not a git checkout: $repo_dir"
    return 1
  fi
  if [[ "$ALLOW_DIRTY" == "true" ]]; then
    return 0
  fi
  if [[ -n "$(git -C "$repo_dir" status --porcelain)" ]]; then
    log_err "$label: working tree is dirty at $repo_dir"
    log_err "  Commit or stash changes (or pass --allow-dirty for a local test). Refusing to publish uncommitted content."
    return 1
  fi
  return 0
}

# ───────── Pre-flight ─────────
if [[ ! -f "$LOCK_FILE" ]]; then
  log_err "Lock file not found: $LOCK_FILE"
  log_err "Expected: $REPO_ROOT/fhir-versions.lock.yaml (hub) or set \$FHIR_LOCK_FILE."
  log_err "Ensure the fhir-terminology-de sibling repo is checked out."
  exit 1
fi

log "Lock file : $LOCK_FILE"
log "Registry  : $NPM_REGISTRY"
log "Code root : $CODE_ROOT"
[[ "$DRY_RUN" == "true" ]]     && log "DRY RUN   : no packages will be published"
[[ "$ALLOW_DIRTY" == "true" ]] && log "ALLOW-DIRTY: clean-tree guard disabled"
echo ""

# ───────── Parse lock file (IG pins only; terminology owns its own versions) ─────────
IG_IDS=$(python3 - "$LOCK_FILE" <<'PYEOF'
import yaml, sys
with open(sys.argv[1]) as f:
    lock = yaml.safe_load(f)
for k in lock.get("igs", {}):
    print(k)
PYEOF
)

ig_lock_version() {
  python3 - "$LOCK_FILE" "$1" <<'PYEOF'
import yaml, sys
with open(sys.argv[1]) as f:
    lock = yaml.safe_load(f)
print(lock["igs"][sys.argv[2]]["version"])
PYEOF
}

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 1 — Verify-and-refuse: check ALL guards before publishing ANYTHING.
# ─────────────────────────────────────────────────────────────────────────────
log "=== Phase 1: Verify-and-refuse (all guards before any publish) ==="
ERRORS=0

# --- IG checkouts: explicit repo map + version pin + clean tree ---
while IFS= read -r pkg_id; do
  [[ -z "$pkg_id" ]] && continue
  lock_ver=$(ig_lock_version "$pkg_id")
  repo_dir="${IG_REPO_DIR[$pkg_id]:-}"

  if [[ -z "$repo_dir" ]]; then
    log_err "No sibling-repo mapping for IG '$pkg_id'. Add it to IG_REPO_DIR in this script."
    ERRORS=$((ERRORS + 1))
    continue
  fi
  if [[ ! -d "$repo_dir" ]]; then
    log_err "Sibling checkout not found: $repo_dir  (for $pkg_id)"
    ERRORS=$((ERRORS + 1))
    continue
  fi
  if [[ ! -f "$repo_dir/sushi-config.yaml" ]]; then
    log_err "sushi-config.yaml missing in $repo_dir"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  checkout_ver=$(grep '^version:' "$repo_dir/sushi-config.yaml" | awk '{print $2}')
  if [[ "$checkout_ver" != "$lock_ver" ]]; then
    log_err "VERSION MISMATCH: $pkg_id"
    log_err "  lock pin   : $lock_ver"
    log_err "  checkout   : $checkout_ver  ($repo_dir/sushi-config.yaml)"
    log_err "  Fix: run fhir-sync-versions skill, commit, then re-run this script."
    ERRORS=$((ERRORS + 1))
  else
    log_ok  "$pkg_id @ $lock_ver  ($(basename "$repo_dir"))"
  fi

  check_tree_clean "$repo_dir" "$pkg_id" || ERRORS=$((ERRORS + 1))

  # Verify the delegate build script exists NOW (Phase 1), not mid-publish, so a
  # missing delegate cannot cause a partial release after earlier IGs published.
  if [[ ! -f "$repo_dir/scripts/build-package.sh" ]]; then
    log_err "$pkg_id: delegate scripts/build-package.sh missing in $repo_dir"
    ERRORS=$((ERRORS + 1))
  fi
done <<< "$IG_IDS"

# --- Terminology repo: clean tree + drift guard (its own source of truth) ---
if [[ ! -d "$TERM_REPO" ]]; then
  log_err "Terminology repo not found: $TERM_REPO"
  ERRORS=$((ERRORS + 1))
else
  check_tree_clean "$TERM_REPO" "fhir-terminology-de" || ERRORS=$((ERRORS + 1))

  # The terminology repo owns its package versions (build.sh + write_bundle_packages)
  # and ships check-fhir-version-drift.sh to assert committed files match the lock.
  # Delegate the version-pin verification to it instead of re-deriving it here.
  DRIFT_GUARD="$TERM_REPO/scripts/check-fhir-version-drift.sh"
  if [[ -x "$DRIFT_GUARD" ]]; then
    if (cd "$TERM_REPO" && bash scripts/check-fhir-version-drift.sh) >/tmp/fhir-drift.log 2>&1; then
      log_ok "fhir-terminology-de version drift guard passed"
    else
      log_err "fhir-terminology-de version drift guard FAILED (see /tmp/fhir-drift.log):"
      tail -20 /tmp/fhir-drift.log >&2 || true
      ERRORS=$((ERRORS + 1))
    fi
  else
    log_err "check-fhir-version-drift.sh not found/executable in terminology repo ($DRIFT_GUARD)."
    log_err "  Cannot verify terminology version pins — refusing to publish. Reinstall the terminology repo's scripts."
    ERRORS=$((ERRORS + 1))
  fi

  # Verify the terminology delegate chain exists NOW (Phase 1), not mid-publish.
  for delegate in build.sh publish.sh; do
    if [[ ! -f "$TERM_REPO/scripts/$delegate" ]]; then
      log_err "fhir-terminology-de: delegate scripts/$delegate missing"
      ERRORS=$((ERRORS + 1))
    fi
  done
fi

if [[ "$ERRORS" -gt 0 ]]; then
  echo ""
  log_err "=== VERIFY-AND-REFUSE: $ERRORS guard failure(s). NOTHING was published. ==="
  exit 1
fi

echo ""
log "=== All guards passed. ==="
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 2 — Publish
# ─────────────────────────────────────────────────────────────────────────────
log "=== Phase 2: Publish ==="
IG_PUBLISHED=0
IG_SKIPPED=0

# --- IG packages: SUSHI build via each repo's build-package.sh, then publish tgz ---
while IFS= read -r pkg_id; do
  [[ -z "$pkg_id" ]] && continue
  lock_ver=$(ig_lock_version "$pkg_id")
  repo_dir="${IG_REPO_DIR[$pkg_id]}"

  if is_published "$pkg_id" "$lock_ver"; then
    log_skip "$pkg_id @ $lock_ver (already on registry)"
    IG_SKIPPED=$((IG_SKIPPED + 1))
    continue
  fi

  log "Building $pkg_id @ $lock_ver via SUSHI ($(basename "$repo_dir"))..."
  if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN: would build and publish $pkg_id @ $lock_ver"
    continue
  fi

  if [[ ! -f "$repo_dir/scripts/build-package.sh" ]]; then
    log_err "No scripts/build-package.sh in $repo_dir"
    exit 1
  fi

  # Clear stale tarballs first. build-package.sh only clears dist/package/, not
  # dist/*.tgz, so a leftover tarball from a prior build could otherwise be
  # selected and published (advisory BLOCKER #1).
  rm -f "$repo_dir/dist"/*.tgz 2>/dev/null || true

  (cd "$repo_dir" && bash scripts/build-package.sh)

  tgz=$(find "$repo_dir/dist" -maxdepth 1 -name '*.tgz' -print -quit 2>/dev/null || true)
  if [[ -z "$tgz" ]]; then
    log_err "No .tgz in $repo_dir/dist/ after build-package.sh"
    exit 1
  fi

  # Verify the freshly built tarball actually carries the pinned package id and
  # version before publishing it (advisory BLOCKER #1: never publish content that
  # does not match what verify-and-refuse approved).
  tgz_meta=$(tar -xzO -f "$tgz" package/package.json 2>/dev/null \
    | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['name'], d['version'])" 2>/dev/null || true)
  tgz_name="${tgz_meta% *}"
  tgz_ver="${tgz_meta#* }"
  if [[ "$tgz_name" != "$pkg_id" || "$tgz_ver" != "$lock_ver" ]]; then
    log_err "Built tarball metadata mismatch for $pkg_id @ $lock_ver"
    log_err "  tarball   : ${tgz_name:-<none>}@${tgz_ver:-<none>}  ($tgz)"
    log_err "  expected  : $pkg_id@$lock_ver"
    log_err "  Refusing to publish a tarball that does not match the pinned id/version."
    exit 1
  fi

  pub_log=$(npm publish "$tgz" --registry "$NPM_REGISTRY" --ignore-scripts --tag latest 2>&1) \
    && pub_exit=0 || pub_exit=$?

  if [[ "$pub_exit" -eq 0 ]]; then
    log_pub "$pkg_id @ $lock_ver"
    IG_PUBLISHED=$((IG_PUBLISHED + 1))
  elif echo "$pub_log" | grep -qE "EPUBLISHCONFLICT|already_published|409|cannot publish over"; then
    log_skip "$pkg_id @ $lock_ver (conflict — already on registry)"
    IG_SKIPPED=$((IG_SKIPPED + 1))
  else
    log_err "npm publish failed for $pkg_id @ $lock_ver: $pub_log"
    exit "$pub_exit"
  fi
done <<< "$IG_IDS"

# --- Terminology packages: delegate to the terminology repo's ETL build + publish.
#     build.sh materializes ALL packages (including ETL-generated leaves that have
#     no committed packages/<id>/ dir — critique #1). publish.sh is itself
#     idempotent and authenticated (critique #2, #4). ---
log "Building + publishing terminology packages via fhir-terminology-de chain..."
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY RUN: would run fhir-terminology-de scripts/build.sh && scripts/publish.sh"
else
  if [[ ! -f "$TERM_REPO/scripts/build.sh" ]] || [[ ! -f "$TERM_REPO/scripts/publish.sh" ]]; then
    log_err "Terminology repo is missing scripts/build.sh or scripts/publish.sh"
    exit 1
  fi
  (cd "$TERM_REPO" && bash scripts/build.sh)
  # publish.sh reports its own per-package PUB/SKIP lines and is idempotent.
  (cd "$TERM_REPO" && bash scripts/publish.sh)
  log_ok "Terminology packages built and published via fhir-terminology-de chain"
fi

echo ""
log "=== Done. IG published: $IG_PUBLISHED  IG skipped: $IG_SKIPPED  Terminology: delegated to fhir-terminology-de ==="
