// PraxisBillingActivity — ActivityDefinition profile
// Anchor for individual billing items referenced by PlanDefinition.action.definitionCanonical.
// Each instance represents one billing code (EBM GOP, GOÄ position, HZV-Ziffer, BEMA or GOZ code)
// as a reusable activity in a plan-library catalog.
//
// Implements ADR-001 Decision 3 and plan-chargeitem linkage.
// The chargeItemDefinition extension (1..1) links to the corresponding ChargeItemDefinition
// for price/point resolution at billing time.
//
// Computability slots (dynamicValue, condition) are intentionally left empty per ADR-001 §Decision 2.

Profile: PraxisBillingActivity
Parent: ActivityDefinition
Id: praxis-billing-activity
Title: "Praxis Billing Activity"
Description: "ActivityDefinition profile for individual billing code activities in the German practice management plan library. Serves as the anchor resource referenced by PlanDefinition.action.definitionCanonical within PraxisBillingPattern. The chargeItemDefinition extension (1..1) links to the corresponding ChargeItemDefinition for price and point resolution. Code binding covers EBM, GOÄ, HZV, BEMA, and GOZ billing systems. Implements ADR-001 (Plan-Library vs. Rule-Execution boundary) and plan-chargeitem linkage."
* ^status = #active
* ^experimental = false
* ^publisher = "cognovis GmbH"

// --- Status: active required ---
* status 1..1 MS
* status = #active

// --- Title: required for catalog display ---
* title 1..1 MS
* title ^short = "Anzeigename der Leistungsziffer"

// --- Code: billing code (EBM/GOÄ/HZV/BEMA/GOZ) ---
// code.coding.system must come from a recognized billing namespace.
// Binding: extensible — allows codes from all recognized German billing systems.
* code 1..1 MS
* code ^short = "Abrechnungsziffer (EBM, GOÄ, HZV, BEMA oder GOZ)"
* code from PraxisBillingCodeVS (extensible)

// --- ChargeItemDefinition reference (mandatory — AK3) ---
// FHIR R4 ActivityDefinition has no native definitionCanonical field.
// This extension adds the catalog link for price/point resolution.
* extension contains PraxisBillingActivityDefinitionExt named chargeItemDefinition 1..1 MS
* extension[chargeItemDefinition] ^short = "Referenz zur ChargeItemDefinition fuer Preis-/Punktwert-Aufloesung"
* extension[chargeItemDefinition].value[x] only Canonical(ChargeItemDefinition)

// --- Intent: proposal (catalog entry, not a direct order) ---
* intent = #proposal

// --- Description: optional free-text for catalog display ---
* description MS
* description ^short = "Beschreibung der Leistung (optional, fuer Katalog-Anzeige)"

// Computability slots are intentionally not constrained — they remain empty per ADR-001 §Decision 2.
// Do NOT populate dynamicValue or condition in adapter-emitted ActivityDefinition instances.
