# Changelog

All notable changes to this project will be documented in this file.

## [0.20.0] - 2026-04-05

### Added

- Medication extensions: `aut-idem`, `is-erezept` (MedicationRequest flags), `is-dauermedikation` (MedicationStatement flag)
- Medication price extensions: `avp` (Apothekenverkaufspreis) and `festbetrag` (GKV-Festbetrag) on MedicationRequest
- CodeSystem `rezept-typ`: gkv, privat, btm, t-rezept
- CodeSystem `medikation-kategorie`: dauermedikation, bedarfsmedikation
- NamingSystem `scheindiagnosen`: Identifier-System fuer Scheindiagnosen (Condition.identifier)
- Documentation comment in `genehmigung.fsh` explaining sub-extension addressing convention

## [unreleased]

### Documentation

- Add DMEA 2026 materials and strategic IG analysis docs

### Miscellaneous

- Bump version to 0.18.0

## [0.18.0] - 2026-04-04

### Miscellaneous

- Bump version to 0.17.1
- Update changelog

### Merge

- Worktree-bead-fpde-8m5

## [0.17.1] - 2026-04-04

### Miscellaneous

- Ignore dolt server artifacts and config.yaml
- Update changelog

## [0.17.0] - 2026-04-04

### Miscellaneous

- Bump version to 0.16.0
- Update changelog
- Bump version to 0.17.0

### Merge

- Worktree-bead-fpde-0d1

## [0.16.0] - 2026-04-04

### Bug Fixes

- **fpde-8m5**: Address review findings iteration 1
- **fpde-8m5**: Address review findings iteration 2
- **fpde-8m5**: Address review panel findings — invariant, status flexibility, item.item MS
- **fpde-0d1**: Address review findings iteration 1
- **fpde-0d1**: Address review findings iteration 2
- **fpde-0d1**: Address cmux review findings — fix cardinality docs, remove redundant constraints, simplify category coding
- **fpde-0d1**: Apply FSH shorthand to all participant role codings

### Documentation

- Update feature documentation for fpde-8m5
- Update feature documentation for fpde-0d1
- **fpde-pbh**: Add PatientSeitExt to extensions documentation
- Improve PatientSeitExt documentation wording and add to profiles table

### Features

- **fpde-8m5**: Green — AnamneseQuestionnaire profile, CS, VS, extensions, example
- **fpde-0d1**: Green — CareTeam-Profil fuer Behandler-Teams
- **fpde-pbh**: Green — PatientSeitExt FSH extension, SUSHI compiles

### Miscellaneous

- Bump version to 0.15.0
- Update changelog
- Update changelog

### Merge

- Worktree-bead-fpde-04d
- Worktree-bead-fpde-pbh

### Test

- **fpde-8m5**: Red — httpyac test for AnamneseQuestionnaire validation
- **fpde-0d1**: Red — CareTeamDE profile references NonExistentValueSet to verify error detection
- **fpde-pbh**: Red — patient.fsh does not exist yet
- **fpde-pbh**: Green — httpyac validation test for patient-seit extension

## [0.15.0] - 2026-04-04

### Miscellaneous

- Update changelog

### Merge

- Worktree-bead-fpde-d8a

## [0.14.0] - 2026-04-04

### Bug Fixes

- **qa**: Suppress remaining warnings and hints in IG Publisher QA
- **qa**: Use exact message text for IG Publisher suppressions
- **fpde-04d**: Address review findings iteration 1
- **fpde-04d**: Address review findings iteration 2
- **fpde-d8a**: Address review findings iteration 1 — add partial and multi bank-account examples

### Documentation

- Update extensions.md for fpde-d8a — add BankAccountExt Organization section
- Update feature documentation for fpde-6no

### Features

- **fpde-04d**: Green — InsurancePlanDE profile with GKV/PKV slicing
- **fpde-04d**: Green — GKV/PKV InsurancePlan examples with Coverage-Referenz docs (AK2+AK3)
- **fpde-d8a**: Green — BankAccountExt complex extension mit iban/bic/bankname/kontoinhaber
- **fpde-d8a**: Green — example with full BankAccountExt usage
- **fpde-6no**: Green — appointment-mode extension, ValueSet, CodeSystem

