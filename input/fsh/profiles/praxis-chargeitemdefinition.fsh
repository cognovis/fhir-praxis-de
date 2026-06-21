// PraxisChargeItemDefinitionDE — PVS billing catalog entry profile
// ChargeItemDefinition.applicability is intentionally not populated per ADR-001 Decision 2
// (Rule-Execution boundary).

Profile: PraxisChargeItemDefinitionDE
Parent: ChargeItemDefinition
Id: praxis-chargeitemdefinition
Title: "Praxis ChargeItemDefinition DE"
Description: "ChargeItemDefinition profile for PVS-imported billing catalog entries in German ambulatory care. Supports standard R4 propertyGroup.priceComponent for point values and billing factors. ChargeItemDefinition.applicability is intentionally not populated per ADR-001 §Decision 2 (Rule-Execution boundary)."
* ^status = #active
* ^experimental = false
* ^publisher = "cognovis GmbH"

// --- Status and catalog identity ---
* status 1..1 MS
* status = #active
* url 1..1 MS
* code 1..1 MS
* title 1..1 MS
* description MS

// --- Price and point resolution ---
* propertyGroup MS
* propertyGroup.priceComponent MS
* propertyGroup.priceComponent.type 1..1 MS
* propertyGroup.priceComponent.code MS
* propertyGroup.priceComponent.amount MS
* propertyGroup.priceComponent.factor MS
