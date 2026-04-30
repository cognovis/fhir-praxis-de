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
