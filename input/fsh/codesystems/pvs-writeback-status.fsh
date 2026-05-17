CodeSystem: PvsWritebackStatusCS
Id: pvs-writeback-status
Title: "PVS Writeback Status"
Description: "Status codes für Adapter-Adapter writeback failures. Wird als meta.tag auf FHIR-Resources (Encounter, ChargeItem, ...) gesetzt, wenn ein Adapter eine Schreib-Operation zum PVS nicht ausführen konnte. Self-healing: der Tag wird auf erfolgreichem Apply (auch nach Retry) wieder entfernt. Discovery context: adapter-tgkr, ADR-032."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
// Fehler-Marker — wird auf 422/503 Writeback-Failures gesetzt
* #pvs-writeback-error "PVS Writeback Error" "Adapter konnte die Resource nicht zum PVS schreiben. Der display-Wert des Tags enthält die Fehler-Kategorie (validation, pvs-db-error, ...) und eine Kurz-Beschreibung."
