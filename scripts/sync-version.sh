#!/usr/bin/env bash
# DEPRECATED (fmgt-5ff): This script managed release/publish/version-sync operations
# that are now owned by fhir-management. Use fhir-management commands instead:
#   uv run fhir-release publish
#   uv run fhir-release update-package-list
#   uv run fhir-graph lock
# See fhir-management docs/release-migration.md for the migration map.
# This script is kept for reference during the transition period.

# Sync sushi-config.yaml version from VERSION file.
# Exits 0 if already in sync, exits 1 if it had to fix a mismatch.
set -euo pipefail

VERSION=$(tr -d '[:space:]' < VERSION)
SUSHI_VERSION=$(grep '^version:' sushi-config.yaml | awk '{print $2}')

if [ "$VERSION" = "$SUSHI_VERSION" ]; then
  echo "Versions in sync: $VERSION"
  exit 0
fi

echo "Version mismatch: VERSION=$VERSION, sushi-config.yaml=$SUSHI_VERSION"
sed -i.bak "s/^version: .*/version: $VERSION/" sushi-config.yaml && rm -f sushi-config.yaml.bak
echo "Updated sushi-config.yaml to $VERSION"
exit 1