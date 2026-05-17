// ============================================================================
// Sub-Extension Convention (ADR)
// Sub-extensions are defined with relative names inside the parent extension
// definition (e.g., leistungsbereich, genehmigungsdatum, ablaufdatum).
// Adapter code addresses them via the full canonical URL of the parent plus
// a '#' fragment, e.g.:
//   https://fhir.cognovis.de/praxis/StructureDefinition/genehmigung-eintrag#ablaufdatum
// This is standard FHIR sub-extension addressing and requires no changes to
// this file. PVS-specific adapter code handles the full URL construction.
// ============================================================================

Extension: GenehmigungenExt
Id: genehmigung-eintrag
Title: "Genehmigungseintrag"
Description: "Einzelner KV-Genehmigungseintrag mit Leistungsbereich und Laufzeit"
Context: Basic
* extension contains
    leistungsbereich 1..1 and
    genehmigungsdatum 0..1 and
    ablaufdatum 0..1 and
    kvAktenzeichen 0..1 and
    status 0..1 and
    cockpitItemId 0..1
* extension[leistungsbereich].value[x] only code
* extension[leistungsbereich].valueCode from GenehmigungenLeistungsbereichVS (extensible)
* extension[genehmigungsdatum].value[x] only date
* extension[ablaufdatum].value[x] only date
* extension[kvAktenzeichen].value[x] only string
* extension[status].value[x] only code
* extension[status].valueCode from GenehmigungenStatusVS (required)
* extension[cockpitItemId].value[x] only string
* extension[cockpitItemId] ^short = "Stable source-system identifier (e.g. Cockpit item.id) for matching across syncs — required to distinguish historical entries of the same leistungsbereich (revoke→re-grant)"

Extension: GenehmigungenTypExt
Id: genehmigung-typ
Title: "Genehmigungstyp"
Description: "Typ der KV-Genehmigung: kopfbezogen (arztgebunden) vs. betriebsstaette"
Context: Basic
* value[x] only code
* valueCode from GenehmigungenTypVS (required)
