// ReportDistributionChannelVS — Hybrid ValueSet combining standard HL7 channels + DE-specific
// Standard channels: v3-ParticipationMode (email, fax, postal mail, hand-over print)
// DE-specific: ReportDistributionChannelCS (kim, patientportal)
// See docs/research/imaging-fhir-reuse-decisions.md for the reuse rationale.

ValueSet: ReportDistributionChannelVS
Id: report-distribution-channel
Title: "Report Distribution Channel"
Description: "ValueSet for report distribution channels. Standard channels from HL7 v3-ParticipationMode; DE-specific channels (KIM, patient portal) from local CodeSystem."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/report-distribution-channel"
* ^status = #draft
* ^experimental = false

// Standard HL7 v3 channels
* http://terminology.hl7.org/CodeSystem/v3-ParticipationMode#EMAILWRIT "Email"
* http://terminology.hl7.org/CodeSystem/v3-ParticipationMode#FAXWRIT "Telefax"
* http://terminology.hl7.org/CodeSystem/v3-ParticipationMode#MAILWRIT "Mail / Post"
* http://terminology.hl7.org/CodeSystem/v3-ParticipationMode#TYPEWRIT "Print / Hand-over"

// DE-specific channels (not covered by international standards)
* include codes from system ReportDistributionChannelCS
