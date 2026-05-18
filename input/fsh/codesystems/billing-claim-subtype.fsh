// PraxisBillingClaimSubTypeCS — machine-readable subType discriminator for AW billing claim split
// Codes correspond to the five AW-SST Abrechnung profiles; used as Claim.subType fixed values.

CodeSystem: PraxisBillingClaimSubTypeCS
Id: billing-claim-subtype
Title: "Praxis Billing Claim SubType"
Description: "Machine-readable subType codes for the AW billing claim split. Each code identifies the role of a Claim resource within the AW-SST preliminary/final billing model."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #vorlaeufig "Preliminary Billing Claim" "Preliminary item-carrier claim (AW: Abrechnung_Vorlaeufig). Carries the billable service-line items. Referenced by all final claims via Claim.related."
* #gkv "GKV Final Claim" "Final statutory health insurance (GKV) billing claim (AW: Abrechnung_vertragsaerztlich). No item lines; references the preliminary claim."
* #privat "Private Final Claim" "Final private billing claim (AW: Abrechnung_privat). No item lines; references the preliminary claim."
* #bg "BG Final Claim" "Final occupational accident insurance (BG/DGUV) billing claim (AW: Abrechnung_BG). No item lines; references the preliminary claim."
* #hzv-selektiv "HZV / Selective Contract Final Claim" "Final selective-contract or HZV billing claim (AW: Abrechnung_HzV_BesondereVersorgung_Selektiv). No item lines; references the preliminary claim."
