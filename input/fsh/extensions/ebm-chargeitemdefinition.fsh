// EBM ChargeItemDefinition-Level Extensions
// (Ergänzung zu den ChargeItemDefinition-Extensions in billing.fsh)

Extension: EbmKapitelExt
Id: ebm-kapitel
Title: "EBM-Kapitel"
Description: "Kapitel des EBM, zu dem die Leistung gehört"
Context: ChargeItemDefinition
* value[x] only string

Extension: EbmPunkteExt
Id: ebm-punkte
Title: "EBM-Punkte"
Description: "EBM-Punktzahl laut Katalog"
Context: ChargeItemDefinition
* value[x] only decimal

Extension: EbmPruefzeitExt
Id: ebm-pruefzeit
Title: "EBM-Prüfzeit"
Description: "Prüfzeit in Minuten für die Plausibilitätsprüfung der Leistung"
Context: ChargeItemDefinition
* value[x] only integer

Extension: EbmRlvRelevanzExt
Id: ebm-rlv-relevanz
Title: "EBM-RLV-Relevanz"
Description: "Kennzeichen, ob die Leistung RLV-relevant ist (Regelleistungsvolumen)"
Context: ChargeItemDefinition
* value[x] only boolean

Extension: EbmEuroBetragExt
Id: ebm-euro-betrag
Title: "EBM-Euro-Betrag"
Description: "Euro-Betrag laut EBM-Katalog (Orientierungspunktwert × Punkte)"
Context: ChargeItemDefinition
* value[x] only Money
