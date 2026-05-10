# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Features

- **ci**: Add `generate-kbv-basis-snapshots` GitHub Actions composite action that injects FHIR snapshots into `kbv.basis` StructureDefinitions before SUSHI runs. Workaround for KBV publishing oversight (kbv.basis ships without snapshots unlike kbv.ita.for). Uses HL7 FHIR Validator CLI v6.9.7 in batch mode (~8-11s for 47 SDs). Idempotent: skips if snapshots already present. Auto-downloads kbv.basis from the public FHIR registry on fresh CI runners. Enables SUSHI inheritance from `KBV_PR_Base_*` profiles (e.g. `Parent: KBV_PR_Base_Condition_Diagnosis`). Integrated in both `ig-ci.yml` and `ig-release.yml`. Reusable pattern documented for fhir-dental-de.

## [0.49.0] - 2026-05-04

### Bug Fixes

- **fpde-daz**: Replace `kbv.mio.impfpass: 1.1.0` dependency with `kbv.mio.impfpass.vocab: 1.1.0-cognovis.1` (vocabulary-only repackage on npm.cognovis.de). The upstream impfpass 1.1.0 transitively depends on `de.basisprofil.r4: 0.9.12`, which conflicts with the pinned `1.6.0-ballot2` (the `dimdi/*` → `bfarm/*` namespace rename means these versions cannot be loaded together). The repackage drops the dimdi-tainted ValueSets/ConceptMaps (8 of 43 resources) and carries `hl7.fhir.r4.core` as its only dependency. PraxisImmunization keeps its extensible binding to `KBV_VS_MIO_Vaccination_Vaccine_List` (canonical URL unchanged) without the transitive resolver conflict. Downstream `@atomic-ehr/codegen` consumers now succeed against `de.basisprofil.r4@1.6.0-ballot2` only. SUSHI 0 errors / 0 warnings.

## [0.48.0] - 2026-05-04

### Features

- **fpde-daz**: Add KBV-MIO-Impfpass vocabulary binding to PraxisImmunization (extensible binding on vaccineCode to KBV_VS_MIO_Vaccination_Vaccine_List from kbv.mio.impfpass 1.1.0)

### Bug Fixes

- **ci**: Fix VERDACCIO_TOKEN GitHub secret (was set to wrong value, causing E401 on npm.cognovis.de)

## [unreleased]

### Bug Fixes

- Replace vendor-specific terms in public IG surfaces
- Remove remaining PVS product name from IG spec surfaces
- **ci**: Use _auth base64 token for Verdaccio instead of _password+username
- **fpde-daz**: Address review findings iteration 1

### Documentation

- **fpde-7yo**: Close epic + migrate Wave-2/3 sub-beads to fhir-deidentification-de

### Features

- **fpde-daz**: Add PraxisComposition and PraxisCommunication profiles
- **fpde-daz**: Add PraxisFlag and PraxisMedicationAdministration profiles
- **fpde-daz**: Add PraxisAnamneseQuestionnaireResponse and PraxisImmunization profiles
- **fpde-daz**: Bump version to 0.47.0 and update CHANGELOG

## [0.46.0] - 2026-05-02

### Documentation

- **fpde-7yo.1**: Track fhir-deidentification-de external repo bootstrap
- **fpde-7yo.1**: Update external repo tracking with advisory fix status
- **fpde-7yo.1**: Add changelog entry for de-identification IG bootstrap

### Features

- **fpde-7yo.1**: Bootstrap cognovis/fhir-deidentification-de repo

### Miscellaneous

- Bump version to 0.46.0

### Merge

- Resolve CHANGELOG conflict with origin/main (fpde-7yo.1)

## [0.45.2] - 2026-05-02

### Documentation

- **fpde-7yo**: Add de-identification IG spec — 4 modes, all AW resolved, single-track v1.0.0

### Miscellaneous

- Bump version to 0.45.2

