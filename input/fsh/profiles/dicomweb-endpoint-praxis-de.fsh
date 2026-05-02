// DicomwebEndpointPraxisDe — DICOMweb-Endpunkt fuer die deutsche ambulante Praxis
// Erbt von R4 Endpoint. Beschraenkt connectionType auf die drei DICOMweb-Protokolle
// (WADO-RS, QIDO-RS, STOW-RS). Erzwingt HTTPS-Adresse via Invariante.
// Enthaelt AE-Title Identifier-Slice fuer PACS-Routing.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Invariant: dicomweb-address-https
Description: "The DICOMweb endpoint address must use the HTTPS scheme."
Expression: "startsWith('https://')"
Severity: #error

Profile: DicomwebEndpointPraxisDe
Parent: Endpoint
Id: dicomweb-endpoint-praxis-de
Title: "DICOMweb Endpoint (Praxis DE)"
Description: "DICOMweb-Endpunkt-Profil fuer die deutsche ambulante Praxis. Erbt von R4 Endpoint. Beschraenkt connectionType auf WADO-RS, QIDO-RS und STOW-RS. Erzwingt HTTPS fuer die Endpunkt-Adresse (Invariante dicomweb-address-https). Enthaelt AE-Title Identifier-Slice fuer PACS-Routing."

// connectionType: Required binding zu den drei DICOMweb-Verbindungstypen
* connectionType MS
* connectionType from DicomwebConnectionTypeVS (required)
* connectionType ^short = "DICOMweb Verbindungstyp (WADO-RS, QIDO-RS oder STOW-RS)"
* connectionType ^definition = "Verbindungstyp des DICOMweb-Endpunkts. Required Binding auf DicomwebConnectionTypeVS: dicom-wado-rs (Abruf), dicom-qido-rs (Abfrage) oder dicom-stow-rs (Speicherung)."

// address: muss HTTPS-URL sein
* address MS
* address obeys dicomweb-address-https
* address ^short = "HTTPS-URL des DICOMweb-Endpunkts"
* address ^definition = "Vollstaendige HTTPS-URL des DICOMweb-Endpunkts (z.B. https://pacs.example.org/wado/rs). Muss mit 'https://' beginnen (Invariante dicomweb-address-https)."

// identifier: AE-Title Slice fuer PACS-Routing
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains aeTitle 0..1 MS
* identifier[aeTitle] ^short = "DICOM Application Entity Title (AE-Title) fuer PACS-Routing"
* identifier[aeTitle].system = "https://fhir.cognovis.de/praxis/NamingSystem/dicom-ae-title"
* identifier[aeTitle].system MS
* identifier[aeTitle].value 1..1 MS

// status: Betriebsstatus des Endpunkts
* status 1..1 MS

// payloadType: Pflichtfeld in R4 Endpoint
* payloadType MS
