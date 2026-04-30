// ReportDistributionChannelCS — DE-specific distribution channels for radiology reports
// Hybrid design: standard channels (email, fax, print) are covered by hl7.terminology.r4
// v3-ParticipationMode (EMAILWRIT, FAXWRIT, MAILWRIT). Only DE-specific channels without
// an international equivalent are defined here.
// See ReportDistributionChannelVS (input/fsh/valuesets/report-distribution-channel.fsh)
// for the combined hybrid ValueSet.

CodeSystem: ReportDistributionChannelCS
Id: report-distribution-channel
Title: "Report Distribution Channel (DE-specific)"
Description: "DE-specific distribution channels for radiology and diagnostic reports that have no equivalent in international standards. Standard channels (email, fax, print) are represented by HL7 v3-ParticipationMode codes in the ReportDistributionChannelVS hybrid ValueSet."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/report-distribution-channel"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

// DE-specific channels only — no international equivalent in v3-ParticipationMode
* #kim "KIM" "Report delivered via KIM (Kommunikation im Medizinwesen) — national DE secure medical messaging standard"
* #patientportal "Patient Portal" "Report delivered to patient via DE-specific secure healthcare portal (Patientenportal or ePA — Elektronische Patientenakte). Distinct from generic online written communication (v3:ONLINEWRIT) due to DE-specific authentication requirements (GesundheitsID / ELGA) and legal framework (§335 SGB V)."
