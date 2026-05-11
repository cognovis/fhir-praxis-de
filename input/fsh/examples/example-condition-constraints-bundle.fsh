// Condition Constraints Bundle — PAR-Grading + Karies Beispiele
// Bead: fpde-shp.8
//
// Demonstriert:
//   - asserter-Constraint: KBV_PR_Base_Practitioner mit LANR
//   - evidence.detail-Linking: Observation, ImagingStudy, DiagnosticReport
//   - HbA1cObservationDE (LOINC 4548-4)
//   - SmokingStatusDE (LOINC 88031-0)
//   - PAR-Grading-Beispiel mit allen drei evidence.detail-Typen
//   - Karies-Beispiel mit Bissfluegel-ImagingStudy + DiagnosticReport
//
// Alle Instanzen verwenden ASCII-sichere Bezeichner (keine Umlaute).

// =============================================================================
// SHARED: Arzt mit LANR (KBV_PR_Base_Practitioner-konform)
// =============================================================================
// Dieser Practitioner entspricht KBV_PR_Base_Practitioner: Er hat eine LANR
// (Lebenslange Arztnummer) und kann daher als asserter in PraxisConditionDE
// verwendet werden (Arzt-/Zahnarzt-Vorbehalt gemaess ZHG/BAeO).

Instance: par-grading-practitioner-arzt
InstanceOf: KBV_PR_Base_Practitioner
Title: "Dr. Stefan Mueller — Zahnarzt mit LANR (PAR-Grading)"
Description: "Zahnarzt mit LANR-Identifier. Konformer KBV_PR_Base_Practitioner fuer asserter-Constraint in PraxisConditionDE. LANR: 123456789."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Mueller"
* name[0].given[0] = "Stefan"
* name[0].prefix[0] = "Dr."
* name[0].prefix[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-EN-qualifier"
* name[0].prefix[0].extension[0].valueCode = #AC
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_ANR"
// LANR: Struktureller Platzhalter — kein KBV-Pruefziffer-Test in FHIR R4 Validator.
* identifier[0].value = "123456789"

// =============================================================================
// PAR-GRADING BEISPIEL
// =============================================================================
// Demonstriert PAR-Grading (Parodontitis) mit:
//   - evidence.detail[0]: HbA1cObservationDE (8.5 %) — metabolischer Risikofaktor
//   - evidence.detail[1]: SmokingStatusDE — Raucher-Risikofaktor
//   - evidence.detail[2]: ImagingStudy (Roentgen) — Knochenabbau-Bildgebung
//   - evidence.detail[3]: DiagnosticReport (Befundbericht)
//
// Diagnosesicherheit: G (gesichert)
// ICD-10-GM: K05.3 — Chronische Parodontitis

// --- HbA1c Observation (PAR-Grading) ---
// HbA1cObservationDE: LOINC 4548-4, Wert 8.5 % (erhoehter Risikofaktor PAR)
Instance: par-grading-hba1c-obs
InstanceOf: HbA1cObservationDE
Title: "HbA1c Observation — PAR-Grading Weber"
Description: "HbA1c-Messung 8.5 % fuer PAR-Grading-Befund. Erhoehter HbA1c ist ein Risikofaktor fuer Parodontitis."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].code = #4548-4
* code.coding[loinc].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-05-01T09:00:00+02:00"
* valueQuantity.value = 8.5
* valueQuantity.unit = "%"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #%
* interpretation.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
* interpretation.coding[0].code = #H
* interpretation.coding[0].display = "High"

// --- Smoking Status Observation (PAR-Grading) ---
// SmokingStatusDE: LOINC 88031-0, Ex-Raucher (LA15920-4)
Instance: par-grading-smoking-obs
InstanceOf: SmokingStatusDE
Title: "Raucherstatus Observation — PAR-Grading Weber"
Description: "Raucherstatus: Ex-Raucher (LA15920-4 Former smoker). Historischer Risikofaktor fuer PAR-Grading."
Usage: #example
* status = #final
* category[social-history] = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].code = #88031-0
* code.coding[loinc].display = "Tobacco use"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-05-01T09:05:00+02:00"
* valueCodeableConcept.coding[0].system = "http://loinc.org"
* valueCodeableConcept.coding[0].code = #LA15920-4
* valueCodeableConcept.coding[0].display = "Former smoker"

