// AppointmentReadinessExt — Bereitschaftsstatus fuer Bildgebungstermine
// Simple Extension: Coding aus AppointmentReadinessVS (required binding).
// Repraesentiert den Post-Check-in-Bereitschaftsstatus des Patienten vor der Modalitaet.
// Context: Appointment
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: AppointmentReadinessExt
Id: appointment-readiness
Title: "Appointment Readiness"
Description: "Post-Check-in-Bereitschaftsstatus fuer Bildgebungstermine. Repraesentiert den Zustand des Patienten nach Appointment.status=checked-in und vor dem Modalitaets-Aufruf."
Context: Appointment
* value[x] only Coding
* value[x] from AppointmentReadinessVS (required)
