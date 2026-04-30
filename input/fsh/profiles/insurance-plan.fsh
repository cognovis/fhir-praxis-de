Profile: InsurancePlanDE
Parent: InsurancePlan
Id: insurance-plan-de
Title: "InsurancePlan DE"
Description: "Profil fuer kassenspezifische und tarifspezifische Leistungsregeln (GKV/PKV) in der deutschen ambulanten Versorgung."

// Slicing on plan for GKV vs PKV differentiation
* plan ^slicing.discriminator.type = #pattern
* plan ^slicing.discriminator.path = "type"
* plan ^slicing.rules = #open
* plan contains
    gkv 0..* and
    pkv 0..*

// GKV slice: Satzungsleistungen, kassenindividuelle Leistungen
* plan[gkv].type = https://fhir.cognovis.de/praxis/CodeSystem/insurance-plan-type#gkv
* plan[gkv].type MS

// PKV slice: GOÄ-Faktoren, Erstattungsregeln
* plan[pkv].type = https://fhir.cognovis.de/praxis/CodeSystem/insurance-plan-type#pkv
* plan[pkv].type MS

// Must support fields
* status 1..1 MS
* name MS
* type MS
* coverageArea MS
* coverage MS
* coverage.benefit MS
* coverage.benefit.type MS
* plan.specificCost MS
* plan.specificCost.category MS
* plan.specificCost.benefit MS
* plan.specificCost.benefit.type MS
* identifier MS
