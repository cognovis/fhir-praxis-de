#!/usr/bin/env bash
# DEPRECATED (fmgt-5ff): This script managed release/publish/version-sync operations
# that are now owned by fhir-management. Use fhir-management commands instead:
#   uv run fhir-release publish
#   uv run fhir-release update-package-list
#   uv run fhir-graph lock
# See fhir-management docs/release-migration.md for the migration map.
# This script is kept for reference during the transition period.

# scripts/release.sh — single, idempotent, drift-safe FHIR release orchestrator (ADR-006).
#
# Wires the existing release scripts into one enforced sequence. It is the
# "durchgehender Prozess": run it and the whole release happens (or each step
# no-ops if already current). It NEVER runs git — pin bumps + commits are a
# deliberate PRE-step (scripts/sync-release-versions.sh + PR), not this script.
#
# Sequence (each step gates the next via set -e):
#   1. release-fhir-packages.sh  — verify-and-refuse (lock == checkout version,
#      clean tree, terminology drift guard) + idempotent npm publish of ALL FHIR
#      packages (IGs + terminology). Skips versions already on npm.cognovis.de.
#   2. advance-package-list.sh   — verify the IG@version is on npm, THEN advance
#      the public package-list.json pointer (verify-before-write). Idempotent.
#   3. release-fhir-ig.sh        — build the IG website (IG Publisher) + QA-gate
#      (refuse on internal errors) + rsync deploy to the public web root.
#   4. git tag v<version>        — tag the IG repo (idempotent) → triggers
#      ig-release.yml → "Create GitHub Release". The only git this orchestrator
#      does, and only to MARK an already-published, already-committed version.
#
# Idempotency: a re-run with nothing changed is safe — publish skips (already on
# registry), the pointer is re-set to the same version, the site is rebuilt and
# rsynced (content-identical → no-op transfer). So running it now also fixes a
# lagging package-list pointer as a side effect (step 2), even when steps 1/3
# are effectively no-ops.
#
# Usage:
#   VERDACCIO_TOKEN=<token> scripts/release.sh [--ig <name>] [--skip-site] [--dry-run]
#
#   --ig <name>    IG whose pointer + website are released (default: praxis).
#                  Only de.cognovis.fhir.* IGs are mapped (praxis, dental).
#   --skip-site    Skip step 3 (no IG Publisher build / rsync). Use when only the
#                  npm packages + pointer need to move.
#   --dry-run      Steps 1 + 3 run in their own dry-run mode (build/verify, no
#                  publish, no rsync). Step 2 (pointer write) is SKIPPED entirely
#                  in dry-run since it has no dry-run mode and mutates the proxy.
#
# Environment:
#   VERDACCIO_TOKEN  npm.cognovis.de auth. Optional — release-fhir-packages.sh
#                    and advance-package-list.sh fall back to the ambient ~/.npmrc
#                    when unset. Supplied locally; never from 1Password.
#   CODE_ROOT        Parent dir of sibling repos. Default: parent of this repo.
#   FHIR_PROXY_SSH   Optional. ssh destination of the public web-root host (e.g.
#                    user@fhir-proxy, reachable via netbird). When set, steps 2+3
#                    deploy to it over ssh (package-list via curl→update→scp, site
#                    via rsync -e ssh) — so the release runs from any machine. When
#                    unset, they write the local /opt/fhir-proxy path (run on the
#                    proxy host). Inherited by the sub-scripts.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CODE_ROOT="${CODE_ROOT:-$(dirname "$REPO_ROOT")}"

# ───────── Args ─────────
IG="praxis"
SKIP_SITE=false
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --ig) ;;                                   # value consumed below
    --ig=*) IG="${arg#--ig=}" ;;
    --skip-site) SKIP_SITE=true ;;
    --dry-run)   DRY_RUN=true ;;
    *) ;;
  esac
done
# Support "--ig <name>" (space-separated) as well as "--ig=<name>".
prev=""
for arg in "$@"; do
  [[ "$prev" == "--ig" ]] && IG="$arg"
  prev="$arg"
done

# ───────── IG → package-id / repo-dir map (fail-closed) ─────────
declare -A IG_PKG=(
  [praxis]="de.cognovis.fhir.praxis"
  [dental]="de.cognovis.fhir.dental"
)
declare -A IG_REPO=(
  [praxis]="$REPO_ROOT"
  [dental]="$CODE_ROOT/fhir-dental-de"
)
if [[ -z "${IG_PKG[$IG]:-}" ]]; then
  echo "ERROR: unknown --ig '$IG'. Mapped IGs: ${!IG_PKG[*]}." >&2
  echo "  (de-identification uses a different id scheme and is not auto-mapped — advance/deploy it manually.)" >&2
  exit 2
