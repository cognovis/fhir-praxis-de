// DeviceMaintenanceStatusExt — Wartungsstatus fuer Bildgebungsgeraete
// Simple Extension: Coding aus DeviceMaintenanceStatusVS (required binding).
// Context: Device (ImagingDevicePraxisDe)
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: DeviceMaintenanceStatusExt
Id: device-maintenance-status
Title: "Device Maintenance Status"
Description: "Aktueller Wartungsstatus eines Bildgebungsgeraets. Kodiert den Betriebszustand (in-service, scheduled-maintenance, out-of-service, quality-control)."
Context: Device
* value[x] only Coding
* value[x] from DeviceMaintenanceStatusVS (required)
