// Da Vinci PAS DE — Prior Authorization Task
// Workflow-Steuerung des Genehmigungsprozesses

Profile: PASTaskDE
Parent: Task
Id: pas-task-de
Title: "PAS Task DE"
Description: "Workflow-Task fuer den KV-Genehmigungsprozess (Prior Authorization), angelehnt an Da Vinci PAS."
* status MS
* intent MS
* intent = #order
* code MS
* code from PASTaskCodeVS (extensible)
* for MS
* for only Reference(Patient)
* requester MS
* requester only Reference(Practitioner or Organization)
* owner MS
* owner only Reference(Organization)
* input MS
* input ^slicing.discriminator.type = #pattern
* input ^slicing.discriminator.path = "type"
* input ^slicing.rules = #open
* input contains claimReference 0..1
* input[claimReference].type = http://terminology.hl7.org/CodeSystem/task-input-type#Reference
* input[claimReference].value[x] only Reference(PASClaimDE)
* output MS
* output ^slicing.discriminator.type = #pattern
* output ^slicing.discriminator.path = "type"
* output ^slicing.rules = #open
* output contains responseReference 0..1
* output[responseReference].type = http://terminology.hl7.org/CodeSystem/task-input-type#Reference
* output[responseReference].value[x] only Reference(PASClaimResponseDE)
