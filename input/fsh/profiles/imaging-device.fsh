// ImagingDevicePraxisDe — Bildgebungsgeraet fuer die deutsche ambulante Praxis
// Erbt von R4 Device. Erweitert um DICOM AE-Title Identifier-Slice (PACS-Routing),
// Modalitaets-Typ-Binding (DicomModalityVS), Standort-Referenz und
// DeviceMaintenanceStatusExt fuer Wartungsstatus.
//
// AE-Title: Pflicht-Identifier fuer PACS-Routing (1..* MS, required).
// Typ: DicomModalityVS (required binding) fuer DICOM-konforme Modalitaetskodierung.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Profile: ImagingDevicePraxisDe
Parent: Device
Id: imaging-device-praxis-de
Title: "Imaging Device (Praxis DE)"
Description: "Bildgebungsgeraet-Profil fuer die deutsche ambulante Praxis. Erbt von R4 Device. Enthaelt DICOM AE-Title Identifier (PACS-Routing), Modalitaets-Typ (DicomModalityVS), Standort-Referenz und Wartungsstatus-Extension."

// DeviceMaintenanceStatusExt: Wartungsstatus des Geraets
* extension contains DeviceMaintenanceStatusExt named deviceMaintenanceStatus 0..1 MS

// AE-Title Identifier-Slicing (fuer PACS-Routing — required 1..*)
* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains aeTitle 1..* MS
* identifier[aeTitle] ^short = "DICOM Application Entity Title (AE-Title) fuer PACS-Routing"
* identifier[aeTitle].system = "https://fhir.cognovis.de/praxis/NamingSystem/dicom-ae-title"
* identifier[aeTitle].system MS
* identifier[aeTitle].value 1..1 MS

// Geraetename
* deviceName MS
* deviceName.name MS
* deviceName.type MS

// Hersteller und Modell
* manufacturer MS
* modelNumber MS

// Typ: DicomModalityVS (required binding fuer DICOM-konforme Modalitaetskodierung)
* type 1..1 MS
* type from DicomModalityVS (required)

// Standort (Praxis-Raum)
* location MS
* location ^short = "Standort des Geraets (Praxis-Raum, z.B. MRT-Raum 1)"

// Status: Betriebsstatus des Geraets
* status 1..1 MS
