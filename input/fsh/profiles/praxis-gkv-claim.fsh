// PraxisGKVClaimDE — Final GKV (statutory health insurance) billing claim
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_vertragsaerztlich
// use=claim; references PraxisPreliminaryBillingClaimDE via Claim.related.
// Item lines stay in the preliminary claim.

Profile: PraxisGKVClaimDE
Parent: Claim
Id: praxis-gkv-claim-de
Title: "Praxis GKV Claim DE"
Description: "Finaler vertragsaerztlicher Abrechnungsanspruch (GKV) fuer die deutsche ambulante Praxis. Referenziert den vorlaeufigerabrechnung (PraxisPreliminaryBillingClaimDE) per Claim.related. Abrechnungspositionen verbleiben in der vorlaeufigerabrechnung. Entspricht KBV_PR_AW_Abrechnung_vertragsaerztlich semantisch."

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #claim
* use MS
* use ^short = "claim — this is the final submitted GKV billing claim"

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
* insurer ^short = "GKV insurer (Krankenkasse)"

* insurance MS
* insurance ^short = "GKV insurance coverage"
* insurance.sequence MS
* insurance.focal MS
* insurance.coverage MS

// Reference to preliminary claim — item lines stay there
* related MS
* related ^short = "Reference to the preliminary billing claim (PraxisPreliminaryBillingClaimDE)"
* related.claim MS
* related.claim ^short = "Reference to PraxisPreliminaryBillingClaimDE"
* related.relationship MS
* related.relationship ^short = "predetermination"
