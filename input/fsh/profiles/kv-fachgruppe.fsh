Profile: KvFachgruppeProfile
Parent: Basic
Id: kv-fachgruppe-profile
Title: "KV Fachgruppe"
Description: "Profil fuer KV-Fachgruppen-Budgetinformationen (KVBudFachgruppe)."
* code = BasicResourceTypeCS#kv-fachgruppe (exactly)
* code MS
* subject MS
* extension contains
    KvfgKvRegionExt named kvfgKvRegion 0..1 and
    KvfgFachgruppeCodeExt named kvfgFachgruppeCode 0..1 and
    KvfgGueltigAbExt named kvfgGueltigAb 0..1 and
    KvfgGueltigBisExt named kvfgGueltigBis 0..1
