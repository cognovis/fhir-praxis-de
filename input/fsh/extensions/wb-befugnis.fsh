// wb-befugnis.fsh
// WB-Befugnis: Weiterbildungsbefugnis eines Arztes an einem Standort
// Cockpit: WeiterbildungsBefugnis model (models.py:854-938)
// Bead: fpde-e0o

Extension: WbBefugnisExt
Id: wb-befugnis
Title: "WB-Befugnis"
Description: "Weiterbildungsbefugnis: Berechtigung eines Arztes, an einem Standort Weiterbildung durchzufuehren."
Context: PractitionerRole
* extension contains
    fachgruppe 1..1 and
    maxMonate 1..1 and
    period 0..1 and
    status 1..1
* extension[fachgruppe].value[x] only Coding
* extension[fachgruppe].valueCoding from KvFachgruppeVS (preferred)
* extension[fachgruppe] ^short = "Fachgruppe der Weiterbildungsbefugnis (KBV WBO)"
* extension[maxMonate].value[x] only positiveInt
* extension[maxMonate] ^short = "Maximale Weiterbildungsdauer in Monaten"
* extension[period].value[x] only Period
* extension[period] ^short = "Gueltigkeitszeitraum der WB-Befugnis"
* extension[status].value[x] only code
* extension[status].valueCode from WbBefugnisStatusVS (required)
* extension[status] ^short = "Status der WB-Befugnis"
