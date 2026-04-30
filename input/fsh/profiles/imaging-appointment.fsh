// ImagingAppointmentPraxisDe — Bildgebungstermin fuer die deutsche ambulante Praxis
// Erbt von R4 Appointment (nicht ISiK — ambulante Praxis, nicht Krankenhaus).
// Erweitert um:
//   - AppointmentModalityExt: DICOM-Modalitaet + optionale Geraete-Referenz
//   - AppointmentPreparationExt: Vorbereitungszeit, Erholungszeit, Patientenhinweis
//   - AppointmentReadinessExt: Post-Check-in Bereitschaftsstatus
// Participant-Slicing:
//   - modalityDevice: Bildgebungsgeraet (ImagingDevicePraxisDe)
//   - mtrPractitioner: MTR (Medizinisch-Technische-Radiologieassistent)
//
// HINWEIS: AppointmentModeExt existiert bereits in extensions/appointment.fsh — nicht neu definieren.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Profile: ImagingAppointmentPraxisDe
Parent: Appointment
Id: imaging-appointment-praxis-de
Title: "Imaging Appointment (Praxis DE)"
Description: "Bildgebungstermin-Profil fuer die deutsche ambulante Praxis. Erbt von R4 Appointment. Erweitert um DICOM-Modalitaet (AppointmentModalityExt), Vorbereitungszeiten (AppointmentPreparationExt), Bereitschaftsstatus (AppointmentReadinessExt) und Participant-Slicing fuer Geraet und MTR."

// Extensions
* extension contains
    AppointmentModalityExt named appointmentModality 0..1 MS and
    AppointmentPreparationExt named appointmentPreparation 0..1 MS and
    AppointmentReadinessExt named appointmentReadiness 0..1 MS

// Status: FHIR-native Appointment-Status
* status MS

// ServiceType: Typ der Bildgebung (z.B. LOINC)
* serviceType MS
* serviceType ^short = "Typ des Bildgebungstermins (z.B. LOINC 36803-5 MRI of knee)"

// Zeitraum
* start MS
* end MS

// Verweis auf den Bildgebungsauftrag (ImagingServiceRequestPraxisDe)
* basedOn MS
* basedOn ^short = "Verweis auf den ImagingServiceRequest"
* basedOn only Reference(ImagingServiceRequestPraxisDe)

// Participant-Slicing: modalityDevice + mtrPractitioner
* participant ^slicing.discriminator.type = #type
* participant ^slicing.discriminator.path = "actor.resolve()"
* participant ^slicing.rules = #open

* participant contains
    modalityDevice 0..1 MS and
    mtrPractitioner 0..* MS

* participant[modalityDevice] ^short = "Bildgebungsgeraet (ImagingDevicePraxisDe)"
* participant[modalityDevice].actor only Reference(ImagingDevicePraxisDe)
* participant[modalityDevice].actor MS
* participant[modalityDevice].status MS

* participant[mtrPractitioner] ^short = "MTR (Medizinisch-Technische-Radiologieassistent)"
* participant[mtrPractitioner].actor only Reference(Practitioner)
* participant[mtrPractitioner].actor MS
* participant[mtrPractitioner].status MS
