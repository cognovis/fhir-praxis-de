// Szenario: Klinische Workflows — Ueberweisung, Einweisung, AU, Diagnose, AI-Provenance, Einwilligung
// Deckt ab: ServiceRequest, Condition, Provenance, Consent, ChargeItemDefinition

Instance: ExampleUeberweisung
InstanceOf: ServiceRequest
Title: "Ueberweisung Nephrologie — Weber"
Description: "Ueberweisung an Nephrologie wegen Diabetes mit AU-Bescheinigung und Referral-Optimierung."
Usage: #example
* status = #active
* intent = #order
* code.coding[0].system = "http://fhir.de/CodeSystem/bfarm/ops"
* code.coding[0].code = #1-100
* code.coding[0].display = "Ueberweisung"
* subject = Reference(example-patient)
* requester = Reference(example-practitioner)
* authoredOn = "2026-01-15"
// Ueberweisungs-Extensions
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/ue-unfall"
* extension[=].valueBoolean = false
// Referral-Optimierung
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/referral-sug-type"
* extension[=].valueString = "optimization"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/referral-cross-arztgruppe"
* extension[=].valueBoolean = true
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/referral-optimization-status"
* extension[=].valueString = "suggested"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/referral-optimization-delta"
* extension[=].valueDecimal = -12.50
// KHE-Extensions (Krankenhauseinweisung)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/khe-belegarzt"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/khe-notfall"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/khe-unfall"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/khe-bvg"
* extension[=].valueBoolean = false

