// HVG/Selektivvertrag Extensions
// Grundstruktur über FHIR Contract Resource, hier nur Zusatzfelder

Extension: HvgFacharztvertragExt
Id: hvg-facharztvertrag
Title: "Facharztvertrag"
Description: "Kennzeichen, ob es sich um einen Facharztvertrag handelt (§73c SGB V)"
Context: Contract
* value[x] only boolean

Extension: HvgKennungExt
Id: hvg-kennung
Title: "HVG-Kennung"
Description: "Eindeutige Kennung des Selektivvertrags beim Kostenträger"
Context: Contract
* value[x] only string
