Profile: RlvBudget
Parent: Basic
Id: rlv-budget
Title: "RLV Budget"
Description: "Profil fuer die Konfiguration des Regelleistungsvolumens (RLV) in der deutschen ambulanten Versorgung."
* code = BasicResourceTypeCS#rlv-budget (exactly)
* code MS
* subject MS
* extension contains
    RlvKvRegionExt named rlvKvRegion 1..1 MS and
    RlvFachgruppeExt named rlvFachgruppe 0..1 MS and
    RlvFallwertExt named rlvFallwert 0..1 MS and
    RlvQzvFallwertExt named rlvQzvFallwert 0..1 and
    RlvZugewiesenExt named rlvZugewiesen 0..1 and
    RlvQzvZugewiesenExt named rlvQzvZugewiesen 0..1 and
    RlvEntbudgetiertExt named rlvEntbudgetiert 0..1 and
    RlvKategorieExt named rlvKategorie 0..1
