// PraxisGKVClaimDE — Final GKV (statutory health insurance) billing claim
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_vertragsaerztlich
// use=claim; references exactly one PraxisPreliminaryBillingClaimDE via Claim.related (1..1).
// related.claim typed to PraxisPreliminaryBillingClaimDE.
// Item lines stay in the preliminary claim (item 0..0 here).

Invariant: praxis-gkv-claim-preliminary-required
Description: "A GKV final claim must reference at least one preliminary billing claim via Claim.related.claim."
Expression: "related.where(claim.exists()).count() >= 1"
Severity: #error

Profile: PraxisGKVClaimDE
Parent: Claim
Id: praxis-gkv-claim-de
Title: "Praxis GKV Claim DE"
Description: "Finaler vertragsaerztlicher Abrechnungsanspruch (GKV) fuer die deutsche ambulante Praxis. Referenziert genau eine vorlaeufigerabrechnung (PraxisPreliminaryBillingClaimDE) per Claim.related (1..1). related.claim auf PraxisPreliminaryBillingClaimDE eingeschraenkt. Keine Abrechnungspositionen (item 0..0). Entspricht KBV_PR_AW_Abrechnung_vertragsaerztlich semantisch."

* obeys praxis-gkv-claim-preliminary-required

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #claim
* use MS
* use ^short = "claim — this is the final submitted GKV billing claim"

// Machine-readable subType: identifies this as a GKV final claim
* subType 1..1 MS
* subType = PraxisBillingClaimSubTypeCS#gkv
* subType ^short = "Billing claim subtype: gkv (GKV final)"

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
* insurer ^short = "GKV insurer (Krankenkasse)"

* insurance MS
* insurance ^short = "GKV insurance coverage"
* insurance.sequence MS
* insurance.focal MS
* insurance.coverage MS

// Preliminary claim reference: exactly one (1..1) — typed to PraxisPreliminaryBillingClaimDE
* related 1..1 MS
* related ^short = "Exactly one reference to PraxisPreliminaryBillingClaimDE — required"
* related.claim 1..1 MS
* related.claim only Reference(PraxisPreliminaryBillingClaimDE)
* related.claim ^short = "Reference to PraxisPreliminaryBillingClaimDE — mandatory, typed"
* related.relationship MS
* related.relationship ^short = "Relationship code"

// No item lines in final claims — all service lines stay in the preliminary claim
* item 0..0
* item ^short = "Not allowed: item lines belong in the preliminary billing claim"
