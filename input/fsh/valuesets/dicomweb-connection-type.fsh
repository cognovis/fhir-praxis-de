// DicomwebConnectionTypeVS — ValueSet fuer DICOMweb-Endpunkt-Verbindungstypen
// Enthaelt die drei DICOMweb-Verbindungstypen aus dem FHIR endpoint-connection-type CodeSystem:
//   - dicom-wado-rs: WADO-RS Abruf (DICOMweb Retrieve)
//   - dicom-qido-rs: QIDO-RS Abfrage (DICOMweb Query)
//   - dicom-stow-rs: STOW-RS Speicherung (DICOMweb Store)
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

ValueSet: DicomwebConnectionTypeVS
Id: dicomweb-connection-type
Title: "DICOMweb Connection Type"
Description: "Verbindungstypen fuer DICOMweb-Endpunkte. Subset des FHIR endpoint-connection-type CodeSystems mit den drei DICOMweb-Protokollen: WADO-RS (Abruf), QIDO-RS (Abfrage) und STOW-RS (Speicherung)."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/dicomweb-connection-type"
* ^status = #active
* ^experimental = false

* http://terminology.hl7.org/CodeSystem/endpoint-connection-type#dicom-wado-rs "DICOM WADO-RS"
* http://terminology.hl7.org/CodeSystem/endpoint-connection-type#dicom-qido-rs "DICOM QIDO-RS"
* http://terminology.hl7.org/CodeSystem/endpoint-connection-type#dicom-stow-rs "DICOM STOW-RS"