fi
PKG_ID="${IG_PKG[$IG]}"
IG_REPO_DIR="${IG_REPO[$IG]}"
PUBLIC_IG_PATH="https://fhir.cognovis.de/$IG"

if [[ ! -f "$IG_REPO_DIR/sushi-config.yaml" ]]; then
  echo "ERROR: sushi-config.yaml not found for IG '$IG' at $IG_REPO_DIR" >&2
  exit 1
fi
IG_VERSION="$(grep '^version:' "$IG_REPO_DIR/sushi-config.yaml" | awk '{print $2}' | tr -d '"')"

REL_PKGS="$SCRIPT_DIR/release-fhir-packages.sh"
ADVANCE="$SCRIPT_DIR/advance-package-list.sh"
REL_IG="$SCRIPT_DIR/release-fhir-ig.sh"
for s in "$REL_PKGS" "$ADVANCE" "$REL_IG"; do
  [[ -f "$s" ]] || { echo "ERROR: required sub-script missing: $s" >&2; exit 1; }
done

log()  { echo ""; echo "═══ [release] $* ═══"; }

log "Orchestrating release: ig=$IG package=$PKG_ID version=$IG_VERSION dry-run=$DRY_RUN skip-site=$SKIP_SITE"

# ─────────────────────────────────────────────────────────────────────────────
# Step 1 — Build + publish ALL FHIR packages (idempotent; verify-and-refuse).
# ─────────────────────────────────────────────────────────────────────────────
log "Step 1/4: release-fhir-packages.sh"
if [[ "$DRY_RUN" == "true" ]]; then
  bash "$REL_PKGS" --dry-run
else
  bash "$REL_PKGS"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Step 2 — Advance the public package-list.json pointer (verify-before-write).
#          Skipped in dry-run (it has no dry-run mode and mutates the proxy).
# ─────────────────────────────────────────────────────────────────────────────
if [[ "$DRY_RUN" == "true" ]]; then
  log "Step 2/4: advance-package-list.sh — SKIPPED (--dry-run)"
else
  log "Step 2/4: advance-package-list.sh ($PKG_ID@$IG_VERSION)"
  bash "$ADVANCE" \
    --package-id "$PKG_ID" \
    --version "$IG_VERSION" \
    --public-ig-path "$PUBLIC_IG_PATH" \
    --package-list "/opt/fhir-proxy/html/$IG/package-list.json"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Step 3 — Build + deploy the IG website.
# ─────────────────────────────────────────────────────────────────────────────
if [[ "$SKIP_SITE" == "true" ]]; then
  log "Step 3/4: release-fhir-ig.sh — SKIPPED (--skip-site)"
else
  log "Step 3/4: release-fhir-ig.sh --ig $IG"
  if [[ "$DRY_RUN" == "true" ]]; then
    bash "$REL_IG" --ig "$IG" --dry-run
  else
    bash "$REL_IG" --ig "$IG"
  fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# Step 4 — Tag the release (idempotent). A pushed v<version> tag triggers
#          ig-release.yml → "Create GitHub Release". Tags are separate refs (not
#          subject to branch protection); this only MARKS an already-published,
#          already-committed version, so it stays consistent with the
#          no-source-commit philosophy of the other scripts.
# ─────────────────────────────────────────────────────────────────────────────
TAG="v$IG_VERSION"
if [[ "$DRY_RUN" == "true" ]]; then
  log "Step 4/4: TAG — would create + push $TAG in $(basename "$IG_REPO_DIR") (--dry-run)"
elif git -C "$IG_REPO_DIR" rev-parse -q --verify "refs/tags/$TAG" >/dev/null 2>&1 \
  || git -C "$IG_REPO_DIR" ls-remote --exit-code --tags origin "$TAG" >/dev/null 2>&1; then
  log "Step 4/4: TAG — $TAG already exists (local or origin) — skipping"
else
  log "Step 4/4: TAG — creating + pushing $TAG ($(basename "$IG_REPO_DIR"))"
  git -C "$IG_REPO_DIR" tag -a "$TAG" -m "Release $IG_VERSION"
  git -C "$IG_REPO_DIR" push origin "$TAG"
fi

log "Release complete: $PKG_ID@$IG_VERSION (ig=$IG)"