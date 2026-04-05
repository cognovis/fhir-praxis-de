// Beispielinstanzen fuer Extensions ohne bisherige Beispiele
// Deckt ab: appointment-mode, aut-idem, avp, festbetrag, is-erezept,
//           is-dauermedikation, digital-workflow, manufacturing-deadline, patient-seit

// ---------------------------------------------------------------------------
// 1. Appointment mit appointment-mode Extension
// ---------------------------------------------------------------------------
Instance: ExampleAppointmentVideosprechstunde
InstanceOf: Appointment
Title: "Videosprechstunde — DMP-Kontrolle Weber"
Description: "Termin fuer eine DMP-Kontrolle per Videosprechstunde, demonstriert die appointment-mode Extension."
Usage: #example
* status = #booked
* start = "2026-04-10T09:00:00+02:00"
* end = "2026-04-10T09:15:00+02:00"
* participant[0].actor = Reference(example-patient)
* participant[0].status = #accepted
* participant[1].actor = Reference(example-practitioner)
* participant[1].status = #accepted
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/appointment-mode"
* extension[=].valueCode = AppointmentModeCS#video

// ---------------------------------------------------------------------------
// 2. MedicationRequest mit aut-idem, avp, festbetrag, is-erezept
// ---------------------------------------------------------------------------
Instance: ExampleMedicationRequestMetformin
InstanceOf: MedicationRequest
Title: "E-Rezept Metformin 1000mg — Weber"
Description: "Kassenrezept fuer Metformin mit aut-idem-Kreuz, AVP, Festbetrag und E-Rezept-Kennzeichen."
Usage: #example
* status = #active
* intent = #order
* medicationCodeableConcept.coding[0].system = "http://fhir.de/CodeSystem/ifa/pzn"
* medicationCodeableConcept.coding[0].code = #02532793
* medicationCodeableConcept.coding[0].display = "Metformin 1000mg Filmtabletten"
* subject = Reference(example-patient)
* requester = Reference(example-practitioner)
* authoredOn = "2026-04-05"
* dosageInstruction[0].text = "1-0-1 zu den Mahlzeiten"
// aut-idem: Substitution ausgeschlossen
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/aut-idem"
* extension[=].valueBoolean = true
// AVP (Apothekenverkaufspreis)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/avp"
* extension[=].valueMoney.value = 18.42
* extension[=].valueMoney.currency = #EUR
// Festbetrag (GKV-Festbetrag)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/festbetrag"
* extension[=].valueMoney.value = 16.80
* extension[=].valueMoney.currency = #EUR
// E-Rezept-Kennzeichen
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/is-erezept"
* extension[=].valueBoolean = true

// ---------------------------------------------------------------------------
// 3. MedicationStatement mit is-dauermedikation
// ---------------------------------------------------------------------------
Instance: ExampleMedicationStatementRamipril
InstanceOf: MedicationStatement
Title: "Dauermedikation Ramipril 5mg — Weber"
Description: "Dauermedikation: Ramipril zur Blutdrucksenkung, demonstriert die is-dauermedikation Extension."
Usage: #example
* status = #active
* medicationCodeableConcept.coding[0].system = "http://fhir.de/CodeSystem/ifa/pzn"
* medicationCodeableConcept.coding[0].code = #00584567
* medicationCodeableConcept.coding[0].display = "Ramipril 5mg Tabletten"
* subject = Reference(example-patient)
* effectivePeriod.start = "2022-06-01"
* dosage[0].text = "1-0-0 morgens"
// Dauermedikation-Kennzeichen
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/is-dauermedikation"
* extension[=].valueBoolean = true

// ---------------------------------------------------------------------------
// 4. ServiceRequest mit digital-workflow und manufacturing-deadline
// ---------------------------------------------------------------------------
Instance: ExampleServiceRequestZahntechnik
InstanceOf: ServiceRequest
Title: "Zahntechnik-Auftrag — Vollkeramikkrone 16"
Description: "Auftrag an zahntechnisches Labor fuer eine CAD/CAM-Vollkeramikkrone, demonstriert digital-workflow und manufacturing-deadline Extensions."
Usage: #example
* status = #active
* intent = #order
* code.text = "Vollkeramikkrone Zahn 16"
* subject = Reference(example-patient)
* requester = Reference(example-practitioner)
* authoredOn = "2026-04-05"
// Digitaler Workflow (CAD/CAM)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/digital-workflow"
* extension[=].valueCode = DigitalWorkflowCS#digital
// Gewuenschter Fertigstellungstermin
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/manufacturing-deadline"
* extension[=].valueDateTime = "2026-04-15T12:00:00+02:00"

// ---------------------------------------------------------------------------
// 5. Patient mit patient-seit Extension
// ---------------------------------------------------------------------------
Instance: ExamplePatientSeit
InstanceOf: Patient
Title: "Klaus Becker — Langzeitpatient"
Description: "Patient mit patient-seit Extension, der seit 2015 in der Praxis behandelt wird."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Becker"
* name[0].given[0] = "Klaus"
* gender = #male
* birthDate = "1958-11-23"
// Patient seit
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/patient-seit"
* extension[=].valueDate = "2015-03-10"
