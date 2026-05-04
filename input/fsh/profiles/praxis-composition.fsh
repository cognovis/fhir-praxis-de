// PraxisComposition — Dokumentkopf fuer Anamnese, Befund und Konsultationsnotizen
// Verbindet Dokumente mit Patient, Encounter und Autor (Arzt/PractitionerRole)

Profile: PraxisComposition
Parent: Composition
Id: praxis-composition
Title: "Praxis Composition"
Description: "Composition-Profil fuer die ambulante Praxis. Bildet den Dokumentkopf fuer Anamnese-, Befund- und Konsultationsnotizen ab. Verbindet das Dokument mit Patient, Encounter und Autor."

// Status: Pflicht
* status 1..1 MS

// Typ: Dokumentkategorie aus lokalem CodeSystem
* type 1..1 MS
* type from DokumentKategorieVS (extensible)

// Titel: Pflicht (lesbarer Dokumentname)
* title 1..1 MS

// Datum: Pflicht
* date 1..1 MS

// Autor: Pflicht — Arzt oder PractitionerRole
* author 1..* MS
* author only Reference(Practitioner or PractitionerRole)

// Patient: Pflicht
* subject 1..1 MS
* subject only Reference(Patient)

// Encounter-Verknuepfung: Optional (Schein-Referenz)
* encounter MS
* encounter only Reference(EncounterPraxis or Encounter)

// Abschnitte: mindestens ein section mit Freitext
* section 1..* MS
* section.title MS
* section.text MS
* section.entry MS
