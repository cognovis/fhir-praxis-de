// HZV-Encounter Beispiel — Abrechnungsschein hausarztzentrierte Versorgung
// Demonstriert: EncounterPraxisHZV mit fixiertem KBV-Scheinart #50 und HZV-Rechnungsschema-Extension

Instance: hzv-encounter-example
InstanceOf: EncounterPraxisHZV
Title: "HZV-Abrechnungsschein AOK Bayern"
Description: "Beispiel-Abrechnungsschein fuer die hausarztzentrierte Versorgung (HZV). Scheinart KBV #50, Rechnungsschema AOK Bayern."
Usage: #example

* identifier[scheinNummer].system = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* identifier[scheinNummer].value = "HZV-2026-00042"

* status = #finished

* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"

* type[kbv-scheinart].coding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* type[kbv-scheinart].coding.code = #50
* type[kbv-scheinart].coding.display = "HZV-Schein"

* subject = Reference(example-patient)

* period.start = "2026-04-10"
* period.end = "2026-04-10"

* participant[0].individual = Reference(example-practitioner)

* extension[hzv-rechnungsschema].valueReference = Reference(ExampleHzvBayernVertrag)
