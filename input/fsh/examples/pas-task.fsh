// PAS Task Beispiele — Workflow-Tasks fuer Genehmigungsprozesse

// Task: Antrag einreichen (aktiver Workflow)
Instance: PASTaskSubmitExample
InstanceOf: PASTaskDE
Title: "PAS Task — Antrag einreichen"
Description: "Workflow-Task fuer das Einreichen des Genehmigungsantrags bei der AOK Bayern."
Usage: #example
* status = #requested
* intent = #order
* code.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/pas-task-code"
* code.coding[0].code = #submit
* code.coding[0].display = "Antrag einreichen"
* for = Reference(PASClaimPatientExample)
* authoredOn = "2024-03-01T09:00:00+01:00"
* requester = Reference(PASClaimPractitionerExample)
* owner = Reference(PASClaimInsurerExample)
* input[claimReference].type.coding[0].system = "http://terminology.hl7.org/CodeSystem/task-input-type"
* input[claimReference].type.coding[0].code = #Reference
* input[claimReference].valueReference = Reference(PASClaimExample)

// Task: Antrag genehmigt — abgeschlossen mit Response
Instance: PASTaskCompletedExample
InstanceOf: PASTaskDE
Title: "PAS Task — Antrag genehmigt (abgeschlossen)"
Description: "Abgeschlossener Workflow-Task nach positiver Genehmigung durch die AOK Bayern."
Usage: #example
* status = #completed
* intent = #order
* code.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/pas-task-code"
* code.coding[0].code = #submit
* code.coding[0].display = "Antrag einreichen"
* for = Reference(PASClaimPatientExample)
* authoredOn = "2024-03-01T09:00:00+01:00"
* lastModified = "2024-03-03T14:00:00+01:00"
* requester = Reference(PASClaimPractitionerExample)
* owner = Reference(PASClaimInsurerExample)
* input[claimReference].type.coding[0].system = "http://terminology.hl7.org/CodeSystem/task-input-type"
* input[claimReference].type.coding[0].code = #Reference
* input[claimReference].valueReference = Reference(PASClaimExample)
* output[responseReference].type.coding[0].system = "http://terminology.hl7.org/CodeSystem/task-input-type"
* output[responseReference].type.coding[0].code = #Reference
* output[responseReference].valueReference = Reference(PASClaimResponseApprovedExample)

// Task: Status abfragen
Instance: PASTaskInquireExample
InstanceOf: PASTaskDE
Title: "PAS Task — Status abfragen"
Description: "Workflow-Task fuer die Statusabfrage eines laufenden Genehmigungsantrags."
Usage: #example
* status = #in-progress
* intent = #order
* code.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/pas-task-code"
* code.coding[0].code = #inquire
* code.coding[0].display = "Status abfragen"
* for = Reference(PASClaimPatientExample)
* authoredOn = "2024-03-02T08:30:00+01:00"
* requester = Reference(PASClaimPractitionerExample)
* owner = Reference(PASClaimInsurerExample)
* input[claimReference].type.coding[0].system = "http://terminology.hl7.org/CodeSystem/task-input-type"
* input[claimReference].type.coding[0].code = #Reference
* input[claimReference].valueReference = Reference(PASClaimExample)
