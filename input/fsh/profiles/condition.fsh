// Praxis Condition Profile — ICD-10-GM mit Diagnosesicherheit
// Pflichtfeld bei KV-Abrechnung (KVDT 6.06)

Profile: PraxisCondition
Parent: Condition
Id: praxis-condition
Title: "Praxis Condition"
Description: "Condition-Profil fuer die ambulante Praxis. Integriert ICD-10-GM Diagnosesicherheit (KVDT 6.06), Dauerdiagnose und Diagnoseseite."

// Must-Support elements
* code 1..1 MS
* code.coding MS
* clinicalStatus MS
* verificationStatus MS

// ICD-10-GM coding mit Diagnosesicherheit
* code.coding ^slicing.discriminator.type = #value
* code.coding ^slicing.discriminator.path = "system"
* code.coding ^slicing.rules = #open
* code.coding contains icd10gm 1..* MS

* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].extension contains
    http://fhir.de/StructureDefinition/icd-10-gm-diagnosesicherheit named diagnosesicherheit 0..1 MS

// Diagnosesicherheit-Invarianten (icd-4..icd-7) werden automatisch durch die
// upstream-Extension http://fhir.de/StructureDefinition/icd-10-gm-diagnosesicherheit
// aus de.basisprofil.r4 erzwungen — keine lokale Neudefinition noetig.

// Praxis-Extensions
* extension contains
    DauerdiagnoseExt named dauerdiagnose 0..1 MS

