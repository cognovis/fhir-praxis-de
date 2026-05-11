// Praxis Lab Observation Profile — Laborergebnis fuer die ambulante Praxis
// Abgebildet als FHIR Observation (R4).
// Angelehnt an KBV_PR_MIO_LAB_Observation_Laboratory_Study (kbv.mio.laborbefund),
// jedoch ohne dieses als Parent zu verwenden, da kein Snapshot im Paket vorhanden.
// Referenz auf KBV MIO Laborbefund ist in der Profil-Beschreibung dokumentiert.
//
// Codierung: LOINC und/oder LDT-Testkennung (FK 8420) — mindestens eine Codierung Pflicht.
// LDT NamingSystem: https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen

Invariant: praxis-lab-obs-code
Description: "Mindestens eine Codierung muss vorhanden sein: LOINC oder LDT-Testkennung."
Expression: "code.coding.where(system = 'http://loinc.org').exists() or code.coding.where(system = 'https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen').exists()"
Severity: #error

Profile: PraxisLabObservation
Parent: Observation
Id: praxis-lab-observation
Title: "Praxis Lab Observation"
Description: "Laborergebnis-Profil fuer die ambulante Praxis. Angelehnt an KBV_PR_MIO_LAB_Observation_Laboratory_Study (kbv.mio.laborbefund). Unterstuetzt LOINC- und LDT-Testkennung (FK 8420) als Code-Slices; mindestens eine Codierung ist Pflicht. Befunde koennen quantitativ (Quantity), qualitativ (string) oder kodiert (CodeableConcept) sein."

* obeys praxis-lab-obs-code

// Status: Pflichtfeld
* status MS

// Kategorie: laboratory (Pflicht)
* category 1..* MS
* category ^slicing.discriminator.type = #pattern
* category ^slicing.discriminator.path = "$this"
* category ^slicing.rules = #open
* category contains laboratory 1..1 MS
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory

// Code: LOINC und/oder LDT-Testkennung
* code MS
* code.coding MS
* code.coding ^slicing.discriminator.type = #value
* code.coding ^slicing.discriminator.path = "system"
* code.coding ^slicing.rules = #open
* code.coding contains loinc 0..1 MS and ldt 0..1 MS

* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].system MS
* code.coding[loinc].code 1..1 MS
* code.coding[loinc].display MS

* code.coding[ldt].system = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen"
* code.coding[ldt].system MS
* code.coding[ldt].code 1..1 MS
* code.coding[ldt].display MS

// Patient: Pflicht
* subject 1..1 MS
* subject only Reference(Patient)

// Messzeitpunkt
* effective[x] only dateTime
* effective[x] MS

// Messwert: Quantity, string oder CodeableConcept
* value[x] only Quantity or string or CodeableConcept
* value[x] MS

// Interpretation (H/L/N etc.)
* interpretation MS
* interpretation from http://hl7.org/fhir/ValueSet/observation-interpretation (extensible)

// Referenzbereich
* referenceRange MS
* referenceRange.low MS
* referenceRange.low.system = "http://unitsofmeasure.org"
* referenceRange.high MS
* referenceRange.high.system = "http://unitsofmeasure.org"

// Probe (optional, Verweis auf PraxisSpecimen)
* specimen MS
* specimen only Reference(PraxisSpecimen)

// =============================================================================
// HbA1cObservationDE — Haemoglobin A1c Observation (LOINC 4548-4)
// Bead: fpde-shp.8
// =============================================================================
//
// Spezialisiertes Laborprofil fuer HbA1c-Messungen (Haemoglobin A1c /
// Haemoglobin.gesamt in Blut). Relevant fuer Diabetes-Monitoring und
// PAR-Grading (Parodontitis-Risikoeinschaetzung).
//
// LOINC 4548-4: Hemoglobin A1c/Hemoglobin.total in Blood
// UCUM unit: % (Prozent, Massenanteil)
// =============================================================================
Profile: HbA1cObservationDE
Parent: PraxisLabObservation
Id: hba1c-observation-de
Title: "HbA1c Observation DE"
Description: "Spezialisiertes Profil fuer Haemoglobin A1c (HbA1c) Messungen nach LOINC 4548-4. Wert als Quantity in Prozent (UCUM %). Relevant fuer Diabetes-Monitoring und PAR-Grading. Erbt Code-Slicing, Must Support und Invarianten von PraxisLabObservation."

// Erzwinge LOINC-Code 4548-4
* code.coding[loinc] 1..1
* code.coding[loinc].code = #4548-4
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* code.coding[loinc] ^short = "LOINC 4548-4 — HbA1c"
* code.coding[loinc] ^definition = "Fester LOINC-Code fuer HbA1c. Zusaetzliche LDT-Testkennung (code.coding[ldt]) ist erlaubt."

// Wert: nur Quantity, Einheit Prozent
* value[x] only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #%
* valueQuantity ^short = "HbA1c-Messwert in Prozent"
* valueQuantity ^definition = "Messergebnis als UCUM-Prozentwert (%). Normalbereich: 4.0–6.0 %; diabetisch relevant ab > 6.5 %."

// =============================================================================
// SmokingStatusDE — Tabakkonsum-Status (LOINC 88031-0)
// Bead: fpde-shp.8
// =============================================================================
//
// Spezialisiertes Profil fuer den dokumentierten Raucherstatus eines Patienten.
// LOINC 88031-0: Tobacco use
// Antwortliste: LOINC LL2255-7 (preferred binding)
//
// Beispiel-Codes aus LL2255-7:
//   LA18976-3 — Never smoker (Nie geraucht)
//   LA15920-4 — Former smoker (Ex-Raucher)
//   LA18977-1 — Current every day smoker (Taegl. Raucher)
// =============================================================================
Profile: SmokingStatusDE
Parent: PraxisLabObservation
Id: smoking-status-de
Title: "Smoking Status DE"
Description: "Spezialisiertes Profil fuer den Tabakkonsum-Status (Raucherstatus) nach LOINC 88031-0. Wert als CodeableConcept aus LOINC-Antwortliste LL2255-7 (preferred). Relevant fuer PAR-Grading und allgemeine Risikoeinschaetzung. Erbt Code-Slicing und Must Support von PraxisLabObservation."

// Erzwinge LOINC-Code 88031-0
* code.coding[loinc] 1..1
* code.coding[loinc].code = #88031-0
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].display = "Tobacco use"
* code.coding[loinc] ^short = "LOINC 88031-0 — Tobacco use (Raucherstatus)"
* code.coding[loinc] ^definition = "Fester LOINC-Code fuer Tabakkonsum-Status. Antworten aus LOINC-Antwortliste LL2255-7."

// Wert: nur CodeableConcept
* value[x] only CodeableConcept
* valueCodeableConcept from http://loinc.org/vs/LL2255-7 (preferred)
* valueCodeableConcept ^short = "Raucherstatus (LOINC LL2255-7)"
* valueCodeableConcept ^definition = "Kodierter Raucherstatus. Preferred Binding auf LOINC-Antwortliste LL2255-7 (z.B. LA18976-3 = Never smoker, LA15920-4 = Former smoker, LA18977-1 = Current every day smoker)."
