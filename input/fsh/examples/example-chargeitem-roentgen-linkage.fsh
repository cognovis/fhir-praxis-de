// example-chargeitem-roentgen-linkage.fsh — ChargeItem GOAe Ae5370 verknuepft mit RoentgenProcedurePraxisDe
// Zeigt: ChargeItemPraxisDe mit GOAe Ae5370 (CT Schaedel) verlinkt per ChargeItem.service
// auf RoentgenProcedurePraxisDe. Demonstriert Erfullung der Invariante radiation-service-required.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $sct = http://snomed.info/sct
Alias: $icd10gm = http://fhir.de/CodeSystem/bfarm/icd-10-gm
Alias: $goae = http://fhir.de/CodeSystem/goae
Alias: $radiology-role-cs = https://fhir.cognovis.de/praxis/CodeSystem/radiology-role

// --- Hilfsinstanz: Patient fuer Roentgen-Linkage-Beispiel ---
Instance: example-patient-roentgen-linkage
InstanceOf: Patient
Title: "Maria Becker — Patientin CT Schaedel"
Description: "Patientin fuer das ChargeItem-Roentgen-Linkage-Beispiel (CT Schaedel GOAe Ae5370)."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Becker"
* name[0].given[0] = "Maria"
* gender = #female
* birthDate = "1962-03-20"

// --- Hilfsinstanz: Encounter fuer CT Schaedel ---
Instance: example-encounter-ct-schaedel
InstanceOf: Encounter
Title: "Encounter — CT Schaedel Becker"
Description: "Ambulanter Encounter fuer CT Schaedel bei Patientin Becker."
Usage: #example
* status = #finished
* class.system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
* class.code = #AMB
* class.display = "ambulatory"
* subject = Reference(example-patient-roentgen-linkage)

// --- Hilfsinstanz: MTR fuer CT Schaedel ---
Instance: example-practitioner-mtr-ct
InstanceOf: Practitioner
Title: "Stefan Wagner — MTR (CT Schaedel)"
Description: "Medizinisch-Technischer Radiologieassistent fuer CT Schaedel Beispiel."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Wagner"
* name[0].given[0] = "Stefan"

// --- Hilfsinstanz: Strahlenschutzverantwortlicher fuer CT Schaedel ---
Instance: example-practitioner-radiologe-ct
InstanceOf: Practitioner
Title: "Prof. Dr. Peter Kurz — Radiologe (CT Schaedel)"
Description: "Radiologischer Facharzt als Strahlenschutzverantwortlicher fuer CT Schaedel."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Kurz"
* name[0].given[0] = "Peter"
* name[0].prefix[0] = "Prof. Dr."

// ============================================================
// RoentgenProcedurePraxisDe: CT Schaedel
// ============================================================
// Basis fuer ChargeItem.service Referenz (Linkage-Nachweis)
//
Instance: example-roentgen-procedure-ct-schaedel
InstanceOf: RoentgenProcedurePraxisDe
Title: "CT Schaedel — Roentgen Procedure (fuer ChargeItem Linkage)"
Description: "CT-Studie des Schaedels. Wird per ChargeItem.service von ChargeItemPraxisDe (GOAe Ae5370) referenziert um die Invariante radiation-service-required zu erfuellen."
Usage: #example

* status = #completed

// category: Diagnostische Prozedur (Fixed in Profile)
* category.coding[0].system = "http://snomed.info/sct"
* category.coding[0].code = #103693007
* category.coding[0].display = "Diagnostic procedure"

// code: CT Schaedel
* code.coding[0].system = "http://snomed.info/sct"
* code.coding[0].code = #303653007
* code.coding[0].display = "Computed tomography of head"

// subject
* subject = Reference(example-patient-roentgen-linkage)

// performedDateTime: Aufnahmedatum
* performedDateTime = "2026-04-30T14:00:00+02:00"

// performer[anwender]: MTR
* performer[anwender].function.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/radiology-role"
* performer[anwender].function.coding[0].code = #MTR
* performer[anwender].function.coding[0].display = "MTR"
* performer[anwender].actor = Reference(example-practitioner-mtr-ct)

// performer[strahlenschutzverantwortlicher]: Radiologe
* performer[strahlenschutzverantwortlicher].function.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/radiology-role"
* performer[strahlenschutzverantwortlicher].function.coding[0].code = #SupervisingRadiologist
* performer[strahlenschutzverantwortlicher].function.coding[0].display = "Supervising Radiologist"
* performer[strahlenschutzverantwortlicher].actor = Reference(example-practitioner-radiologe-ct)

// reasonCode[rechtfertigende-indikation]: ICD-10-GM G35 Multiple Sklerose (Screening)
* reasonCode[rechtfertigende-indikation].coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[rechtfertigende-indikation].coding[0].code = #G35
* reasonCode[rechtfertigende-indikation].coding[0].display = "Multiple Sklerose"
* reasonCode[rechtfertigende-indikation].text = "V.a. Multiple Sklerose — CT Schaedel zur Plaque-Diagnostik"

// ============================================================
// ChargeItemPraxisDe: GOAe Ae5370 (CT Schaedel) mit service Link
// ============================================================
// Invariante radiation-service-required ist erfuellt:
// code.coding mit GOAe Ae5370 (in radiation-relevant-billing-codes VS) →
// service.where(resolve() is Procedure).exists() = true
//
Instance: example-chargeitem-ct-schaedel-goae5370
InstanceOf: ChargeItemPraxisDe
Title: "ChargeItem GOAe Ae5370 — CT Schaedel mit RoentgenProcedure Linkage"
Description: "ChargeItem fuer GOAe Ae5370 (CT des Schaedels). ChargeItem.service verweist auf example-roentgen-procedure-ct-schaedel (RoentgenProcedurePraxisDe). Demonstriert Erfullung der Invariante radiation-service-required: Strahlenrelevanter Abrechnungscode → Pflicht-Verknuepfung zur Roentgen-Prozedur."
Usage: #example

* status = #billable

// subject: Patientin
* subject = Reference(example-patient-roentgen-linkage)

// context: Encounter
* context = Reference(example-encounter-ct-schaedel)

// code: GOAe Ae5370 — CT Schaedel (strahlenrelevanter Abrechnungscode)
* code.coding[0].system = "http://fhir.de/CodeSystem/goae"
* code.coding[0].code = #5370
* code.coding[0].display = "CT Schaedel"

// service: Referenz auf RoentgenProcedurePraxisDe (Pflicht gemaess Invariante)
// Invariante radiation-service-required: code in radiation-relevant-billing-codes VS →
// service.where(resolve() is Procedure).exists() muss true sein
* service[0] = Reference(example-roentgen-procedure-ct-schaedel)

// occurrenceDateTime: Leistungsdatum
* occurrenceDateTime = "2026-04-30T14:00:00+02:00"

// performer: Radiologin als ChargeItem-Performer
* performer[0].actor = Reference(example-practitioner-radiologe-ct)
