// AppointmentPreparationExt — Vorbereitungs- und Nachbereitungszeiten fuer Bildgebungstermine
// Komplexe Extension mit drei Sub-Extensions:
//   - prepDuration (0..1): Vorbereitungszeit (Duration)
//   - recoveryDuration (0..1): Nachbereitungszeit / Erholungszeit (Duration)
//   - patientInstruction (0..1): Hinweise an den Patienten (string)
// Context: Appointment
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: AppointmentPreparationExt
Id: appointment-preparation
Title: "Appointment Preparation"
Description: "Vorbereitungs- und Nachbereitungszeiten sowie Patientenhinweise fuer Bildgebungstermine. Enthaelt Vorbereitungszeit, Erholungszeit und freitextliche Patientenanweisungen."
Context: Appointment

* extension contains
    prepDuration 0..1 MS and
    recoveryDuration 0..1 MS and
    patientInstruction 0..1 MS

* extension[prepDuration] ^short = "Vorbereitungszeit vor dem Bildgebungstermin (z.B. Kontrastmittel-Vorbereitung)"
* extension[prepDuration].value[x] only Duration

* extension[recoveryDuration] ^short = "Erholungszeit nach dem Bildgebungstermin (z.B. nach Kontrastmittelgabe)"
* extension[recoveryDuration].value[x] only Duration

* extension[patientInstruction] ^short = "Freitextliche Hinweise an den Patienten (z.B. keine metallischen Gegenstaende)"
* extension[patientInstruction].value[x] only string
