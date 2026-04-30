// ImagingDiagnosticReportPraxisDe — Radiologiebefund fuer die deutsche ambulante Praxis
// Erbt von IHE IMR DiagnosticReport (IHE.IMR.DiagnosticReport).
// Erweitert um KDL-Category-Slicing, LOINC-Code-Binding, Distribution-Tracking
// und Sub-Status-Extension. Performer-Slicing nach RadiologyRoleCS.
//
// FHIR-native Status-Maschine: registered -> partial -> preliminary -> final -> amended
//
// Performer-Hinweis: IMR performer[organization] 1..* ist im IMR-Profil bereits definiert.
// Dieses Profil fuegt performer[practitionerRole] als zusaetzlichen Slice hinzu.
// Der Radiologen-Typ (Reading vs. Supervising) wird ueber PractitionerRole.code
// mit RadiologyRoleCS kodiert.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $imr-diagnosticreport = https://profiles.ihe.net/RAD/IMR/StructureDefinition/imr-diagnosticreport
Alias: $kdl = http://dvmd.de/fhir/CodeSystem/kdl

Profile: ImagingDiagnosticReportPraxisDe
Parent: imr-diagnosticreport
Id: imaging-diagnostic-report-praxis-de
Title: "Imaging DiagnosticReport (Praxis DE)"
Description: "Radiologiebefund-Profil fuer die deutsche ambulante Praxis. Erbt von IHE IMR DiagnosticReport (IHE.IMR.DiagnosticReport). Erweitert um KDL-Category-Slicing, LOINC-Code-Binding, Distribution-Tracking und Sub-Status-Extension."

// Extensions
* extension contains
    ReportSubstatusExt named reportSubstatus 0..1 MS and
    ReportDistributionExt named reportDistribution 0..* MS

// Status: FHIR-native Status-Maschine — registered -> partial -> preliminary -> final -> amended
* status MS

// Category: KDL-Slicing fuer deutsche Radiologie-Kategorien
// IMR schraenkt category nicht ein — KDL-Slices werden zusaetzlich definiert.
* category ^slicing.discriminator.type = #pattern
* category ^slicing.discriminator.path = "$this"
* category ^slicing.rules = #open
* category contains
    roentgen 0..1 MS and
    ct 0..1 MS and
    mrt 0..1 MS and
    sono 0..1 MS

* category[roentgen] = $kdl#DG020110 "Roentgenbefund"
* category[ct] = $kdl#DG020103 "CT-Befund"
* category[mrt] = $kdl#DG020107 "MRT-Befund"
* category[sono] = $kdl#DG020111 "Sonographiebefund"

// Code: LOINC preferred binding fuer Radiologie-Befundcodes
* code from RadiologyReportCodeVS (preferred)

// Performer: PractitionerRole-Slice als Ergaenzung zum IMR performer[organization] 1..*
// HINWEIS: performer[organization] ist bereits in IMR definiert — nicht neu definieren.
// PractitionerRole.code identifiziert Reading vs. Supervising Radiologe via RadiologyRoleCS.
* performer contains practitionerRole 0..* MS
* performer[practitionerRole] only Reference(PractitionerRole)
* performer[practitionerRole] ^short = "Radiologin/Radiologe (PractitionerRole.code: ReadingRadiologist | SupervisingRadiologist aus RadiologyRoleCS)"

// ResultsInterpreter: Befundende Radiologin/Radiologe (primaere Unterzeichnerin)
* resultsInterpreter MS

// ImagingStudy: Pflicht durch IMR (bereits 1..*), als MS markieren
* imagingStudy MS

// PresentedForm: HTML Pflicht durch IMR (geerbt), PDF empfohlen
* presentedForm MS
