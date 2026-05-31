#!/usr/bin/env bash
# DEPRECATED (fmgt-5ff): This script managed release/publish/version-sync operations
# that are now owned by fhir-management. Use fhir-management commands instead:
#   uv run fhir-release publish
#   uv run fhir-release update-package-list
#   uv run fhir-graph lock
# See fhir-management docs/release-migration.md for the migration map.
# This script is kept for reference during the transition period.

# Script 3 (ADR-006): Build the rendered IG website locally and deploy via rsync.
#
# This is "Script 3" from ADR-006: builds the IG Publisher HTML site for the
# selected IG, gates on QA quality, and deploys to the public web root via rsync.
# Decoupled from package publishing (Script 1) and SDK orchestration (Script 2).
#
# Usage:
#   scripts/release-fhir-ig.sh [--ig <name>] [--dry-run]
#
# Options:
#   --ig <name>    IG to build and deploy (default: praxis). Controls the rsync
#                  deploy target: /opt/fhir-proxy/html/<name>/
#   --dry-run      Build and QA-gate, but skip rsync and post-deploy verify.
#
# Steps:
#   1. BUILD    — preload private FHIR packages + run IG Publisher via _genonce.sh
#   2. QA-GATE  — abort if internal errors > 0 (before any rsync)
#   3. DEPLOY   — rsync output/ to /opt/fhir-proxy/html/<ig>/ (skipped on --dry-run)
#   4. VERIFY   — fetch the public IG path and confirm served version matches
#                 (skipped on --dry-run)
#
# No git operations. "Deploy" = rsync to the local web root only.
#
# Environment:
#   VERDACCIO_TOKEN       Optional. Auth token for private FHIR package registry
#                         (passed through to scripts/preload-private-fhir-packages.sh).
#   FHIR_IG_PUBLIC_BASE   Optional. Public URL base for post-deploy version verify.
#                         Default: https://fhir.cognovis.de
#   FHIR_IG_DEPLOY_BASE   Optional. Local filesystem deploy root.
#                         Default: /opt/fhir-proxy/html
#
# Release sequence (ADR-006, Script 3 is the deploy half):
#   0. Bump + commit version pins (fhir-sync-versions) — done BEFORE this script.
#   1. scripts/release-fhir-packages.sh — FHIR packages live on npm.cognovis.de.
#   2. Script 2 (downstream SDK/codegen repo) — SDK + Aidbox (separate bead).
#   3. scripts/release-fhir-ig.sh — IG Publisher HTML built and deployed (this script).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ───────── Defaults ─────────
IG_NAME="praxis"
DRY_RUN=false
FHIR_IG_PUBLIC_BASE="${FHIR_IG_PUBLIC_BASE:-https://fhir.cognovis.de}"
FHIR_IG_DEPLOY_BASE="${FHIR_IG_DEPLOY_BASE:-/opt/fhir-proxy/html}"
QA_ALLOWLIST="${REPO_ROOT}/.github/qa-allowlist.yml"

# ───────── Argument parsing ─────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --ig)
      IG_NAME="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      sed -n '2,31p' "$0"
      exit 0
      ;;
    *)
      echo "ERROR: Unknown argument: $1" >&2
      echo "Usage: $0 [--ig <name>] [--dry-run]" >&2
      exit 2
      ;;
  esac
done

DEPLOY_TARGET="${FHIR_IG_DEPLOY_BASE}/${IG_NAME}"
PUBLIC_URL="${FHIR_IG_PUBLIC_BASE}/${IG_NAME}"
OUTPUT_DIR="${REPO_ROOT}/output"
QA_HTML="${OUTPUT_DIR}/qa.html"

log() {
  echo "[release-fhir-ig] $*"
}

# ───────── IG name validation ─────────
# Verify that --ig matches the sushi-config.yaml `id` field (last dot-segment)
# so that a mismatch (e.g. running fhir-praxis-de's script with --ig dental)
# is caught early rather than deploying the wrong IG to the wrong web root.
SUSHI_CONFIG="${REPO_ROOT}/sushi-config.yaml"
if [[ -f "$SUSHI_CONFIG" ]]; then
  SUSHI_ID=$(grep -E '^id:[[:space:]]+' "$SUSHI_CONFIG" | head -1 | awk '{print $2}')
  # Derive the short IG name from the package id (last dot-segment)
  # e.g. de.cognovis.fhir.praxis → praxis
  SUSHI_SHORT="${SUSHI_ID##*.}"
  if [[ -n "$SUSHI_SHORT" && "$SUSHI_SHORT" != "$IG_NAME" ]]; then
    echo "ERROR: --ig '$IG_NAME' does not match this repo's IG id '$SUSHI_ID' (short: '$SUSHI_SHORT')." >&2
    echo "Run this script from the '${IG_NAME}' IG repository, or omit --ig to use the repo default." >&2
    exit 1
  fi
fi

