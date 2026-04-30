// Imaging DiagnosticReport Beispiele — ImagingDiagnosticReportPraxisDe Profil
// Zwei Szenarien: MRT-Knie-Befund (final, signiert, KIM-Distribution)
// und vorlaeufiger Befund (preliminary, dictated Sub-Status).
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $kdl = http://dvmd.de/fhir/CodeSystem/kdl
Alias: $loinc = http://loinc.org
Alias: $dcm = http://dicom.nema.org/resources/ontology/DCM
Alias: $report-substatus = https://fhir.cognovis.de/praxis/CodeSystem/report-substatus
Alias: $report-dist-channel = https://fhir.cognovis.de/praxis/CodeSystem/report-distribution-channel
Alias: $radiology-role = https://fhir.cognovis.de/praxis/CodeSystem/radiology-role

// --- Hilfsobservation: Radiologin als PractitionerRole (ReadingRadiologist) ---
Instance: example-practitioner-radiologin
InstanceOf: Practitioner
Title: "Dr. Andrea Fischer — Radiologin"
Description: "Befundende Radiologin fuer MRT-Knie Beispiel."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Fischer"
* name[0].given[0] = "Andrea"
* name[0].prefix[0] = "Dr."

Instance: example-practitionerrole-reading-radiologist
InstanceOf: PractitionerRole
Title: "PractitionerRole: Befundende Radiologin"
Description: "PractitionerRole fuer Dr. Andrea Fischer als Reading Radiologist (RadiologyRoleCS#ReadingRadiologist)."
Usage: #example
* active = true
* practitioner = Reference(example-practitioner-radiologin)
* organization = Reference(example-organization)
* code[0].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/radiology-role"
* code[0].coding[0].code = #ReadingRadiologist
* code[0].coding[0].display = "Reading Radiologist"

// --- Hilfsinstanz: ImagingStudy MRT Knie ---
// Minimal-Instanz um den IMR 1..* imagingStudy-Constraint zu erfuellen.
Instance: example-imaging-study-mrt-knie
InstanceOf: ImagingStudy
Title: "ImagingStudy: MRT Knie Weber"
Description: "MRT-Studie des linken Knies von Patient Thomas Weber. Minimal-Instanz fuer IMR imagingStudy-Referenz."
Usage: #example
* status = #available
* subject = Reference(example-patient)
* modality[0].system = "http://dicom.nema.org/resources/ontology/DCM"
* modality[0].code = #MR

// --- Beispiel 1: MRT-Knie Befund (final, signiert, KIM-Distribution) ---
// Status: final, Sub-Status: signed
// KDL-Kategorie: MRT-Befund (DG020107)
// presentedForm: HTML (Pflicht IMR) + PDF-URL (optional empfohlen)
// Distribution: KIM-Kanal an ueberweisenden Arzt
// Performer: Organization (IMR-Pflicht) + PractitionerRole (Reading Radiologist)
// ResultsInterpreter: befundende Radiologin
Instance: example-imaging-mrt-knie
InstanceOf: ImagingDiagnosticReportPraxisDe
Title: "Imaging DiagnosticReport: MRT Knie (final)"
Description: "MRT-Kniebefund, Status final. KDL MRT-Befund, LOINC 36803-5. KIM-Distribution an ueberweisenden Hausarzt. Sub-Status: signed. HTML + PDF presentedForm."
Usage: #example
* status = #final

// Sub-Status: signiert (final abgeschlossen)
* extension[reportSubstatus].valueCoding.system = "https://fhir.cognovis.de/praxis/CodeSystem/report-substatus"
* extension[reportSubstatus].valueCoding.code = #signed
* extension[reportSubstatus].valueCoding.display = "Signed"

// KIM-Distribution an ueberweisenden Hausarzt
* extension[reportDistribution][0].extension[channel].valueCoding.system = "https://fhir.cognovis.de/praxis/CodeSystem/report-distribution-channel"
* extension[reportDistribution][0].extension[channel].valueCoding.code = #kim
* extension[reportDistribution][0].extension[channel].valueCoding.display = "KIM"
* extension[reportDistribution][0].extension[recipient].valueReference = Reference(example-practitioner)
* extension[reportDistribution][0].extension[timestamp].valueDateTime = "2026-04-30T16:30:00+02:00"

// KDL-Kategorie: MRT-Befund
* category[mrt] = $kdl#DG020107 "MRT-Befund"

// LOINC-Code: MRT des Knies
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #36803-5
* code.coding[0].display = "MRI of knee"

* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-30T10:00:00+02:00"
* issued = "2026-04-30T16:00:00+02:00"

// Performer: Organization (IMR-Pflicht 1..*) + PractitionerRole (Reading Radiologist)
* performer[organization][0] = Reference(example-organization)
* performer[practitionerRole][0] = Reference(example-practitionerrole-reading-radiologist)

// ResultsInterpreter: befundende Radiologin
* resultsInterpreter[0] = Reference(example-practitioner-radiologin)

