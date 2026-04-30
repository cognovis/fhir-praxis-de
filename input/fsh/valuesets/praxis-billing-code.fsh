// PraxisBillingCodeVS — extensible binding for PraxisBillingActivity.code
// Covers all recognized German ambulatory billing systems: EBM, GOÄ, HZV (§73b),
// BEMA, and GOZ. Extensible binding allows additional systems (e.g. BG-Tarife).

ValueSet: PraxisBillingCodeVS
Id: praxis-billing-code
Title: "Praxis Billing Code"
Description: "Billing codes from recognized German ambulatory billing systems for use as PraxisBillingActivity.code. Covers EBM (GKV), GOÄ (PKV), HZV (§73b SGB V), BEMA (GKV-Dental), and GOZ (PKV-Dental). Extensible — additional systems (e.g. DGUV/BG) may be used."
* ^status = #active
* ^experimental = false
// EBM — Einheitlicher Bewertungsmaßstab (KBV SFHIR)
* include codes from system https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM
// GOÄ — Gebührenordnung für Ärzte (Bundesärztekammer)
* include codes from system https://fhir.de/CodeSystem/bak/goae
// BEMA — Bewertungsmaßstab zahnärztlich (KZBV, via dental IG)
* include codes from system https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BEMA
// HZV — Hausarztzentrierte Versorgung codes (BillingTypeCS context)
* include codes from system BillingTypeCS where concept descendent-of #hzv
// GOZ — Gebührenordnung für Zahnärzte (BZÄK)
* include codes from system https://fhir.de/CodeSystem/bzaek/goz