log "IG: $IG_NAME | dry-run: $DRY_RUN"
log "Deploy target: $DEPLOY_TARGET"
log "Public URL:    $PUBLIC_URL"
echo ""

# ──────────────────────────────────────────────────
# Step 1: BUILD — preload private packages + IG Publisher
# ──────────────────────────────────────────────────
log "Step 1: BUILD — preload private FHIR packages + run IG Publisher"

BUILD_SCRIPT="${REPO_ROOT}/scripts/build-local-ig.sh"
if [[ ! -f "$BUILD_SCRIPT" ]]; then
  echo "ERROR: build script not found at $BUILD_SCRIPT" >&2
  exit 1
fi

# Clean output/ before the build so stale rendered files from a previous build
# (removed profiles, an old version's pages) can never linger and get deployed.
rm -rf "$OUTPUT_DIR"

"$BUILD_SCRIPT"

if [[ ! -d "$OUTPUT_DIR" ]]; then
  echo "ERROR: IG Publisher build did not produce output/ at $OUTPUT_DIR" >&2
  exit 1
fi

log "Step 1 complete: output/ produced"
echo ""

# ──────────────────────────────────────────────────
# Step 2: QA-GATE — abort before deploy if internal errors > 0
# ──────────────────────────────────────────────────
log "Step 2: QA-GATE — checking $QA_HTML"

QA_GATE="${REPO_ROOT}/scripts/qa_gate.py"
if [[ ! -f "$QA_GATE" ]]; then
  echo "ERROR: qa_gate.py not found at $QA_GATE" >&2
  exit 1
fi
if [[ ! -f "$QA_HTML" ]]; then
  echo "ERROR: qa.html not found at $QA_HTML" >&2
  echo "IG Publisher may not have completed successfully." >&2
  exit 1
fi
if [[ ! -f "$QA_ALLOWLIST" ]]; then
  echo "ERROR: qa-allowlist.yml not found at $QA_ALLOWLIST" >&2
  exit 1
fi

if ! python3 "$QA_GATE" --qa-html "$QA_HTML" --allowlist "$QA_ALLOWLIST"; then
  echo "" >&2
  echo "ERROR: QA gate failed — aborting before any rsync deploy." >&2
  exit 1
fi

log "Step 2 complete: QA gate passed"
echo ""

# ──────────────────────────────────────────────────
# Step 3: DEPLOY — rsync output/ to per-IG web root
# (skipped on --dry-run)
# ──────────────────────────────────────────────────
if [[ "$DRY_RUN" == "true" ]]; then
  log "Step 3: DEPLOY — SKIPPED (--dry-run)"
  log "Step 4: VERIFY — SKIPPED (--dry-run)"
  echo ""
  log "Dry-run complete: build and QA gate passed; no files were deployed."
  exit 0
fi

log "Step 3: DEPLOY — rsyncing output/ to ${FHIR_PROXY_SSH:+$FHIR_PROXY_SSH:}$DEPLOY_TARGET/"

# Shared rsync flags: trailing slash sends the CONTENTS of output/ into the target;
# --delete prunes stale files from prior builds; --checksum avoids serving stale
# content on equal mtimes; --exclude package-list.json keeps the curated public
# release-history (owned by advance-package-list.sh) from being overwritten/deleted
# by the IG Publisher's ci-build stub.
RSYNC_FLAGS=(-av --delete --checksum --exclude 'package-list.json')

if [[ -n "${FHIR_PROXY_SSH:-}" ]]; then
  # Remote mode: the web root lives on another host (ssh / netbird). Deploy over
  # ssh so this can run from any machine (e.g. the local releaser laptop).
  if ! ssh "$FHIR_PROXY_SSH" "mkdir -p '$DEPLOY_TARGET'"; then
    echo "ERROR: could not create $DEPLOY_TARGET on $FHIR_PROXY_SSH (is it reachable via ssh/netbird?)." >&2
    exit 1
  fi
  if ! rsync "${RSYNC_FLAGS[@]}" -e ssh "${OUTPUT_DIR}/" "${FHIR_PROXY_SSH}:${DEPLOY_TARGET}/"; then
    echo "" >&2
    echo "ERROR: rsync over ssh to $FHIR_PROXY_SSH:$DEPLOY_TARGET failed." >&2
    exit 1
  fi
else
  # Local mode: the web root is on THIS host (run on the proxy host or a mount).
  if [[ ! -d "$FHIR_IG_DEPLOY_BASE" ]]; then
    echo "ERROR: deploy root not found: $FHIR_IG_DEPLOY_BASE" >&2
    echo "Set FHIR_PROXY_SSH=<user@host> to deploy over ssh, or mount the fhir-proxy path here." >&2
    exit 1
  fi
  mkdir -p "$DEPLOY_TARGET"
  if ! rsync "${RSYNC_FLAGS[@]}" "${OUTPUT_DIR}/" "${DEPLOY_TARGET}/"; then
    echo "" >&2
    echo "ERROR: rsync failed — deploy target may be unreachable or permission denied." >&2
    exit 1
  fi
