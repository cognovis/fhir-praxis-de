// ImagingServiceRequestPraxisDe — Bildgebungsauftrag fuer die deutsche ambulante Praxis
// Erbt von IHE IMR ServiceRequest (imr-servicerequest).
// Erweitert um ICD-10-GM reasonCode-Slicing, Coverage-Referenz (GKV/Privat),
// Prior-Study supportingInfo und LOINC-Code-Binding fuer Bildgebungsverfahren.
//
// IMR parent bereits definiert: identifier[accession] 1..1, intent bound to imr-servicerequest-intent-vs
// Dieses Profil fuegt hinzu: reasonCode[icd10gm], insurance, supportingInfo[priorStudy], code-Binding.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $imr-sr = https://profiles.ihe.net/RAD/IMR/StructureDefinition/imr-servicerequest

Profile: ImagingServiceRequestPraxisDe
Parent: $imr-sr
Id: imaging-service-request-praxis-de
Title: "Imaging ServiceRequest (Praxis DE)"
Description: "Bildgebungsauftrag-Profil fuer die deutsche ambulante Praxis. Erbt von IHE IMR ServiceRequest (imr-servicerequest). Erweitert um ICD-10-GM Indikations-Slicing (reasonCode), Coverage-Referenz (GKV/Privat), Prior-Study supportingInfo und LOINC Imaging Procedure Code Binding."

// Code: LOINC preferred binding fuer Bildgebungsverfahren
* code MS
* code from ImagingRequestCodeVS (preferred)
* code ^short = "Bildgebungsverfahren-Code (LOINC, z.B. 36803-5 MRI of knee)"

// Priority: FHIR standard required binding (request-priority VS) inherited from R4 base — no override needed
* priority MS
* priority ^short = "Prioritaet des Auftrags (routine, urgent, asap, stat) — required binding auf http://hl7.org/fhir/ValueSet/request-priority"

// ReasonCode: ICD-10-GM Indikations-Slicing
* reasonCode MS
* reasonCode ^slicing.discriminator.type = #value
* reasonCode ^slicing.discriminator.path = "coding.system"
* reasonCode ^slicing.rules = #open
* reasonCode contains icd10gm 0..* MS
* reasonCode[icd10gm] ^short = "ICD-10-GM Indikation fuer die Bildgebung"
* reasonCode[icd10gm].coding 1..* MS
* reasonCode[icd10gm].coding.system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[icd10gm].coding.system MS
* reasonCode[icd10gm].coding.code 1..1 MS
* reasonCode[icd10gm] from ImagingIndicationICD10VS (required)

// Insurance: Referenz auf GKV- oder Privat-Coverage
* insurance MS
* insurance ^short = "Versicherungsreferenz (GKV: FPDECoverageGKV oder Privat: FPDECoveragePrivat)"
* insurance only Reference(FPDECoverageGKV or FPDECoveragePrivat)

// SupportingInfo: Prior-Study fuer Vergleichsbefundung
* supportingInfo MS
* supportingInfo ^short = "Voruntersuchungen fuer Vergleichsbefundung (ImagingStudy)"
* supportingInfo only Reference(ImagingStudy)

// Subject: Pflichtfeld
* subject MS
* subject only Reference(Patient)

// Requester: anforderender Arzt
* requester MS
