// Szenario: Privatpatient Weber — GOÄ-Abrechnung Q1/2026
// Kompletter Abrechnungsfall: Encounter → ChargeItems → Claim → Account → Mahnung → Zahlung
// Deckt ab: Account, ChargeItem, Claim, ClaimResponse, Communication, Coverage, Encounter, PaymentReconciliation

Instance: ExampleCoveragePrivat
InstanceOf: Coverage
Title: "PKV Debeka — Weber"
Description: "Privatkrankenversicherung des Patienten Weber bei der Debeka."
Usage: #example
* status = #active
* type = http://fhir.de/CodeSystem/versicherungsart-de-basis#PKV "Private Krankenversicherung"
* subscriber = Reference(example-patient)
* beneficiary = Reference(example-patient)
* payor[0].display = "Debeka PKV"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/hv-versicherten-nr"
* extension[=].valueString = "A123456789"

Instance: ExampleEncounterPrivat
InstanceOf: Encounter
Title: "Arztbesuch Weber 14.01.2026 — Privatpatient"
Description: "Ambulanter Besuch mit Diabetes/Hypertonie/Hypercholesterinaemie. Noch nicht freigegeben zur Abrechnung."
Usage: #example
* status = #in-progress
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"
* subject = Reference(example-patient)
* participant[0].individual = Reference(example-practitioner)
* period.start = "2026-01-14T09:30:00+01:00"
* serviceProvider = Reference(example-organization)
* reasonCode[0].coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[0].coding[0].code = #E11.9
* reasonCode[0].coding[0].display = "Diabetes mellitus, Typ 2, ohne Komplikationen"
* reasonCode[1].coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[1].coding[0].code = #E78.0
* reasonCode[1].coding[0].display = "Reine Hypercholesterinaemie"
* reasonCode[2].coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[2].coding[0].code = #I10.90
* reasonCode[2].coding[0].display = "Essentielle Hypertonie"
// Encounter-spezifische Extensions
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/privat-freigabe-status"
* extension[=].valueString = "billable"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/privat-reviewed-status"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/privat-reviewed-at"
* extension[=].valueDateTime = "2026-01-14T17:00:00+01:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/encounter-created-at"
* extension[=].valueDateTime = "2026-01-14T09:25:00+01:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/encounter-called"
* extension[=].valueDateTime = "2026-01-14T09:28:00+01:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/arrival-time"
* extension[=].valueDateTime = "2026-01-14T09:15:00+01:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/abrechnungsquartal"
* extension[=].valueString = "1/2026"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/linked-document"
* extension[=].valueReference = Reference(example-documentreference)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/cross-ak-billed-under"
* extension[=].valueReference = Reference(example-organization)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/au-typ"
* extension[=].valueString = "Erstbescheinigung"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/au-arbeitsunfall"
* extension[=].valueBoolean = false

Instance: ExampleChargeItemGOAE
InstanceOf: ChargeItem
Title: "GOÄ 5 — Symptombezogene Untersuchung"
Description: "GOÄ-Leistung mit Faktor 2.2, Sachkosten und Organangabe fuer Privatpatient Weber."
Usage: #example
* status = #billable
* code.coding[0].system = "http://fhir.de/CodeSystem/goae"
* code.coding[0].code = #5
* code.coding[0].display = "Symptombezogene Untersuchung"
* subject = Reference(example-patient)
* context = Reference(ExampleEncounterPrivat)
* performingOrganization = Reference(example-organization)
* occurrenceDateTime = "2026-01-14"
* quantity.value = 1
* factorOverride = 2.2
* priceOverride.value = 25.65
* priceOverride.currency = #EUR
// ChargeItem-Extensions: GOÄ-spezifisch
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rech-form-art"
* extension[=].valueString = "GOAE"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-faktor"
* extension[=].valueDecimal = 2.2
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-punkte"
* extension[=].valueDecimal = 80
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-organ"
* extension[=].valueString = "Abdomen"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-uhrzeit"
* extension[=].valueTime = "09:45:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-sachkosten-bezeichnung"
* extension[=].valueString = "Teststreifen Glucose"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-materialkosten"
* extension[=].valueMoney.value = 1.50
* extension[=].valueMoney.currency = #EUR
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/analog-reference"
* extension[=].valueString = "A420"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/manual-override"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/schein-position"
* extension[=].valueInteger = 1
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/statistikleistung"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/bgt-punkte"
* extension[=].valueDecimal = 0
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/reviewed-status"
* extension[=].valueString = "pending"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/reviewed-at"
* extension[=].valueDateTime = "2026-01-14T17:00:00+01:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/linked-document"
* extension[=].valueReference = Reference(example-documentreference)

