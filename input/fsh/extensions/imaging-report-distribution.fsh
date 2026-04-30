// ReportDistributionExt — Komplexe Extension fuer Befund-Verteilung
// Tracking von Distribution-Events (Kanal, Empfaenger, Zeitstempel).
// Binding auf ReportDistributionChannelVS (hybrides VS: HL7 v3 + KIM/Patientenportal).
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: ReportDistributionExt
Id: report-distribution
Title: "Report Distribution Event"
Description: "Tracking eines Befund-Verteilungs-Events. Enthaelt Kanal (KIM, E-Mail, Fax, etc.), Empfaenger-Referenz und Zeitstempel der Uebermittlung. Wird als Array 0..* verwendet, um mehrere Verteilungen nachzuverfolgen."
Context: DiagnosticReport

* extension contains
    channel 1..1 MS and
    recipient 0..1 MS and
    timestamp 1..1 MS

* extension[channel] ^short = "Verteilungskanal (KIM, E-Mail, Fax, Patientenportal)"
* extension[channel].value[x] only Coding
* extension[channel].value[x] from ReportDistributionChannelVS (required)

* extension[recipient] ^short = "Empfaenger des Befunds (Arzt, Organisation, Patient)"
* extension[recipient].value[x] only Reference(Practitioner or PractitionerRole or Organization or Patient)

* extension[timestamp] ^short = "Zeitstempel der Uebermittlung"
* extension[timestamp].value[x] only dateTime
