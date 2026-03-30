Extension: GenehmigungenExt
Id: genehmigung-eintrag
Title: "Genehmigungseintrag"
Description: "Einzelner KV-Genehmigungseintrag mit Leistungsbereich und Laufzeit"
Context: Basic
* extension contains
    leistungsbereich 1..1 and
    genehmigungsdatum 0..1 and
    ablaufdatum 0..1 and
    kvAktenzeichen 0..1
* extension[leistungsbereich].value[x] only code
* extension[leistungsbereich].valueCode from GenehmigungenLeistungsbereichVS (extensible)
* extension[genehmigungsdatum].value[x] only date
* extension[ablaufdatum].value[x] only date
* extension[kvAktenzeichen].value[x] only string

Extension: GenehmigungenTypExt
Id: genehmigung-typ
Title: "Genehmigungstyp"
Description: "Typ der KV-Genehmigung: kopfbezogen (arztgebunden) vs. betriebsstaette"
Context: Basic
* value[x] only code
* valueCode from GenehmigungenTypVS (required)
