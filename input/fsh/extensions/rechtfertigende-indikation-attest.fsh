// rechtfertigende-indikation-attest Extension — Attestierungsmetadaten fuer rechtfertigende Indikation
// Erweiterung auf Procedure.reasonCode fuer den Attestierungsnachweis gemaess SS83 StrlSchG.
// Erfasst: beurteilende Person, Datum der Beurteilung, Freitext-Begruendung.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: RechtfertigendeIndikationAttestExt
Id: rechtfertigende-indikation-attest
Title: "Rechtfertigende Indikation Attest"
Description: "Attestierungsmetadaten fuer die rechtfertigende Indikation gemaess SS83 StrlSchG / SS119 StrlSchV. Dokumentiert wer die Indikation gestellt hat (assessor), wann (assessmentDate) und eine Freitext-Begruendung (narrative)."
* ^url = "https://fhir.cognovis.de/praxis/StructureDefinition/rechtfertigende-indikation-attest"
* ^status = #active
* ^experimental = false
* ^context[+].type = #element
* ^context[=].expression = "Procedure.reasonCode"

* extension contains
    assessor 0..1 MS and
    assessmentDate 0..1 MS and
    narrative 0..1 MS

// assessor: Wer hat die Indikation gestellt?
* extension[assessor].value[x] only Reference(Practitioner)
* extension[assessor] ^short = "Beurteilende Person (rechtfertigende Indikation)"
* extension[assessor] ^definition = "Referenz auf den Arzt oder die Aerztin, die die rechtfertigende Indikation gestellt hat (SS119 Abs. 1 StrlSchV)."

// assessmentDate: Wann wurde die Indikation gestellt?
* extension[assessmentDate].value[x] only dateTime
* extension[assessmentDate] ^short = "Datum der Indikationsstellung"
* extension[assessmentDate] ^definition = "Zeitpunkt der Indikationsstellung fuer die Strahlenanwendung (Aufzeichnungspflicht SS85 StrlSchV)."

// narrative: Freitext-Begruendung
* extension[narrative].value[x] only string
* extension[narrative] ^short = "Freitext-Begruendung der rechtfertigenden Indikation"
* extension[narrative] ^definition = "Klinische Freitext-Begruendung der rechtfertigenden Indikation. Ergaenzt die Kodierung in Procedure.reasonCode."
