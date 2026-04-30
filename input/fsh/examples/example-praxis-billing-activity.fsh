// Examples for PraxisBillingActivity
// Demonstrates: EBM code + chargeItemDefinition extension link

// Example 1: EBM Hausbesuch (01410)
Instance: example-billing-activity-ebm-01410
InstanceOf: PraxisBillingActivity
Title: "Beispiel Billing Activity EBM 01410 (Hausbesuch)"
Description: "PraxisBillingActivity fuer den allgemeinmedizinischen Hausbesuch (EBM GOP 01410). Referenziert die entsprechende ChargeItemDefinition fuer Punktwert-Aufloesung. Implements ADR-001 Decision 3."
Usage: #example
* status = #active
* title = "Hausbesuch (EBM 01410)"
* description = "Ordination eines approbierten Arztes in der Wohnung des Patienten (EBM 01410)"
* code = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM#01410 "Hausbesuch"
* intent = #proposal
* extension[chargeItemDefinition].valueCanonical = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/ebm-01410"

// Example 2: GOÄ position (example)
Instance: example-billing-activity-goae-1
InstanceOf: PraxisBillingActivity
Title: "Beispiel Billing Activity GOÄ Nr. 1 (Beratung)"
Description: "PraxisBillingActivity fuer die GOÄ-Beratungsleistung Nr. 1. Demonstriert GOÄ-Code-Binding."
Usage: #example
* status = #active
* title = "Beratung GOÄ Nr. 1"
* description = "Eingehende Beratung, auch telefonisch (GOÄ Nr. 1)"
* code = https://fhir.de/CodeSystem/bak/goae#1 "Beratung"
* intent = #proposal
* extension[chargeItemDefinition].valueCanonical = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/goae-1"
