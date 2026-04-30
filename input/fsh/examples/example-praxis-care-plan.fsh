// Examples for PraxisCarePlanDE
// Demonstrates HZV, DMP, and generic plan types

// Example 1: HZV CarePlan
Instance: example-care-plan-hzv
InstanceOf: PraxisCarePlanDE
Title: "Beispiel CarePlan HZV (Hausarztzentrierte Versorgung)"
Description: "PraxisCarePlanDE fuer einen HZV-eingeschriebenen Patienten. Implements ADR-001."
Usage: #example
* status = #active
* intent = #plan
* title = "HZV-Versorgungsplan 2026"
* subject = Reference(example-patient-hzv)
* period.start = "2026-01-01"
* period.end = "2026-12-31"
* category[praxis] = PraxisCarePlanCategoryCS#praxis "Praxis"
* category[planType] = PraxisCarePlanTypeCS#hzv "HZV"

// Example Patient (shared resource for examples)
Instance: example-patient-hzv
InstanceOf: Patient
Title: "Beispiel Patient (HZV)"
Description: "Minimaler Patient fuer CarePlan-Beispiele."
Usage: #example
* name.family = "Mustermann"
* name.given[0] = "Max"
* birthDate = "1970-05-15"
* gender = #male

// Example 2: DMP CarePlan (Diabetes mellitus Typ 2)
Instance: example-care-plan-dmp-dm2
InstanceOf: PraxisCarePlanDE
Title: "Beispiel CarePlan DMP Diabetes mellitus Typ 2"
Description: "PraxisCarePlanDE fuer einen DMP-Diabetes-Patienten mit Verweis auf die Primaeidiagnose."
Usage: #example
* status = #active
* intent = #plan
* title = "DMP Diabetes mellitus Typ 2 — Quartal 1/2026"
* subject = Reference(example-patient-hzv)
* period.start = "2026-01-01"
* period.end = "2026-03-31"
* category[praxis] = PraxisCarePlanCategoryCS#praxis "Praxis"
* category[planType] = PraxisCarePlanTypeCS#dmp "DMP"
* addresses = Reference(example-condition-dm2)

// Example Condition for DMP
Instance: example-condition-dm2
InstanceOf: Condition
Title: "Beispiel Condition Diabetes mellitus Typ 2"
Description: "Primaeidiagnose fuer DMP-CarePlan-Beispiel."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* code.coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[0].code = #E11.90
* code.coding[0].display = "Diabetes mellitus, Typ 2: Ohne Komplikationen, nicht als entgleist bezeichnet"
* subject = Reference(example-patient-hzv)

// Example 3: Generic CarePlan
Instance: example-care-plan-generic
InstanceOf: PraxisCarePlanDE
Title: "Beispiel CarePlan Generic (Generisch)"
Description: "Generischer PraxisCarePlanDE ohne spezifischen Programmtyp."
Usage: #example
* status = #draft
* intent = #plan
* title = "Allgemeiner Behandlungsplan"
* subject = Reference(example-patient-hzv)
* category[praxis] = PraxisCarePlanCategoryCS#praxis "Praxis"
* category[planType] = PraxisCarePlanTypeCS#generic "Generisch"
