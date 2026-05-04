// PraxisFlag — Patientenbezogene Flags in der ambulanten Praxis
// CAVE, Hinweise, Risiken, OP-Hinweise, DICOM-Sicherheitshinweise

Profile: PraxisFlag
Parent: Flag
Id: praxis-flag
Title: "Praxis Flag"
Description: "Flag-Profil fuer die ambulante Praxis. Bildet patientenbezogene Flags (CAVE, Hinweise, Risiken, OP-Hinweise, DICOM-Sicherheitshinweise) ab."

// Status: Pflicht
* status 1..1 MS

// Kategorie: Required-Binding auf lokales CodeSystem
* category 1..* MS
* category from FlagKategorieVS (required)

// Code: Pflicht (Freitext-Beschreibung des Flags)
* code 1..1 MS

// Patient: Pflicht
* subject 1..1 MS
* subject only Reference(Patient)

// Gueltigkeitszeitraum: Must-Support fuer Flag-Gueltigkeit
* period MS
