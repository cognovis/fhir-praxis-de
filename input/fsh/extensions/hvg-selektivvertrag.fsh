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

Extension: HvgBezeichnungExt
Id: hvg-bezeichnung
Title: "HVG-Bezeichnung"
Description: "Vollstaendige Bezeichnung des Selektivvertrags"
Context: Contract
* value[x] only string

Extension: HvgKurzbezeichnungExt
Id: hvg-kurzbezeichnung
Title: "HVG-Kurzbezeichnung"
Description: "Kurzbezeichnung des Selektivvertrags fuer Anzeige im PVS"
Context: Contract
* value[x] only string

Extension: HvgDatumExt
Id: hvg-datum
Title: "HVG-Datum"
Description: "Vertragsdatum des Selektivvertrags"
Context: Contract
* value[x] only date

Extension: HvgVertragNummerExt
Id: hvg-vertrag-nummer
Title: "HVG-Vertragsnummer"
Description: "Vertragsnummer des Selektivvertrags beim Kostentraeger"
Context: Contract
* value[x] only string

Extension: HvgDatumBeantragtExt
Id: hvg-datum-beantragt
Title: "HVG Datum Beantragt"
Description: "Antragsdatum für die Einschreibung in den HVG-Selektivvertrag (§73b/§73c SGB V)"
Context: EpisodeOfCare
* value[x] only date