// ImagingStudy: Pflicht durch IMR
* imagingStudy[0] = Reference(example-imaging-study-mrt-knie)

// PresentedForm HTML: Pflicht durch IMR (contentType, size, hash, data)
// Base64 von: <html><body><p>MRT Knie Befund - Thomas Weber, 2026-04-30</p></body></html>
// Size: 75 Bytes, SHA-1: vtQNbtF63wRnP3GeL6OsLO5Ixgk=
* presentedForm[html].data = "PGh0bWw+PGJvZHk+PHA+TVJUIEtuaWUgQmVmdW5kIC0gVGhvbWFzIFdlYmVyLCAyMDI2LTA0LTMwPC9wPjwvYm9keT48L2h0bWw+"
* presentedForm[html].contentType = #text/html
* presentedForm[html].size = 75
* presentedForm[html].hash = "vtQNbtF63wRnP3GeL6OsLO5Ixgk="
* presentedForm[html].title = "MRT Knie Befund"

// PresentedForm PDF: optional, URL-Referenz (kein inline base64)
// size und hash Pflichtfelder per IMR — Platzhalter-Werte fuer Beispiel-URL
* presentedForm[pdf].contentType = #application/pdf
* presentedForm[pdf].url = "https://example.org/reports/mrt-knie-weber-2026-04-30.pdf"
* presentedForm[pdf].title = "MRT Knie Befund (PDF)"
* presentedForm[pdf].size = 51200
* presentedForm[pdf].hash = "6gpKsjpry+6hXpI3RR9l1cCJH+Q="

* conclusion = "Kein Nachweis eines Meniskusrisses. Leichtgradige mediale Gonarthrose (Grad I). Keine Gelenkerguss-Zeichen."

// --- Hilfsinstanz: ImagingStudy fuer vorlaeufigen Befund (CT Thorax) ---
Instance: example-imaging-study-ct-thorax
InstanceOf: ImagingStudy
Title: "ImagingStudy: CT Thorax Weber"
Description: "CT-Studie des Thorax von Patient Thomas Weber. Minimal-Instanz fuer IMR imagingStudy-Referenz."
Usage: #example
* status = #available
* subject = Reference(example-patient)
* modality[0].system = "http://dicom.nema.org/resources/ontology/DCM"
* modality[0].code = #CT

// --- Beispiel 2: Vorlaeufiger Befund (preliminary, dictated Sub-Status) ---
// Status: preliminary, Sub-Status: dictated (Diktat erstellt, Freigabe ausstehend)
// KDL-Kategorie: CT-Befund (DG020103)
// Kein PDF — vorlaeufig, nur HTML-Pflicht durch IMR
// Performer: Organization (IMR-Pflicht)
Instance: example-imaging-ct-thorax-preliminary
InstanceOf: ImagingDiagnosticReportPraxisDe
Title: "Imaging DiagnosticReport: CT Thorax (preliminary/dictated)"
Description: "CT-Thoraxbefund, Status preliminary. Sub-Status: dictated (Diktat erfolgt, Freigabe ausstehend). KDL CT-Befund, LOINC 24627-2."
Usage: #example
* status = #preliminary

// Sub-Status: dictated (Diktat erstellt, Arzt-Review ausstehend)
* extension[reportSubstatus].valueCoding.system = "https://fhir.cognovis.de/praxis/CodeSystem/report-substatus"
* extension[reportSubstatus].valueCoding.code = #dictated
* extension[reportSubstatus].valueCoding.display = "Dictated"

// KDL-Kategorie: CT-Befund
* category[ct] = $kdl#DG020103 "CT-Befund"

// LOINC-Code: CT study note
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #24627-2
* code.coding[0].display = "CT study note"

* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-30T09:00:00+02:00"
* issued = "2026-04-30T11:00:00+02:00"

// Performer: Organization (IMR-Pflicht 1..*)
* performer[organization][0] = Reference(example-organization)

// ResultsInterpreter: Pflicht durch IMR (1..*) — vorlaeufiger Befund, Diktat noch nicht freigegeben
* resultsInterpreter[0] = Reference(example-practitioner-radiologin)

// ImagingStudy: Pflicht durch IMR
* imagingStudy[0] = Reference(example-imaging-study-ct-thorax)

// PresentedForm HTML: Pflicht durch IMR
// Base64 von: <html><body><p>MRT Knie - Vorlaeufiger Befund (Diktat)</p></body></html>
// Size: 72 Bytes, SHA-1: Hly20WoLlLFcBOdy/dz0FJjLVlo=
* presentedForm[html].data = "PGh0bWw+PGJvZHk+PHA+TVJUIEtuaWUgLSBWb3JsYWV1ZmlnZXIgQmVmdW5kIChEaWt0YXQpPC9wPjwvYm9keT48L2h0bWw+"
* presentedForm[html].contentType = #text/html
* presentedForm[html].size = 72
* presentedForm[html].hash = "Hly20WoLlLFcBOdy/dz0FJjLVlo="
* presentedForm[html].title = "CT Thorax - Vorlaeufiger Befund"
