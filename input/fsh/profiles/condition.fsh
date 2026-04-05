// Praxis Condition Profile — ICD-10-GM mit Diagnosesicherheit
// Pflichtfeld bei KV-Abrechnung (KVDT 6.06)

Profile: PraxisCondition
Parent: Condition
Id: praxis-condition
Title: "Praxis Condition"
Description: "Condition-Profil fuer die ambulante Praxis. Integriert ICD-10-GM Diagnosesicherheit (KVDT 6.06), Dauerdiagnose und Diagnoseseite."

// Must-Support elements
* code MS
* code.coding MS
* clinicalStatus MS
* verificationStatus MS

// ICD-10-GM coding mit Diagnosesicherheit
* code.coding ^slicing.discriminator.type = #value
* code.coding ^slicing.discriminator.path = "system"
* code.coding ^slicing.rules = #open
* code.coding contains icd10gm 0..* MS

* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].extension contains
    http://fhir.de/StructureDefinition/icd-10-gm-diagnosesicherheit named diagnosesicherheit 0..1 MS

// FHIRPath Invarianten fuer Diagnosesicherheit (aus de.basisprofil, Severity: warning)
* code.coding[icd10gm] obeys icd-4 and icd-5 and icd-6 and icd-7

// Praxis-Extensions
* extension contains
    DauerdiagnoseExt named dauerdiagnose 0..1 MS and
    DiagnoseSeiteExt named diagnoseSeite 0..1 MS

Invariant: icd-4
Description: "Wenn die Diagnosesicherheit \"A (Ausschluss)\" verwendet wird, dann muss clinicalStatus leer bleiben und verificationStatus auf \"refuted\" gesetzt werden."
Severity: #warning
Expression: "code!='A' or (%resource.verificationStatus.coding.where(code='refuted').exists() and %resource.clinicalStatus.empty())"

Invariant: icd-5
Description: "Wenn die Diagnosesicherheit \"G (Gesichert)\" verwendet wird, dann muss clinicalStatus auf \"active\" und verificationStatus auf \"confirmed\" gesetzt werden."
Severity: #warning
Expression: "code!='G' or (%resource.clinicalStatus.coding.where(code='active').exists() and %resource.verificationStatus.coding.where(code='confirmed').exists())"

Invariant: icd-6
Description: "Wenn die Diagnosesicherheit \"V (Verdacht auf)\" verwendet wird, dann muss clinicalStatus auf \"active\" und verificationStatus auf \"provisional\" oder \"differential\" gesetzt werden."
Severity: #warning
Expression: "code!='V' or (%resource.clinicalStatus.coding.where(code='active').exists() and (%resource.verificationStatus.coding.where(code='provisional').exists() or %resource.verificationStatus.coding.where(code='differential').exists()))"

Invariant: icd-7
Description: "Wenn die Diagnosesicherheit \"Z (Zustand nach)\" verwendet wird, dann muss clinicalStatus auf \"resolved\" und verificationStatus auf \"confirmed\" gesetzt werden."
Severity: #warning
Expression: "code!='Z' or (%resource.clinicalStatus.coding.where(code='resolved').exists() and %resource.verificationStatus.coding.where(code='confirmed').exists())"
