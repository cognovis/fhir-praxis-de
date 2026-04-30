// ReportSubstatusExt — Sub-Status-Extension fuer den Radiologiebefund-Workflow
// Binding auf ReportSubstatusVS fuer granulare Workflow-Nachverfolgung
// (Diktat, Lesung, Freigabe), die im FHIR DiagnosticReport.status nicht abgebildet werden.
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: ReportSubstatusExt
Id: report-substatus
Title: "Report Sub-Status"
Description: "Sub-Status fuer Radiologie- und Diagnostikbefund-Workflow. Ermoeglicht granulare Nachverfolgung (Diktat, Lese-Wartend, Freigegeben), die im FHIR DiagnosticReport.status nicht abgebildet werden kann."
Context: DiagnosticReport
* value[x] only Coding
* value[x] from ReportSubstatusVS (required)
