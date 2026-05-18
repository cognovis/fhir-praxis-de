// AW-SST Billing Claim Examples
// Demonstrates the preliminary->final claim relationship for all 5 claim profiles.

// Shared inline references for billing claim examples
Instance: BillingClaimPatientExample
InstanceOf: Patient
Title: "Example Patient (Billing Claims)"
Description: "Example patient for billing claim examples"
Usage: #example
* identifier[0].system = "http://fhir.de/NamingSystem/gkv/kvid-10"
* identifier[0].value = "A987654321"
* name[0].family = "Musterfrau"
* name[0].given[0] = "Erika"
* birthDate = "1965-07-20"
* gender = #female

Instance: BillingClaimPractitionerExample
InstanceOf: Practitioner
Title: "Example Practitioner (Billing Claims)"
Description: "Example practitioner for billing claim examples"
Usage: #example
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_ANR"
* identifier[0].value = "123456789"
* name[0].family = "Mueller"
* name[0].given[0] = "Hans"
* name[0].prefix[0] = "Dr. med."

Instance: BillingClaimGKVInsurerExample
InstanceOf: Organization
Title: "Example GKV Insurer (Billing Claims)"
Description: "Techniker Krankenkasse as example GKV insurer"
Usage: #example
* identifier[0].system = "http://fhir.de/NamingSystem/arge-ik/iknr"
* identifier[0].value = "101575519"
* name = "Techniker Krankenkasse"

// --- Preliminary Billing Claim (item carrier) ---
Instance: PraxisPreliminaryBillingClaimExample
InstanceOf: PraxisPreliminaryBillingClaimDE
Title: "Preliminary Billing Claim Example"
Description: "Vorlaeufigerabrechnung mit den tatsaechlichen Abrechnungspositionen (EBM). Wird von finalen Claims per Claim.related referenziert."
Usage: #example
* status = #active
* use = #predetermination
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(BillingClaimPatientExample)
* created = "2024-04-01T08:00:00+02:00"
* provider = Reference(BillingClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(BillingClaimGKVInsurerExample)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "TK GKV-Versicherung"
* item[0].sequence = 1
* item[0].productOrService.coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM"
* item[0].productOrService.coding[0].code = #03000
* item[0].productOrService.coding[0].display = "Hausarztpauschale"
* item[0].quantity.value = 1
* item[0].quantity.system = "http://unitsofmeasure.org"
* item[0].quantity.code = #1
* item[1].sequence = 2
* item[1].productOrService.coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM"
* item[1].productOrService.coding[0].code = #03220
* item[1].productOrService.coding[0].display = "Chronikerzuschlag"
* item[1].quantity.value = 1
* item[1].quantity.system = "http://unitsofmeasure.org"
* item[1].quantity.code = #1

// --- Final GKV Claim ---
Instance: PraxisGKVClaimExample
InstanceOf: PraxisGKVClaimDE
Title: "GKV Claim Example"
Description: "Finaler GKV-Abrechnungsanspruch. Referenziert die vorlaeufigerabrechnung per Claim.related."
Usage: #example
* status = #active
* use = #claim
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(BillingClaimPatientExample)
* created = "2024-04-30T10:00:00+02:00"
* provider = Reference(BillingClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(BillingClaimGKVInsurerExample)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "TK GKV-Versicherung"
* related[0].claim = Reference(PraxisPreliminaryBillingClaimExample)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated

// --- Final Private Claim ---
Instance: PraxisPrivateClaimExample
InstanceOf: PraxisPrivateClaimDE
Title: "Private Claim Example"
Description: "Finaler Privatabrechnungsanspruch. Referenziert die vorlaeufigerabrechnung per Claim.related."
Usage: #example
* status = #active
* use = #claim
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(BillingClaimPatientExample)
* created = "2024-04-15T11:00:00+02:00"
* provider = Reference(BillingClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer.display = "Patient (Selbstzahler)"
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "Privatversicherung / Selbstzahler"
* related[0].claim = Reference(PraxisPreliminaryBillingClaimExample)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated

// --- Final BG Claim ---
Instance: PraxisBGClaimExample
InstanceOf: PraxisBGClaimDE
Title: "BG Claim Example"
Description: "Finaler BG-Abrechnungsanspruch (Unfallversicherung). Referenziert die vorlaeufigerabrechnung per Claim.related."
Usage: #example
* status = #active
* use = #claim
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(BillingClaimPatientExample)
* created = "2024-04-20T09:30:00+02:00"
* provider = Reference(BillingClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer.display = "DGUV / Berufsgenossenschaft Holz und Metall"
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "BG Unfallversicherung"
* accident.date = "2024-04-10"
* accident.type = http://terminology.hl7.org/CodeSystem/v3-ActIncidentCode#MVA
* related[0].claim = Reference(PraxisPreliminaryBillingClaimExample)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated

// --- Final Selective Contract Claim ---
Instance: PraxisSelectiveContractClaimExample
InstanceOf: PraxisSelectiveContractClaimDE
Title: "Selective Contract Claim Example"
Description: "Finaler Selektivvertrags-Abrechnungsanspruch (HZV). Referenziert die vorlaeufigerabrechnung per Claim.related."
Usage: #example
* status = #active
* use = #claim
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(BillingClaimPatientExample)
* created = "2024-04-30T12:00:00+02:00"
* provider = Reference(BillingClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(BillingClaimGKVInsurerExample)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "TK HZV-Selektivvertrag"
* related[0].claim = Reference(PraxisPreliminaryBillingClaimExample)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated
