// PraxisSelectiveContractClaimDE — Final selective contract / HZV billing claim
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_HzV_BesondereVersorgung_Selektiv
// use=claim; references PraxisPreliminaryBillingClaimDE via Claim.related.
// Carries selective-contract and HZV-specific billing context.

Profile: PraxisSelectiveContractClaimDE
Parent: Claim
Id: praxis-selective-contract-claim-de
Title: "Praxis Selective Contract Claim DE"
Description: "Finaler Selektivvertrags-Abrechnungsanspruch (HZV/Besondere Versorgung) fuer die deutsche ambulante Praxis. Referenziert den vorlaeufigerabrechnung (PraxisPreliminaryBillingClaimDE) per Claim.related. Traegt Selektivvertrags- und HZV-spezifischen Abrechnungskontext. Entspricht KBV_PR_AW_Abrechnung_HzV_BesondereVersorgung_Selektiv semantisch."

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #claim
* use MS
* use ^short = "claim — this is the final submitted selective-contract billing claim"

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

// Reference to preliminary claim — item lines stay there
* related MS
* related ^short = "Reference to the preliminary billing claim (PraxisPreliminaryBillingClaimDE)"
* related.claim MS
* related.claim ^short = "Reference to PraxisPreliminaryBillingClaimDE"
* related.relationship MS
* related.relationship ^short = "predetermination"
