# Changelog

All notable changes to this project will be documented in this file.

## [unreleased]

### Breaking Changes

- **fpde-za3**: Remove `KrablLinkContentCS` (krabllink-content) — no profile or example references
- **fpde-za3**: Rename `KrablLinkKategorieCS` → `DocumentKategorieCS` (Id: `dokument-kategorie`) — PVS-agnostische Benennung
- **fpde-za3**: Rename extension `KrabllinkRefExt` (Id: `krabllink-ref`) → `LinkedDocumentExt` (Id: `linked-document`) — update all example URLs accordingly
- **fpde-za3**: Remove `bsnr` NamingSystem (lokaler Alias) — upstream canonical `http://fhir.de/sid/dkgev/bsnr` direkt verwenden
- **fpde-za3**: Remove `DiagnoseSeiteCS` and `DiagnoseSeiteVS` — Extension binding geöffnet, Beispiel auf SNOMED CT umgestellt (consistent mit fpde-5z0)
- **fpde-za3**: Remove `LabInterpretationVS` — Lab-Profil nutzt bereits HL7-Standard-VS `http://hl7.org/fhir/ValueSet/observation-interpretation` direkt
- **fpde-za3**: `FPDECoverageGKV` Parent von `Coverage` auf `http://fhir.de/StructureDefinition/coverage-de-gkv` (de.basisprofil.r4 1.6.0-ballot2) umgestellt — Beispiele erfordern jetzt `identifier[KrankenversichertenID]`

### Miscellaneous

- **fpde-za3**: `KvdtScheinuntergruppeCS` bleibt als lokaler Mirror (KBV-Paket nicht in Dependencies verfügbar)
- **fpde-za3**: `InsurancePlanTypeCS`, `KvFachgruppeCS`, `ZuzahlungsstatusCS`, `LdtMaterialbezeichnungCS`, `ProbenmaterialSnomedVS`, NamingSystems `abrechnr`/`ldt-testkennungen`/`ldt-auftragsnummer` behalten — kein upstream-Duplikat

### Bug Fixes

- **fpde-orv**: Address review findings iteration 1
- **fpde-orv**: Address review findings iteration 1
- **fpde-orv**: Address review findings iteration 2
- **fpde-orv**: Correct resultsInterpreter comment to match constraint
- **fpde-orv**: Address review panel findings iteration 1
- **fpde-orv**: Address review panel findings iteration 2
- **fpde-4zh**: Address review findings iteration 2 — add httpyac profile test

### Documentation

- Update feature documentation for fpde-4zh
- Update feature documentation for fpde-orv

### Features

- **fpde-4zh**: Green — Lab Observation profile + 3 examples
- **fpde-orv**: Add PraxisLabDiagnosticReport profile
- **fpde-orv**: Add lab DiagnosticReport example instances (4 scenarios)
- **fpde-orv**: Green -- PraxisLabDiagnosticReport profile with LAB/MB/PAT category slices and 4 example instances

### Miscellaneous

- Bump version to 0.28.0

### Test

- **fpde-orv**: Red -- stub DiagnosticReport profile and example trigger sushi error

## [0.28.0] - 2026-04-05

### Features

- **fpde-oz2**: Complete KvdtScheinuntergruppeCS with all 21 KBV V1.02 codes

### Miscellaneous

- Bump version to 0.27.0
- Update changelog

## [0.27.0] - 2026-04-05

### Miscellaneous

- Update changelog

### Merge

- Resolve conflict in profiles.md (keep both FPDEPatient/GKV and PraxisSpecimen sections)
- Worktree-bead-fpde-d5d

## [0.26.0] - 2026-04-05

### Bug Fixes

- **fpde-csw**: Address review panel findings iteration 1
- **fpde-csw**: Address review panel findings iteration 2
- **fpde-2te**: Address review findings iteration 1
- **fpde-2te**: Address review findings iteration 1 (FK 8402 context, ASCII umlauts, FK 8410 out-of-scope note)

### Documentation

- Update feature documentation for fpde-2te (PraxisDevice profile + gdt-device-id NamingSystem)

### Features

- **fpde-2te**: Green — PraxisDevice profile for medical devices/lab analyzers

### Miscellaneous

- Bump version to 0.25.1
- Update changelog
- Bump version to 0.26.0

### Merge

- Resolve conflict — keep PraxisDevice + LDT/ProcedureAmbulantDE/PraxisSpecimen docs from main
- Worktree-bead-fpde-2te

### Test

- **fpde-2te**: Red — Device example references PraxisDevice profile (not yet defined)

## [0.25.1] - 2026-04-05

### Bug Fixes