// --- PAR Roentgen ImagingStudy ---
// Basis-ImagingStudy (nicht ImagingStudyPraxisDe) um Pflichtfeld-Constraint
// (referrer, endpoint) der Spezial-Profil-Instanz zu vermeiden.
// Modalitaet: DX (Digital Radiography) fuer Panoramaroentgen PAR
Instance: par-grading-roentgen
InstanceOf: ImagingStudy
Title: "ImagingStudy: Panoramaroentgen PAR (DX)"
Description: "Roentgenstudie fuer PAR-Grading-Befund. Modalitaet: DX (Digital Radiography). Knochenabbau-Befund als Bildgebungsgrundlage."
Usage: #example
* status = #available
* subject = Reference(example-patient)
* started = "2026-05-01T10:00:00+02:00"
* modality[0].system = "http://dicom.nema.org/resources/ontology/DCM"
* modality[0].code = #DX
* modality[0].display = "Digital Radiography"
// Serie: Panoramaroentgen
* series[0].uid = "2.16.840.1.113883.19.5.99.3.1"
* series[0].number = 1
* series[0].modality.system = "http://dicom.nema.org/resources/ontology/DCM"
* series[0].modality.code = #DX
* series[0].modality.display = "Digital Radiography"
* series[0].description = "Panorama OPG PAR-Grading"
// Pflichtfeld: mindestens eine Instanz pro Serie
* series[0].instance[0].uid = "2.16.840.1.113883.19.5.99.3.1.1"
* series[0].instance[0].sopClass.system = "urn:ietf:rfc:3986"
* series[0].instance[0].sopClass.code = #urn:oid:1.2.840.10008.5.1.4.1.1.1.1

// --- PAR Befundbericht DiagnosticReport ---
// Zusammenfassender Befundbericht mit HbA1c als Ergebnis-Referenz
Instance: par-grading-befund
InstanceOf: DiagnosticReport
Title: "DiagnosticReport: PAR-Grading Befundbericht"
Description: "Strukturierter Befundbericht fuer PAR-Grading. Schlussfolgerung: PAR-Grad III. Referenziert HbA1c-Observation als Ergebnis."
Usage: #example
* status = #final
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #24558-9
* code.coding[0].display = "Dental diagnostic study"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-05-01T14:00:00+02:00"
* issued = "2026-05-01T13:00:00Z"
* result[0] = Reference(par-grading-hba1c-obs)
* conclusion = "PAR-Grad III. Erhoehter HbA1c (8.5 %) und Ex-Raucher als Risikofaktoren. Knochenabbau radiologisch gesichert."

