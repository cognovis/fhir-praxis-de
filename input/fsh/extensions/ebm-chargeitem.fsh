// EBM ChargeItemDefinition-Level Extensions
// (Ergänzung zu den ChargeItemDefinition-Extensions in billing.fsh)

Extension: EbmKapitelExt
Id: ebm-kapitel
Title: "EBM-Kapitel"
Description: "Kapitel des EBM, zu dem die abgerechnete Leistung gehört"
Context: ChargeItemDefinition
* value[x] only string

Extension: EbmPunkteExt
Id: ebm-punkte
Title: "EBM-Punkte"
Description: "Konkret abgerechnete EBM-Punktzahl (kann durch Zuschläge/Abzüge vom Katalogwert abweichen)"
Context: ChargeItemDefinition
* value[x] only decimal

Extension: EbmPruefzeitExt
Id: ebm-pruefzeit
Title: "EBM-Prüfzeit"
Description: "Prüfzeit in Minuten für die Plausibilitätsprüfung der abgerechneten Leistung"
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
Description: "Konkreter Euro-Betrag der abgerechneten EBM-Leistung (nach Anwendung des Orientierungspunktwerts)"
Context: ChargeItemDefinition
* value[x] only Money
