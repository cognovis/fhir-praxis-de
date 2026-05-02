// DICOM RequestedProcedureID NamingSystem
// Eindeutiger Bezeichner fuer den geplanten Untersuchungsschritt im DICOM MWL (Modality Worklist).
// DICOM-Tag (0040,1001): RequestedProcedureID — identifiziert den spezifischen Prozedurschritt,
// vergeben durch das Scheduling-System (RIS/PVS).
// Verwendet als system-Wert fuer identifier[requestedProcedureId] in ImagingServiceRequestPraxisDe.
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Instance: dicom-requested-procedure-id
InstanceOf: NamingSystem
Usage: #definition
* name = "DicomRequestedProcedureId"
* status = #active
* kind = #identifier
* date = "2026-05-02"
* publisher = "cognovis GmbH"
* description = "DICOM RequestedProcedureID (0040,1001) — Identifier des geplanten Untersuchungsschritts fuer DICOM MWL-Scheduling (Modality Worklist). Wird vom Scheduling-System (RIS/PVS) vergeben und ermoeglicht das Routing von Bildgebungsauftraegen zu Modalitaeten."
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/dicom-requested-procedure-id"
* uniqueId[0].preferred = true
