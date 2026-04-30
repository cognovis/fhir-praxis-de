// DICOM AE-Title NamingSystem
// Eindeutiger Bezeichner fuer DICOM-Geraete im PACS-Netzwerk (Application Entity Title).
// Verwendet als system-Wert fuer identifier[aeTitle] in ImagingDevicePraxisDe.
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Instance: dicom-ae-title
InstanceOf: NamingSystem
Usage: #definition
* name = "DicomAeTitle"
* status = #active
* kind = #identifier
* date = "2026-04-30"
* publisher = "cognovis GmbH"
* description = "DICOM Application Entity Title (AE-Title) — eindeutiger Bezeichner fuer DICOM-Geraete im PACS-Netzwerk. Pflicht-Identifier fuer PACS-Routing in ImagingDevicePraxisDe."
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/dicom-ae-title"
* uniqueId[0].preferred = true
