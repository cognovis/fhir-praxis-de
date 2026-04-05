// Praxis Specimen Profile — Probenmaterial fuer die ambulante Praxis
// Erweitert KBV MIO Labor Specimen mit LDT-Probenmaterial-Codierung (FK 8428)
// SNOMED-CT ist Pflichtcoding; LDT-Code optional.
//
// Proben-Identifier-Pattern: Labs vergeben eigene Identifikatoren.
// Kein shared NamingSystem — jedes Labor nutzt seine eigene System-URL.
// Beispiel: system = "https://<labor-url>/proben-id", value = "BL-2026-XXXXX"

// Hinweis: KBV_PR_MIO_LAB_Specimen (kbv.mio.laborbefund#1.0.0-kommentierung.2) hat keinen
// Snapshot in der Paketversion und kann daher nicht als Parent verwendet werden.
// Fallback auf base FHIR Specimen. Referenz auf KBV MIO Laborbefund ist in der
// Profil-Beschreibung dokumentiert.

Profile: PraxisSpecimen
Parent: Specimen
Id: praxis-specimen
Title: "Praxis Specimen"
Description: "Specimen-Profil fuer die ambulante Praxis. Angelehnt an KBV_PR_MIO_LAB_Specimen (kbv.mio.laborbefund). SNOMED-CT ist Pflichtcoding (type.coding[snomed]); zusaetzlicher LDT-Code (FK 8428) optional. Labore vergeben Proben-Identifier mit eigener System-URL (z.B. https://labor-beispiel.de/proben-id)."

// Proben-Identifier: optional, labs vergeben eigene Identifier
* identifier 0..* MS

// Probenmaterial: SNOMED-CT Pflichtcoding + optionaler LDT-Code
* type 1..1 MS
* type.coding MS
* type.coding ^slicing.discriminator.type = #value
* type.coding ^slicing.discriminator.path = "system"
* type.coding ^slicing.rules = #open
* type.coding contains snomed 1..1 MS and ldt 0..1

* type.coding[snomed] from ProbenmaterialSnomedVS (extensible)
* type.coding[snomed].system = "http://snomed.info/sct"
* type.coding[snomed].system MS
* type.coding[snomed].code MS

* type.coding[ldt].system = "https://fhir.cognovis.de/praxis/CodeSystem/ldt-materialbezeichnung"
* type.coding[ldt].system MS
* type.coding[ldt].code MS

// Must-Support Pflichtfelder
* subject only Reference(Patient)
* subject MS
* collection MS
* collection.collectedDateTime MS
* collection.method MS
* collection.bodySite MS
* container MS
* container.type MS
