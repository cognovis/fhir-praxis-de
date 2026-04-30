// technique-parameter Extension — Aufnahmetechnik-Parameter fuer ImagingStudy.series
// Workflow-relevante Technikparameter (KEINE DICOM-Header-Duplikate).
// Felder: kV, mAs (Roentgen/CT), TR/TE (MRT), Schichtdicke, Freitext-Notizen.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: TechniqueParameterExt
Id: technique-parameter
Title: "Technique Parameter"
Description: "Workflow-relevante Aufnahmetechnik-Parameter einer Bildserie. Erfasst kV und mAs fuer Roentgen/CT, TR und TE fuer MRT, Schichtdicke und optionale Freitext-Notizen. Keine Duplikation von DICOM-Header-Daten — nur workflow-relevante Felder."
* ^url = "https://fhir.cognovis.de/praxis/StructureDefinition/technique-parameter"
* ^status = #active
* ^experimental = false
* ^context[+].type = #element
* ^context[=].expression = "ImagingStudy.series"

* extension contains
    kv 0..1 and
    mas 0..1 and
    tr-ms 0..1 and
    te-ms 0..1 and
    slice-thickness-mm 0..1 and
    modality-specific-notes 0..1

// kv: Spitzenspannung in kV (Roentgen/CT)
* extension[kv].value[x] only decimal
* extension[kv] ^short = "Spitzenspannung (kV)"
* extension[kv] ^definition = "Spitzenspannung der Roentgenroehre in Kilovolt (kV). Relevant fuer Roentgen- und CT-Aufnahmen."

// mas: Milliamperesekunden (Roentgen/CT)
* extension[mas].value[x] only decimal
* extension[mas] ^short = "Milliamperesekunden (mAs)"
* extension[mas] ^definition = "Roehrenladung in Milliamperesekunden (mAs). Relevant fuer Roentgen- und CT-Aufnahmen."

// tr-ms: Repetitionszeit in ms (MRT)
* extension[tr-ms].value[x] only decimal
* extension[tr-ms] ^short = "Repetitionszeit TR (ms)"
* extension[tr-ms] ^definition = "Repetitionszeit (Repetition Time, TR) in Millisekunden fuer MRT-Sequenzen."

// te-ms: Echozeit in ms (MRT)
* extension[te-ms].value[x] only decimal
* extension[te-ms] ^short = "Echozeit TE (ms)"
* extension[te-ms] ^definition = "Echozeit (Echo Time, TE) in Millisekunden fuer MRT-Sequenzen."

// slice-thickness-mm: Schichtdicke in mm
* extension[slice-thickness-mm].value[x] only decimal
* extension[slice-thickness-mm] ^short = "Schichtdicke (mm)"
* extension[slice-thickness-mm] ^definition = "Schichtdicke der Bildserie in Millimeter. Relevant fuer Schichtaufnahmen (CT, MRT)."

// modality-specific-notes: Freitext-Techniknotizen
* extension[modality-specific-notes].value[x] only string
* extension[modality-specific-notes] ^short = "Modalitaets-spezifische Techniknotizen"
* extension[modality-specific-notes] ^definition = "Optionale Freitext-Notizen zu modalitaets-spezifischen Technikparametern, die durch die strukturierten Felder nicht abgedeckt werden."
