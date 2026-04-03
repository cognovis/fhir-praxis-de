// PAS ClaimResponse Beispiele — Genehmigungsbescheide

// Genehmigter Antrag
Instance: PASClaimResponseApprovedExample
InstanceOf: PASClaimResponseDE
Title: "Genehmigungsbescheid — genehmigt"
Description: "Beispiel eines positiven Genehmigungsbescheids der AOK Bayern fuer die Langzeittherapie."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* use = #preauthorization
* patient = Reference(PASClaimPatientExample)
* created = "2024-03-03T14:00:00+01:00"
* insurer = Reference(PASClaimInsurerExample)
* request = Reference(PASClaimExample)
* outcome = #complete
* item[0].itemSequence = 1
* item[0].adjudication[0].category.coding[0].system = "http://terminology.hl7.org/CodeSystem/adjudication"
* item[0].adjudication[0].category.coding[0].code = #eligible
* item[0].adjudication[0].category.coding[0].display = "Eligible"

// Abgelehnter Antrag (Edge Case)
Instance: PASClaimResponseRejectedExample
InstanceOf: PASClaimResponseDE
Title: "Genehmigungsbescheid — abgelehnt"
Description: "Beispiel eines negativen Genehmigungsbescheids: Antrag fuer Hausarztpauschale wird abgelehnt (Leistung nicht genehmigungspflichtig)."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* use = #preauthorization
* patient = Reference(PASClaimPatientExample)
* created = "2024-03-07T11:15:00+01:00"
* insurer = Reference(PASClaimInsurerExample)
* request = Reference(PASClaimHausarztExample)
* outcome = #error
* error[0].code.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/adjudication-error"
* error[0].code.coding[0].code = #nicht-genehmigungspflichtig
* error[0].code.coding[0].display = "Nicht genehmigungspflichtig"
* item[0].itemSequence = 1
* item[0].adjudication[0].category.coding[0].system = "http://terminology.hl7.org/CodeSystem/adjudication"
* item[0].adjudication[0].category.coding[0].code = #ineligible
* item[0].adjudication[0].category.coding[0].display = "Ineligible"
