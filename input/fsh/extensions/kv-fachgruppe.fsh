Extension: KvfgKvRegionExt
Id: kvfg-kv-region
Title: "KV-Fachgruppe KV-Region"
Description: "KV-Regionskennzeichen fuer Fachgruppen-Budgetinformationen"
Context: Basic
* value[x] only string

Extension: KvfgFachgruppeCodeExt
Id: kvfg-fachgruppe-code
Title: "KV-Fachgruppe Code"
Description: "Fachgruppen-Code gebunden an KBV BAR2-WBO."
Context: Basic
* value[x] only Coding
* valueCoding from https://fhir.kbv.de/ValueSet/KBV_VS_SFHIR_BAR2_WBO (required)

Extension: KvfgGueltigAbExt
Id: kvfg-gueltig-ab
Title: "KV-Fachgruppe Gueltig ab"
Description: "Beginn der Gueltigkeit der Fachgruppen-Budgetinformation"
Context: Basic
* value[x] only date

Extension: KvfgGueltigBisExt
Id: kvfg-gueltig-bis
Title: "KV-Fachgruppe Gueltig bis"
Description: "Ende der Gueltigkeit der Fachgruppen-Budgetinformation"
Context: Basic
* value[x] only date
