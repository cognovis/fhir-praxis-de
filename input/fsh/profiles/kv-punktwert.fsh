Profile: KvPunktwert
Parent: Basic
Id: kv-punktwert
Title: "KV Punktwert"
Description: "Profil fuer KV-Punktwerte je EBM-Gebührenordnungsposition."
* code = BasicResourceTypeCS#kv-punktwert (exactly)
* code MS
* subject MS
* extension contains
    PunktwertGoNummerExt named punktwertGoNummer 0..1 and
    PunktwertKategorieNummerExt named punktwertKategorieNummer 0..1 and
    PunktwertWertExt named punktwertWert 0..1
