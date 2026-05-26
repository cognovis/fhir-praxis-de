// AW-SST Billing Claim Examples
// Demonstrates the preliminary->final claim relationship for all 5 claim profiles.
// Each final claim instance includes subType and a mandatory Claim.related reference.

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

Instance: BillingClaimPrivateInsurerExample
InstanceOf: Organization
Title: "Example Private Insurer (Billing Claims)"
Description: "Example private insurer for private billing claim examples"
Usage: #example
* identifier[0].system = "http://fhir.de/NamingSystem/arge-ik/iknr"
* identifier[0].value = "168140346"
* name = "DKV Deutsche Krankenversicherung"

Instance: BillingClaimBGInsurerExample
InstanceOf: Organization
Title: "Example BG Insurer (Billing Claims)"
Description: "Example Berufsgenossenschaft insurer for BG billing claim examples"
Usage: #example
* identifier[0].system = "http://fhir.de/NamingSystem/arge-ik/iknr"
* identifier[0].value = "120491885"
* name = "BG Holz und Metall"

// --- Source Conditions for quarterly Claim.diagnosis projection ---
// Same naked ICD with different Diagnosesicherheit stays separate.
Instance: BillingClaimQuarterDiabetesConfirmedCondition
InstanceOf: PraxisCondition
Title: "Quarter Diagnosis Source Condition - E11.90 Confirmed"
Description: "Source PraxisCondition for E11.90 with Diagnosesicherheit G; projects to one Claim.diagnosis entry."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].code = #E11.90
* code.coding[icd10gm].display = "Diabetes mellitus, Typ 2, ohne Komplikationen"
* code.coding[icd10gm].extension[diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#G "gesicherte Diagnose"
* subject = Reference(BillingClaimPatientExample)

Instance: BillingClaimQuarterDiabetesSuspectedCondition
InstanceOf: PraxisCondition
Title: "Quarter Diagnosis Source Condition - E11.90 Suspected"
Description: "Source PraxisCondition for E11.90 with Diagnosesicherheit V; same ICD as confirmed diabetes but a different billing tuple."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#provisional
* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].code = #E11.90
* code.coding[icd10gm].display = "Diabetes mellitus, Typ 2, ohne Komplikationen"
* code.coding[icd10gm].extension[diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#V "Verdacht auf / zum Ausschluss von"
* subject = Reference(BillingClaimPatientExample)

// Same naked ICD and Diagnosesicherheit with different Seitenlokalisation stays separate.
Instance: BillingClaimQuarterBackPainRightCondition
InstanceOf: PraxisCondition
Title: "Quarter Diagnosis Source Condition - M54.4 Right"
Description: "Source PraxisCondition for M54.4 G with Seitenlokalisation R; projects separately from the left-sided tuple."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].code = #M54.4
* code.coding[icd10gm].display = "Lumboischialgie"
* code.coding[icd10gm].extension[diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#G "gesicherte Diagnose"
* code.coding[icd10gm].extension[seitenlokalisation].url = "http://fhir.de/StructureDefinition/seitenlokalisation"
* code.coding[icd10gm].extension[seitenlokalisation].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_SEITENLOKALISATION#R "rechts"
* subject = Reference(BillingClaimPatientExample)

Instance: BillingClaimQuarterBackPainLeftCondition
InstanceOf: PraxisCondition
Title: "Quarter Diagnosis Source Condition - M54.4 Left"
Description: "Source PraxisCondition for M54.4 G with Seitenlokalisation L; same naked ICD as right-sided back pain but a different billing tuple."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].code = #M54.4
* code.coding[icd10gm].display = "Lumboischialgie"
* code.coding[icd10gm].extension[diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#G "gesicherte Diagnose"
* code.coding[icd10gm].extension[seitenlokalisation].url = "http://fhir.de/StructureDefinition/seitenlokalisation"
* code.coding[icd10gm].extension[seitenlokalisation].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_SEITENLOKALISATION#L "links"
* subject = Reference(BillingClaimPatientExample)

// Exact duplicate tuple sources remain as source Conditions, but collapse to one Claim.diagnosis entry.
Instance: BillingClaimQuarterBackPainDuplicateACondition
InstanceOf: PraxisCondition
Title: "Quarter Diagnosis Source Condition - M54.4 Duplicate A"
Description: "First source PraxisCondition for the exact M54.4 G tuple without laterality."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].code = #M54.4
* code.coding[icd10gm].display = "Lumboischialgie"
* code.coding[icd10gm].extension[diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#G "gesicherte Diagnose"
* subject = Reference(BillingClaimPatientExample)

Instance: BillingClaimQuarterBackPainDuplicateBCondition
InstanceOf: PraxisCondition
Title: "Quarter Diagnosis Source Condition - M54.4 Duplicate B"
Description: "Second source PraxisCondition with the exact same M54.4 G tuple; retained as source documentation and not projected as an extra Claim.diagnosis entry."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].code = #M54.4
* code.coding[icd10gm].display = "Lumboischialgie"
* code.coding[icd10gm].extension[diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#G "gesicherte Diagnose"
* subject = Reference(BillingClaimPatientExample)

// --- Preliminary Billing Claim (item carrier) ---
Instance: PraxisPreliminaryBillingClaimExample
InstanceOf: PraxisPreliminaryBillingClaimDE
Title: "Preliminary Billing Claim Example"
Description: "Vorlaeufigerabrechnung mit den tatsaechlichen Abrechnungspositionen (EBM). Wird von finalen Claims per Claim.related referenziert. Pflicht: mindestens eine item-Zeile (1..*). subType=vorlaeufig. Demonstriert Claim.diagnosis-Deduplizierung ueber den exakten Abrechnungstupel."
Usage: #example
* status = #active
* use = #predetermination
* subType = PraxisBillingClaimSubTypeCS#vorlaeufig
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
// Claim.diagnosis projection:
// E11.90 G and E11.90 V are separate because Diagnosesicherheit differs.
// M54.4 R and M54.4 L are separate because Seitenlokalisation differs.
// Two exact M54.4 G source Conditions without laterality collapse to one entry.
* diagnosis[0].sequence = 1
* diagnosis[0].diagnosisReference = Reference(BillingClaimQuarterDiabetesConfirmedCondition)
* diagnosis[1].sequence = 2
* diagnosis[1].diagnosisReference = Reference(BillingClaimQuarterDiabetesSuspectedCondition)
* diagnosis[2].sequence = 3
* diagnosis[2].diagnosisReference = Reference(BillingClaimQuarterBackPainRightCondition)
* diagnosis[3].sequence = 4
* diagnosis[3].diagnosisReference = Reference(BillingClaimQuarterBackPainLeftCondition)
* diagnosis[4].sequence = 5
* diagnosis[4].diagnosisReference = Reference(BillingClaimQuarterBackPainDuplicateACondition)
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
Description: "Finaler GKV-Abrechnungsanspruch. Referenziert die vorlaeufigerabrechnung per Claim.related (Pflicht). Keine item-Zeilen (item 0..0). subType=gkv."
Usage: #example
* status = #active
* use = #claim
* subType = PraxisBillingClaimSubTypeCS#gkv
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
Description: "Finaler Privatabrechnungsanspruch. Referenziert die vorlaeufigerabrechnung per Claim.related (Pflicht). Keine item-Zeilen (item 0..0). subType=privat."
Usage: #example
* status = #active
* use = #claim
* subType = PraxisBillingClaimSubTypeCS#privat
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(BillingClaimPatientExample)
* created = "2024-04-15T11:00:00+02:00"
* provider = Reference(BillingClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(BillingClaimPrivateInsurerExample)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "DKV Privatversicherung"
* related[0].claim = Reference(PraxisPreliminaryBillingClaimExample)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated

// --- Final BG Claim ---
// Note: BG accident context is carried via referenced Condition/Procedure resources,
// not via Claim.accident (which is not part of the AW final claim semantics for BG).
Instance: PraxisBGClaimExample
InstanceOf: PraxisBGClaimDE
Title: "BG Claim Example"
Description: "Finaler BG-Abrechnungsanspruch (Unfallversicherung). Referenziert die vorlaeufigerabrechnung per Claim.related (Pflicht). Keine item-Zeilen (item 0..0). subType=bg. Unfallkontext wird per referenzierter Condition/Procedure getragen."
Usage: #example
* status = #active
* use = #claim
* subType = PraxisBillingClaimSubTypeCS#bg
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(BillingClaimPatientExample)
* created = "2024-04-20T09:30:00+02:00"
* provider = Reference(BillingClaimPractitionerExample)
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(BillingClaimBGInsurerExample)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "BG Holz und Metall Unfallversicherung"
* related[0].claim = Reference(PraxisPreliminaryBillingClaimExample)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated

// --- Final Selective Contract Claim ---
Instance: PraxisSelectiveContractClaimExample
InstanceOf: PraxisSelectiveContractClaimDE
Title: "Selective Contract Claim Example"
Description: "Finaler Selektivvertrags-Abrechnungsanspruch (HZV). Referenziert die vorlaeufigerabrechnung per Claim.related (Pflicht). Keine item-Zeilen (item 0..0). subType=hzv-selektiv."
Usage: #example
* status = #active
* use = #claim
* subType = PraxisBillingClaimSubTypeCS#hzv-selektiv
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
