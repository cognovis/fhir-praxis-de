// praxis-plan-section — Action-group marker CodeSystem for PlanDefinition.action.code
// Marks structural sections within a PraxisBillingPattern action tree.
// Implements ADR-001 Decision 4: section-level grouping via CodeSystem, not slice constraints.
// Convention enforcement (a Job MUST have all three sections) is the adapter's responsibility,
// not FHIR profile validation. See ADR-001 §Rejected Alternatives B.

CodeSystem: PraxisPlanSectionCS
Id: praxis-plan-section
Title: "Praxis Plan Section"
Description: "Action-group markers for PlanDefinition.action.code within PraxisBillingPattern resources. Identifies the structural role of an action group (documentation, billing codes, diagnoses). Implements ADR-001 Decision 4. Extensible without profile version bump."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-plan-section"
// Behandlungsdokumentation section: free-text or structured documentation activities
* #behandlungsdoku "Behandlungsdokumentation" "Aktionsgruppe fuer Behandlungsdokumentation (Freitext, strukturierte Befunde, Anamnese-Items)"
// Ziffern section: billing code activities (EBM/GOÄ/BEMA/HZV codes)
* #ziffern "Leistungsziffern" "Aktionsgruppe fuer Abrechnungsziffern (EBM, GOÄ, BEMA, HZV, GOZ)"
// Diagnosen section: diagnosis/ICD-code activities
* #diagnosen "Diagnosen" "Aktionsgruppe fuer Diagnosen (ICD-10-GM Codes, SNOMED CT)"

// Companion ValueSet — all section codes (extensible)
ValueSet: PraxisPlanSectionVS
Id: praxis-plan-section
Title: "Praxis Plan Section"
Description: "All codes from the praxis-plan-section CodeSystem. Bind to PlanDefinition.action.code (extensible) to mark structural sections within PraxisBillingPattern actions."
* ^status = #active
* ^experimental = false
* include codes from system PraxisPlanSectionCS
