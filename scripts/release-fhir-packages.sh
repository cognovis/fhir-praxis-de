#!/usr/bin/env bash
# Script 1 (ADR-006): Build and publish all FHIR packages to npm.cognovis.de.
#
# Driven by fhir-versions.lock.yaml in the fhir-terminology-de sibling checkout.
# Idempotent: packages already on npm.cognovis.de at the pinned version are skipped.
# Verify-and-refuse: if ANY sibling checkout version != lock pin, exits non-zero
# before publishing ANYTHING.
#
# Usage:
#   VERDACCIO_TOKEN=<token> ./scripts/release-fhir-packages.sh [--dry-run]
#
# Environment:
#   VERDACCIO_TOKEN   Required. npm.cognovis.de auth token (cognovis:<token>, base64-encoded).
#   CODE_ROOT         Optional. Parent dir of sibling repos. Default: parent of this repo.
#   LOCK_FILE         Optional. Path to fhir-versions.lock.yaml. Default: derived from CODE_ROOT.
#
# This script NEVER runs git commit, git tag, or git push.
# "Publishing" = npm publish to npm.cognovis.de ONLY.
#
# Release sequence (ADR-006):
#   0. Bump + commit version pins (fhir-sync-versions skill) — done BEFORE this script.
#   1. Run this script → FHIR packages live on npm.cognovis.de.
#   2. Run Script 2 (downstream SDK/codegen repo) → SDK + Aidbox (separate bead).
#   3. Optionally run scripts/build-local-ig.sh → IG Publisher HTML site for one IG.

set -euo pipefail

# ───────── Configuration ─────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CODE_ROOT="${CODE_ROOT:-$(dirname "$REPO_ROOT")}"
LOCK_FILE="${LOCK_FILE:-$CODE_ROOT/fhir-terminology-de/fhir-versions.lock.yaml}"
NPM_REGISTRY="https://npm.cognovis.de"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# ───────── Credentials ─────────
if [[ -z "${VERDACCIO_TOKEN:-}" ]]; then
  echo "ERROR: VERDACCIO_TOKEN is not set." >&2
  echo "Supply it as an environment variable — not from 1Password:" >&2
  echo "  VERDACCIO_TOKEN=<token> $0" >&2
  exit 1
fi

# Write auth to a temp .npmrc — never modify the global one.
NPMRC_TMP=$(mktemp)
trap 'rm -f "$NPMRC_TMP"' EXIT
{
  echo "//npm.cognovis.de/:_auth=$(printf '%s' "cognovis:${VERDACCIO_TOKEN}" | base64)"
  echo "//npm.cognovis.de/:always-auth=true"
} > "$NPMRC_TMP"
export NPM_CONFIG_USERCONFIG="$NPMRC_TMP"

# ───────── Logging helpers ─────────
log()         { echo "[release-fhir-packages] $*"; }
log_ok()      { echo "[release-fhir-packages] OK    $*"; }
log_skip()    { echo "[release-fhir-packages] SKIP  $*"; }
log_pub()     { echo "[release-fhir-packages] PUB   $*"; }
log_note()    { echo "[release-fhir-packages] NOTE  $*"; }
log_err()     { echo "[release-fhir-packages] ERROR $*" >&2; }

# ───────── Helpers ─────────

# Returns 0 (true) if pkg@version is already published on the registry.
is_published() {
  local pkg="$1" ver="$2"
  local http_code
  http_code=$(curl -sf -o /dev/null -w "%{http_code}" \
    --max-time 15 "$NPM_REGISTRY/$pkg/$ver" 2>/dev/null || echo "000")
  [[ "$http_code" == "200" ]]
}

