// Extension: PraxisBillingActivityDefinitionExt
// Adds a canonical reference from ActivityDefinition to the corresponding ChargeItemDefinition.
// FHIR R4 ActivityDefinition does not have a native definitionCanonical field; this extension
// fills that gap for the plan-library catalog model. See ADR-001.

Extension: PraxisBillingActivityDefinitionExt
Id: praxis-billing-activity-definition
Title: "Praxis Billing Activity ChargeItemDefinition Reference"
Description: "Canonical reference from a PraxisBillingActivity (ActivityDefinition) to the corresponding ChargeItemDefinition. Used by the plan-library catalog to resolve billing codes to prices and points. Implements ADR-001 Decision 3: plan-library resources carry only structural catalog references, not rule-bearing computability."
Context: ActivityDefinition
* value[x] only Canonical(ChargeItemDefinition)
