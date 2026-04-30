// BGT2001 BG-Tarif Extensions (ergänzt dguv.basis)

Extension: BgtPunkteExt
Id: bgt-punkte
Title: "BGT-Punktzahl"
Description: "Punktzahl der BG-Tarifposition (BGT2001)"
Context: ChargeItemDefinition, ChargeItem
* value[x] only decimal

Extension: BgtKatalogGruppeExt
Id: bgt-katalog-gruppe
Title: "BGT-Kataloggruppe"
Description: "Obergruppe im BGT2001-Katalog (z.B. Allgemeine Leistungen, Chirurgie)"
Context: ChargeItemDefinition
* value[x] only string

Extension: BgtKatalogUntergruppeExt
Id: bgt-katalog-untergruppe
Title: "BGT-Kataloguntergruppe"
Description: "Untergruppe im BGT2001-Katalog"
Context: ChargeItemDefinition
* value[x] only string
