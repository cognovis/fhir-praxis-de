// Da Vinci PAS DE — Prior Authorization Claim
// Abbildung des KV-Genehmigungsantrags auf FHIR Claim

Profile: PASClaimDE
Parent: Claim
Id: pas-claim-de
Title: "PAS Claim DE"
Description: "Genehmigungsantrag (Prior Authorization Request) fuer die deutsche ambulante Versorgung, angelehnt an Da Vinci PAS."
* status MS
* type MS
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* use = #preauthorization
* patient MS
* patient only Reference(Patient)
* provider MS
* provider only Reference(Practitioner or Organization)
* insurer MS
* insurer only Reference(Organization)
* item MS
* item.productOrService MS
* item.quantity MS