// --- PAR-Grading Condition (Parodontitis K05.3) ---
// Demonstriert alle drei evidence.detail-Typen in einer Condition:
//   evidence[0].detail[0] = HbA1cObservationDE (Observation)
//   evidence[0].detail[1] = SmokingStatusDE (Observation)
//   evidence[0].detail[2] = ImagingStudy (DX-Roentgen)
//   evidence[0].detail[3] = DiagnosticReport (PAR-Befund)
//
// asserter: par-grading-practitioner-arzt (KBV_PR_Base_Practitioner mit LANR)
Instance: par-grading-condition
InstanceOf: PraxisConditionDE
Title: "Condition: PAR-Grading K05.3 Chronische Parodontitis"
Description: "PAR-Grading Beispiel: Parodontitis K05.3 mit evidence.detail-Verlinkung auf HbA1c, Raucherstatus, Roentgen und PAR-Befundbericht. Alle drei evidence.detail-Typen (Observation, ImagingStudy, DiagnosticReport) demonstriert."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[ICD-10-GM].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[ICD-10-GM].version = "2024"
* code.coding[ICD-10-GM].code = #K05.3
* code.coding[ICD-10-GM].display = "Chronische Parodontitis"
* code.coding[ICD-10-GM].extension[Diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#G "gesicherte Diagnose"
* subject = Reference(example-patient)
* recordedDate = "2026-05-01"
// asserter: Arzt mit LANR (KBV_PR_Base_Practitioner-konform)
* asserter = Reference(par-grading-practitioner-arzt) "Dr. Stefan Mueller"
// evidence.detail-Linking: alle drei Typen
* evidence[0].detail[0] = Reference(par-grading-hba1c-obs) "HbA1c 8.5%"
* evidence[0].detail[1] = Reference(par-grading-smoking-obs) "Raucherstatus Ex-Raucher"
* evidence[0].detail[2] = Reference(par-grading-roentgen) "Panoramaroentgen OPG"
* evidence[0].detail[3] = Reference(par-grading-befund) "PAR-Befundbericht"

// =============================================================================
// KARIES BEISPIEL
// =============================================================================
// Demonstriert Karies-Diagnose mit:
//   - evidence.detail[0]: ImagingStudy (Bissfluegel-Aufnahme DX)
//   - evidence.detail[1]: DiagnosticReport (Karies-Befund)
//
// Diagnosesicherheit: G (gesichert)
// ICD-10-GM: K02.1 — Karies mit Dentinbeteiligung

// --- Karies Bissfluegel ImagingStudy ---
// Basis-ImagingStudy (nicht Spezial-Profil) fuer Bissfluegel-Aufnahme
Instance: karies-bissfluegel-study
InstanceOf: ImagingStudy
Title: "ImagingStudy: Bissfluegel-Aufnahme Karies Zahn 36 (DX)"
Description: "Bissfluegel-Roentgenaufnahme (Bitewing) fuer Karies-Befund an Zahn 36. Modalitaet: DX (Digital Radiography)."
Usage: #example
* status = #available
* subject = Reference(example-patient)
* started = "2026-05-05T10:30:00+02:00"
* modality[0].system = "http://dicom.nema.org/resources/ontology/DCM"
* modality[0].code = #DX
* modality[0].display = "Digital Radiography"
// Serie: Bissfluegel (Bitewing)
* series[0].uid = "2.16.840.1.113883.19.5.99.4.1"
* series[0].number = 1
* series[0].modality.system = "http://dicom.nema.org/resources/ontology/DCM"
* series[0].modality.code = #DX
* series[0].modality.display = "Digital Radiography"
* series[0].description = "Bissfluegel Zahn 36 Karies approximal"
// Pflichtfeld: mindestens eine Instanz pro Serie
* series[0].instance[0].uid = "2.16.840.1.113883.19.5.99.4.1.1"
* series[0].instance[0].sopClass.system = "urn:ietf:rfc:3986"
* series[0].instance[0].sopClass.code = #urn:oid:1.2.840.10008.5.1.4.1.1.1.1

// --- Karies DiagnosticReport ---
// Befundbericht Karies approximal Zahn 36
Instance: karies-befund
InstanceOf: DiagnosticReport
Title: "DiagnosticReport: Karies approximal Zahn 36"
Description: "Befundbericht fuer Karies approximal an Zahn 36 auf Basis der Bissfluegel-Aufnahme."
Usage: #example
* status = #final
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #24558-9
* code.coding[0].display = "Dental diagnostic study"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-05-05T11:00:00+02:00"
* issued = "2026-05-05T10:00:00Z"
* conclusion = "Karies approximal Zahn 36, radiologisch gesichert. Dentinbeteiligung K02.1."

// --- Karies Condition (K02.1) ---
// Karies mit evidence.detail auf Bissfluegel + DiagnosticReport
Instance: karies-condition
InstanceOf: PraxisConditionDE
Title: "Condition: Karies K02.1 approximal Zahn 36"
Description: "Karies-Diagnose K02.1 mit evidence.detail-Verlinkung auf Bissfluegel-ImagingStudy und Karies-DiagnosticReport. Demonstriert ImagingStudy + DiagnosticReport als evidence.detail-Typen."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[ICD-10-GM].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[ICD-10-GM].version = "2024"
* code.coding[ICD-10-GM].code = #K02.1
* code.coding[ICD-10-GM].display = "Karies mit Dentinbeteiligung"
* code.coding[ICD-10-GM].extension[Diagnosesicherheit].valueCoding = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_DIAGNOSESICHERHEIT#G "gesicherte Diagnose"
* subject = Reference(example-patient)
* recordedDate = "2026-05-05"
// asserter: Arzt mit LANR (KBV_PR_Base_Practitioner-konform)
* asserter = Reference(par-grading-practitioner-arzt) "Dr. Stefan Mueller"
// evidence.detail-Linking: ImagingStudy + DiagnosticReport
* evidence[0].detail[0] = Reference(karies-bissfluegel-study) "Bissfluegel-Aufnahme Zahn 36"
* evidence[0].detail[1] = Reference(karies-befund) "Karies-Befundbericht"

// =============================================================================
// BUNDLE: PAR-Grading — alle Constraint-Typen
// =============================================================================
Instance: par-grading-bundle
InstanceOf: Bundle
Title: "PAR-Grading Bundle — alle Constraint-Typen"
Description: "Beispiel-Bundle fuer PAR-Grading Diagnose mit asserter=Arzt, evidence.detail=[HbA1c-Obs, SmokingStatus-Obs, ImagingStudy, DiagnosticReport]. Demonstriert alle drei fpde-shp.8 Constraints."
Usage: #example
* type = #collection
* entry[0].fullUrl = "urn:uuid:par-grading-practitioner-arzt"
* entry[0].resource = par-grading-practitioner-arzt
* entry[1].fullUrl = "urn:uuid:par-grading-hba1c-obs"
* entry[1].resource = par-grading-hba1c-obs
* entry[2].fullUrl = "urn:uuid:par-grading-smoking-obs"
* entry[2].resource = par-grading-smoking-obs
* entry[3].fullUrl = "urn:uuid:par-grading-roentgen"
* entry[3].resource = par-grading-roentgen
* entry[4].fullUrl = "urn:uuid:par-grading-befund"
* entry[4].resource = par-grading-befund
* entry[5].fullUrl = "urn:uuid:par-grading-condition"
* entry[5].resource = par-grading-condition

// =============================================================================
// BUNDLE: Karies — ImagingStudy + DiagnosticReport
// =============================================================================
Instance: karies-bundle
InstanceOf: Bundle
Title: "Karies Bundle — ImagingStudy + DiagnosticReport"
Description: "Beispiel-Bundle fuer Karies-Diagnose K02.1 mit asserter=Arzt, evidence.detail=[Bissfluegel-ImagingStudy, DiagnosticReport]. Demonstriert ImagingStudy + DiagnosticReport als evidence.detail-Typen."
Usage: #example
* type = #collection
* entry[0].fullUrl = "urn:uuid:par-grading-practitioner-arzt"
* entry[0].resource = par-grading-practitioner-arzt
* entry[1].fullUrl = "urn:uuid:karies-bissfluegel-study"
* entry[1].resource = karies-bissfluegel-study
* entry[2].fullUrl = "urn:uuid:karies-befund"
* entry[2].resource = karies-befund
* entry[3].fullUrl = "urn:uuid:karies-condition"
* entry[3].resource = karies-condition