Instance: ExampleDiagnose
InstanceOf: PraxisCondition
Title: "Diabetes mellitus Typ 2 — Dauerdiagnose rechts"
Description: "Gesicherte Dauerdiagnose mit Seitenlokalisation (rechts = Beispiel fuer Extension) und ICD-10-GM Diagnosesicherheit G (gesichert)."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[icd10gm].code = #E11.9
* code.coding[icd10gm].display = "Diabetes mellitus, Typ 2, ohne Komplikationen"
* code.coding[icd10gm].extension[diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#G "gesicherte Diagnose"
* subject = Reference(example-patient)
* recordedDate = "2020-03-15"
* extension[dauerdiagnose].valueBoolean = true

Instance: ExampleAiProvenance
InstanceOf: Provenance
Title: "AI-Provenance — Abrechnungsoptimierung Weber"
Description: "Provenance-Nachweis gemaess EU AI Act: KI-generierter Abrechnungsvorschlag, noch nicht vom Arzt reviewed."
Usage: #example
* target[0] = Reference(example-observation)
* recorded = "2026-01-15T10:30:00+01:00"
* agent[0].who = Reference(example-ai-device)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/ai-generated"
* extension[=].valueBoolean = true
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/ai-provider"
* extension[=].valueString = "Cognovis GmbH"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/ai-model"
* extension[=].valueString = "praxis-billing-optimizer-v2.1"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/ai-timestamp"
* extension[=].valueDateTime = "2026-01-15T10:30:00+01:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/ai-purpose"
* extension[=].valueString = "Abrechnungsoptimierung — fehlende EBM-Ziffern erkennen"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/human-reviewed"
* extension[=].valueBoolean = true
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/human-reviewer"
* extension[=].valueReference = Reference(example-practitioner)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/human-review-timestamp"
* extension[=].valueDateTime = "2026-01-15T16:45:00+01:00"

Instance: ExampleEinwilligung
InstanceOf: Consent
Title: "DMP-Einwilligung Weber"
Description: "Patienteneinwilligung zur Teilnahme am DMP Diabetes mellitus Typ 2 mit allen Einwilligungs-Extensions."
Usage: #example
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category[0] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* patient = Reference(example-patient)
* dateTime = "2019-06-15"
* policyRule = http://terminology.hl7.org/CodeSystem/v3-ActCode#OPTIN
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/einwilligung-kuerzel"
* extension[=].valueString = "DMP-DM2"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/einwilligung-zielgruppe"
* extension[=].valueString = "Patienten mit gesichertem Diabetes mellitus Typ 2"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/einwilligung-gueltigkeitsdauer"
* extension[=].valueDuration.value = 12
* extension[=].valueDuration.unit = "mo"
* extension[=].valueDuration.system = "http://unitsofmeasure.org"
* extension[=].valueDuration.code = #mo
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/einwilligung-widerruf-moeglich"
* extension[=].valueBoolean = true
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/einwilligung-auswahl"
* extension[=].valueString = "Ja"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/einwilligung-schein-nummer"
* extension[=].valueString = "S-2019-0642"

Instance: ExampleEbmKatalog
InstanceOf: ChargeItemDefinition
Title: "EBM 01735 — Chroniker-Beratung"
Description: "EBM-Leistungsdefinition: Beratung gemaess Chroniker-Richtlinie, 103 Punkte, 13.12 EUR, Ausschluesse und Fachgruppenrestriktionen."
Usage: #example
* status = #active
* url = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/ExampleEbmKatalog"
* title = "EBM 01735"
* description = "Beratung gemaess § 4 der Chroniker-Richtlinie zu Frueherkennungsuntersuchungen"
* code = http://fhir.de/CodeSystem/bfarm/ops#01735 "Chroniker-Beratung"
// Billing-Extensions
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-system"
* extension[=].valueString = "EBM"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-code"
* extension[=].valueString = "01735"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-category"
* extension[=].valueString = "Allgemeine Leistungen"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-points"
* extension[=].valueDecimal = 103
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-euro-value"
* extension[=].valueDecimal = 13.12
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-leistungsinhalt"
* extension[=].valueString = "Beratung gemaess Chroniker-Richtlinie ueber Teilnahme an Frueherkennungsuntersuchungen"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-requirements"
* extension[=].valueString = "Nur fuer nach dem 1. April 1987 geborene Frauen"
// billing-exclusions: individual valueCoding per excluded GOP
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-exclusions"
* extension[=].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM#01620
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-exclusions"
* extension[=].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM#01621
// billing-exclusions-context: complex extension for BF group
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-exclusions-context"
* extension[=].extension[+].url = "bezugsraum"
* extension[=].extension[=].valueCode = #BF
* extension[=].extension[+].url = "excludedGop"
* extension[=].extension[=].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM#01620
* extension[=].extension[+].url = "excludedGop"
* extension[=].extension[=].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM#01621
// billing-fachgruppen: individual valueCoding per Fachgruppe
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-fachgruppen"
* extension[=].valueCoding = https://fhir.cognovis.de/praxis/CodeSystem/kv-fachgruppe#allgemeinmedizin
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-fachgruppen"
* extension[=].valueCoding = https://fhir.cognovis.de/praxis/CodeSystem/kv-fachgruppe#innere-medizin
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-fachgruppen"
* extension[=].valueCoding = https://fhir.cognovis.de/praxis/CodeSystem/kv-fachgruppe#paediatrie
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-genehmigungspflicht"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-pruefzeit"
* extension[=].valueInteger = 6
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/billing-rlv-relevanz"
* extension[=].valueBoolean = true
// Katalog-Metadaten
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/catalog-is-active"
* extension[=].valueBoolean = true
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/catalog-version-label"
* extension[=].valueString = "Q1/2026"
// Alter/Geschlecht-Einschraenkungen
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/age-min"
* extension[=].valueInteger = 18
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/age-max"
* extension[=].valueInteger = 99
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/gender"
* extension[=].valueCode = #female
// Mengenrestriktionen
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/max-per-case"
* extension[=].valueInteger = 1
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/max-per-quarter"
* extension[=].valueInteger = 1
// GOÄ-spezifisch (Multiplikatoren)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/multiplier-min"
* extension[=].valueDecimal = 1.0
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/multiplier-default"
* extension[=].valueDecimal = 2.3
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/multiplier-max"
* extension[=].valueDecimal = 3.5
// BGT-Katalog
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/bgt-punkte"
* extension[=].valueDecimal = 0
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/bgt-katalog-gruppe"
* extension[=].valueString = "Allgemeine Leistungen"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/bgt-katalog-untergruppe"
* extension[=].valueString = "Chroniker-Beratung"
// Ergaenzungsziffer
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/supplement-to"
* extension[=].valueString = "03220"
// Sachkosten
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/sachkosten-price"
* extension[=].valueMoney.value = 0
* extension[=].valueMoney.currency = #EUR
// Preishistorie
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/price-history"
* extension[=].extension[+].url = "validFrom"
* extension[=].extension[=].valueDate = "2025-01-01"
* extension[=].extension[+].url = "validTo"
* extension[=].extension[=].valueDate = "2025-12-31"
* extension[=].extension[+].url = "points"
* extension[=].extension[=].valueDecimal = 99
* extension[=].extension[+].url = "euroValue"
* extension[=].extension[=].valueMoney.value = 12.40
* extension[=].extension[=].valueMoney.currency = #EUR
