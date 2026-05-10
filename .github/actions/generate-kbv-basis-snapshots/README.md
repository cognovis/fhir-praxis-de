# generate-kbv-basis-snapshots

GitHub Actions composite action that injects FHIR snapshots into `kbv.basis`
StructureDefinitions before SUSHI compilation.

## Why This Exists

FHIR StructureDefinitions can be published in two forms:

- **With snapshots**: the full expanded element list (all base resource elements
  + differential constraints merged). SUSHI and IG Publisher can directly
  inherit from these profiles.
- **Without snapshots** (differential-only): only the constraints are listed.
  Tools that inherit from these profiles must compute the snapshot themselves,
  which requires the parent chain to be fully resolved first.

**KBV's kbv.basis package ships without snapshots.** This is a publishing
oversight: most FHIR IGs pre-compute snapshots so that downstream consumers do
not need the full toolchain to use them. KBV has not done this for kbv.basis.

### Contrast: kbv.ita.for

`kbv.ita.for` (the KBV eRezept/eAU package) **does** ship with snapshots.
You can verify this:

```bash
python3 -c "
import json, glob
sds = glob.glob(expanduser('~/.fhir/packages/kbv.ita.for#*/package/StructureDefinition-*.json'))
with_snap = sum(1 for f in sds if json.load(open(f)).get('snapshot', {}).get('element'))
print(f'{with_snap}/{len(sds)} SDs have snapshots')
"
```

`kbv.basis` has 0/47. `kbv.ita.for` has all SDs with snapshots.

## What This Action Does

1. Scans `~/.fhir/packages/kbv.basis#*` for installed versions.
2. **Idempotency check**: if all SDs already have snapshots, exits immediately.
3. Downloads `validator_cli.jar` (HL7 FHIR Validator CLI) if not cached.
4. Runs a **single JVM invocation** to generate snapshots for all 47 SDs
   simultaneously (avoids per-SD JVM startup overhead — ~11s vs ~430s).
5. Merges generated snapshots back into the original package JSON files.

## Tool Selection: HL7 FHIR Validator CLI

**Chosen**: `validator_cli.jar` (HL7 FHIR Validator CLI)

**Rationale**:
- Java 17 is already in CI (via `actions/setup-java@v4`) — no additional
  runtime needed
- Lightweight: ~190MB download, no framework dependencies
- Supports batch mode: all 47 SDs in one JVM invocation
- `.NET/dotnet` not in CI → Firely Terminal ruled out
- IG Publisher (`publisher.jar`) is downloaded after SUSHI — not available at
  the right point in the workflow. Also significantly larger.

## Performance

Measured on kbv.basis#1.8.0 (47 StructureDefinitions):

| Mode | Time |
|------|------|
| Sequential (one JVM per SD) | ~430s (~7 min) |
| **Batch (one JVM for all SDs)** | **~11s** |

The action uses batch mode. Subsequent runs (idempotency check) take < 1s.

## Usage

In your workflow, add this step **after** FHIR packages are pre-loaded and
**before** SUSHI runs:

```yaml
- name: Pre-load private FHIR packages from npm.cognovis.de
  # ... (existing step)

- name: Generate KBV Basis snapshots
  uses: ./.github/actions/generate-kbv-basis-snapshots

- name: Run SUSHI
  run: sushi .
```

## Reuse in fhir-dental-de

This action was validated in `fhir-praxis-de` (bead fpde-shp.5). To reuse
in `fhir-dental-de`:

1. Copy `.github/actions/generate-kbv-basis-snapshots/` to the same path in
   `fhir-dental-de`.
2. Add the same workflow step in both `ig-ci.yml` and `ig-release.yml`.
3. Add `kbv.basis: 1.8.0` to `sushi-config.yaml` dependencies if needed.

The action auto-detects all installed `kbv.basis#*` versions — no version
pinning in the action itself.

## Inputs / Outputs

- **Inputs**: none
- **Outputs**: none (side-effect: `~/.fhir/packages/kbv.basis#X.Y.Z/package/`
  StructureDefinition files gain `snapshot` sections)

## When KBV Fixes This

When KBV publishes `kbv.basis` with snapshots pre-included, this action will
detect that all snapshots are present on first check and exit immediately
without invoking the validator. It is safe to leave in place.

To verify KBV has fixed the issue:

```bash
python3 -c "
from os.path import expanduser
import json, glob
sds = glob.glob(expanduser('~/.fhir/packages/kbv.basis#*/package/StructureDefinition-*.json'))
sds = [f for f in sds if not f.endswith('.snapshot.json')]
with_snap = sum(1 for f in sds if json.load(open(f)).get('snapshot', {}).get('element'))
print(f'{with_snap}/{len(sds)} SDs have snapshots')
"
```

If this prints `47/47` (or similar), this action can be removed.