- **fpde-g25**: Address review findings iteration 1
- **fpde-g25**: Address review findings iteration 2 — complete scenario examples
- **fpde-g25**: Address review panel findings — preferred URI, LOINC 6690-2, doc wording

### Documentation

- Update IG documentation for PraxisSpecimen profile (fpde-csw)
- Update feature documentation for fpde-g25

### Features

- **fpde-g25**: Green — NamingSystems ldt-testkennungen + ldt-auftragsnummer
- **fpde-g25**: Green — ValueSet LabInterpretation using v3-ObservationInterpretation

### Miscellaneous

- Bump version to 0.25.0
- Update changelog

### Merge

- Worktree-bead-fpde-g25

## [0.25.0] - 2026-04-05

### Bug Fixes

- **fpde-csw**: Address review findings iteration 1
- **fpde-csw**: Address review findings iteration 2
- **fpde-oz2**: Address review findings iteration 1 — ConceptMap source canonical, code #10 display
- **fpde-oz2**: Address review findings iteration 2 — content=complete, consistent descriptions, equivalence #wider for gkv→#00

### Features

- **fpde-csw**: Add Specimen profile, ValueSet, and example instances
- **fpde-oz2**: Green — KVDT Scheinuntergruppe CS with OID and ConceptMap

### Miscellaneous

- Update changelog

### Merge

- Worktree-bead-fpde-oz2

### Test

- **fpde-oz2**: Red — KVDT Scheinuntergruppe CS and ConceptMap (incomplete)

## [0.24.0] - 2026-04-05

### Bug Fixes

- **fpde-d5d**: Address review findings iteration 1
- **fpde-d5d**: Address review findings iteration 2
- **fpde-1q9**: Address review findings iteration 1 — remove incorrectly contexted FHIRPath invariants
- **fpde-1q9**: Address review findings iteration 1
- **fpde-1q9**: Address review findings iteration 2 — correct code cardinality to 1..1 in docs

### Documentation

- Update feature documentation for fpde-d5d
- Update feature documentation for fpde-1q9

### Features

- **fpde-d5d**: Green — Geburtsname, Ortsteil, WOP demografie extensions
- **fpde-1q9**: Green — PraxisCondition profile with ICD-10-GM Diagnosesicherheit

### Miscellaneous

- Update changelog
- Bump version to 0.24.0

### Merge

- Worktree-bead-fpde-1q9

### Test

- **fpde-d5d**: Red — FSH examples for Geburtsname, Ortsteil, WOP
- **fpde-1q9**: Red — validate PraxisCondition profile

## [0.23.0] - 2026-04-05

### Miscellaneous

- Bump version to 0.22.0
- Update changelog
- Bump version to 0.23.0

### Merge

- Worktree-bead-fpde-76c

## [0.22.0] - 2026-04-05

### Bug Fixes

- **fpde-76c**: Address review findings iteration 1
- **fpde-76c**: Correct code cardinality to 1..1 in profiles.md documentation

### Features

- **fpde-76c**: Green — Procedure profile ambulant DE with OPS coding
- **fpde-98l**: Green — xDT NamingSystems (gdt-anforderungs-ident, kvdt-fallnummer, gdt-device-id)

### Miscellaneous

- Update changelog

### Merge

- Worktree-bead-fpde-98l

### Test

- **fpde-76c**: Red — Procedure profile not yet defined
- **fpde-98l**: Red — xDT NamingSystems draft with validation error

## [0.21.0] - 2026-04-05

### Bug Fixes

- **fpde-ria**: Address review findings iteration 1 — CHANGELOG ordering
- **fpde-ria**: Address review findings iteration 2 — add 0.19.0 section, clear stale unreleased
- **fpde-ria**: Correct CHANGELOG — ServiceRequest (not DeviceRequest), restore 0.19.0 items

### Documentation

- Update feature documentation for fpde-ria

### Features

- **fpde-ria**: Green — add medication extensions, CodeSystems, NamingSystem + version bump

### Miscellaneous

- Update changelog
- Bump version to 0.21.0

### Merge

- Worktree-bead-fpde-ria

### Test

- **fpde-ria**: Red — add FSH definitions for 8 medication artifacts (pre-compile)

## [0.19.0] - 2026-04-04

### Documentation

- Update workshop presentation with custom device order extensions and dental lab orders

### Features

- Add custom device order extensions (ManufacturingDeadline, DigitalWorkflow)

### Miscellaneous

- Bump version to 0.18.1
- Bump version to 0.19.0

## [0.18.1] - 2026-04-04

### Documentation

- Add DMEA 2026 materials and strategic IG analysis docs

### Miscellaneous

- Bump version to 0.18.0
- Update changelog

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


