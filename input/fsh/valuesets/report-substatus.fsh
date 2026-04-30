// ReportSubstatusVS — ValueSet fuer den Sub-Status des Radiologiebefunds
// Enthaelt alle Codes aus ReportSubstatusCS.
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

ValueSet: ReportSubstatusVS
Id: report-substatus
Title: "Report Substatus"
Description: "ValueSet fuer den Sub-Status des Radiologiebefunds (Diktat, Lesung, Freigabe). Enthaelt alle Codes aus ReportSubstatusCS."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/report-substatus"
* ^status = #active
* ^experimental = false

* include codes from system ReportSubstatusCS
