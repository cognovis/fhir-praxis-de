// Szenario: Praxis-Konfiguration — RLV, Zeitbudget, Genehmigungen, KV-Benchmark
// Administrative Ressourcen (Basic) fuer die Praxiskonfiguration
// Deckt ab: Basic (alle 18+ Extensions), PractitionerRole, Contract, EpisodeOfCare, Flag
// Note: WB-Zuordnung (Basic#wb-zuordnung) entfaellt — WBA-Modellierung jetzt ueber PractitionerRole
//       mit WbRolleExt + WbSupervisorRoleExt (siehe ExamplePractitionerRoleWba)

Instance: ExampleRlvConfig
InstanceOf: Basic
Title: "RLV-Konfiguration — Dr. Schoell"
Description: "Regelleistungsvolumen-Konfiguration: Allgemeinmedizin Bayern, Fallwert 42.50 EUR, entbudgetiert."
Usage: #example
* code = BasicResourceTypeCS#rlv-budget
* subject = Reference(example-practitioner)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-kv-region"
* extension[=].valueString = "71"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-fachgruppe"
* extension[=].valueString = "Allgemeinmedizin"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-fallwert"
* extension[=].valueDecimal = 42.5
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-kategorie"
* extension[=].valueString = "Regelleistungsvolumen"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-qzv-fallwert"
* extension[=].valueDecimal = 15.80
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-zugewiesen"
* extension[=].valueDecimal = 12750.00
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-qzv-zugewiesen"
* extension[=].valueDecimal = 4740.00
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-entbudgetiert"
* extension[=].valueBoolean = true

Instance: ExampleKvBenchmark
InstanceOf: Basic
Title: "KV-Benchmark — Allgemeinmedizin Bayern 2026"
Description: "KV-Benchmarkdaten: Durchschnittliche Fallzahl, Honorar je Fall, Auszahlungsquote, RLV-Fallwerte nach Altersklassen."
Usage: #example
* code = BasicResourceTypeCS#kv-benchmark
* subject = Reference(example-organization)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-kv-region"
* extension[=].valueString = "Bayern"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-fachgruppe"
* extension[=].valueString = "Allgemeinmedizin"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-fachgruppe-code"
* extension[=].valueString = "010"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-gueltig-jahr"
* extension[=].valueInteger = 2026
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-durchschnitt-fallzahl"
* extension[=].valueDecimal = 850.0
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-honorar-je-fall"
* extension[=].valueDecimal = 42.50
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-auszahlungsquote"
* extension[=].valueDecimal = 0.85
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-rlv-fallwert-ak1"
* extension[=].valueDecimal = 38.20
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-rlv-fallwert-ak2"
* extension[=].valueDecimal = 42.50
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-rlv-fallwert-ak3"
* extension[=].valueDecimal = 51.30
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kv-benchmark-qzv-bereiche"
* extension[=].valueString = "QZV Diabetes, QZV Hypertonie, QZV Psychosomatik"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/kvbm-qzv-gops"
* extension[=].valueString = "03220, 03221, 03230, 35100, 35110"

Instance: ExampleGenehmigung
InstanceOf: Basic
Title: "Aerztliche Genehmigungen — Dr. Schmidt"
Description: "KV-Genehmigungen fuer Langzeit-EKG, Langzeit-Blutdruck und Sonografie Abdomen mit Aktenzeichen und Laufzeiten."
Usage: #example
* code = BasicResourceTypeCS#genehmigung
* subject = Reference(example-practitioner)
// Genehmigung 1: Langzeit-EKG
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/genehmigung-eintrag"
* extension[=].extension[+].url = "leistungsbereich"
* extension[=].extension[=].valueCode = #psychotherapie
* extension[=].extension[+].url = "genehmigungsdatum"
* extension[=].extension[=].valueDate = "2022-03-10"
* extension[=].extension[+].url = "ablaufdatum"
* extension[=].extension[=].valueDate = "2029-03-09"
* extension[=].extension[+].url = "kvAktenzeichen"
* extension[=].extension[=].valueString = "KVB-2022-EKG-0088"
// Genehmigung 2: Sonografie Abdomen
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/genehmigung-eintrag"
* extension[=].extension[+].url = "leistungsbereich"
* extension[=].extension[=].valueCode = #chirotherapie
* extension[=].extension[+].url = "genehmigungsdatum"
* extension[=].extension[=].valueDate = "2023-11-20"
* extension[=].extension[+].url = "ablaufdatum"
* extension[=].extension[=].valueDate = "2030-11-19"
* extension[=].extension[+].url = "kvAktenzeichen"
* extension[=].extension[=].valueString = "KVB-2023-USG-0203"
// Genehmigungstyp
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/genehmigung-typ"
* extension[=].valueCode = #kopfbezogen

