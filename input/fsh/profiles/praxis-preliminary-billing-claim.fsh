// PraxisPreliminaryBillingClaimDE — Preliminary billing claim carrying item lines
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_Vorlaeufig
// use=predetermination; this is the item carrier for the AW billing split.
// Final claims (GKV/private/BG/selective) reference this via Claim.related.
// Invariant: preliminary claims MUST have at least one item line (item 1..*).

Profile: PraxisPreliminaryBillingClaimDE
Parent: Claim
Id: praxis-preliminary-billing-claim-de
Title: "Praxis Preliminary Billing Claim DE"
Description: "Vorlaeufigerabrechnung fuer die deutsche ambulante Praxis. Traegt die tatsaechlichen Abrechnungspositionen (ChargeItem-Zeilen). Wird von finalen Claim-Profilen (GKV, privat, BG, Selektivvertrag) per Claim.related referenziert. Item-Zeilen Pflicht (1..*). Entspricht KBV_PR_AW_Abrechnung_Vorlaeufig semantisch."

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #predetermination
* use MS
* use ^short = "predetermination — this is the preliminary item-carrier claim"

// Machine-readable subType: identifies this as a preliminary billing claim
* subType 1..1 MS
* subType = PraxisBillingClaimSubTypeCS#vorlaeufig
* subType ^short = "Billing claim subtype: vorlaeufig (preliminary item carrier)"

// type fixed to professional — matches AW billing claim semantics
* type 1..1 MS
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* type ^short = "Claim type: professional"

* patient 1..1 MS
* patient only Reference(Patient)
* patient ^short = "Patient"

* created MS
* created ^short = "Claim creation date"

* provider MS
* provider only Reference(Practitioner or PractitionerRole or Organization)
* provider ^short = "Treating practitioner or organization"

* priority MS
* priority ^short = "Process priority"

* insurer MS
* insurer only Reference(Organization)
* insurer ^short = "Insurer or payer"

* insurance MS
* insurance ^short = "Insurance coverage details"
* insurance.sequence MS
* insurance.focal MS
* insurance.coverage MS

// Quarterly treatment diagnoses:
// Claim.diagnosis carries the quarter diagnosis list for billing resolution.
// Dedupe is only by the billing tuple: ICD code + Diagnosesicherheit +
// Seitenlokalisation + Mehrfachcodierungskennzeichen. Different certainty,
// laterality, or marker values must remain separate entries.
* diagnosis 0..* MS
* diagnosis ^short = "Quarterly treatment diagnoses for billing"
* diagnosis ^definition = "Optional quarterly Behandlungsdiagnosen. Each entry references one source PraxisCondition when available; otherwise diagnosisCodeableConcept may carry the billing diagnosis. Dedupe is over the exact billing tuple only: ICD code, Diagnosesicherheit, Seitenlokalisation, and Mehrfachcodierungskennzeichen."
* diagnosis.sequence MS
* diagnosis.sequence ^short = "Stable diagnosis sequence within the claim"
* diagnosis.diagnosisReference MS
* diagnosis.diagnosisReference only Reference(PraxisCondition)
* diagnosis.diagnosisReference ^short = "Source PraxisCondition for this billing diagnosis tuple"
* diagnosis.diagnosisCodeableConcept MS
* diagnosis.diagnosisCodeableConcept ^short = "Billing diagnosis code when no source Condition reference is available"

// Item lines: REQUIRED (1..*) — this profile is the item carrier for the AW billing split
* item 1..* MS
* item ^short = "Billable service line items (from ChargeItem) — at least one required"
* item.sequence MS
* item.productOrService MS
* item.quantity MS
* item.unitPrice MS
* item.net MS
