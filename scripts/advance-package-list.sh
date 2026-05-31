#!/usr/bin/env bash
# Advance the public package-list.json pointer on fhir.cognovis.de — locally,
# AFTER an npm publish, in strict verify-before-write order (ADR-006, fpde-qsc).
#
# This replaces the old ig-release.yml `update-package-list` CI job, which wrote
# the public pointer BEFORE checking npm — so a failed verify left the public
# package-list pointing at a version that was not on the registry. Here the npm
# check gates the write: the pointer can never lead the registry.
#
# Order (never reorder):
#   1. VERIFY the package@version IS on npm.cognovis.de (npm-only check).
#   2. Only on success → ADVANCE package-list.json (update-package-list-remote.py).
#   3. Then full publication VERIFY (incl. the public package-list).
#
# Run this AFTER scripts/release-fhir-packages.sh (Script 1) confirms the publish.
# It is intentionally a separate, explicit step — Script 1 does NOT call it.
#
# Usage:
#   scripts/advance-package-list.sh \
#     [--package-id de.cognovis.fhir.praxis] \
#     [--version <X.Y.Z>] \              # default: VERSION file
#     [--public-ig-path https://fhir.cognovis.de/praxis] \
#     [--package-list <path>] \         # default: /opt/fhir-proxy/html/praxis/package-list.json
#     [--registry https://npm.cognovis.de] \
#     [--repository <owner/repo>]       # default: $GITHUB_REPOSITORY, for the GitHub-release check
#
# Environment:
#   VERDACCIO_TOKEN  Optional. Auth for the npm registry read (private packages).
#
# The remote package-list path must be reachable from where this runs (e.g. the
# releaser machine on the internal network, or the fhir-proxy host). The default
# targets the praxis pointer; pass --package-id/--public-ig-path/--package-list
# for other IGs (e.g. dental).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ───────── Defaults ─────────
PACKAGE_ID="de.cognovis.fhir.praxis"
VERSION=""
PUBLIC_IG_PATH="https://fhir.cognovis.de/praxis"
PACKAGE_LIST="/opt/fhir-proxy/html/praxis/package-list.json"
REGISTRY="https://npm.cognovis.de"
REPOSITORY="${GITHUB_REPOSITORY:-cognovis/fhir-praxis-de}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --package-id)     PACKAGE_ID="$2"; shift 2 ;;
    --version)        VERSION="$2"; shift 2 ;;
    --public-ig-path) PUBLIC_IG_PATH="$2"; shift 2 ;;
    --package-list)   PACKAGE_LIST="$2"; shift 2 ;;
    --registry)       REGISTRY="$2"; shift 2 ;;
    --repository)     REPOSITORY="$2"; shift 2 ;;
    -h|--help)        sed -n '2,38p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

# Default version = VERSION file in this repo.
if [[ -z "$VERSION" ]]; then
  VERSION="$(tr -d '[:space:]' < "$REPO_ROOT/VERSION")"
fi

VERIFY="$REPO_ROOT/.github/scripts/verify-fhir-release-publication.py"
UPDATE="$REPO_ROOT/.github/scripts/update-package-list-remote.py"
for f in "$VERIFY" "$UPDATE"; do
  if [[ ! -f "$f" ]]; then
    echo "ERROR: required helper not found: $f" >&2
    exit 1
  fi
done

log() { echo "[advance-package-list] $*"; }

log "package : $PACKAGE_ID@$VERSION"
log "registry: $REGISTRY"
log "pointer : $PACKAGE_LIST"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# STEP 1 — VERIFY-BEFORE-WRITE: the package@version MUST already be on npm.
#          npm-only (skip github-release + public-package-list, which are not yet
#          advanced at this point).
# ─────────────────────────────────────────────────────────────────────────────
log "Step 1: verifying $PACKAGE_ID@$VERSION is on $REGISTRY (npm-only gate)..."
if ! python3 "$VERIFY" \
      --package-id "$PACKAGE_ID" \
      --version "$VERSION" \
      --public-ig-path "$PUBLIC_IG_PATH" \
      --registry "$REGISTRY" \
      --repository "$REPOSITORY" \
      --skip-github-release \
      --skip-public-package-list; then
  echo "[advance-package-list] ERROR: $PACKAGE_ID@$VERSION is NOT on $REGISTRY." >&2
  echo "[advance-package-list]   Run scripts/release-fhir-packages.sh first; refusing to advance the public pointer ahead of the registry." >&2
  exit 1
fi
log "Step 1 OK: package confirmed on registry."
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2 — ADVANCE the public package-list.json pointer (only reached after the
#          npm check passed).
# ─────────────────────────────────────────────────────────────────────────────
TODAY="$(date -u +%Y-%m-%d)"
log "Step 2: advancing package-list.json → $VERSION ($TODAY)..."
# PACKAGE_LIST_EXACT_PATH_ONLY=true: update ONLY the explicit path (otherwise
# update-package-list-remote.py scans nginx config + filesystem roots and rewrites
# every package-list.json it finds).
if [[ -n "${FHIR_PROXY_SSH:-}" ]]; then
  # Remote mode: the web root lives on another host (ssh / netbird), not here.
  # Fetch the current PUBLIC package-list, update it locally, push it back over ssh
  # — no privileged local /opt path needed, so this runs from any machine.
  tmp_pl=$(mktemp)
  if ! curl -fsS --max-time 30 "$PUBLIC_IG_PATH/package-list.json" -o "$tmp_pl"; then
    echo "[advance-package-list] ERROR: could not fetch $PUBLIC_IG_PATH/package-list.json" >&2
    rm -f "$tmp_pl"; exit 1
  fi
  PACKAGE_LIST_EXACT_PATH_ONLY=true \
    python3 "$UPDATE" "$VERSION" "$TODAY" "$PACKAGE_ID" "$PUBLIC_IG_PATH" "$tmp_pl"
  log "Pushing updated package-list to $FHIR_PROXY_SSH:$PACKAGE_LIST ..."
  if ! scp -q "$tmp_pl" "$FHIR_PROXY_SSH:$PACKAGE_LIST"; then
    echo "[advance-package-list] ERROR: scp to $FHIR_PROXY_SSH:$PACKAGE_LIST failed (ssh/netbird reachable?)." >&2
    rm -f "$tmp_pl" "$tmp_pl.bak"; exit 1
  fi
  rm -f "$tmp_pl" "$tmp_pl.bak"
else
  # Local mode: the web root is on THIS host (run on the proxy host or a mount).
  PACKAGE_LIST_EXACT_PATH_ONLY=true \
    python3 "$UPDATE" "$VERSION" "$TODAY" "$PACKAGE_ID" "$PUBLIC_IG_PATH" "$PACKAGE_LIST"
fi
log "Step 2 OK: pointer advanced."
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3 — Full publication VERIFY (now including the public package-list).
# ─────────────────────────────────────────────────────────────────────────────
log "Step 3: full publication verify (registry + github-release + public package-list)..."
python3 "$VERIFY" \
  --package-id "$PACKAGE_ID" \
  --version "$VERSION" \
  --public-ig-path "$PUBLIC_IG_PATH" \
  --registry "$REGISTRY" \
  --repository "$REPOSITORY"
log "Step 3 OK: $PACKAGE_ID@$VERSION verified on all public release surfaces."
