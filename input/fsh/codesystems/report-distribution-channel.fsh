// ReportDistributionChannelCS — DE distribution channels for radiology reports
// Covers all relevant German healthcare report delivery channels including
// the national KIM (Kommunikation im Medizinwesen) secure messaging standard.

CodeSystem: ReportDistributionChannelCS
Id: report-distribution-channel
Title: "Report Distribution Channel"
Description: "Distribution channels for radiology and diagnostic reports in the German healthcare system. Includes the national KIM (Kommunikation im Medizinwesen) secure messaging standard."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/report-distribution-channel"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #email "Email" "Report delivered via standard email"
* #fax "Fax" "Report delivered via fax (still widely used in German ambulatory care)"
* #kim "KIM" "Report delivered via KIM (Kommunikation im Medizinwesen) — national DE secure medical messaging"
* #patientportal "Patient Portal" "Report delivered to patient via secure online portal (e.g. Patientenportal / ePA)"
* #print "Print" "Report printed and handed over or mailed as paper document"
