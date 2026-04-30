// Example PlanDefinition using praxis-plan-topic and praxis-plan-section codes
// Demonstrates how PraxisBillingPattern uses the new CodeSystems from ADR-001 Decision 3+4.
// This example represents a "chain"-type plan (Ziffernkette) with structured sections.

Instance: example-billingpattern-chain-with-topic
InstanceOf: PraxisBillingPattern
Title: "Beispiel BillingPattern mit Praxis Topic und Section Codes"
Description: "PraxisBillingPattern-Beispiel das praxis-plan-topic='chain' und praxis-plan-section-Aktionsgruppen demonstriert. Implements ADR-001 Decision 3+4."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/plan-definition-type#order-set
* title = "EBM-Ziffernkette: 01410 + 01416 (Hausbesuch)"
* description = "Automatische Mitnahmekette: Hausbesuch (01410) impliziert Wegepauschale (01416). Klassifiziert als 'chain' via praxis-plan-topic."

// Source-system billing pattern identifier
* identifier[billingPatternId].system = "https://fhir.cognovis.de/praxis/sid/billing-pattern-id"
* identifier[billingPatternId].value = "CHAIN-HB-001"

// Topic: chain — Ziffernkette (praxis-plan-topic)
* topic[0].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-plan-topic"
* topic[0].coding[0].code = #chain
* topic[0].coding[0].display = "Ziffernkette"

// Action group: ziffern section (praxis-plan-section)
* action[0].title = "Leistungsziffern"
* action[0].code[0].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-plan-section"
* action[0].code[0].coding[0].code = #ziffern
* action[0].code[0].coding[0].display = "Leistungsziffern"

// Sub-action: Hausbesuch EBM 01410
* action[0].action[0].title = "Hausbesuch (EBM 01410)"
* action[0].action[0].definitionCanonical = "https://fhir.cognovis.de/praxis/ActivityDefinition/ebm-01410"

// Sub-action: Wegepauschale EBM 01416
* action[0].action[1].title = "Wegepauschale (EBM 01416)"
* action[0].action[1].definitionCanonical = "https://fhir.cognovis.de/praxis/ActivityDefinition/ebm-01416"
