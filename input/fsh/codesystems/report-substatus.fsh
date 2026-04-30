// ReportSubstatusCS — Sub-states for radiology report workflow
// FHIR R4 DiagnosticReport.status has no sub-states for the dictation/reading
// workflow common in German radiology practices.
// Used as extension on DiagnosticReport to track granular workflow state.
// Note: #signed is a sub-state of DiagnosticReport.status=final (signed implies status=final).

CodeSystem: ReportSubstatusCS
Id: report-substatus
Title: "Report Substatus"
Description: "Sub-states for radiology and diagnostic report workflow in German practices. Fills the gap in FHIR R4 DiagnosticReport.status for dictation, reading, and sign-off workflow tracking. Note: #signed is only valid when DiagnosticReport.status=final — it represents the sub-state at which the report has been signed but is not a replacement for status=final."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/report-substatus"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

// Ordered workflow progression: dictation-pending -> dictated -> read-pending -> signed
* #dictation-pending "Dictation Pending" "Images acquired; report not yet dictated (radiologist has not yet started dictation)"
* #dictated "Dictated" "Report dictated (voice or typed); awaiting final read-through and approval"
* #read-pending "Read Pending" "Dictation transcribed or reviewed; awaiting final radiologist sign-off"
* #signed "Signed" "Report finalized and signed by responsible radiologist; only valid as sub-state when DiagnosticReport.status=final. Signals the report is ready for distribution."
