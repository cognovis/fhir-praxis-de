---
name: fhir-sync-versions
description: >-
  use when: reconciling fhir-* version pins after manifest, SUSHI, FHIR package,
  registry, Polaris, or Mira version changes; triggers: /fhir-sync-versions,
  fhir version sync, reconcile fhir pins, sync fhir versions. NOT for: deciding
  SemVer bump tiers, publishing packages, or regenerating Polaris SDK output.
  boundary: runs the bundled sync.py script for deterministic pin drift and
  optional release-chain audit.
requires_standards: [english-only, no-emoji, judge-layer]
compatibility: {}
metadata: {}
action_boundary:
  risk_class: reversible-write
  effect_type: filesystem
  proposal_schema: standard://judge-layer/proposals/action-proposal.v1
  judge: agent://judge-default
  requires_mandate: false
---

# fhir-sync-versions

> **Diagnostic and recovery tool.** As of fhir-praxis-de v0.70.x, downstream version-pin
> updates are automated via receiver workflows in `fhir-dental-de` and `fhir-terminology-de`
> that trigger on the `ig-published` `repository_dispatch` event. Use this skill to
> diagnose drift, audit release chains, or recover when automation fails — not as the
> primary post-release sync path.

Reconcile fhir-* version pins across all locally-checked-out repos against the `fhir-versions.lock.yaml` manifest.

## Usage

```bash
python3 skills/fhir-sync-versions/scripts/sync.py [--dry-run] [--apply] [--release-audit] [--manifest PATH] [--registry URL]
```

Run from the fhir-terminology-de repo root.

**Modes:**
- `--dry-run` (default): show drift table only, no file edits
- `--apply`: apply all edits and run the drift guard (`scripts/check-fhir-version-drift.sh`)
- `--release-audit`: also check published package metadata, aux pins, tags, GitHub releases, registry package existence, cycles, and release order

## What it does

1. Reads `fhir-versions.lock.yaml` from the fhir-terminology-de repo (searches CWD + parent dirs)
2. Queries `npm.cognovis.de` dist-tags for registry latest (requires `NODE_AUTH_TOKEN` or `~/.npmrc`)
3. Walks consumer files:
   - `~/code/fhir-praxis-de/sushi-config.yaml` — SUSHI IG, `dependencies:` section
   - `~/code/fhir-dental-de/sushi-config.yaml` — SUSHI IG, `dependencies:` section
   - `~/code/fhir-deidentification-de/sushi-config.yaml` — SUSHI IG, `dependencies:` section
   - `./packages/*/package.json` in the fhir-terminology-de repo — bundle `dependencies:`
   - `~/code/polaris/**/package.json` and `~/code/mira/**/package.json` — package pins in `dependencies`, `devDependencies`, `peerDependencies`, `optionalDependencies`, `overrides`, and `resolutions`
   - Generated/install directories are skipped: `.claude`, `.codegen-cache`, `.git`, `.next`, `dist`, `node_modules`, and similar build/cache folders
4. Checks Polaris `@polaris/fhir-de` generated provenance:
   - `~/code/polaris/packages/fhir-de/generated/**/*.ts` — `pkg: package#version` comments from `@atomic-ehr/codegen`
   - `~/code/polaris/packages/fhir-de/src/client/generated/*.ts` — `Source: package@version` comments from de-identification codegen
5. Computes transitive closure of drifted pins (manifest vs actual)
6. In `--apply` mode: edits structured pins and runs `scripts/check-fhir-version-drift.sh`; generated SDK drift remains `REGENERATE`
7. Reports packages where registry latest < manifest version (unpublished)
8. In `--release-audit` mode:
   - Fetches published `package.json` metadata with `npm pack` and reports `REGISTRY_METADATA_STALE` when published dependencies disagree with manifest/local expected versions
   - Scans workflow/action/script files in local fhir-* repos for duplicated version pins and reports `AUX_PIN_DRIFT`
   - Checks local tags for version mismatch, missing GitHub releases, and missing registry package versions where `git`, `gh`, and `npm` are available
   - Checks public `https://fhir.cognovis.de/<ig>/package-list.json` files and reports `PUBLIC_PACKAGE_LIST_STALE` when the manifest version is not marked current
   - Reports `LEGACY_PACKAGE_LIST_DEPLOY_TARGET` when workflows/scripts still point at the old `116.202.111.75` or `/var/www/fhir/` package-list deployment path
   - Prints dependency graph cycle status and a topological release order

When a local SUSHI IG is not listed in `fhir-versions.lock.yaml`, its own top-level
`id`/`version` is treated as the expected version for downstream package.json
consumers. This lets `io.cognovis.de-identification.de` flow into Polaris without
requiring it to be owned by the fhir-terminology-de lock manifest.

## Out of Scope

- Does not make SemVer bump decisions (bump tier = MAJOR/MINOR/PATCH is caller's responsibility)
- Does not run `publish.sh` or push to the registry
- Does not edit `fhir-versions.lock.yaml` directly (the manifest; update it manually for `RELEASE_LOCAL_OR_UPDATE_MANIFEST` items)
- Does not modify an IG's own top-level `version:` field — when the checkout is ahead of the manifest, the user must either release the local version or update the manifest
- Does not rewrite package specs that are not direct version pins, such as `file:`, `workspace:`, Git, or URL dependencies
- Does not regenerate Polaris SDK files; `REGENERATE` rows mean run the Polaris generation command after updating pins
- Does not patch registry metadata for an already-published package; publish a new patch version instead

## Outputs

**Drift table** (columns: file | package | local/actual | manifest/expected | registry | action):
```
FILE                                      PACKAGE                        LOCAL/ACTUAL  MANIFEST/EXPECTED  REGISTRY  ACTION
~/code/fhir-dental-de/sushi-config.yaml  de.cognovis.fhir.dental        0.36.0        0.35.0             0.35.0    RELEASE_LOCAL_OR_UPDATE_MANIFEST
~/code/polaris/packages/fhir-de/generated de.cognovis.fhir.dental       0.30.0        0.35.0                       REGENERATE
...
```

**Unpublished report**: packages not yet at their manifest version in the registry.

**Release-chain plan**: only with `--release-audit`; reports graph cycles and the computed release order.

**Regeneration follow-up**: when `REGENERATE` rows exist, the script prints a
separate suggestion to create a Polaris bead/workstream, update pins, regenerate
`@polaris/fhir-de`, fix generation/type/test issues, run checks, commit, merge or
rebase, push beads data, and `git push`.

## Release Rules

- A dependency bump in `sushi-config.yaml` or generated FHIR package metadata requires a new package version before downstream consumers pin it.
- Already-published npm/FHIR packages are immutable for this workflow; if metadata is wrong, create a patch release.
- Polaris may pin only versions that exist in the registry and whose published metadata is consistent.
- Comments should not duplicate version literals; when they do, `AUX_PIN_DRIFT` identifies stale comment/script pins for manual cleanup.
