# Changelog

All notable changes to this project will be documented in this file.

## [unreleased]

### Features

- Add Da Vinci PAS DE artifacts — 3 Profiles, 3 CodeSystems, 4 ValueSets, 2 Extensions

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


