// DicomModalityVS — Wrapper for DICOM CID 29 Acquisition Modality codes
// References the fhir.dicom package CID 29 ValueSet.
// MUST NOT copy DICOM codes locally — references the canonical DICOM VS.
// Binding strength: required (for ImagingStudy.modality)
// Requires fhir.dicom: 2022.4.20221006 in sushi-config.yaml dependencies.

ValueSet: DicomModalityVS
Id: dicom-modality
Title: "DICOM Modality"
Description: "Acquisition modality codes from DICOM CID 29 (Acquisition Modality). Required binding for ImagingStudy.modality in DE imaging profiles. References the fhir.dicom package CID 29 ValueSet — codes are not copied locally."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/dicom-modality"
* ^status = #active
* ^experimental = false

// Include all codes from the DICOM CID 29 Acquisition Modality ValueSet
// (from fhir.dicom package, canonical: http://dicom.nema.org/medical/dicom/current/output/chtml/part16/sect_CID_29.html)
* include codes from valueset http://dicom.nema.org/medical/dicom/current/output/chtml/part16/sect_CID_29.html
