Profile: RlvFallwertDetail
Parent: Basic
Id: rlv-fallwert-detail
Title: "RLV Fallwert Detail"
Description: "Profil fuer detaillierte RLV-Fallwert-Informationen mit Zuschlaegen und Fallzahlen."
* code = BasicResourceTypeCS#rlv-fallwert-detail (exactly)
* code MS
* subject MS
* extension contains
    RlvFallwertzuschlagExt named rlvFallwertzuschlag 0..1 and
    RlvFallzahlExt named rlvFallzahl 0..1 and
    RlvZuschlagsgruppeExt named rlvZuschlagsgruppe 0..1 and
    RlvVerrechnungExt named rlvVerrechnung 0..1 and
    RlvParentIdExt named rlvParentId 0..1
