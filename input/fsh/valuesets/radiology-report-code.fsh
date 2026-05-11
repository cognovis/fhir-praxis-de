// RadiologyReportCodeVS — LOINC ValueSet fuer Radiologiebefund-Codes
// Enthaelt allgemeine Radiologie-LOINC-Codes sowie modalitaetsspezifische Codes
// fuer den deutschen ambulanten Radiologiebefund.
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

ValueSet: RadiologyReportCodeVS
Id: radiology-report-code
Title: "Radiology Report Code"
Description: "LOINC-Codes fuer Radiologiebefunde. Umfasst allgemeine Bildgebungs-Studiencodes sowie modalitaetsspezifische Codes (CT, MRT, Roentgen, Sonographie)."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/radiology-report-code"
* ^status = #active
* ^experimental = false

// Allgemeine Radiologie-Codes
* http://loinc.org#18748-4 "Diagnostic imaging study"
* http://loinc.org#68604-8 "Radiology diagnostic study note"

// CT-Codes (verified against tx.fhir.org 2026-05-11)
* http://loinc.org#24627-2 "CT Chest"
* http://loinc.org#24725-4 "CT Head"

// Sonographie/Ultraschall-Codes (verified against tx.fhir.org 2026-05-11)
* http://loinc.org#24558-9 "US Abdomen"

// MRT-Codes (verified against tx.fhir.org 2026-05-11)
* http://loinc.org#24802-1 "MR Knee"
* http://loinc.org#24590-2 "MR Brain"

// Roentgen-Codes (verified against tx.fhir.org 2026-05-11)
* http://loinc.org#24648-8 "XR Chest PA upright"
* http://loinc.org#24647-0 "XR Chest PA and Lateral upright"

// Sonographie-Codes Thorax (verified against tx.fhir.org 2026-05-11)
// Note: 24591-0 was incorrect (NM Brain code). 24630-6 = "US Chest" per tx.fhir.org.
* http://loinc.org#24630-6 "US Chest"
