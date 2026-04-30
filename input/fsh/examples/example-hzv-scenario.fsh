// HZV/Selektivvertrag billing scenario
// Demonstrates: Coverage with HZV class, Contract with hvg-kennung identifier, EncounterPraxisHZV with Reference(Contract), ChargeItem with HZV catalog CodeSystem
// Key contract: ChargeItem.code.coding.system carries the concrete HZV contract catalog, NOT EBM.
// HVG-Kennung is modeled as Contract.identifier (system: hvg-kennung NamingSystem), not as Extension.

// --- Coverage: GKV patient enrolled in HZV Bayern ---

Instance: example-coverage-hzv
InstanceOf: FPDECoverageGKV
Title: "GKV-Coverage mit HZV-Bayern-Klasse"
Description: "GKV-Versicherung eines HZV-Teilnehmers. Coverage.class signalisiert die HZV-Bayern-Vertragsteilnahme via class.type=plan und class.value=AOK_BY_HZV."
Usage: #example
* status = #active
* identifier[KrankenversichertenID].system = "http://fhir.de/sid/gkv/kvid-10"
* identifier[KrankenversichertenID].value = "A234567890"
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #GKV
* type.coding[VersicherungsArtDeBasis].display = "gesetzliche Krankenversicherung"
* beneficiary = Reference(example-patient)
* payor[0].display = "AOK Bayern"
* extension[wop].url = "http://fhir.de/StructureDefinition/gkv/wop"
* extension[wop].valueCoding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ITA_WOP"
* extension[wop].valueCoding.code = #71
* extension[wop].valueCoding.display = "Bayern"
// HZV-Vertragsteilnahme: class.type=plan, value=Vertragskatalog-Kennung, name=Vertragsname
* class[0].type = http://terminology.hl7.org/CodeSystem/coverage-class#plan
* class[0].value = "AOK_BY_HZV"
* class[0].name = "HZV Bayern - Einheitskatalog"

// --- Contract: HZV Bayern Einheitskatalog ---

Instance: ExampleHzvBayernVertrag
InstanceOf: Contract
Title: "HZV-Vertrag Bayern — Einheitskatalog (§73b SGB V)"
Description: "Hausarztvertrag Bayern gemaess §73b SGB V, Einheitskatalog. identifier[hvg-vertrags-id].value='AOK_BY_HZV'. HVG-Kennung als Contract.identifier (system: hvg-kennung), nicht mehr als Extension."
Usage: #example
* status = #executed
* applies.start = "2024-01-01"
* applies.end = "2026-12-31"
* subject[0] = Reference(example-organization)
* identifier[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/hvg-vertrag"
* identifier[0].value = "hzv-bayern-ek"
* identifier[1].system = "https://fhir.cognovis.de/praxis/NamingSystem/hvg-vertrags-id"
* identifier[1].value = "AOK_BY_HZV"
* identifier[2].system = "https://fhir.cognovis.de/praxis/NamingSystem/hvg-kennung"
* identifier[2].value = "BY"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-bezeichnung"
* extension[=].valueString = "HZV Bayern - Einheitskatalog"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-facharztvertrag"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-datum"
* extension[=].valueDate = "2024-01-01"

// --- EncounterPraxisHZV: HZV Abrechnungsschein referencing the Contract ---

Instance: ExampleEncounterHzvBayern
InstanceOf: EncounterPraxisHZV
Title: "HZV-Abrechnungsschein AOK Bayern"
Description: "Beispiel-Abrechnungsschein fuer die hausarztzentrierte Versorgung (HZV) AOK Bayern. extension[hzv-rechnungsschema] referenziert den Contract per Reference(ExampleHzvBayernVertrag)."
Usage: #example
* identifier[scheinNummer].system = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* identifier[scheinNummer].value = "HZV-2026-00099"
* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"
* type[kbv-scheinart].coding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* type[kbv-scheinart].coding.code = #50
* type[kbv-scheinart].coding.display = "HZV-Schein"
* subject = Reference(example-patient)
* period.start = "2026-04-10"
* period.end = "2026-04-10"
* participant[0].individual = Reference(example-practitioner)
* extension[hzv-rechnungsschema].valueReference = Reference(ExampleHzvBayernVertrag)

// --- ChargeItem: HZV service billed against the HZV contract catalog, NOT EBM ---

Instance: ExampleChargeItemHzv
InstanceOf: ChargeItem
Title: "HZV-Leistung: Hausaerztliche Grundpauschale Bayern"
Description: "Abgerechnete HZV-Leistung. code.coding.system traegt den konkreten HZV-Vertragskatalog (hzv-bayern-ek), NICHT EBM. Der Versicherungskontext (HZV) ist ueber die Coverage.class abgebildet."
Usage: #example
* status = #billable
* code.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/hzv-bayern-ek"
* code.coding[0].code = #HZVE001
* code.coding[0].display = "Hausaerztliche Grundpauschale HZV Bayern"
* subject = Reference(example-patient)
* performer[0].actor = Reference(example-practitioner)
* occurrenceDateTime = "2026-04-10"
// Coverage-Kontext: Die HZV-Coverage wird als supportingInformation referenziert.
// (ChargeItem.insurance existiert in FHIR R4 nicht; Abrechnungskontext laeuft ueber supportingInformation.)
* supportingInformation[0] = Reference(example-coverage-hzv)
* definitionUri = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/hzv-bayern-ek-HZVE001"
