# Changelog

All notable changes to this project will be documented in this file.

## [unreleased]

### Documentation

- Update CLAUDE.md, add QA analysis, switch beads to server mode

### Miscellaneous

- Bump version to 0.6.0
- **deps**: Upgrade de.basisprofil.r4 1.5.0 → 1.6.0-ballot2

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


