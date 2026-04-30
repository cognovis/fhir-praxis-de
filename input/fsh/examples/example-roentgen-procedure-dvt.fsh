// example-roentgen-procedure-dvt.fsh — DVT Oberkiefer mit rechtfertigender Indikation
// Zeigt: RoentgenProcedurePraxisDe mit ICD-10-GM Indikation + Attestierungsextension,
// Anwender (MTR) mit Fachkunde-Extension (DVT), Strahlendosis-Extension.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $sct = http://snomed.info/sct
Alias: $icd10gm = http://fhir.de/CodeSystem/bfarm/icd-10-gm
Alias: $radiology-role-cs = https://fhir.cognovis.de/praxis/CodeSystem/radiology-role
Alias: $fachkunde-cs = https://fhir.cognovis.de/imaging/CodeSystem/fachkunde-strahlenschutz
Alias: $radiation-dose-ext = https://fhir.cognovis.de/praxis/StructureDefinition/radiation-dose
Alias: $ri-attest-ext = https://fhir.cognovis.de/praxis/StructureDefinition/rechtfertigende-indikation-attest
Alias: $anwender-fachkunde-ext = https://fhir.cognovis.de/praxis/StructureDefinition/anwender-fachkunde

// --- Hilfsinstanz: Radiologin (Strahlenschutzverantwortliche) ---
Instance: example-practitioner-radiologin-dvt
InstanceOf: Practitioner
Title: "Dr. Anna Hofmann — Radiologin (Strahlenschutzverantwortliche DVT)"
Description: "Radiologin als Strahlenschutzverantwortliche fuer DVT Oberkiefer-Beispiel."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Hofmann"
* name[0].given[0] = "Anna"
* name[0].prefix[0] = "Dr."

// --- Hilfsinstanz: MTR (Anwender DVT) ---
Instance: example-practitioner-mtr-dvt
InstanceOf: Practitioner
Title: "Klaus Richter — MTR (Anwender DVT)"
Description: "Medizinisch-Technischer Radiologieassistent als Anwender fuer DVT Oberkiefer."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Richter"
* name[0].given[0] = "Klaus"

// ============================================================
// Hauptbeispiel: DVT Oberkiefer mit Implantatplanung Region 16
// ============================================================
// Indikation: Implantatplanung Region 16 (ICD-10-GM K08.1 — Verlust von Zaehnen)
// Anwender: Klaus Richter (MTR), Fachkunde DVT
// Dosis: DAP 1500 microGy*m2, kVp 90 kV
//
Instance: example-dvt-oberkiefer-implantat
InstanceOf: RoentgenProcedurePraxisDe
Title: "DVT Oberkiefer — Implantatplanung Region 16"
Description: "Digitale Volumentomographie (DVT) des Oberkiefers fuer Implantatplanung Region 16. Zeigt rechtfertigende Indikation (ICD-10-GM K08.1) mit Attestierungsmetadaten, Anwender (MTR) mit DVT-Fachkunde-Extension und Strahlendosis-Extension."
Usage: #example

// Status: completed
* status = #completed

// category: Diagnostische Prozedur (SNOMED 103693007) — Fixed in Profile
* category.coding[0].system = "http://snomed.info/sct"
* category.coding[0].code = #103693007
* category.coding[0].display = "Diagnostic procedure"

// code: DVT (aus ImagingProcedureVS — extensible)
* code.coding[0].system = "http://snomed.info/sct"
* code.coding[0].code = #1255414003
* code.coding[0].display = "Cone beam computed tomography of maxilla"

// subject: Patient
* subject = Reference(example-patient)

// performedDateTime: Aufnahmedatum (Pflicht gemaess SS85 StrlSchV)
* performedDateTime = "2026-04-30T10:30:00+02:00"

// performer[anwender]: MTR mit Fachkunde-Extension (DVT)
* performer[anwender].function.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/radiology-role"
* performer[anwender].function.coding[0].code = #MTR
* performer[anwender].function.coding[0].display = "MTR"
* performer[anwender].actor = Reference(example-practitioner-mtr-dvt)
* performer[anwender].extension[fachkunde].valueCoding.system = "https://fhir.cognovis.de/imaging/CodeSystem/fachkunde-strahlenschutz"
* performer[anwender].extension[fachkunde].valueCoding.code = #dvt
* performer[anwender].extension[fachkunde].valueCoding.display = "Fachkunde DVT"

// performer[strahlenschutzverantwortlicher]: Radiologin
* performer[strahlenschutzverantwortlicher].function.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/radiology-role"
* performer[strahlenschutzverantwortlicher].function.coding[0].code = #SupervisingRadiologist
* performer[strahlenschutzverantwortlicher].function.coding[0].display = "Supervising Radiologist"
* performer[strahlenschutzverantwortlicher].actor = Reference(example-practitioner-radiologin-dvt)

// reasonCode[rechtfertigende-indikation]: ICD-10-GM K08.1 — Verlust von Zaehnen durch Unfall etc.
// Mit rechtfertigende-indikation-attest Extension
* reasonCode[rechtfertigende-indikation].coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[rechtfertigende-indikation].coding[0].code = #K08.1
* reasonCode[rechtfertigende-indikation].coding[0].display = "Verlust von Zaehnen durch Unfall, Extraktion oder lokale parodontale Erkrankung"
* reasonCode[rechtfertigende-indikation].text = "Implantatplanung Region 16 nach Extraktion — DVT fuer 3D-Knochenvolumen-Analyse"

// rechtfertigende-indikation-attest Extension: Attestierungsmetadaten
* reasonCode[rechtfertigende-indikation].extension[attest].extension[assessor].valueReference = Reference(example-practitioner-radiologin-dvt)
* reasonCode[rechtfertigende-indikation].extension[attest].extension[assessmentDate].valueDateTime = "2026-04-30T09:45:00+02:00"
* reasonCode[rechtfertigende-indikation].extension[attest].extension[narrative].valueString = "Implantatplanung Region 16 — DVT indiziert fuer exakte Knochenhoehen- und -breitenbestimmung sowie Nachweis ausreichender Knochensubstanz fuer Implantat. Keine konventionelle Roentgenalternative ausreichend."

// radiation-dose Extension: Dosiswerte DVT
* extension[radiationDose].extension[dap].valueQuantity.value = 1500
* extension[radiationDose].extension[dap].valueQuantity.unit = "uGy.m2"
* extension[radiationDose].extension[dap].valueQuantity.system = "http://unitsofmeasure.org"
* extension[radiationDose].extension[dap].valueQuantity.code = #uGy.m2
* extension[radiationDose].extension[kvp].valueQuantity.value = 90
* extension[radiationDose].extension[kvp].valueQuantity.unit = "kV"
* extension[radiationDose].extension[kvp].valueQuantity.system = "http://unitsofmeasure.org"
* extension[radiationDose].extension[kvp].valueQuantity.code = #kV
* extension[radiationDose].extension[exposureTime].valueQuantity.value = 17
* extension[radiationDose].extension[exposureTime].valueQuantity.unit = "s"
* extension[radiationDose].extension[exposureTime].valueQuantity.system = "http://unitsofmeasure.org"
* extension[radiationDose].extension[exposureTime].valueQuantity.code = #s
