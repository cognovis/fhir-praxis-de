// DeviceMaintenanceStatusCS — Wartungsstatus fuer Bildgebungsgeraete
// Kodiert den aktuellen Betriebszustand eines Geraets im Wartungszyklus.
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

CodeSystem: DeviceMaintenanceStatusCS
Id: device-maintenance-status
Title: "Device Maintenance Status"
Description: "Wartungsstatus-Codes fuer Bildgebungsgeraete in der deutschen ambulanten Praxis. Kodiert den aktuellen Betriebszustand (in-service, scheduled-maintenance, out-of-service, quality-control)."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/device-maintenance-status"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #in-service "In Service" "Geraet ist betriebsbereit"
* #scheduled-maintenance "Scheduled Maintenance" "Geraet ist fuer Wartung eingeplant"
* #out-of-service "Out of Service" "Geraet ist ausser Betrieb"
* #quality-control "Quality Control" "Geraet wird auf Qualitaetssicherung geprueft"
