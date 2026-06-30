// Heilmittelverordnung (Muster 13) — Physiotherapie example for PraxisTherapeuticRemedyDE

Instance: example-therapeutic-remedy-physio
InstanceOf: PraxisTherapeuticRemedyDE
Title: "Heilmittelverordnung: Physiotherapie bei Wirbelsaeulenerkrankung"
Description: "Beispiel einer Heilmittelverordnung (Muster 13) fuer Physiotherapie mit Diagnosegruppe WS, Leitsymptomatik a, und 6 Behandlungseinheiten."
Usage: #example
* status = #active
* intent = #order
* category[therapeuticRemedy] = https://fhir.gevko.de/CodeSystem/EVO_CS_FOR_FormularArt#e13 "eHLM elektronische Heilmittelverordnung"
* subject = Reference(example-patient)
* requester = Reference(example-practitioner)
* authoredOn = "2026-04-10"
* reasonCode[icd10gm].coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[icd10gm].coding[0].code = #M54.5
* reasonCode[icd10gm].coding[0].display = "Kreuzschmerz"
* code.coding[0].system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Katalog"
* code.coding[0].code = #X0501
* code.coding[0].display = "Klassische Massage"
* orderDetail[diagnosegruppe].coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_HM_DIAGNOSEGRUPPE"
* orderDetail[diagnosegruppe].coding[0].code = #WS
* orderDetail[diagnosegruppe].coding[0].display = "Wirbelsaeulenerkrankungen"
* orderDetail[leitsymptomatik].coding[0].system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Leitsymptomatik"
* orderDetail[leitsymptomatik].coding[0].code = #a
* orderDetail[leitsymptomatik].coding[0].display = "Leitsymptomatik a"
* orderDetail[anlageTyp].coding[0].system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Section_Type"
* orderDetail[anlageTyp].coding[0].code = #HLM
* orderDetail[anlageTyp].coding[0].display = "Heilmittel"
* orderDetail[heilmittelbereich].coding[0].system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Heilmittelbereich"
* orderDetail[heilmittelbereich].coding[0].code = #PHYS
* orderDetail[heilmittelbereich].coding[0].display = "Physiotherapie"
* orderDetail[hausbesuch].coding[0].system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Hausbesuch"
* orderDetail[hausbesuch].coding[0].code = #0
* orderDetail[hausbesuch].coding[0].display = "Hausbesuch - NEIN"
* quantityQuantity.value = 6
* quantityQuantity.unit = "Behandlungseinheiten"
* occurrenceTiming.repeat.frequency = 1
* occurrenceTiming.repeat.period = 1
* occurrenceTiming.repeat.periodUnit = #wk
* insurance[0].reference = "Coverage/ExampleCoverageGkvZe"
