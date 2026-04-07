// Szenario: KV-Honorarbescheid Q3/2025 — Richtigstellungen und Korrekturen
// Realer Abrechnungsbescheid der KV Bayern mit Absetzungen
// Deckt ab: ClaimResponse (Honorarbescheid-Extensions)

Instance: ExampleHonorarbescheid
InstanceOf: ClaimResponse
Title: "Honorarbescheid Q3/2025 — mit Richtigstellung"
Description: "KV-Honorarbescheid mit Absetzung (UV10255): Leistung 95166H fuer Patient Mueller abgesetzt, Korrektur -3.56 EUR."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* use = #claim
* patient = Reference(example-patient)
* created = "2025-07-01"
* insurer = Reference(example-organization)
* outcome = #complete
// Honorarbescheid-Kopfdaten
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/honorarbescheid-quartal"
* extension[=].valueString = "3/2025"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/honorarbescheid-correction-sign"
* extension[=].valueString = "SR"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/honorarbescheid-patient-name"
* extension[=].valueString = "Mueller, Hans"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/honorarbescheid-patient-birthdate"
* extension[=].valueDate = "1958-03-22"
