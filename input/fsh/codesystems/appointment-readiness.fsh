// AppointmentReadinessCS — Pre-modality readiness states for imaging appointments
// Represents states between Appointment.checked-in and modality call.
// No international FHIR profile covers these workflow-specific pre-imaging states.
// Used as backing CS for AppointmentReadinessVS.

CodeSystem: AppointmentReadinessCS
Id: appointment-readiness
Title: "Appointment Readiness"
Description: "Pre-modality readiness states for imaging appointments in German radiology workflows. Covers states between Appointment.checked-in and the point where the patient is called to the modality."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/appointment-readiness"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #checked-in "Checked In" "Patient has arrived and checked in at reception; readiness assessment not yet started"
* #preparation-complete "Preparation Complete" "All pre-imaging preparation steps completed (e.g. contrast consent, patient history, IV access if needed); patient ready to be called to modality"
* #waiting-for-modality "Waiting for Modality" "Patient preparation complete; waiting for modality to become available for exam start"
