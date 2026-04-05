// Praxis Lab DiagnosticReport Profile — Laborbefund fuer die ambulante Praxis
// Abgebildet als FHIR DiagnosticReport (R4).
// Angelehnt an KBV_PR_MIO_LAB_DiagnosticReport_Laboratory_Study (kbv.mio.laborbefund),
// jedoch ohne dieses als Parent zu verwenden, da kein Snapshot im Paket vorhanden.
// Referenz auf KBV MIO Laborbefund ist in der Profil-Beschreibung dokumentiert.
//
// Varianten werden ueber category-Slices abgebildet:
//   LAB  = Einzelbefund oder Kumulativbefund (Standard-Labor)
//   MB   = Mikrobiologie
//   PAT  = Pathologie
//
// Kumulativbefund-Pattern: separate DiagnosticReport-Instanzen pro Datum —
// kein FHIR-eigener Gruppiermechanismus notwendig.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Profile: PraxisLabDiagnosticReport
Parent: DiagnosticReport
Id: praxis-lab-diagnostic-report
Title: "Praxis Lab DiagnosticReport"
Description: "Laborbefund-Profil fuer die ambulante Praxis. Unterstuetzt Standard-Labor (LAB), Mikrobiologie (MB) und Pathologie (PAT) ueber category-Slices (HL7 v2 Table 0074). Referenziert PraxisLabObservation (Einzelergebnisse) und PraxisSpecimen (Probe). Kumulativbefunde werden als separate DiagnosticReports pro Zeitpunkt abgebildet. Angelehnt an KBV_PR_MIO_LAB_DiagnosticReport_Laboratory_Study (kbv.mio.laborbefund), Parent ist base FHIR DiagnosticReport da kein Snapshot im KBV MIO Paket vorhanden."

// Status: Pflichtfeld — final, preliminary, amended, corrected
* status MS

// Kategorie: mindestens eine Pflicht (1..*), offenes Slicing nach Pattern
// Slices: lab (LAB), mb (MB), pat (PAT) — je 0..1
// Eine DiagnosticReport-Instanz muss mindestens einen der Slices belegen.
* category 1..* MS
* category ^slicing.discriminator.type = #pattern
* category ^slicing.discriminator.path = "$this"
* category ^slicing.rules = #open
* category contains lab 0..1 MS and mb 0..1 MS and pat 0..1 MS

* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* category[mb]  = http://terminology.hl7.org/CodeSystem/v2-0074#MB
* category[pat] = http://terminology.hl7.org/CodeSystem/v2-0074#PAT

// Befund-Code: LOINC bevorzugt — kein hartes LOINC-Constraint (Labs nutzen diverse Codes)
* code 1..1 MS

// Patient: Pflichtfeld
* subject 1..1 MS
* subject only Reference(Patient)

// Untersuchungszeitpunkt: nur dateTime (kein Period)
* effective[x] only dateTime
* effective[x] MS

// Zeitstempel der Befundfreigabe
* issued MS

// Durchfuehrender: Arzt oder Organisation
* performer MS
* performer only Reference(Practitioner or Organization)

// Befundinterpretierende: nur Arzt
* resultsInterpreter MS
* resultsInterpreter only Reference(Practitioner)

// Probe: Verweis auf PraxisSpecimen
* specimen MS
* specimen only Reference(PraxisSpecimen)

// Einzelergebnisse: Verweis auf PraxisLabObservation
* result MS
* result only Reference(PraxisLabObservation)

// Eingebettetes Befunddokument (PDF als Attachment oder URL-Referenz)
* presentedForm MS

// Narrative Zusammenfassung (z.B. Befundtext, Mikrobiologie-Ergebnis)
* conclusion MS

// Auftragsreferenz (optional — fuer Kumulativbefund-Verkettung nuetzlich)
* basedOn MS
* basedOn only Reference(ServiceRequest)
