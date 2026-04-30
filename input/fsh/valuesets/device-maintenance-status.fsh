// DeviceMaintenanceStatusVS — Wrapper fuer DeviceMaintenanceStatusCS
// Backed by DeviceMaintenanceStatusCS (lokal definiert).
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

ValueSet: DeviceMaintenanceStatusVS
Id: device-maintenance-status
Title: "Device Maintenance Status"
Description: "ValueSet der Wartungsstatus-Codes fuer Bildgebungsgeraete. Backed by DeviceMaintenanceStatusCS."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/device-maintenance-status"
* ^status = #active
* ^experimental = false
* include codes from system DeviceMaintenanceStatusCS
