// PraxisBGClaimDE — Final Berufsgenossenschaft (occupational accident insurance) billing claim
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_BG
// use=claim; references PraxisPreliminaryBillingClaimDE via Claim.related (1..*).
// Item lines stay in the preliminary claim (item 0..0 here).
// Note: Claim.accident is NOT used here — BG accident context is carried via referenced
// Condition/Procedure resources, not inline in the final claim per AW semantics.

Invariant: praxis-bg-claim-preliminary-required
Description: "A BG final claim must reference at least one preliminary billing claim via Claim.related.claim."
Expression: "related.where(claim.exists()).count() >= 1"
Severity: #error

Profile: PraxisBGClaimDE
Parent: Claim
Id: praxis-bg-claim-de
Title: "Praxis BG Claim DE"
Description: "Finaler BG-Abrechnungsanspruch (Berufsgenossenschaft / Unfallversicherung) fuer die deutsche ambulante Praxis. Referenziert den vorlaeufigerabrechnung (PraxisPreliminaryBillingClaimDE) per Claim.related (Pflicht: 1..*). Keine Abrechnungspositionen (item 0..0) — diese verbleiben in der vorlaeufigerabrechnung. BG-Unfallkontext wird ueber referenzierte Condition/Procedure-Ressourcen getragen, nicht per Claim.accident. Entspricht KBV_PR_AW_Abrechnung_BG semantisch."

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

* type MS
* type ^short = "Claim type"

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

// Preliminary claim reference: REQUIRED (1..*) — enforces AW billing split
* related 1..* MS
* related ^short = "Reference to the preliminary billing claim (PraxisPreliminaryBillingClaimDE) — required"
* related.claim 1..1 MS
* related.claim ^short = "Reference to PraxisPreliminaryBillingClaimDE — mandatory"
* related.relationship MS
* related.relationship ^short = "Relationship code — use 'associated' to indicate the preliminary claim"

// No item lines in final claims — all service lines stay in the preliminary claim
* item 0..0
* item ^short = "Not allowed: item lines belong in the preliminary billing claim"
