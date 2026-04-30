// AppointmentReadinessVS — Post-check-in readiness states for imaging appointments
// Backed by local AppointmentReadinessCS (defined in codesystems/appointment-readiness.fsh)
// since no external CS covers these DE radiology workflow states.
// checked-in is not included — that state is tracked natively via Appointment.status.

ValueSet: AppointmentReadinessVS
Id: appointment-readiness
Title: "Appointment Readiness"
Description: "ValueSet of post-check-in readiness states for imaging appointments. Represents patient states AFTER Appointment.status=checked-in and before the modality call in German radiology workflow. The checked-in state itself is not included as it is covered by Appointment.status."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/appointment-readiness"
* ^status = #draft
* ^experimental = false

// All codes from the local AppointmentReadinessCS
* include codes from system AppointmentReadinessCS
