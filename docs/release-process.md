# Release Process

This document describes the release pipeline for `fhir-praxis-de`, including
the **QA Gate** that blocks releases when the IG Publisher produces unfixed internal errors.

## Overview

Releases are fully automated via GitHub Actions:

1. **Bump version** — update `VERSION` and `sushi-config.yaml` to the new version (must match).
2. **Push to `main`** — `ig-ci.yml` runs SUSHI, IG Publisher, Aidbox validation tests.
3. **Auto-tag** — `ig-ci.yml`'s `auto-tag` job creates `vX.Y.Z` tag if the version is new.
4. **Release workflow** — `ig-release.yml` triggers on the tag push:
   - Runs SUSHI + IG Publisher again (full fresh build).
   - **QA Gate** — blocks release if internal errors > 0 (see below).
   - Builds the FHIR package tarball.
   - Creates a GitHub Release with the tarball and `full-ig.zip`.
   - Publishes to `npm.cognovis.de` (private FHIR registry).
   - Updates `package-list.json` on `fhir.cognovis.de`.
   - Dispatches `ig-published` event to downstream consumers.

## QA Gate

### What it does

After IG Publisher runs, `scripts/qa_gate.py` parses `output/qa.html` and
classifies every `Error`-severity message as either:

- **Internal** — an error in our own FSH sources that must be fixed.
- **External** — an error caused by an upstream system (tx server, external IG,
  third-party terminology) that we cannot fix, listed in `.github/qa-allowlist.yml`.

If `internal_errors > 0`, the gate fails with exit 1 and the release is blocked
(no GitHub Release, no npm publish).

### Design principles (fail-closed)

| Scenario | Gate behaviour |
|----------|----------------|
| `internal_errors = 0` | Pass (exit 0) |
| `internal_errors > 0` | **Fail** (exit 1) |
| `qa.html` missing | **Fail** — file is required |
| `qa.html` empty | **Fail** — content is required |
| Allowlist missing | **Fail** — all errors treated as internal |
| Allowlist empty (`patterns: []`) | **Fail** if any errors exist |
| Allowlist YAML malformed | **Fail** — structural errors caught |
| Error not in allowlist | **Counted as internal** |

There is intentionally no "fail-open" path. If in doubt, the gate fails.

### Running locally

```bash
# After running IG Publisher (which generates output/qa.html):
python3 scripts/qa_gate.py \
  --qa-html output/qa.html \
  --allowlist .github/qa-allowlist.yml
```

Exit code 0 = gate passes. Exit code 1 = gate fails (see stdout for details).

### When the gate fails

1. Read the gate output — it lists all internal errors.
2. Fix each error in the relevant FSH file in `input/fsh/`.
3. Run SUSHI + IG Publisher locally, re-run the gate.
4. If the error is truly external (upstream system, dependency we don't control),
   add it to the allowlist (see below).
5. Push the fix — the CI will re-run automatically.

## Managing the Allowlist

The allowlist lives at `.github/qa-allowlist.yml`. It contains only errors that
originate from external systems outside this repository.

### Allowlist format

```yaml
version: "1"
patterns:
  - pattern: "substring that must appear in the error message"
    reason: "why this error is external and cannot be fixed here"
    source: "which upstream system causes this (e.g. tx.fhir.org, de.basisprofil.r4)"
```

Matching is **substring-based**: the `pattern` string is checked for presence
anywhere in the error message text.

### Adding a new entry

1. **Confirm it is external** — the error must come from an upstream system
   (terminology server, external IG canonical, third-party package). If it is
   in our own FSH, fix it instead.
2. **Copy the exact error text** from `output/qa.html` or the gate output.
3. **Choose a minimal but specific pattern** — long enough to be unambiguous,
   short enough to survive minor message rewording.
4. **Document the reason** — explain why this cannot be fixed here and reference
   any upstream issue if available.
5. **Open a tracking issue** in the appropriate upstream repository if applicable.
6. **Add the entry** to `.github/qa-allowlist.yml` and push.

### Removing an entry

When an upstream fix lands (e.g. tx.fhir.org starts supporting a filter, or
a dependency publishes a corrected package), verify that the error no longer
appears in `output/qa.html`, then delete the corresponding entry from the
allowlist.

### Current allowlist (v0.59.0 baseline)

| Source | Pattern (abbreviated) | Count |
|--------|-----------------------|-------|
| tx.fhir.org | `Error: The filter "LIST = LL2255-7" is not understood` | 2x |
| de.basisprofil.r4 | `IG URL should refer directly to the ImplementationGuide resource` | 2x |
| snomed-ct | `Unknown code '1255414003' in the CodeSystem 'http://snomed.info/sct'` | 1x |
| de.basisprofil.r4 | `The link 'http://fhir.de/StructureDefinition/coverage-de-gkv` | 1x |
| de.basisprofil.r4 | `The link 'http://fhir.de/StructureDefinition/coverage-de-basis` | 1x |

**Total external errors: 7. Total internal errors: 0.**

## Reusing this pattern in other IGs

The QA gate is designed to be reusable across `dental-de`, `terminology-de`,
and any future IG in this organization.

To adopt it in another IG:

1. **Copy** `scripts/qa_gate.py` — it has no external dependencies (stdlib only).
2. **Copy** `.github/qa-allowlist.yml` — edit patterns for the target IG's baseline.
3. **Add the gate step** to the release workflow after "Run IG Publisher":

```yaml
- name: QA Gate — block release if internal errors > 0
  run: |
    python3 scripts/qa_gate.py \
      --qa-html output/qa.html \
      --allowlist .github/qa-allowlist.yml
```

4. **Copy** `tests/test_qa_gate.py` (optional but recommended) — run with
   `python3 -m pytest tests/test_qa_gate.py`.
5. **Copy** this document to the target repo's `docs/release-process.md`.
6. Establish the allowlist baseline by running IG Publisher once, reviewing
   `output/qa.html`, and adding all confirmed external errors to the allowlist.
