// PraxisCarePlanDE — General practice CarePlan profile
// Humanmedizinisches Pendant zu DentalCarePlanDE (fhir-dental-de).
// Covers HZV, DMP, and generic care plan types for German ambulatory general practice.
//
// Plan type differentiation via category[planType] slice with PraxisCarePlanTypeVS.
// Subject: Patient 1..1 (mandatory).
// addresses: Condition (optional — relevant for DMP plans with a primary diagnosis).
//
// Computability slots (CarePlan.activity.detail.goal, .reasonCode beyond category)
// remain unconstrained — rule execution lives outside the IG per ADR-001.
// See ADR-001 (Plan-Library vs. Rule-Execution).

Profile: PraxisCarePlanDE
Parent: CarePlan
Id: praxis-care-plan
Title: "Praxis CarePlan DE"
Description: "General practice care plan profile for German ambulatory Praxisverwaltung. Covers HZV (§73b SGB V), DMP (§137f SGB V), and generic care plan types. Differentiates plan type via category[planType] slice with PraxisCarePlanTypeVS. Subject is always Patient (1..1). Parallel to DentalCarePlanDE (fhir-dental-de) for general (humanmedizinische) practice use. Implements ADR-001 (Plan-Library vs. Rule-Execution)."
* ^status = #active
* ^experimental = false
* ^publisher = "cognovis GmbH"

// --- Subject: Patient (mandatory) ---
* subject 1..1 MS
* subject only Reference(Patient)
* subject ^short = "Patient"

// --- Status ---
* status 1..1 MS
* status ^short = "Planstatus: draft | active | on-hold | revoked | completed"

// --- Intent: always plan ---
* intent = #plan
* intent ^short = "Planabsicht: immer 'plan'"

// --- Title ---
* title MS
* title ^short = "Planbeschreibung"

// --- Category: two slices — praxis (required) + planType (required) ---
* category ^slicing.discriminator.type = #pattern
* category ^slicing.discriminator.path = "$this"
* category ^slicing.rules = #open
* category contains praxis 1..1 MS and planType 1..1 MS

// praxis slice — fixed to praxis category marker
* category[praxis] = PraxisCarePlanCategoryCS#praxis "Praxis"
* category[praxis] ^short = "Praxis-Kategorie (immer 'praxis')"

// planType slice — bound to PraxisCarePlanTypeVS (required)
* category[planType] from PraxisCarePlanTypeVS (required)
* category[planType] ^short = "Plantyp: hzv | dmp | generic"

// --- Period ---
* period MS
* period ^short = "Behandlungszeitraum"

// --- Created ---
* created MS
* created ^short = "Erstelldatum"

// --- Addresses: Condition (optional — primary diagnosis for DMP plans) ---
* addresses MS
* addresses only Reference(Condition)
* addresses ^short = "Zugehoerige Diagnose (Condition), relevant fuer DMP-Plaene"

// --- Supporting Info ---
* supportingInfo MS
* supportingInfo ^short = "Unterstuetzende Informationen"

// --- Identifier ---
* identifier MS
* identifier ^short = "Interne Plan-ID"

// Helper CodeSystem — praxis category marker (in-file, no separate codesystem file needed)
// This inline CS avoids a separate file for a single-code marker system.
