// PraxisCarePlanCategoryCS — category marker for PraxisCarePlanDE
// Single-code system that marks this CarePlan as a Praxis (general practice) plan.
// Parallel to DentalCategoryCS in fhir-dental-de.

CodeSystem: PraxisCarePlanCategoryCS
Id: praxis-care-plan-category
Title: "Praxis CarePlan Category"
Description: "Category marker CodeSystem for PraxisCarePlanDE. Single code 'praxis' identifies this CarePlan as a general practice (humanmedizinisch) plan, in contrast to dental care plans (DentalCarePlanDE) from fhir-dental-de."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-care-plan-category"
* #praxis "Praxis" "Allgemeinmedizinischer / humanmedizinischer Behandlungsplan (Praxisverwaltung)"

// PraxisCarePlanTypeCS — plan type discriminator
// Differentiates HZV, DMP and generic care plans within PraxisCarePlanDE.

CodeSystem: PraxisCarePlanTypeCS
Id: praxis-care-plan-type
Title: "Praxis CarePlan Type"
Description: "Plan type codes for PraxisCarePlanDE category[planType] slice. Discriminates HZV (hausarzt), DMP (disease management), and generic care plan types."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-care-plan-type"
* #hzv "HZV" "Hausarztzentrierte Versorgungsplan (§73b SGB V)"
* #dmp "DMP" "Disease-Management-Programm-Plan (§137f SGB V)"
* #generic "Generisch" "Generischer Behandlungsplan (kein spezifischer Programmtyp)"

// PraxisCarePlanTypeVS — required binding for planType slice
ValueSet: PraxisCarePlanTypeVS
Id: praxis-care-plan-type
Title: "Praxis CarePlan Type"
Description: "Plan type codes for use as PraxisCarePlanDE.category[planType]. Covers HZV, DMP, and generic care plan types."
* ^status = #active
* ^experimental = false
* include codes from system PraxisCarePlanTypeCS
