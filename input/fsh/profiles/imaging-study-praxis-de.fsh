// ImagingStudyPraxisDe — Bildgebungs-Studie fuer die deutsche ambulante Praxis
// Erbt von IPS ImagingStudy-uv-ips (hl7.fhir.uv.ips#1.1.0).
// Erweitert um DICOM-Modalitaet (required), Koerperregion/Lateralitaet,
// Ueberweiser-Tracking (referrer 1..1), WADO-RS Endpoint,
// KM-Gabe-Extension und Technikparameter-Extension.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $ips-imagingstudy = http://hl7.org/fhir/uv/ips/StructureDefinition/ImagingStudy-uv-ips
Alias: $dicom-modality-vs = https://fhir.cognovis.de/praxis/ValueSet/dicom-modality
Alias: $body-site-vs = http://hl7.org/fhir/ValueSet/body-site
Alias: $laterality-vs = http://hl7.org/fhir/ValueSet/bodysite-laterality
Alias: $endpoint-connection-type-vs = http://hl7.org/fhir/ValueSet/endpoint-connection-type
Alias: $km-ext = https://fhir.cognovis.de/praxis/StructureDefinition/image-km-administration
Alias: $technique-ext = https://fhir.cognovis.de/praxis/StructureDefinition/technique-parameter

Profile: ImagingStudyPraxisDe
Parent: $ips-imagingstudy
Id: imaging-study-praxis-de
Title: "ImagingStudy (Praxis DE)"
Description: "Bildgebungs-Studie-Profil fuer die deutsche ambulante Praxis. Erbt von IPS ImagingStudy-uv-ips. Erweitert um DICOM-Modalitaet (required Binding), Koerperregion- und Lateralitaets-Slices, Ueberweiser-Tracking (referrer 1..1 fuer KV-Abrechnung), WADO-RS Endpoint, Kontrastmittel-Gabe-Extension und Aufnahmetechnik-Parameter-Extension."

// identifier: AccessionNumber-Slice fuer DICOM QIDO-RS Study-Level Queries
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type.coding.code"
* identifier ^slicing.rules = #open
* identifier contains accessionNumber 0..1 MS
* identifier[accessionNumber].value 1..1 MS
* identifier[accessionNumber].type.coding.system 1..1 MS
* identifier[accessionNumber].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[accessionNumber].type.coding.code = #ACSN
* identifier[accessionNumber] ^short = "AccessionNumber (DICOM 0008,0050)"
* identifier[accessionNumber] ^definition = "Zugriffsnummer der Studie (DICOM AccessionNumber, Tag 0008,0050). Entspricht dem identifier[accession] auf dem zugrundeliegenden ImagingServiceRequest."

// Extensions auf ImagingStudy-Ebene
* extension contains
    $km-ext named kmAdministration 0..1 MS

// modality (Top-Level): required Binding zu DicomModalityVS
// ImagingStudy.modality ist ein Coding (nicht CodeableConcept)
* modality MS
* modality from $dicom-modality-vs (required)
* modality ^short = "Bildgebungsmodalitaet (DICOM CID 29, required)"
* modality ^definition = "Modalitaet der Bildgebungsstudie gemaess DICOM CID 29 Acquisition Modality. Required Binding."

// referrer: Ueberweisender Arzt — 1..1 fuer KV-Abrechnungs-Tracking
* referrer 1..1 MS
* referrer ^short = "Ueberweisender Arzt (Pflichtfeld fuer KV-Abrechnung)"
* referrer ^definition = "Ueberweisender Arzt oder Ueberweiserin. Pflichtfeld fuer das KV-Abrechnungs-Tracking (Ueberweiser-Statistik und Qualitaetssicherung)."

// endpoint: WADO-RS-faehiger DICOM-Endpunkt
// endpoint: WADO-RS connection-type is RECOMMENDED (not enforced).
// The example uses dicom-wado-rs. Profile intentionally omits connectionType constraint
// to allow future endpoint types (QIDO-RS, STOW-RS) without re-profiling.
// See bead notes: fpde-cpw.2 DECIDE on endpoint constraint.
* endpoint MS
* endpoint ^short = "WADO-RS Endpunkt fuer DICOM-Studie"
* endpoint ^definition = "Verbindungsendpunkt fuer den Abruf der DICOM-Bilddaten. Connection type SHOULD be `dicom-wado-rs` (WADO-RS) for PACS retrieval. Constraint not enforced at profile level to allow future DICOMweb endpoint variants (QIDO-RS, STOW-RS)."

// series: Bildserien-Constraints
* series MS

// series.modality: DICOM-Modalitaet der Serie (inherited from IPS — MS marking)
* series.modality MS

// series.bodySite: Koerperregion preferred Binding zu SNOMED-CT body-site VS
* series.bodySite from $body-site-vs (preferred)
* series.bodySite ^short = "Koerperregion der Bildserie (SNOMED CT, preferred)"
* series.bodySite ^definition = "Koerperregion/anatomische Lokalisation der Bildserie. Preferred Binding auf SNOMED CT body-site ValueSet."

// series.laterality: Seitenangabe preferred Binding
* series.laterality from $laterality-vs (preferred)
* series.laterality ^short = "Seitenangabe (preferred Binding: bodysite-laterality)"
* series.laterality ^definition = "Seitenangabe (links/rechts/bilateral) der Bildserie. Preferred Binding auf FHIR bodysite-laterality ValueSet."

// series extension: Technikparameter
* series.extension contains
    $technique-ext named techniqueParameter 0..1 MS
