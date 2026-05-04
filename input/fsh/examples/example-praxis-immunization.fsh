// Beispiel: Influenza-Schutzimpfung in der Praxis
// Jahrliche Grippeschutzimpfung fuer Thomas Weber

Instance: example-praxis-immunization
InstanceOf: PraxisImmunization
Title: "Influenza-Impfung Weber 2025"
Description: "Jaehrliche Influenza-Schutzimpfung bei Patient Thomas Weber (Oktober 2025)."
Usage: #example

* status = #completed
* vaccineCode.coding[0].system = "http://snomed.info/sct"
* vaccineCode.coding[0].code = #46233009
* vaccineCode.coding[0].display = "Influenza virus vaccine"
* vaccineCode.text = "Influvac Tetra — Influenza-Impfstoff quadrivalent"
* patient = Reference(example-patient)
* occurrenceDateTime = "2025-10-15"

// Verabreichender Arzt mit LANR
* performer[0].actor = Reference(example-practitioner)
* performer[0].actor.identifier.system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_ANR"
* performer[0].actor.identifier.value = "123456789"
