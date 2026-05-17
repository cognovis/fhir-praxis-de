CodeSystem: PvsWritebackStatusCS
Id: pvs-writeback-status
Title: "PVS Writeback Status"
Description: "Statuscodes fuer PVS-Writeback-Failures. Wird als meta.tag auf FHIR-Ressourcen (Encounter, ChargeItem, ...) gesetzt, wenn eine Schreib-Operation in das anbindende Praxisverwaltungssystem nicht ausgefuehrt werden konnte. Self-healing: der Tag wird bei erfolgreichem Apply (auch nach Retry) wieder entfernt."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
// Fehler-Marker — wird auf 422/503 Writeback-Failures gesetzt
* #pvs-writeback-error "PVS Writeback Error" "Die Ressource konnte nicht in das PVS geschrieben werden. Der display-Wert des Tags traegt die Fehler-Kategorie (validation, pvs-db-error, ...) und eine Kurz-Beschreibung."
