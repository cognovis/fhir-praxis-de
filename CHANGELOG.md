# Changelog

All notable changes to this project will be documented in this file.

## [unreleased]

### Bug Fixes

- **ci**: Show full SUSHI output on error instead of tail -5
- **ci**: Use tee to stream SUSHI output and capture exit code correctly
- **ci**: Pre-load de.cognovis.terminology.imaging from npm.cognovis.de
- **ci**: Vendor de.cognovis.terminology.imaging for CI FHIR cache
- **fpde-cpw.5**: Address review findings iteration 1

### Documentation

- **fpde-cpw.5**: Update changelog with imaging subscriptions, translate tests, architecture page

### Features

- **fpde-cpw.5**: Add subscription templates, $translate tests, imaging billing architecture page

### Miscellaneous

- Update dist/package with imaging profiles from fpde-cpw.2 and fpde-cpw.4

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


