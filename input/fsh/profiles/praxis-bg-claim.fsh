// PraxisBGClaimDE — Final Berufsgenossenschaft (occupational accident insurance) billing claim
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_BG
// use=claim; references exactly one PraxisPreliminaryBillingClaimDE via Claim.related (1..1).
// related.claim typed to PraxisPreliminaryBillingClaimDE.
// Item lines stay in the preliminary claim (item 0..0 here).
// BG accident context is carried via referenced Condition/Procedure resources, not Claim.accident.

Invariant: praxis-bg-claim-preliminary-required
Description: "A BG final claim must reference at least one preliminary billing claim via Claim.related.claim."
Expression: "related.where(claim.exists()).count() >= 1"
Severity: #error

Profile: PraxisBGClaimDE
Parent: Claim
Id: praxis-bg-claim-de
Title: "Praxis BG Claim DE"
Description: "Finaler BG-Abrechnungsanspruch (Berufsgenossenschaft / Unfallversicherung) fuer die deutsche ambulante Praxis. Referenziert genau eine vorlaeufigerabrechnung (PraxisPreliminaryBillingClaimDE) per Claim.related (1..1). related.claim auf PraxisPreliminaryBillingClaimDE eingeschraenkt. Keine Abrechnungspositionen (item 0..0). BG-Unfallkontext wird ueber referenzierte Condition/Procedure-Ressourcen getragen. Entspricht KBV_PR_AW_Abrechnung_BG semantisch."

* obeys praxis-bg-claim-preliminary-required

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #claim
* use MS
* use ^short = "claim — this is the final submitted BG billing claim"

// Machine-readable subType: identifies this as a BG final claim
* subType 1..1 MS
* subType = PraxisBillingClaimSubTypeCS#bg
* subType ^short = "Billing claim subtype: bg (BG/DGUV final)"

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
* insurer ^short = "BG or DGUV insurer"

* insurance MS
* insurance ^short = "BG/DGUV insurance coverage"
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
