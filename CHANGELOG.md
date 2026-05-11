# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.56.0] - 2026-05-11

### Bug Fixes

- **QA Cleanup**: Resolved 26 internal QA errors — fixed HumanName prefix extensions, DVMD display codes, ParticipationMode codes, imaging LOINC codes, and FHIRPath invariants across profiles and examples

### Documentation

- **QA Audit**: Created comprehensive audit report documenting v0.55.0 baseline (79 total errors: 26 internal, 53 external) with remediation strategy and external error suppressions

## [0.55.0] - 2026-05-11

### Bug Fixes

- **fpde-shp.8**: Address review findings iteration 1

### Features

- **fpde-shp.8**: Implement Condition constraints bundle (AC 1-10)

### Miscellaneous

- **fpde-shp.8**: Update changelog for v0.55.0
- **fpde-shp.8**: Session-close — regenerate changelog for v0.55.0

### Merge

- Worktree-bead-fpde-shp.8

## [0.54.0] - 2026-05-11

### Bug Fixes

- **fpde-shp.9**: Address review findings — typo, unused aliases, broken URL

### Documentation

- **fpde-shp.9**: Extend steuer-compliance.md with CID pattern diagram and UNECE migration notes

### Features

- **fpde-shp.9**: Extend tax extension context to include ChargeItemDefinition.propertyGroup.priceComponent
- **fpde-shp.9**: Migrate TaxCategoryDE ValueSet from local CS to UNECE-5305 URN
- **fpde-shp.9**: Add ChargeItemDefinition demo examples with UNECE-5305 tax category

### Miscellaneous

- Commit generated files before bead merge (worktree-bead-fpde-shp.9)
- **fpde-shp.9**: Bump version to 0.54.0
- **fpde-shp.9**: Update changelog for v0.54.0 release

### Merge

- Worktree-bead-fpde-shp.9

## [0.52.0] - 2026-05-11

### Bug Fixes

- **fpde-shp.2**: Address review findings iteration 1
- **fpde-shp.2**: Address codex adversarial findings
- **fpde-shp.7**: Address review findings iteration 1
- **fpde-shp.7**: Address codex adversarial findings
- **fpde-shp.7**: Add steuer-compliance to navigation menu

### Documentation

- **fpde-shp.2**: Add changelog entry for multi-coverage linking pattern

### Features

- **fpde-shp.2**: Add multi-coverage linking pattern documentation and examples
- **fpde-shp.2**: Add multi-coverage linking pattern for GKV + Zusatz/PKV/Beihilfe
- **fpde-shp.7**: Add UStBefreiungsgrundCS, TaxCategoryDE, ext-tax-category, ext-tax-exemption-reason, ext-ku-hinweis-pflicht
- **fpde-shp.7**: Green — PraxisInvoiceDE profile + invoice tax examples
- **fpde-shp.7**: Green — steuer-compliance pagecontent + version 0.52.0

### Miscellaneous

- **fpde-shp.7**: Update changelog for v0.52.0 release

### Merge

- Worktree-bead-fpde-shp.7
- Worktree-bead-fpde-shp.2

## [0.51.0] - 2026-05-10

### Bug Fixes

- **fpde-shp.6**: Address review findings iteration 1

### Documentation

- **fpde-shp.6**: Add changelog entry for kbv wrapper profiles

### Features

- **fpde-shp.6**: Green — 4 KBV wrapper profiles + kleinunternehmer ext + inheritance doc

### Miscellaneous

- Commit generated files before bead merge (worktree-bead-fpde-shp.6)
- **fpde-shp.6**: Update changelog for v0.51.0 release

### Merge

- Worktree-bead-fpde-shp.6

### Test

- **fpde-shp.6**: Red — test profiles extending PraxisDE wrappers (not yet created)

## [0.50.0] - 2026-05-10

### Bug Fixes

- **fpde-shp.5**: Address review findings (version pinning, file handles, dead import)
- **fpde-shp.5**: Ensure kbv.basis downloaded before snapshot generation (CI fresh runner fix)

### Documentation

- **fpde-shp.5**: Add changelog entry for kbv.basis snapshot composite action

### Features

- **fpde-shp.5**: Green — generate-kbv-basis-snapshots composite action + workflow integration
- **fpde-shp.5**: Add generate-kbv-basis-snapshots CI composite action

### Miscellaneous

- Commit generated files before bead merge (worktree-bead-fpde-shp.5)
- Bump version to 0.50.0

### Merge

- Worktree-bead-fpde-shp.5

### Test

- **fpde-shp.5**: Red — TestKBVCondition FSH fails without kbv.basis snapshots

## [0.49.0] - 2026-05-04

### Bug Fixes

- **fpde-daz**: Replace kbv.mio.impfpass with cognovis vocab repackage to drop de.basisprofil.r4@0.9.12 transitive dep
- **fpde-daz**: Pre-load kbv.mio.impfpass.vocab from npm.cognovis.de in CI

## [0.48.0] - 2026-05-04

### Features

- **fpde-daz**: Bind KBV-MIO-Impfpass vocabulary to PraxisImmunization + bump to 0.48.0

## [0.47.0] - 2026-05-04

### Bug Fixes

- Replace vendor-specific terms in public IG surfaces
- Remove remaining PVS product name from IG spec surfaces
- **ci**: Use _auth base64 token for Verdaccio instead of _password+username
- **fpde-daz**: Address review findings iteration 1
- Replace vendor-specific terms in external-repos doc

### Documentation

- **fpde-7yo**: Close epic + migrate Wave-2/3 sub-beads to fhir-deidentification-de

### Features

- **fpde-daz**: Add PraxisComposition and PraxisCommunication profiles
- **fpde-daz**: Add PraxisFlag and PraxisMedicationAdministration profiles
- **fpde-daz**: Add PraxisAnamneseQuestionnaireResponse and PraxisImmunization profiles
- **fpde-daz**: Bump version to 0.47.0 and update CHANGELOG

### Miscellaneous

- **fpde-daz**: Update changelog for session close

### Merge

- Worktree-bead-fpde-daz

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


