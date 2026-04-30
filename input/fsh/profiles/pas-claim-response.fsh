// Da Vinci PAS DE — Prior Authorization ClaimResponse
// Abbildung des KV-Genehmigungsbescheids auf FHIR ClaimResponse

Profile: PASClaimResponseDE
Parent: ClaimResponse
Id: pas-claim-response-de
Title: "PAS ClaimResponse DE"
Description: "Genehmigungsbescheid (Prior Authorization Response) fuer die deutsche ambulante Versorgung, angelehnt an Da Vinci PAS."
* status MS
* type MS
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* use = #preauthorization
* patient MS
* patient only Reference(Patient)
* insurer MS
* insurer only Reference(Organization)
* outcome MS
* item MS
* item.adjudication MS
