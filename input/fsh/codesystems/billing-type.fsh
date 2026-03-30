CodeSystem: BillingTypeCS
Id: billing-type
Title: "Abrechnungsart"
Description: "Codes für Abrechnungsarten in der ambulanten Versorgung. Dient als Diskriminator für ChargeItemDefinition-Kataloge. Regionale Selektivverträge nutzen den generischen Typ (z.B. hzv, facharztvertrag) — die KV-Region wird über Contract.identifier bzw. ChargeItemDefinition.jurisdiction abgebildet."
* ^status = #draft
* ^caseSensitive = true
// Bundesweite Gebührenordnungen
* #ebm "EBM" "Einheitlicher Bewertungsmaßstab (GKV)"
* #goae "GOÄ" "Gebührenordnung für Ärzte (PKV)"
* #bema "BEMA" "Bewertungsmaßstab für zahnärztliche Leistungen (GKV)"
* #goz "GOZ" "Gebührenordnung für Zahnärzte (PKV)"
* #bgt2001 "BGT2001" "Berufsgenossenschaftliche Gebühren-Tarifpositionen (DGUV)"
// Selektivverträge (§73b/§73c SGB V) — regionsneutral
* #hzv "HZV" "Hausarztzentrierte Versorgung (§73b SGB V)"
* #facharztvertrag "Facharztvertrag" "Facharztvertrag / Besondere Versorgung (§73c/§140a SGB V)"
// Sonstige
* #igel "IGeL" "Individuelle Gesundheitsleistung"
* #bg "BG" "Berufsgenossenschaft (sonstige BG-Abrechnung)"
