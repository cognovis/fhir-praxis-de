#!/usr/bin/env bash
# Fail if public repository surfaces contain product-, project-, or adapter-specific names.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Keep generic PVS language allowed; block concrete product/project identifiers.
# Terms are encoded so this guard can scan its own source without self-matching.
TERMS=(
  $'\x63\x68\x61\x72\x6c\x79'
  $'\x73\x6f\x6c\x75\x74\x69\x6f'
  $'\x73\x6f\x6c\x75\x63\x69\x6f'
  $'\x6d\x69\x72\x61'
  $'\x70\x6f\x6c\x61\x72\x69\x73'
  $'\x6b\x72\x61\x62\x6c\x6c\x69\x6e\x6b'
  $'\x77\x69\x6e\x61\x63\x73'
  $'\x6d\x65\x64\x61\x74\x69\x78\x78'
  $'\x64\x61\x6d\x70\x73\x6f\x66\x74'
  $'\x65\x76\x69\x64\x65\x6e\x74'
  $'\x74\x6f\x6d\x65\x64\x6f'
  $'\x65\x70\x69\x6b\x75\x72'
  $'\x78[-._ ]?\x69\x73\x79\x6e\x65\x74'
  $'\x78\x69\x73\x79\x6e\x65\x74'
  $'\x69\x73\x79\x6e\x65\x74'
)

PATTERN="$(IFS='|'; echo "${TERMS[*]}")"
PATTERN="(^|[^[:alnum:]_])(${PATTERN})([^[:alnum:]_]|$)"
PATHS=(
  README.md
  CHANGELOG.md
  CLAUDE.md
  AGENTS.md
  .beads
  docs
  input/fsh
  input/pagecontent
  test
  dist/package
  sushi-config.yaml
  oids.ini
  scripts
  .github
)

TRACKED_PATHS=()
while IFS= read -r -d '' path; do
  if [ -f "$path" ]; then
    TRACKED_PATHS+=("$path")
  fi
done < <(git ls-files -z -- "${PATHS[@]}")

if [ "${#TRACKED_PATHS[@]}" -eq 0 ]; then
  echo "Vendor leak guard skipped: no tracked public repository surfaces found."
  exit 0
fi

if command -v rg >/dev/null 2>&1; then
  MATCHES="$(rg -n -i "$PATTERN" "${TRACKED_PATHS[@]}" || true)"
else
  MATCHES="$(grep -I -n -i -E "$PATTERN" "${TRACKED_PATHS[@]}" || true)"
fi

if [ -n "$MATCHES" ]; then
  echo "ERROR: vendor-specific term found in public repository surfaces."
  echo ""
  echo "$MATCHES"
  echo ""
  echo "Use vendor-neutral wording in the IG, or keep adapter/product-specific"
  echo "details in downstream adapter repositories or historical docs."
  exit 1
fi

echo "Vendor leak guard passed."
