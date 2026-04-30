// PAS Claim Beispiele — Genehmigungsantraege

// Inline-Ressourcen fuer Referenzen
Instance: PASClaimPatientExample
InstanceOf: Patient
Title: "Beispiel-Patient (PAS)"
Description: "Beispiel-Patient fuer den Genehmigungsantrag"
Usage: #example
* identifier[0].system = "http://fhir.de/NamingSystem/gkv/kvid-10"
* identifier[0].value = "A123456789"
* name[0].family = "Mustermann"
* name[0].given[0] = "Max"
* birthDate = "1970-03-15"
* gender = #male

Instance: PASClaimPractitionerExample
InstanceOf: Practitioner
Title: "Beispiel-Arzt (PAS)"
Description: "Beispiel-Arzt fuer den Genehmigungsantrag"
Usage: #example
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_ANR"
* identifier[0].value = "456789012"
* name[0].family = "Schmidt"
* name[0].given[0] = "Maria"
* name[0].prefix[0] = "Dr."

Instance: PASClaimInsurerExample
InstanceOf: Organization
Title: "Beispiel-Kostentraeger (PAS)"
Description: "AOK Bayern als Beispiel-Kostentraeger"
Usage: #example
* identifier[0].system = "http://fhir.de/NamingSystem/arge-ik/iknr"
* identifier[0].value = "101575519"
* name = "AOK Bayern"

// Hauptbeispiel: Genehmigungsantrag fuer Langzeittherapie
Instance: PASClaimExample
InstanceOf: PASClaimDE
Title: "Genehmigungsantrag Langzeittherapie"
Description: "Beispiel eines Genehmigungsantrags fuer eine kardiovaskulaere Praevention (EBM 13210), eingereicht von Dr. Schmidt an AOK Bayern."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* use = #preauthorization
* patient = Reference(PASClaimPatientExample)
* created = "2024-03-01T09:00:00+01:00"
* provider = Reference(PASClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(PASClaimInsurerExample)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "AOK Bayern GKV-Versicherung"
* item[0].sequence = 1
* item[0].productOrService.coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM"
* item[0].productOrService.coding[0].code = #13210
* item[0].productOrService.coding[0].display = "Kardiovaskulaere Praevention"
* item[0].quantity.value = 10
* item[0].quantity.unit = "Sitzungen"
* item[0].quantity.system = "http://unitsofmeasure.org"
* item[0].quantity.code = #1

// Zweites Beispiel: Antrag fuer Hausarztpauschale
Instance: PASClaimHausarztExample
InstanceOf: PASClaimDE
Title: "Genehmigungsantrag Hausarztpauschale"
Description: "Beispiel eines Genehmigungsantrags fuer die Hausarztpauschale (EBM 03000)."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* use = #preauthorization
* patient = Reference(PASClaimPatientExample)
* created = "2024-03-05T10:30:00+01:00"
* provider = Reference(PASClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(PASClaimInsurerExample)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "AOK Bayern GKV-Versicherung"
* item[0].sequence = 1
* item[0].productOrService.coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM"
* item[0].productOrService.coding[0].code = #03000
* item[0].productOrService.coding[0].display = "Hausarztpauschale"
* item[0].quantity.value = 4
* item[0].quantity.unit = "Quartal"
* item[0].quantity.system = "http://unitsofmeasure.org"
* item[0].quantity.code = #1
