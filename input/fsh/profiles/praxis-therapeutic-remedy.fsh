// PraxisTherapeuticRemedyDE — Heilmittelverordnung (Muster 13) remedy order.
// Models HMV as ServiceRequest (not MedicationRequest, not PraxisReferralDE).
// Terminology: gevko EVO_VS_HLM_* via de.cognovis.terminology.heilmittel mirror;
// Diagnosegruppe via KBV_VS_SFHIR_HM_DIAGNOSEGRUPPE (de.cognovis.terminology.kbv).
// ServiceRequest.code uses stable EVO_CS_HLM_Katalog system + per-record position code;
// required binding against EVO_VS_HLM_Katalog is intentionally avoided (no backing CodeSystem).

Profile: PraxisTherapeuticRemedyDE
Parent: ServiceRequest
Id: praxis-therapeutic-remedy-de
Title: "Praxis Therapeutic Remedy DE"
Description: "Heilmittelverordnung (Muster 13) als ServiceRequest — Verordnung eines Heilmittels (Physio, Ergo, Logo, Podo, Ernaehrung), nicht als Ueberweisung. Bindet gevko eHeilmittelverordnung-Terminologie (EVO_VS_HLM_*) und KBV Heilmittel-Diagnosegruppe."

* status 1..1 MS
* status ^short = "Status der Heilmittelverordnung"

* intent = #order
* intent MS
* intent ^short = "order — eine Heilmittelverordnung ist eine Auftragsleistung"

// Category discriminator: eHLM form type — distinct from referral and lab ServiceRequests
* category MS
* category ^slicing.discriminator.type = #pattern
* category ^slicing.discriminator.path = "$this"
* category ^slicing.rules = #closed
* category ^slicing.description = "Identifies this ServiceRequest as a therapeutic remedy (Heilmittel) order"
* category contains therapeuticRemedy 1..1 MS
* category[therapeuticRemedy] = https://fhir.gevko.de/CodeSystem/EVO_CS_FOR_FormularArt#e13 "eHLM elektronische Heilmittelverordnung"
* category[therapeuticRemedy] ^short = "Therapeutic remedy order discriminator (eHLM)"

* subject 1..1 MS
* subject only Reference(Patient)
* subject ^short = "Patient mit Heilmittelbedarf"

* requester MS
* requester only Reference(PractitionerRole or Practitioner or Organization)
* requester ^short = "Verordnender Arzt (LANR) bzw. Betriebsstaette (BSNR)"

* authoredOn MS
* authoredOn ^short = "Verordnungsdatum"

* reasonCode MS
* reasonCode ^slicing.discriminator.type = #value
* reasonCode ^slicing.discriminator.path = "coding.system"
* reasonCode ^slicing.rules = #open
* reasonCode contains icd10gm 0..* MS
* reasonCode[icd10gm] ^short = "ICD-10-GM Indikation / Diagnose fuer die Heilmittelverordnung"
* reasonCode[icd10gm].coding 1..* MS
* reasonCode[icd10gm].coding.system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[icd10gm].coding.code 1..1 MS

// Heilmittelkatalog position: stable system + per-record code (example binding only)
* code MS
* code ^short = "Verordnetes Heilmittel / Positionsnummer aus Heilmittelkatalog"
* code.coding 1..* MS
* code.coding.system 1..1 MS
* code.coding.system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Katalog"
* code.coding.code 1..1 MS
* code from https://fhir.gevko.de/ValueSet/EVO_VS_HLM_Katalog (example)

// HMV-specific order details bound to gevko/KBV ValueSets
* orderDetail MS
* orderDetail ^slicing.discriminator.type = #value
* orderDetail ^slicing.discriminator.path = "coding.system"
* orderDetail ^slicing.rules = #open
* orderDetail ^slicing.description = "Heilmittelverordnung detail slices: Diagnosegruppe, Leitsymptomatik, AnlageTyp, Heilmittelbereich, Hausbesuch"
* orderDetail contains
    diagnosegruppe 0..1 MS and
    leitsymptomatik 0..1 MS and
    anlageTyp 0..1 MS and
    heilmittelbereich 0..1 MS and
    hausbesuch 0..1 MS

* orderDetail[diagnosegruppe] ^short = "Heilmittel-Diagnosegruppe (KBV Schluesseltabelle)"
* orderDetail[diagnosegruppe].coding 1..* MS
* orderDetail[diagnosegruppe].coding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_HM_DIAGNOSEGRUPPE"
* orderDetail[diagnosegruppe] from https://fhir.kbv.de/ValueSet/KBV_VS_SFHIR_HM_DIAGNOSEGRUPPE (required)

* orderDetail[leitsymptomatik] ^short = "Leitsymptomatik nach Heilmittelkatalog"
* orderDetail[leitsymptomatik].coding 1..* MS
* orderDetail[leitsymptomatik].coding.system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Leitsymptomatik"
* orderDetail[leitsymptomatik] from https://fhir.gevko.de/ValueSet/EVO_VS_HLM_Leitsymptomatik (required)

* orderDetail[anlageTyp] ^short = "Heilmittel oder ergaenzendes Heilmittel"
* orderDetail[anlageTyp].coding 1..* MS
* orderDetail[anlageTyp].coding.system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Section_Type"
* orderDetail[anlageTyp] from https://fhir.gevko.de/ValueSet/EVO_VS_HLM_ergaenzendesHLM (required)

* orderDetail[heilmittelbereich] ^short = "Heilmittelbereich (Physio, Ergo, Logo, Podo, Ernaehrung)"
* orderDetail[heilmittelbereich].coding 1..* MS
* orderDetail[heilmittelbereich].coding.system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Heilmittelbereich"
* orderDetail[heilmittelbereich] from https://fhir.gevko.de/ValueSet/EVO_VS_HLM_Heilmittelbereich (required)

* orderDetail[hausbesuch] ^short = "Hausbesuch angezeigt"
* orderDetail[hausbesuch].coding 1..* MS
* orderDetail[hausbesuch].coding.system = "https://fhir.gevko.de/CodeSystem/EVO_CS_HLM_Hausbesuch"
* orderDetail[hausbesuch] from https://fhir.gevko.de/ValueSet/EVO_VS_HLM_Hausbesuch (extensible)

* quantity[x] MS
* quantity[x] ^short = "Verordnete Menge (z.B. Behandlungseinheiten)"

* occurrence[x] MS
* occurrence[x] ^short = "Behandlungsfrequenz / Zeitplan"

// Optional insurance reference
* insurance 0..* MS
* insurance ^short = "Versicherungsreferenz (GKV oder Privat)"
* insurance only Reference(FPDECoverageGKV or FPDECoveragePrivat)