## [0.45.1] - 2026-05-02

### Bug Fixes

- **ci**: Fetch terminology.imaging from Verdaccio with VERDACCIO_TOKEN
- **imaging**: Pin AccessionNumber identifier.system to pvs-id NamingSystem

### Features

- **fpde-nzb**: Add DicomwebEndpointPraxisDe profile with connectionType constraint

### Miscellaneous

- Bump version to 0.45.1 + reconcile CHANGELOG

### Merge

- Worktree-bead-fpde-nzb

## [0.45.0] - 2026-05-02

### Miscellaneous

- Bump version to 0.45.0

### Merge

- Worktree-bead-fpde-8c1
- Resolve CHANGELOG conflict with origin/main (fpde-5h0 + 0.44.1)
- Worktree-bead-fpde-5h0

## [0.44.1] - 2026-05-02

### Bug Fixes

- **fpde-5h0**: Add type.coding discriminator to requestedProcedureId identifier slice
- **fpde-5h0**: Use v2-0203#FILL type coding instead of non-existent local CodeSystem
- **fpde-8c1**: Require value 1..1 and system 1..1 on accessionNumber slice
- **fpde-8c1**: Update changelog for accessionNumber slice on ImagingStudyPraxisDe
- **fpde-z4n**: Correct legal citation from §14 StrlSchV to §85 StrlSchG / §127 StrlSchV
- **fpde-z4n**: Replace vendor-specific references in ADR-002 with neutral wording

### Documentation

- **fpde-z4n**: Add ADR-002 confirming radiation-dose extension satisfies §14 StrlSchV

### Features

- **fpde-5h0**: Add requestedProcedureId identifier slice to ImagingServiceRequestPraxisDe

### Miscellaneous

- **fpde-5h0**: Update changelog for requestedProcedureId identifier slice
- **fpde-z4n**: Update changelog for radiation-dose extension legal review
- Bump version to 0.44.1

### Merge

- Worktree-bead-fpde-z4n
- Resolve CHANGELOG conflict from origin/main (fpde-z4n + fpde-8c1)

### Task

- **fpde-8c1**: Add identifier:accessionNumber ACSN slice to ImagingStudyPraxisDe

## [0.44.0] - 2026-05-01

### Bug Fixes

- **fpde-9fq**: Remove HvgVertragsartCS stub, use dmp-kennzeichen-de in example
- **fpde-9fq**: Use correct numeric DMP Kennzeichen code 01 for DM2
- **fpde-9fq**: Update CHANGELOG for HvgVertragsartCS stub removal
- **fpde-bra**: Remove unused ZuzahlungsstatusCS and ZuzahlungsstatusVS
- **fpde-bra**: Remove stale dist/package artifacts, test fixtures, and oids.ini entries

### Miscellaneous

- **fpde-bra**: Update changelog for ZuzahlungsstatusCS removal
- Bump version to 0.44.0
- Merge worktree-bead-fpde-bra — remove ZuzahlungsstatusCS stub

### Merge

- Worktree-bead-fpde-9fq

## [0.43.1] - 2026-05-01

### Bug Fixes

- **ci**: Pre-load terminology.imaging in release workflow before SUSHI

## [0.43.0] - 2026-04-30

### Miscellaneous

- Merge origin/main — resolve CHANGELOG and sushi-config conflicts (fpde-cpw.5 + fpde-cpw.6)
- Bump version to 0.43.0

## [0.42.0] - 2026-04-30

### Bug Fixes

- **ci**: Show full SUSHI output on error instead of tail -5
- **ci**: Use tee to stream SUSHI output and capture exit code correctly
- **ci**: Pre-load de.cognovis.terminology.imaging from npm.cognovis.de
- **ci**: Vendor de.cognovis.terminology.imaging for CI FHIR cache
- **fpde-cpw.6**: Address review findings iteration 1
- **fpde-cpw.6**: Address codex adversarial findings
- **fpde-cpw.5**: Address review findings iteration 1
- **fpde-cpw.5**: Replace vendor-specific term with vendor-neutral 'rule engine' in public IG surfaces

