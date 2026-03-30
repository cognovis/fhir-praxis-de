#!/bin/bash
# Build a FHIR npm package from SUSHI output.
# Creates dist/package/ with package.json + all StructureDefinition/CodeSystem/ValueSet JSONs.
# Usage: ./scripts/build-package.sh
#        Then: cd dist && npm pack  (creates .tgz for npm install)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SCRIPT_DIR/.."
DIST="$ROOT/dist/package"

# 1. Run SUSHI
echo "Running SUSHI..."
cd "$ROOT"
npx sushi . 2>&1 | tail -5

# 2. Read version from sushi-config.yaml
VERSION=$(grep '^version:' sushi-config.yaml | awk '{print $2}')
PACKAGE_ID=$(grep '^id:' sushi-config.yaml | awk '{print $2}')
echo "Building $PACKAGE_ID@$VERSION"

# 3. Create dist/package/ directory
rm -rf "$DIST"
mkdir -p "$DIST"

# 4. Create package.json (FHIR package format)
cat > "$DIST/package.json" <<EOF
{
  "name": "$PACKAGE_ID",
  "version": "$VERSION",
  "description": "German Practice Management FHIR Profiles (R4)",
  "author": "cognovis GmbH",
  "fhirVersions": ["4.0.1"],
  "jurisdiction": "urn:iso:std:iso:3166#DE",
  "canonical": "https://fhir.cognovis.de/praxis",
  "url": "https://fhir.cognovis.de/praxis/ImplementationGuide/de.cognovis.fhir.praxis",
  "dependencies": {
    "hl7.fhir.r4.core": "4.0.1",
    "de.basisprofil.r4": "1.5.0",
    "kbv.basis": "1.8.0",
    "kbv.ita.for": "1.3.1",
    "kbv.ita.aws": "1.2.0",
    "kbv.all.st-combined": "1.32.0",
    "dguv.basis": "1.4.0"
  }
}
EOF

# 5. Copy all StructureDefinition, CodeSystem, ValueSet JSONs (flat, like KBV packages)
for f in "$ROOT/fsh-generated/resources/"*.json; do
  basename=$(basename "$f")
  # Skip ImplementationGuide resource itself
  if [[ "$basename" == ImplementationGuide-* ]]; then
    continue
  fi
  cp "$f" "$DIST/$basename"
done

COUNT=$(ls "$DIST"/*.json | wc -l | tr -d ' ')
echo "Package built: $DIST ($COUNT resources)"
echo ""
echo "To install locally into FHIR cache:"
echo "  mkdir -p ~/.fhir/packages/${PACKAGE_ID}#${VERSION}/package"
echo "  cp -r $DIST/* ~/.fhir/packages/${PACKAGE_ID}#${VERSION}/package/"
echo ""
echo "To create npm tarball:"
echo "  cd $DIST && npm pack"
