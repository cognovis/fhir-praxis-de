// ermaechtigung.fsh
// Extension for aerztliche Ermaechtigung data on Basic resource
// Bead: fpde-e0o

Extension: ErmaechtigungExt
Id: ermaechtigung-eintrag
Title: "Ermaechtigung Eintrag"
Description: "Aerztliche Ermaechtigung gemaess § 116 SGB V: Berechtigung fuer ambulante Behandlung an einer Einrichtung."
Context: Basic
* extension contains
    art 1..1 and
    einrichtung 1..1 and
    leistungsbereich 0..* and
    period 0..1 and
    status 1..1 and
    kvAktenzeichen 0..1
* extension[art].value[x] only code
* extension[art].valueCode from ErmaechtigungArtVS (required)
* extension[art] ^short = "Art der Ermaechtigung"
* extension[einrichtung].value[x] only Reference(Organization)
* extension[einrichtung] ^short = "Einrichtung, fuer die die Ermaechtigung gilt"
* extension[leistungsbereich].value[x] only code
* extension[leistungsbereich].valueCode from GenehmigungenLeistungsbereichVS (extensible)
* extension[leistungsbereich] ^short = "Genehmigter Leistungsbereich"
* extension[period].value[x] only Period
* extension[period] ^short = "Gueltigkeitszeitraum der Ermaechtigung"
* extension[status].value[x] only code
* extension[status].valueCode from ErmaechtigungStatusVS (required)
* extension[status] ^short = "Status der Ermaechtigung"
* extension[kvAktenzeichen].value[x] only string
* extension[kvAktenzeichen] ^short = "KV-Aktenzeichen der Ermaechtigung"
