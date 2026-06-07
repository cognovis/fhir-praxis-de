#!/usr/bin/env bash
# Fail when published IG pagecontent links to internal ADR markdown files.
#
# Scans input/pagecontent/ only. Catches:
#   - plain docs/adr/ path references
#   - relative adr/ADR-*.md references
#   - github.com/.../blob/.../docs/adr/ URL references

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

TARGET_DIR="input/pagecontent"

if [ ! -d "$TARGET_DIR" ]; then
  echo "ERROR: $TARGET_DIR not found."
  exit 1
fi

TRACKED_FILES=()
while IFS= read -r -d '' path; do
  TRACKED_FILES+=("$path")
done < <(git ls-files -z -- "$TARGET_DIR")

if [ "${#TRACKED_FILES[@]}" -eq 0 ]; then
  echo "IG pagecontent ADR-link guard skipped: no tracked files under $TARGET_DIR."
  exit 0
fi

PATTERN='docs/adr/|(^|[^[:alnum:]_/])adr/ADR-|github\.com/[^/[:space:]]+/blob/[^/[:space:]]+/docs/adr/'

if command -v rg >/dev/null 2>&1; then
  MATCHES="$(rg -n -i -e 'docs/adr/' -e '(^|[^[:alnum:]_/])adr/ADR-' -e 'github\.com/[^/[:space:]]+/blob/[^/[:space:]]+/docs/adr/' "${TRACKED_FILES[@]}" || true)"
else
  MATCHES="$(grep -I -n -i -E "$PATTERN" "${TRACKED_FILES[@]}" || true)"
fi

if [ -n "$MATCHES" ]; then
  echo "ERROR: ADR link or path reference found in published IG pagecontent."
  echo ""
  echo "$MATCHES"
  echo ""
  echo "Published IG pages must be self-contained. State decision outcomes inline"
  echo "instead of linking to docs/adr/ or ADR markdown files."
  exit 1
fi

echo "IG pagecontent ADR-link guard passed."
