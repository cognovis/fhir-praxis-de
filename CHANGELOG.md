# Changelog

All notable changes to this project will be documented in this file.

## [0.41.4] - 2026-04-30

### Bug Fixes

- **fpde-cpw.4**: Address codex adversarial findings - use #profile discriminator for participant slicing
- **fpde-cpw.2**: Fix binding paths and endpoint payloadType for SUSHI compilation
- **fpde-cpw.2**: Address review findings iteration 1
- **fpde-cpw.2**: Address codex adversarial findings

### Features

- **fpde-cpw.5**: Add imaging workflow Subscription templates for DiagnosticReport finalization, signing, and Appointment arrival events
- **fpde-cpw.5**: Add $translate smoke tests for billing suggestion ConceptMaps (ModalityToGoaeSuggestion, ImagingStudyToEbmGop) from de.cognovis.terminology.imaging
- **fpde-cpw.5**: Document 3-layer billing architecture: Terminology ConceptMaps (suggestions) → Catalog ChargeItemDefinitions → MIRA Rule-Engine business logic
- **fpde-cpw.4**: Add ImagingServiceRequestPraxisDe profile with IHE IMR inheritance, ICD-10-GM reasonCode slicing, insurance reference, and prior study support
- **fpde-cpw.4**: Add ImagingAppointmentPraxisDe profile with modality, preparation, and readiness extensions
- **fpde-cpw.4**: Add ImagingDevicePraxisDe profile with DICOM AE-Title identifier and maintenance status tracking
- **fpde-cpw.2**: Add hl7.fhir.uv.ips 1.1.0 dependency
- **fpde-cpw.2**: Add image-km-administration extension
- **fpde-cpw.2**: Add technique-parameter extension
- **fpde-cpw.2**: Add ImagingStudyPraxisDe profile on IPS ImagingStudy-uv-ips
- **fpde-cpw.2**: Add ImagingStudy examples (MRT Knie KM, CT Abdomen)

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


