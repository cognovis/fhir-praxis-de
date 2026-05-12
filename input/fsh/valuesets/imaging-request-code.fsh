// ImagingRequestCodeVS — LOINC-Codes fuer Bildgebungsanforderungen
// Preferred binding fuer ServiceRequest.code in ImagingServiceRequestPraxisDe.
// Includes selected radiology imaging procedure codes from LOINC.
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $loinc = http://loinc.org

ValueSet: ImagingRequestCodeVS
Id: imaging-request-code
Title: "Imaging Request Code"
Description: "LOINC-Codes fuer Bildgebungsanforderungen in der deutschen ambulanten Praxis. Preferred binding fuer ServiceRequest.code in ImagingServiceRequestPraxisDe."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/imaging-request-code"
* ^status = #active
* ^experimental = false

// Selected LOINC radiology order codes (MRI, CT, X-ray, US)
// All codes verified against tx.fhir.org CodeSystem/$lookup (2026-05-11)
//
// Codes removed in v0.57.0 (QA cleanup — wrong displays, replaced with correct codes):
//   #24558-9 "MRI of head" — WRONG: 24558-9 is "US Abdomen", not any head MRI.
//             Replaced by #24590-2 "MR Brain" for brain MRI requests.
//   #36803-5 "MRI of knee" — WRONG: 36803-5 is "MRA Pulmonary vessels", not knee MRI.
//             Replaced by #24802-1 "MR Knee" (correct LOINC for knee MRI).
//   #36218-5 — Removed in v0.56.0 QA cleanup (invalid code not in LOINC CodeSystem).
* $loinc#24802-1 "MR Knee"
* $loinc#24590-2 "MR Brain"
* $loinc#24627-2 "CT Chest"
* $loinc#24725-4 "CT Head"
* $loinc#24905-2 "MR Shoulder"
* $loinc#24556-3 "MR Abdomen"
* $loinc#24648-8 "XR Chest PA upright"
* $loinc#24558-9 "US Abdomen"
* $loinc#18748-4 "Diagnostische Bildgebung - Untersuchung"
