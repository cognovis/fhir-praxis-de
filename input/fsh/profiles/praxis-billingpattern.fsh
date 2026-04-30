Profile: PraxisBillingPattern
Parent: PlanDefinition
Id: praxis-billingpattern
Title: "Praxis BillingPattern"
Description: "Profil fuer Abrechnungsmuster (Ziffernketten) in der deutschen ambulanten Praxis. Repraesentiert abrechnungsnahe Ziffernketten als PlanDefinition-Ressource mit Stoppfeldern und ICD-Fokus."

// Fixed values
* status = #active
* type = http://terminology.hl7.org/CodeSystem/plan-definition-type#order-set (exactly)

// Title is required
* title 1..1

// Identifier: optional source-system billing pattern ID
* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains billingPatternId 0..1
* identifier[billingPatternId].system = "https://fhir.cognovis.de/praxis/sid/billing-pattern-id"
* identifier[billingPatternId].value 1..1

// useContext slicing: practitioner + icdFocus
* useContext ^slicing.discriminator.type = #pattern
* useContext ^slicing.discriminator.path = "code"
* useContext ^slicing.rules = #open
* useContext contains practitioner 0..1 and icdFocus 0..*
* useContext[practitioner].code = http://terminology.hl7.org/CodeSystem/usage-context-type#user
* useContext[practitioner].value[x] only CodeableConcept
* useContext[icdFocus].code = http://terminology.hl7.org/CodeSystem/usage-context-type#focus
* useContext[icdFocus].value[x] only CodeableConcept

// Stopfield extension
* extension contains BillingPatternStopfield named stopfield 0..*

// Actions reference ActivityDefinitions
* action.definitionCanonical only Canonical(ActivityDefinition)
* action.definitionUri 0..0
