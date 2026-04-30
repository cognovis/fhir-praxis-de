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

// CT-Codes
* http://loinc.org#24627-2 "CT study note"
* http://loinc.org#36643-5 "CT of thorax"
* http://loinc.org#24558-9 "CT Abdomen and Pelvis"

// MRT-Codes
* http://loinc.org#36554-4 "MRI study note"
* http://loinc.org#36803-5 "MRI of knee"

// Roentgen-Codes
* http://loinc.org#24648-8 "DXA study note"
* http://loinc.org#24893-0 "XR Chest 2 views"

// Sonographie-Codes
* http://loinc.org#24591-0 "US study note"
