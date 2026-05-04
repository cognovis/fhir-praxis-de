// PraxisMedicationAdministration — In-Praxis-Medikamentengabe
// Injektionen, Infusionen und sonstige direkt verabreichte Medikamente

Profile: PraxisMedicationAdministration
Parent: MedicationAdministration
Id: praxis-medication-administration
Title: "Praxis Medication Administration"
Description: "MedicationAdministration-Profil fuer die ambulante Praxis. Bildet in der Praxis direkt verabreichte Medikamente (Injektionen, Infusionen) ab."

// Status: Pflicht
* status 1..1 MS

// Medikament: Nur CodeableConcept (kein Referenz-Slice)
* medication[x] only CodeableConcept
* medicationCodeableConcept 1..1 MS

// Patient: Pflicht
* subject 1..1 MS
* subject only Reference(Patient)

// Zeitpunkt: Nur effectiveDateTime (kein Period-Slice)
* effective[x] only dateTime
* effectiveDateTime 1..1 MS

// Dosierung: Menge als Quantity
* dosage MS
* dosage.dose MS