fi

log "Step 3 complete: output/ rsynced to $DEPLOY_TARGET/"
echo ""

# ──────────────────────────────────────────────────
# Step 4: VERIFY — fetch the public IG and confirm served version matches
# ──────────────────────────────────────────────────
log "Step 4: VERIFY — confirming public site serves the released version"

# Read expected version from output/package.json (produced by IG Publisher).
# Fall back to the VERSION file if package.json is absent.
PACKAGE_JSON="${OUTPUT_DIR}/package.json"
if [[ -f "$PACKAGE_JSON" ]]; then
  EXPECTED_VERSION="$(python3 -c "import json, sys; d=json.load(open('${PACKAGE_JSON}')); print(d['version'])")"
else
  echo "WARNING: output/package.json not found — falling back to VERSION file" >&2
  EXPECTED_VERSION="$(tr -d '[:space:]' < "$REPO_ROOT/VERSION")"
fi

PUBLIC_PACKAGE_URL="${PUBLIC_URL}/package.json"
log "Fetching $PUBLIC_PACKAGE_URL to confirm version=$EXPECTED_VERSION"

HTTP_CODE=$(curl -sI -o /dev/null -w '%{http_code}' --max-time 15 "$PUBLIC_PACKAGE_URL" 2>/dev/null || echo "000")
# Retry as GET on 405 Method Not Allowed (some servers reject HEAD for .json)
if [[ "$HTTP_CODE" == "405" ]]; then
  HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 15 "$PUBLIC_PACKAGE_URL" 2>/dev/null || echo "000")
fi

if [[ ! "$HTTP_CODE" =~ ^(2|3) ]]; then
  echo "ERROR: Could not reach $PUBLIC_PACKAGE_URL (HTTP $HTTP_CODE)." >&2
  echo "Post-deploy verify failed — confirm the public URL is reachable and retry." >&2
  echo "To skip verify, set FHIR_IG_SKIP_VERIFY=1 (only for development/staging use)." >&2
  if [[ "${FHIR_IG_SKIP_VERIFY:-0}" == "1" ]]; then
    echo "WARNING: FHIR_IG_SKIP_VERIFY=1 — skipping verify (rsync succeeded)." >&2
    log "Step 4: SKIPPED (FHIR_IG_SKIP_VERIFY=1)"
    log "Release deployed (verify manually): $IG_NAME@$EXPECTED_VERSION → $DEPLOY_TARGET/"
    exit 0
  fi
  exit 1
fi

SERVED_JSON=$(curl -sf --max-time 15 "$PUBLIC_PACKAGE_URL" 2>/dev/null || echo "")
if [[ -z "$SERVED_JSON" ]]; then
  echo "ERROR: $PUBLIC_PACKAGE_URL returned an empty body." >&2
  echo "Post-deploy verify failed — the web server may not have picked up the new files yet." >&2
  if [[ "${FHIR_IG_SKIP_VERIFY:-0}" == "1" ]]; then
    echo "WARNING: FHIR_IG_SKIP_VERIFY=1 — skipping verify (rsync succeeded)." >&2
    log "Step 4: SKIPPED (FHIR_IG_SKIP_VERIFY=1)"
    log "Release deployed (verify manually): $IG_NAME@$EXPECTED_VERSION → $DEPLOY_TARGET/"
    exit 0
  fi
  exit 1
fi

SERVED_VERSION=$(echo "$SERVED_JSON" | python3 -c \
  "import json, sys; d=json.load(sys.stdin); print(d.get('version', ''))" 2>/dev/null || echo "")

if [[ -z "$SERVED_VERSION" ]]; then
  echo "ERROR: Could not parse 'version' from $PUBLIC_PACKAGE_URL." >&2
  echo "Post-deploy verify failed — the served file may not be valid JSON." >&2
  if [[ "${FHIR_IG_SKIP_VERIFY:-0}" == "1" ]]; then
    echo "WARNING: FHIR_IG_SKIP_VERIFY=1 — skipping verify (rsync succeeded)." >&2
    log "Step 4: SKIPPED (FHIR_IG_SKIP_VERIFY=1)"
    log "Release deployed (verify manually): $IG_NAME@$EXPECTED_VERSION → $DEPLOY_TARGET/"
    exit 0
  fi
  exit 1
fi

if [[ "$SERVED_VERSION" == "$EXPECTED_VERSION" ]]; then
  log "Step 4 complete: public site confirms version=$SERVED_VERSION"
  echo ""
  log "Release complete: $IG_NAME@$EXPECTED_VERSION deployed to $PUBLIC_URL"
  exit 0
else
  echo "" >&2
  echo "ERROR: Version mismatch after deploy." >&2
  echo "  Expected: $EXPECTED_VERSION" >&2
  echo "  Served:   $SERVED_VERSION" >&2
  echo "Check the rsync target and web server cache." >&2
  exit 1
fi