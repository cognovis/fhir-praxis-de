// GOÄ Detail Extensions (Privatärztliche Detailabrechnung)

Extension: GoaeOrganExt
Id: goae-organ
Title: "Ultraschall-Organ"
Description: "Bezeichnung des untersuchten Organs bei Ultraschall-Leistungen (GOÄ Kapitel C V)"
Context: ChargeItem, Claim
* value[x] only string

Extension: GoaeUhrzeitExt
Id: goae-uhrzeit
Title: "Behandlungsuhrzeit"
Description: "Uhrzeit der Leistungserbringung (relevant für Zuschläge bei Unzeiten, GOÄ Buchstabe E/F)"
Context: ChargeItem, Claim
* value[x] only time

Extension: GoaeSachkostenBezeichnungExt
Id: goae-sachkosten-bezeichnung
Title: "Sachkosten-Bezeichnung"
Description: "Bezeichnung der abgerechneten Sachkosten (z.B. Material, Medikamente) gemäß GOÄ §10"
Context: ChargeItem, Claim
* value[x] only string

Extension: GoaeMaterialkostenExt
Id: goae-materialkosten
Title: "Materialkosten"
Description: "Betrag der abgerechneten Materialkosten gemäß GOÄ §10"
Context: ChargeItem, Claim
* value[x] only Money

Extension: SachkostenPriceExt
Id: sachkosten-price
Title: "Sachkosten-Preis"
Description: "Sachkostenpauschale für GOÄ-Ziffern mit Material-Anteil (z.B. 0xxx-Ziffern)"
Context: ChargeItemDefinition
* value[x] only Money

Extension: AnalogReferenceExt
Id: analog-reference
Title: "Analogziffer-Referenz"
Description: "Referenz auf die Originalziffer bei Analogabrechnung gemäß GOÄ §6 Abs. 2"
Context: ChargeItem, Claim
* value[x] only string
