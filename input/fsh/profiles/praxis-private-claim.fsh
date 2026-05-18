// PraxisPrivateClaimDE — Final private billing claim
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_privat
// use=claim; references PraxisPreliminaryBillingClaimDE via Claim.related.
// Item lines stay in the preliminary claim.
// Private receiver/payment/routing semantics are distinct from PraxisInvoiceDE.

Profile: PraxisPrivateClaimDE
Parent: Claim
Id: praxis-private-claim-de
Title: "Praxis Private Claim DE"
Description: "Finaler Privatabrechnungsanspruch fuer die deutsche ambulante Praxis. Referenziert den vorlaeufigerabrechnung (PraxisPreliminaryBillingClaimDE) per Claim.related. Haelt private Empfaenger/Zahlungs-/Routing-Semantik getrennt von PraxisInvoiceDE. Entspricht KBV_PR_AW_Abrechnung_privat semantisch."

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #claim
* use MS
* use ^short = "claim — this is the final submitted private billing claim"

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
* insurer ^short = "Private payer organization (private insurer, billing service, or payer)"

* insurance MS
* insurance ^short = "Private insurance or self-pay coverage"
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