Instance: ExampleClaimPrivat
InstanceOf: Claim
Title: "Privatrechnung Weber Q1/2026"
Description: "GOÄ-Abrechnung mit BG-Angaben und Review-Status fuer Privatpatient Weber."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* use = #claim
* patient = Reference(example-patient)
* created = "2026-01-31"
* provider = Reference(example-practitioner)
* priority = http://terminology.hl7.org/CodeSystem/processpriority#normal
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage = Reference(ExampleCoveragePrivat)
// Claim-Extensions: GOÄ, BG, Review
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rech-form-art"
* extension[=].valueString = "GOAE"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-faktor"
* extension[=].valueDecimal = 2.2
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-punkte"
* extension[=].valueDecimal = 80
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-organ"
* extension[=].valueString = "Abdomen"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-uhrzeit"
* extension[=].valueTime = "09:45:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-sachkosten-bezeichnung"
* extension[=].valueString = "Teststreifen Glucose"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/goae-materialkosten"
* extension[=].valueMoney.value = 1.50
* extension[=].valueMoney.currency = #EUR
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/analog-reference"
* extension[=].valueString = "A420"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rab-status"
* extension[=].valueString = "sent"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rab-ref"
* extension[=].valueString = "Claim/rab-privat-weber-q1-2026"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/manual-override"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/bg-aktenzeichen"
* extension[=].valueString = "BG-2026-12345"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/bg-unfalltag"
* extension[=].valueDate = "2026-01-10"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/privat-freigabe-status"
* extension[=].valueString = "billable"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/privat-reviewed-status"
* extension[=].valueBoolean = true
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/privat-reviewed-at"
* extension[=].valueDateTime = "2026-01-31T16:00:00+01:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/reviewed-status"
* extension[=].valueString = "approved"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/reviewed-at"
* extension[=].valueDateTime = "2026-01-31T16:00:00+01:00"
// Claim.item mit KV-Abrechnung Extensions
* item[0].sequence = 1
* item[0].productOrService.coding[0].system = "http://fhir.de/CodeSystem/goae"
* item[0].productOrService.coding[0].code = #5
* item[0].productOrService.coding[0].display = "Symptombezogene Untersuchung"
* item[0].extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/abrech-satzart"
* item[0].extension[=].valueString = "ACH"
* item[0].extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/abrech-feldkennung"
* item[0].extension[=].valueInteger = 5001

Instance: ExampleAccountOP
InstanceOf: Account
Title: "Offener Posten — Weber Q1/2026"
Description: "Offener Rechnungsposten mit Mahnwesen: Rechnung 228.44 EUR, noch unbezahlt, erste Mahnstufe."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#PBILLACCT "patient billing account"
* description = "Offener Posten — Rechnung Q1/2026 Weber"
* subject[0] = Reference(example-patient)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/rechnungsbetrag"
* extension[=].valueMoney.value = 228.44
* extension[=].valueMoney.currency = #EUR
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/op-soll"
* extension[=].valueMoney.value = 228.44
* extension[=].valueMoney.currency = #EUR
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/op-haben"
* extension[=].valueMoney.value = 0
* extension[=].valueMoney.currency = #EUR
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/mahnstufe"
* extension[=].valueInteger = 1
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/mahnsperre"
* extension[=].valueBoolean = false
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/faelligkeitsdatum"
* extension[=].valueDate = "2026-04-01"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/letzte-mahnung"
* extension[=].valueDate = "2026-04-15"

Instance: ExampleCommunicationMahnung
InstanceOf: Communication
Title: "1. Mahnung an Weber"
Description: "Erste Zahlungserinnerung mit Mahngebuehr und Bezug zum offenen Posten."
Usage: #example
* status = #completed
* category[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/communication-category"
* category[0].coding[0].code = #notification
* subject = Reference(example-patient)
* sent = "2026-04-15T10:00:00+01:00"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/mahngebuehr"
* extension[=].valueMoney.value = 5.00
* extension[=].valueMoney.currency = #EUR
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/op-ref"
* extension[=].valueReference = Reference(ExampleAccountOP)

Instance: ExamplePaymentReconPrivat
InstanceOf: PaymentReconciliation
Title: "Zahlung Weber — Teilzahlung Q3/2025"
Description: "Ueberweisung ueber 62.15 EUR als Teilzahlung einer Privatrechnung."
Usage: #example
* status = #active
* period.start = "2025-10-15"
* period.end = "2025-10-15"
* created = "2025-10-15"
* paymentDate = "2025-10-15"
* outcome = #complete
* paymentAmount.value = 62.15
* paymentAmount.currency = #EUR
* detail[0].type = http://terminology.hl7.org/CodeSystem/payment-type#payment "Payment"
* detail[0].date = "2025-10-15"
* detail[0].amount.value = 62.15
* detail[0].amount.currency = #EUR
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/zahlungsart"
* extension[=].valueCodeableConcept.text = "Ueberweisung"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/payment-patient-ref"
* extension[=].valueReference = Reference(example-patient)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/honorarbescheid-quartal"
* extension[=].valueString = "3/2025"
