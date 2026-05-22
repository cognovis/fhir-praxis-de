// HZV-Encounter Beispiel — Abrechnungsschein hausarztzentrierte Versorgung
// Demonstriert: EncounterPraxisHZV mit lokaler Praxis-Scheinart hzv und HZV-Rechnungsschema-Extension

Instance: hzv-encounter-example
InstanceOf: EncounterPraxisHZV
Title: "HZV-Abrechnungsschein AOK Bayern"
Description: "Beispiel-Abrechnungsschein fuer die hausarztzentrierte Versorgung (HZV). Lokale Praxis-Scheinart hzv, Rechnungsschema AOK Bayern."
Usage: #example

* identifier[scheinNummer].system = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* identifier[scheinNummer].value = "HZV-2026-00042"

* status = #finished

* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"

* type[praxis-scheinart].coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/scheinart"
* type[praxis-scheinart].coding.code = #hzv
* type[praxis-scheinart].coding.display = "HZV"

* subject = Reference(example-patient)

* period.start = "2026-04-10"
* period.end = "2026-04-10"

* participant[0].individual = Reference(example-practitioner)

* extension[hzv-rechnungsschema].valueReference = Reference(ExampleHzvBayernVertrag)
