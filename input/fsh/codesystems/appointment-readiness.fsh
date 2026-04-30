// AppointmentReadinessCS — Post-check-in readiness states for imaging appointments
// Represents states AFTER Appointment.status=checked-in and before modality call.
// #checked-in is intentionally omitted — it duplicates Appointment.status=checked-in.
// No international FHIR profile covers these workflow-specific pre-imaging states.
// Used as backing CS for AppointmentReadinessVS.

CodeSystem: AppointmentReadinessCS
Id: appointment-readiness
Title: "Appointment Readiness"
Description: "Post-check-in readiness states for imaging appointments in German radiology workflows. Covers states AFTER Appointment.status=checked-in and before the patient is called to the modality. Does not duplicate Appointment.status — checked-in state is tracked natively on Appointment."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/appointment-readiness"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #preparation-complete "Preparation Complete" "All pre-imaging preparation steps completed (e.g. contrast consent, patient history, IV access if needed); patient ready to be called to modality"
* #waiting-for-modality "Waiting for Modality" "Patient preparation complete; waiting for modality to become available for exam start"
