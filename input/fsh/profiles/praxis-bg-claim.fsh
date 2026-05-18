// PraxisBGClaimDE — Final Berufsgenossenschaft (occupational accident insurance) billing claim
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_BG
// use=claim; references PraxisPreliminaryBillingClaimDE via Claim.related.
// Carries BG-specific billing context.

Profile: PraxisBGClaimDE
Parent: Claim
Id: praxis-bg-claim-de
Title: "Praxis BG Claim DE"
Description: "Finaler BG-Abrechnungsanspruch (Berufsgenossenschaft / Unfallversicherung) fuer die deutsche ambulante Praxis. Referenziert den vorlaeufigerabrechnung (PraxisPreliminaryBillingClaimDE) per Claim.related. Traegt BG-spezifischen Abrechnungskontext (Unfall, BG-Nummer). Entspricht KBV_PR_AW_Abrechnung_BG semantisch."

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #claim
* use MS
* use ^short = "claim — this is the final submitted BG billing claim"

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

// accident context: BG claims typically reference an accident
* accident MS
* accident ^short = "Accident context for BG claims (date, type, location)"
* accident.date MS
* accident.type MS

// Reference to preliminary claim — item lines stay there
* related MS
* related ^short = "Reference to the preliminary billing claim (PraxisPreliminaryBillingClaimDE)"
* related.claim MS
* related.claim ^short = "Reference to PraxisPreliminaryBillingClaimDE"
* related.relationship MS
* related.relationship ^short = "predetermination"
