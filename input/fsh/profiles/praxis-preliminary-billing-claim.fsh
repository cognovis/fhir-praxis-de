// PraxisPreliminaryBillingClaimDE — Preliminary billing claim carrying item lines
// AW-SST crosswalk: maps to KBV_PR_AW_Abrechnung_Vorlaeufig
// use=predetermination; this is the item carrier for the AW billing split.
// Final claims (GKV/private/BG/selective) reference this via Claim.related.

Profile: PraxisPreliminaryBillingClaimDE
Parent: Claim
Id: praxis-preliminary-billing-claim-de
Title: "Praxis Preliminary Billing Claim DE"
Description: "Vorlaeufigerabrechnung fuer die deutsche ambulante Praxis. Traegt die tatsaechlichen Abrechnungspositionen (ChargeItem-Zeilen). Wird von finalen Claim-Profilen (GKV, privat, BG, Selektivvertrag) per Claim.related referenziert. Entspricht KBV_PR_AW_Abrechnung_Vorlaeufig semantisch."

* status 1..1 MS
* status ^short = "Status of the claim"

* use = #predetermination
* use MS
* use ^short = "predetermination — this is the preliminary item-carrier claim"

* type MS
* type ^short = "Claim type (professional, institutional, etc.)"

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

// Item lines: this profile carries the billable service lines from ChargeItem
* item MS
* item ^short = "Billable service line items (from ChargeItem)"
* item.sequence MS
* item.productOrService MS
* item.quantity MS
* item.unitPrice MS
* item.net MS