### Miscellaneous

- Update changelog
- Bump version to 0.14.0

### Merge

- Worktree-bead-fpde-6no

### Test

- **fpde-04d**: Red — InsurancePlanDE profile skeleton fails SUSHI
- **fpde-04d**: Red — InsurancePlanDE examples fail SUSHI
- **fpde-d8a**: Red — stub BankAccountExt without sub-extensions
- **fpde-d8a**: Red — example without bank-account extension
- **fpde-6no**: Red — appointment-mode extension with unresolved ValueSet reference

## [0.13.1] - 2026-04-03

### Bug Fixes

- **qa**: Reduce IG Publisher warnings and hints
- **qa**: Suppress de-DE display name hints for international codes
- **fpde-5fj**: Address review findings iteration 1
- **fpde-5fj**: Use #draft status for BGT2001 ValueSet per project convention

### Features

- **fpde-5fj**: Add BGT2001 standalone CodeSystem and ValueSet

### Miscellaneous

- Update changelog
- Bump version to 0.13.1

### Merge

- Worktree-bead-fpde-5fj

## [0.13.0] - 2026-04-03

### Bug Fixes

- **fpde-bua**: Address review findings iteration 1 — update ebm-chargeitem comment, verify sushi build clean
- **fpde-bua**: Update examples to match corrected extension contexts (AU→Encounter, EBM→ChargeItemDefinition)
- **fpde-bua**: Address review findings iteration 1 — catalog descriptions, rename ebm file, add AU/EBM examples
- **fpde-bua**: Address review findings iteration 2 — remove instance-level wording from ebm-kapitel and ebm-pruefzeit descriptions

### Features

- **fpde-bua**: Fix extension context for AU (ServiceRequest→Encounter) and EBM (ChargeItem→ChargeItemDefinition)

### Miscellaneous

- Bump version to 0.12.0
- Update changelog
- Bump version to 0.13.0

### Merge

- Worktree-bead-fpde-bua

## [0.12.0] - 2026-04-03

### Miscellaneous

- Bump version to 0.11.0
- Update changelog

### Merge

- Worktree-bead-fpde-w60

## [0.11.0] - 2026-04-03

### Miscellaneous

- Bump version to 0.10.0

### Merge

- Resolve CHANGELOG conflict from origin/main
- Worktree-bead-fpde-9bx

## [0.10.0] - 2026-04-03

### Bug Fixes

- **publishing**: Revert to path-based canonical URL with Caddy reverse proxy
- **ci**: Remove package-list.json from IG output
- Remove package-list.json from repo root
- **fpde-w60**: Address review findings iteration 1
- **fpde-w60**: Address review findings iteration 2 — remove ^url, fix anaesthesiologie code, doc sync, add .http tests
- **fpde-9bx**: Address review findings iteration 1 — add http test for kv-abrech extensions
- **fpde-kn1**: Address review findings iteration 1 — pvs-agnostic, publisher, descriptions
- **fpde-kn1**: Address review findings iteration 2 — fix typo Enthalt→Enthaelt

### Documentation

- Update codesystems.md with kv-fachgruppe, krabllink-kategorie, krabllink-content, lkz for fpde-w60
- Update feature documentation for fpde-kn1 — add NamingSystems page and IG menu entry

### Features

- **publishing**: Set up canonical URL and FHIR registry discovery
- **ci**: Include package-list.json in GitHub Pages output
- **fpde-w60**: Add missing CodeSystem FSH definitions — kv-fachgruppe, krabllink-kategorie, krabllink-content, lkz
- **fpde-9bx**: Green — add 3 FSH extensions: abrech-satzart, abrech-feldkennung, hv-versicherten-nr
- **fpde-kn1**: Green — add 8 NamingSystem FSH definitions for PVS identifier systems

### Miscellaneous

- Bump version to 0.9.0
- Update changelog
- Update changelog

### Merge

- Worktree-bead-fpde-kn1

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