# Pack and publish a pre-built package directory.
# Idempotent: EPUBLISHCONFLICT / 409 treated as success.
publish_dir() {
  local pkg_dir="$1" pkg_id="$2" ver="$3"
  local tmpdir pub_log pub_exit tgz
  tmpdir=$(mktemp -d)

  npm pack "$pkg_dir" --pack-destination "$tmpdir" --ignore-scripts >/dev/null 2>&1
  tgz=$(find "$tmpdir" -maxdepth 1 -name '*.tgz' -print -quit)
  if [[ -z "$tgz" ]]; then
    log_err "npm pack produced no tgz for $pkg_id@$ver (dir: $pkg_dir)"
    rm -rf "$tmpdir"
    return 1
  fi

  pub_log=$(npm publish "$tgz" --registry "$NPM_REGISTRY" --ignore-scripts 2>&1) \
    && pub_exit=0 || pub_exit=$?

  rm -rf "$tmpdir"

  if [[ "$pub_exit" -eq 0 ]]; then
    log_pub "$pkg_id@$ver"
    return 0
  fi
  if echo "$pub_log" | grep -qE "EPUBLISHCONFLICT|already_published|409|cannot publish over"; then
    log_skip "$pkg_id@$ver (conflict — already on registry)"
    return 0
  fi
  log_err "npm publish failed for $pkg_id@$ver: $pub_log"
  return "$pub_exit"
}

# ───────── Pre-flight ─────────
if [[ ! -f "$LOCK_FILE" ]]; then
  log_err "Lock file not found: $LOCK_FILE"
  log_err "Expected: $CODE_ROOT/fhir-terminology-de/fhir-versions.lock.yaml"
  log_err "Ensure the fhir-terminology-de sibling repo is checked out."
  exit 1
fi

log "Lock file : $LOCK_FILE"
log "Registry  : $NPM_REGISTRY"
log "Code root : $CODE_ROOT"
[[ "$DRY_RUN" == "true" ]] && log "DRY RUN   : no packages will be published"
echo ""

# ───────── Parse lock file ─────────
LOCK_JSON=$(python3 - <<PYEOF
import yaml, json, sys

with open("$LOCK_FILE") as f:
    lock = yaml.safe_load(f)

# Bundles are being eliminated per ADR-006 (downstream bead) — skip them.
output = {
    "igs": lock.get("igs", {}),
    "packages": lock.get("packages", {}),
}
print(json.dumps(output))
PYEOF
)

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 1 — Verify-and-refuse: check ALL versions before publishing ANYTHING.
# ─────────────────────────────────────────────────────────────────────────────
log "=== Phase 1: Verify-and-refuse (all version checks before any publish) ==="
ERRORS=0

# --- Check IG checkouts ---
while IFS= read -r pkg_id; do
  lock_ver=$(echo "$LOCK_JSON" | python3 -c \
    "import json,sys; d=json.load(sys.stdin); print(d['igs']['$pkg_id']['version'])")

  # Naming convention: de.cognovis.fhir.X → ~/code/fhir-X-de
  repo_suffix="${pkg_id#de.cognovis.fhir.}"
  repo_dir="$CODE_ROOT/fhir-${repo_suffix}-de"

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
    log_ok  "$pkg_id @ $lock_ver  ($repo_dir)"
  fi
done < <(echo "$LOCK_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); [print(k) for k in d['igs']]")

# --- Check terminology packages ---
TERM_REPO="$CODE_ROOT/fhir-terminology-de"
while IFS= read -r pkg_id; do
  lock_ver=$(echo "$LOCK_JSON" | python3 -c \
    "import json,sys; d=json.load(sys.stdin); print(d['packages']['$pkg_id']['version'])")
  pkg_dir="$TERM_REPO/packages/$pkg_id"

  if [[ ! -d "$pkg_dir" ]]; then
    # ETL-generated packages have no committed package dir — note and skip check.
    log_note "$pkg_id — no committed package dir (ETL-generated); version check skipped"
    continue
  fi

  if [[ ! -f "$pkg_dir/package.json" ]]; then
    log_err "package.json missing: $pkg_dir/package.json"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  checkout_ver=$(python3 -c \
    "import json; print(json.load(open('$pkg_dir/package.json'))['version'])")
  if [[ "$checkout_ver" != "$lock_ver" ]]; then
    log_err "VERSION MISMATCH: $pkg_id"
    log_err "  lock pin   : $lock_ver"
    log_err "  package.json: $checkout_ver  ($pkg_dir/package.json)"
    ERRORS=$((ERRORS + 1))
  else
    log_ok  "$pkg_id @ $lock_ver"
  fi
