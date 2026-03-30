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

# 4. Create package.json (FHIR package format) — deps derived from sushi-config.yaml
DEPS_JSON=$(python3 - <<'PYEOF'
import re, json

with open("sushi-config.yaml") as f:
    content = f.read()

match = re.search(r'^dependencies:\s*\n((?:  \S.*\n)*)', content, re.MULTILINE)
deps = {"hl7.fhir.r4.core": "4.0.1"}
if match:
    for line in match.group(1).splitlines():
        line = line.strip().split("#")[0].strip()
        if ":" in line:
            k, v = line.split(":", 1)
            deps[k.strip()] = v.strip()
print(json.dumps(deps, indent=4))
PYEOF
)

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
  "dependencies": $DEPS_JSON
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
echo "Package dir: $DIST ($COUNT resources)"

# 6. Create tgz
cd "$DIST"
npm pack --pack-destination "$ROOT/dist"
cd "$ROOT"

TGZ="dist/${PACKAGE_ID}-${VERSION}.tgz"
echo "Package built: $TGZ ($(du -h "$TGZ" | cut -f1))"
