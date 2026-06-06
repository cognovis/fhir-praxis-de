// praxis-healthcare-service-de.fsh
// Ambulatory HealthcareService contract aligned with ISiK ISiKMedizinischeBehandlungseinheit
// Bead: fpde-ir8 — see ADR-007 and healthcare-service-contract.md

Profile: PraxisHealthcareServiceDE
Parent: HealthcareService
Id: praxis-healthcare-service-de
Title: "Praxis Healthcare Service DE"
Description: "Ambulatory practice service offering. Structurally aligned with gematik ISiK ISiKMedizinischeBehandlungseinheit (Terminplanung Stufe 5) without ISiK package dependency. Used to publish service offerings for downstream configuration consumers. KV Genehmigung evidence remains on Basic resources, not on HealthcareService.type."

* active 1..1 MS
* active ^short = "Whether the service offering is currently available"
* active ^definition = "ISiK-aligned: active status is mandatory. Inactive offerings remain in the record but MUST NOT be offered for scheduling or configuration."

* name 1..1 MS
* name ^short = "Human-readable service offering name"
* name ^definition = "Display name for the ambulatory service offering (e.g. practice name + specialty label)."

* identifier 0..* MS
* identifier ^short = "Business identifiers for the service offering"
* identifier ^definition = "Stable identifiers for downstream sync (e.g. internal service-offering id, KV Betriebsstaettennummer when applicable). Systems SHOULD persist at least one business identifier."

* providedBy 1..1 MS
* providedBy only Reference(PraxisOrganizationDE)
* providedBy ^short = "Organization that provides this service offering"
* providedBy ^definition = "The practice organization (PraxisOrganizationDE) responsible for this HealthcareService. Ambulatory anchor beyond ISiK hospital scope."

* location 0..* MS
* location only Reference(Location)
* location ^short = "Physical sites where this service is delivered"
* location ^definition = "Locations where the service offering is available. Shared Location references link co-located offerings and PractitionerRole.location routing."

* type 1..* MS
* type from PraxisHealthcareServiceTypeVS (extensible)
* type ^short = "Service-offering category"
* type ^definition = "PVS-agnostic service category. Do not use GenehmigungenLeistungsbereich codes here; KV authorization evidence belongs on Basic Genehmigung resources."

* specialty 1..* MS
* specialty from PraxisHealthcareServiceSpecialtyVS (extensible)
* specialty ^short = "Ambulatory specialty (Fachgruppe)"
* specialty ^definition = "Primary specialty using KBV BAR2-WBO. For ISiK hospital exchange, map to IHE XDS practice setting per healthcare-service-contract.md."