done < <(echo "$LOCK_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); [print(k) for k in d['packages']]")

if [[ "$ERRORS" -gt 0 ]]; then
  echo ""
  log_err "=== VERIFY-AND-REFUSE: $ERRORS mismatch(es). NOTHING was published. ==="
  exit 1
fi

echo ""
log "=== All versions verified OK. ==="
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 2 — Publish
# ─────────────────────────────────────────────────────────────────────────────
log "=== Phase 2: Publish ==="
PUBLISHED=0
SKIPPED=0

# --- Publish IG packages (SUSHI build required) ---
while IFS= read -r pkg_id; do
  lock_ver=$(echo "$LOCK_JSON" | python3 -c \
    "import json,sys; d=json.load(sys.stdin); print(d['igs']['$pkg_id']['version'])")

  if is_published "$pkg_id" "$lock_ver"; then
    log_skip "$pkg_id @ $lock_ver"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  repo_suffix="${pkg_id#de.cognovis.fhir.}"
  repo_dir="$CODE_ROOT/fhir-${repo_suffix}-de"

  log "Building $pkg_id @ $lock_ver via SUSHI ($(basename "$repo_dir"))..."
  if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN: would build and publish $pkg_id @ $lock_ver"
    continue
  fi

  if [[ ! -f "$repo_dir/scripts/build-package.sh" ]]; then
    log_err "No scripts/build-package.sh in $repo_dir"
    exit 1
  fi

  (cd "$repo_dir" && bash scripts/build-package.sh)

  tgz=$(find "$repo_dir/dist" -maxdepth 1 -name '*.tgz' -print -quit 2>/dev/null || true)
  if [[ -z "$tgz" ]]; then
    log_err "No .tgz in $repo_dir/dist/ after build-package.sh"
    exit 1
  fi

  pub_log=$(npm publish "$tgz" --registry "$NPM_REGISTRY" --ignore-scripts 2>&1) \
    && pub_exit=0 || pub_exit=$?

  if [[ "$pub_exit" -eq 0 ]]; then
    log_pub "$pkg_id @ $lock_ver"
    PUBLISHED=$((PUBLISHED + 1))
  elif echo "$pub_log" | grep -qE "EPUBLISHCONFLICT|already_published|409|cannot publish over"; then
    log_skip "$pkg_id @ $lock_ver (conflict)"
    SKIPPED=$((SKIPPED + 1))
  else
    log_err "npm publish failed for $pkg_id @ $lock_ver: $pub_log"
    exit "$pub_exit"
  fi
done < <(echo "$LOCK_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); [print(k) for k in d['igs']]")

# --- Publish terminology packages (pre-built, pack from packages/ dir) ---
while IFS= read -r pkg_id; do
  lock_ver=$(echo "$LOCK_JSON" | python3 -c \
    "import json,sys; d=json.load(sys.stdin); print(d['packages']['$pkg_id']['version'])")
  pkg_dir="$TERM_REPO/packages/$pkg_id"

  if [[ ! -d "$pkg_dir" ]]; then
    log_note "$pkg_id — no committed package dir (ETL-generated); skipping publish"
    continue
  fi

  if is_published "$pkg_id" "$lock_ver"; then
    log_skip "$pkg_id @ $lock_ver"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN: would publish $pkg_id @ $lock_ver from $pkg_dir"
    continue
  fi

  publish_dir "$pkg_dir" "$pkg_id" "$lock_ver"
  PUBLISHED=$((PUBLISHED + 1))
done < <(echo "$LOCK_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); [print(k) for k in d['packages']]")

echo ""
log "=== Done. Published: $PUBLISHED  Skipped (already on registry): $SKIPPED ==="
