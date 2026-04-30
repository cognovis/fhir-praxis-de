// anwender-fachkunde Extension — Fachkunde Strahlenschutz des Anwenders
// Erweiterung auf Procedure.performer fuer den Nachweis der Fachkunde gemaess SS14 StrlSchV.
// Gebunden an FachkundeStrahlenschutzVS aus dem Terminology-Paket.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: AnwenderFachkundeExt
Id: anwender-fachkunde
Title: "Anwender Fachkunde Strahlenschutz"
Description: "Fachkunde Strahlenschutz des Anwenders gemaess SS14 StrlSchV. Required Binding an FachkundeStrahlenschutzVS (https://fhir.cognovis.de/imaging/ValueSet/fachkunde-strahlenschutz) aus dem Terminology-Paket de.cognovis.terminology.imaging."
* ^url = "https://fhir.cognovis.de/praxis/StructureDefinition/anwender-fachkunde"
* ^status = #active
* ^experimental = false
* ^context[+].type = #element
* ^context[=].expression = "Procedure.performer"

// value[x]: Coding aus FachkundeStrahlenschutzVS (required)
* value[x] only Coding
* valueCoding from https://fhir.cognovis.de/imaging/ValueSet/fachkunde-strahlenschutz (required)
* value[x] ^short = "Fachkunde Strahlenschutz des Anwenders"
* value[x] ^definition = "Kategorie der Fachkunde Strahlenschutz des durchfuehrenden Anwenders gemaess SS14 StrlSchV. Gebunden an FachkundeStrahlenschutzVS aus de.cognovis.terminology.imaging."
