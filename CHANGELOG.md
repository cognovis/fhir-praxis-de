# Changelog

All notable changes to this project will be documented in this file.

## [unreleased]

### Bug Fixes

- **publishing**: Revert to path-based canonical URL with Caddy reverse proxy
- **ci**: Remove package-list.json from IG output
- Remove package-list.json from repo root
- **fpde-9bx**: Address review findings iteration 1 — add http test for kv-abrech extensions

### Features

- **publishing**: Set up canonical URL and FHIR registry discovery
- **ci**: Include package-list.json in GitHub Pages output
- **fpde-9bx**: Green — add 3 FSH extensions: abrech-satzart, abrech-feldkennung, hv-versicherten-nr

### Miscellaneous

- Bump version to 0.9.0

### Test

- **fpde-9bx**: Red — 3 extensions missing: abrech-satzart, abrech-feldkennung, hv-versicherten-nr

## [0.9.0] - 2026-04-03

### Features

- **qa**: Zero errors - add 27 examples, PASTaskInputTypeCS, fix QA issues for registry publication

### Miscellaneous

- Bump version to 0.8.0
- Update changelog

## [0.8.0] - 2026-04-03

### Bug Fixes

- **beads**: Switch to shared-server Dolt mode
- **qa**: Fix jurisdiction display and add hl7.terminology dependency

### Features

- **registry**: Prepare IG for FHIR registry publication

### Miscellaneous

- Bump version to 0.7.0
- Update changelog

## [0.7.0] - 2026-04-03

### Bug Fixes

- **fpde-749a121b**: Address review findings iteration 1 — fix adjudication codes, description, LANR
- **fpde-749a121b**: Address review findings iteration 2 — add adjudication-error CodeSystem
- **fpde-749a121b**: Fix display text mismatch — match adjudication-error CodeSystem definition

### Features

- **fpde-749a121b**: Add FSH example instances for PASClaimDE, PASClaimResponseDE, PASTaskDE

### Miscellaneous

- Bump version to 0.6.1
- Update changelog

### Merge

- Worktree-bead-fpde-749a121b

## [0.6.1] - 2026-04-03

### Documentation

- Update CLAUDE.md, add QA analysis, switch beads to server mode

### Miscellaneous

- Bump version to 0.6.0
- **deps**: Upgrade de.basisprofil.r4 1.5.0 → 1.6.0-ballot2
- Update changelog

### Test

- Update Aidbox test suite for basisprofil 1.6.0-ballot2

## [0.6.0] - 2026-04-02

### Bug Fixes

- **qa**: Add experimental=false, fix resource IDs, add httpyac tests

### Features

- Add Aidbox test infrastructure + Claude commands

### Miscellaneous

- Bump version to v0.5.1
- Update changelog

## [0.5.1] - 2026-03-30

### Miscellaneous

- Bump version to 0.5.0
- Update changelog

## [0.5.0] - 2026-03-30

### Bug Fixes

- **mira-adapters-4p9**: Address review findings iteration 1
- **mira-adapters-4p9**: Address review findings iteration 2 — rebuild dist after FSH fixes
- **mira-adapters-4p9**: Fix SNOMED equivalence A→420134006 narrower→wider

### CI/CD

- Auto-release package on every push to main
- Use IG Publisher output for release package (includes snapshots)

### Documentation

- **mira-adapters-4p9**: Add context comment to HvgDatumBeantragtExt

### Features

- **mira-adapters-4p9**: Add hvgDatumBeantragt extension to hvg-selektivvertrag.fsh
- **mira-adapters-4p9**: Add hzv-participation extension file
- **mira-adapters-4p9**: Add cave-clinical-warning-type CS with SNOMED-CT ConceptMap
- **mira-adapters-4p9**: Verify sushi build and package output

### Miscellaneous

- Bump version to 0.4.0
- Update changelog

## [0.4.0] - 2026-03-30

### Features

- Add Da Vinci PAS DE artifacts — 3 Profiles, 3 CodeSystems, 4 ValueSets, 2 Extensions

### Miscellaneous

- Update changelog

## [0.3.0] - 2026-03-30

### Bug Fixes

- Remove unused deps (kbv.basis, kbv.ita.for, kbv.ita.aws, kbv.all.st-combined, dguv.basis) — no FSH extension references them

### Features

- Add build-package.sh for FHIR npm package generation
- CI/CD auto-release — tag v* triggers SUSHI + npm pack + GitHub Release with tgz
- Add kvbm-qzv-gops extension for KV-Benchmark QZV-GOP mapping

### Miscellaneous

- VERSION file as single source of truth, SemVer tag pattern
- Bump version to 0.3.0

## [2026.03.1] - 2026-03-30

### Bug Fixes

- Lowercase DGUV.Basis dependency to avoid SUSHI warning

### Features

- Initial scaffold for de.cognovis.fhir.praxis IG
- Add LICENSE, README, CHANGELOG, CI/CD workflow, and VERSION
- Add 22 extensions, 2 CodeSystem shells, extend BillingType — bump to v0.2.0

### Miscellaneous

- Clean up beads metadata