Instance: ExampleZeitbudget
InstanceOf: Basic
Title: "Zeitbudget-Konfiguration — Dr. Schoell"
Description: "Zeitbudget 72.000 Minuten pro Quartal, Abrechnungskreise AK1 und AK2."
Usage: #example
* code = BasicResourceTypeCS#zeitbudget
* subject = Reference(example-practitioner)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/zeitbudget-max-minuten"
* extension[=].valueInteger = 72000
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/zeitbudget-abrechnungskreise"
* extension[=].valueString = "praxis-gibitzenhof"

Instance: ExampleHvgVertrag
InstanceOf: Contract
Title: "HVG-Vertrag — DMP Diabetes mellitus Typ 2"
Description: "Hausarztvertrag fuer DMP DM2: Facharztvertrag, Vertragsnummer 101, KV Bayern."
Usage: #example
* status = #executed
* applies.start = "2019-07-01"
* applies.end = "2026-12-31"
* subject[0] = Reference(example-organization)
* identifier[+].system = "https://fhir.cognovis.de/praxis/NamingSystem/hvg-kennung"
* identifier[=].value = "DMP-DM2"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-bezeichnung"
* extension[=].valueString = "DMP Diabetes mellitus Typ 2"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-kurzbezeichnung"
* extension[=].valueString = "DMP DM2"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-vertrag-nummer"
* extension[=].valueString = "101"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-datum"
* extension[=].valueDate = "2019-07-01"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-facharztvertrag"
* extension[=].valueBoolean = false
// RLV-Angaben auf Vertragsebene
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-kv-region"
* extension[=].valueString = "71"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-fachgruppe"
* extension[=].valueString = "Allgemeinmedizin"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-fallwert"
* extension[=].valueDecimal = 42.5
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-qzv-fallwert"
* extension[=].valueDecimal = 15.80
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-zugewiesen"
* extension[=].valueDecimal = 12750.00
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-qzv-zugewiesen"
* extension[=].valueDecimal = 4740.00
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-entbudgetiert"
* extension[=].valueBoolean = true
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rlv-kategorie"
* extension[=].valueString = "Regelleistungsvolumen"

Instance: ExampleHzvEpisode
InstanceOf: EpisodeOfCare
Title: "HZV-Einschreibung Weber — DMP DM2"
Description: "Patient Weber eingeschrieben im DMP Diabetes mellitus Typ 2 seit 2019, Antrag vom 15.06.2019."
Usage: #example
* status = #active
* type[0].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/hvg-vertragsart"
* type[0].coding[0].code = #DMP
* type[0].coding[0].display = "Disease Management Programm"
* patient = Reference(example-patient)
* managingOrganization = Reference(example-organization)
* period.start = "2019-07-01"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hzv-participation"
* extension[=].valueCodeableConcept = HzvParticipationCS#eingeschrieben "Eingeschrieben"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hzv-einschreibedatum"
* extension[=].valueDate = "2019-07-01"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hzv-abmeldedatum"
* extension[=].valueDate = "2030-12-31"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hvg-datum-beantragt"
* extension[=].valueDate = "2019-06-15"

Instance: ExampleHzvFlag
InstanceOf: Flag
Title: "HZV-Teilnahme-Flag Weber"
Description: "Flag fuer aktive HZV-Teilnahme des Patienten Weber."
Usage: #example
* status = #active
* category[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/flag-category"
* category[0].coding[0].code = #admin
* code.text = "HZV-Teilnahme aktiv"
* subject = Reference(example-patient)
* period.start = "2019-07-01"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hzv-participation"
* extension[=].valueCodeableConcept = HzvParticipationCS#eingeschrieben "Eingeschrieben"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hzv-einschreibedatum"
* extension[=].valueDate = "2019-07-01"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hzv-abmeldedatum"
* extension[=].valueDate = "2030-12-31"

Instance: ExamplePractitionerRole
InstanceOf: PractitionerRole
Title: "Arztrolle Dr. Schoell — Praxis Gibitzenhof"
Description: "Hausarzt-Rolle mit Zeitbudget und Cross-AK-Konfiguration."
Usage: #example
* active = true
* practitioner = Reference(example-practitioner)
* organization = Reference(example-organization)
* code[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
* code[0].coding[0].code = #doctor
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/zeitbudget-max-minuten"
* extension[=].valueInteger = 72000
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/zeitbudget-abrechnungskreise"
* extension[=].valueString = "praxis-gibitzenhof"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/cross-ak-is-primary"
* extension[=].valueBoolean = true

Instance: ExamplePractitionerRoleWba
InstanceOf: PractitionerRole
Title: "WBA-Rolle Dr. Mueller — Praxis Gibitzenhof"
Description: "Weiterbildungsassistent-Rolle: WB-Assistent mit Supervisor-Referenz auf Dr. Schoells PractitionerRole."
Usage: #example
* active = true
* practitioner = Reference(example-practitioner-wb)
* organization = Reference(example-organization)
* code[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
* code[0].coding[0].code = #doctor
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/wb-rolle"
* extension[=].valueCode = #wb-assistent
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/wb-supervisor-role"
* extension[=].valueReference = Reference(ExamplePractitionerRole)
