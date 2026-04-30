// AppointmentReadinessVS — Pre-modality readiness states for imaging appointments
// Backed by local AppointmentReadinessCS (defined in codesystems/appointment-readiness.fsh)
// since no external CS covers these DE radiology workflow states.

ValueSet: AppointmentReadinessVS
Id: appointment-readiness
Title: "Appointment Readiness"
Description: "ValueSet of pre-modality readiness states for imaging appointments. Represents patient states between Appointment.checked-in and the modality call in German radiology workflow."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/appointment-readiness"
* ^status = #draft
* ^experimental = false

// All codes from the local AppointmentReadinessCS
* include codes from system AppointmentReadinessCS
