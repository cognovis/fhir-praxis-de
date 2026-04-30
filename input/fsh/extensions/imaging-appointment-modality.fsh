// AppointmentModalityExt — Modalitaet und Geraet fuer Bildgebungstermine
// Komplexe Extension mit zwei Sub-Extensions:
//   - modality (1..1): DICOM Modalitaet aus DicomModalityVS (required)
//   - device (0..1): Referenz auf ImagingDevicePraxisDe
// Context: Appointment
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: AppointmentModalityExt
Id: appointment-modality
Title: "Appointment Modality"
Description: "DICOM-Modalitaet und optionale Geraete-Referenz fuer einen Bildgebungstermin. Enthaelt den Modalitaetstyp (MR, CT, etc.) und eine optionale Referenz auf das konkrete Bildgebungsgeraet."
Context: Appointment

* extension contains
    modality 1..1 MS and
    device 0..1 MS

* extension[modality] ^short = "DICOM Modalitaet (MR, CT, US, DX, etc.)"
* extension[modality].value[x] only Coding
* extension[modality].value[x] from DicomModalityVS (required)

* extension[device] ^short = "Referenz auf das konkrete Bildgebungsgeraet (ImagingDevicePraxisDe)"
* extension[device].value[x] only Reference(ImagingDevicePraxisDe)