### Documentation

- **fpde-cpw.5**: Update changelog with imaging subscriptions, translate tests, architecture page

### Features

- **fpde-cpw.6**: Green — RoentgenProcedurePraxisDe, radiation-dose ext, ChargeItemPraxisDe invariant, IG page
- **fpde-cpw.6**: Add Strahlenschutz-Compliance & Röntgenbuch profiles (StrlSchG §83/§85)
- **fpde-cpw.5**: Add subscription templates, $translate tests, imaging billing architecture page

### Miscellaneous

- Update dist/package with imaging profiles from fpde-cpw.2 and fpde-cpw.4
- **fpde-cpw.5**: Update CHANGELOG for imaging subscriptions and ConceptMap tests
- Bump version to 0.42.0

### Merge

- Worktree-bead-fpde-cpw.5

### Test

- **fpde-cpw.6**: Red — stub FSH profiles and extensions

## [0.41.4] - 2026-04-30

### Bug Fixes

- **fpde-cpw.2**: Fix binding paths and endpoint payloadType for SUSHI compilation
- **fpde-cpw.2**: Address review findings iteration 1
- **fpde-cpw.2**: Address codex adversarial findings
- **fpde-cpw.4**: Address codex adversarial findings - use #profile discriminator for participant slicing

### Documentation

- Update changelog with fpde-cpw.4 imaging workflow profile entries

### Features

- **fpde-cpw.2**: Add hl7.fhir.uv.ips 1.1.0 dependency
- **fpde-cpw.2**: Add image-km-administration extension
- **fpde-cpw.2**: Add technique-parameter extension
- **fpde-cpw.2**: Add ImagingStudyPraxisDe profile on IPS ImagingStudy-uv-ips
- **fpde-cpw.2**: Add ImagingStudy examples (MRT Knie KM, CT Abdomen)
- **fpde-cpw.2**: Add ImagingStudy profile with DE extensions and IPS base
- **fpde-cpw.4**: Green -- imaging workflow profiles ServiceRequest, Appointment, Device
- **fpde-cpw.4**: Add imaging workflow profiles ServiceRequest, Appointment, Device

### Miscellaneous

- **fpde-cpw.4**: Bump version to 0.41.4 for imaging workflow profiles

### Merge

- Worktree-bead-fpde-cpw.2

### Test

- **fpde-cpw.4**: Red -- imaging workflow profiles not yet defined

## [0.41.3] - 2026-04-30

### Bug Fixes

- **fpde-cpw.3**: Address review findings iteration 1

### Documentation

- Update changelog for fpde-cpw.3 imaging diagnostic report profile
- Update changelog for fpde-cpw.3 imaging diagnostic report profile

### Features

- **fpde-cpw.3**: Add IHE IMR and KDL dependencies to sushi-config
- **fpde-cpw.3**: Add report-substatus and report-distribution extensions
- **fpde-cpw.3**: Add ImagingDiagnosticReportPraxisDe profile
- **fpde-cpw.3**: Add imaging diagnostic report examples
- **fpde-cpw.3**: Update dist package with imaging profile and new deps

### Miscellaneous

- **fpde-cpw.3**: Bump version to 0.41.3 for imaging diagnostic report profile

## [0.41.2] - 2026-04-30

### Bug Fixes

- **fpde-cpw.1b**: Address review findings iteration 1

### Features

- **fpde-cpw.1b**: Migrate cpw.1 terminology to external imaging package

### Miscellaneous

- **fpde-cpw.1b**: Update changelog for imaging terminology migration
- **fpde-cpw.1b**: Bump version to 0.41.2 for imaging terminology migration

## [0.41.1] - 2026-04-30

### Miscellaneous

- Vendor-clear public baseline v0.41.1


