// PraxisSelectiveContractClaimDE — Final selective contract / HZV billing claim
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_HzV_BesondereVersorgung_Selektiv
// use=claim; references PraxisPreliminaryBillingClaimDE via Claim.related (1..*).
// Item lines stay in the preliminary claim (item 0..0 here).

Invariant: praxis-selective-contract-claim-preliminary-required
Description: "A selective-contract final claim must reference at least one preliminary billing claim via Claim.related.claim."
Expression: "related.where(claim.exists()).count() >= 1"
Severity: #error

Profile: PraxisSelectiveContractClaimDE
Parent: Claim
Id: praxis-selective-contract-claim-de
Title: "Praxis Selective Contract Claim DE"
Description: "Finaler Selektivvertrags-Abrechnungsanspruch (HZV/Besondere Versorgung) fuer die deutsche ambulante Praxis. Referenziert den vorlaeufigerabrechnung (PraxisPreliminaryBillingClaimDE) per Claim.related (Pflicht: 1..*). Keine Abrechnungspositionen (item 0..0) — diese verbleiben in der vorlaeufigerabrechnung. Entspricht KBV_PR_AW_Abrechnung_HzV_BesondereVersorgung_Selektiv semantisch."

* obeys praxis-selective-contract-claim-preliminary-required

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #claim
* use MS
* use ^short = "claim — this is the final submitted selective-contract billing claim"

// Machine-readable subType: identifies this as an HZV/selective-contract final claim
* subType 1..1 MS
* subType = PraxisBillingClaimSubTypeCS#hzv-selektiv
* subType ^short = "Billing claim subtype: hzv-selektiv (HZV/selective-contract final)"

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
* insurer ^short = "Selective contract / HZV insurer"

* insurance MS
* insurance ^short = "Selective contract insurance coverage"
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
