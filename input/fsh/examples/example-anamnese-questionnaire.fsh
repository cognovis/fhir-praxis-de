Instance: example-anamnese-erstanamnese
InstanceOf: AnamneseQuestionnaire
Title: "Beispiel Erstanamnese-Questionnaire"
Description: "Beispiel-Template fuer eine allgemeinmedizinische Erstanamnese mit Hauptbeschwerden + Vorerkrankungen-Freitext und drei strukturierten Gruppen: Vorerkrankungen-Detail, Medikation, Sozialanamnese."
Usage: #example

* extension[kategorie].valueString = "Allgemeinmedizin"
* url = "https://fhir.cognovis.de/praxis/Questionnaire/example-anamnese-erstanamnese"
* version = "1.0.0"
* title = "Erstanamnese — Allgemeinmedizin"
* status = #active
* date = "2026-01-01"
* publisher = "cognovis GmbH"
* description = "Standardisierter Anamnesebogen fuer die allgemeinmedizinische Erstuntersuchung."
* subjectType = #Patient
* useContext[bogentyp].code = http://terminology.hl7.org/CodeSystem/usage-context-type#workflow
* useContext[bogentyp].valueCodeableConcept = AnamneseBogentypCS#erstanamnese "Erstanamnese"

// Frage 0: Hauptbeschwerden (Freitext, Top-Level)
* item[0].linkId = "beschwerden"
* item[0].text = "Schildern Sie bitte Ihre aktuellen Beschwerden."
* item[0].type = #text
* item[0].required = false

// Frage 1: Vorerkrankungen (Freitext, Top-Level)
* item[1].linkId = "vorerkrankungen"
* item[1].text = "Haben Sie bekannte Vorerkrankungen?"
* item[1].type = #text
* item[1].required = false

// Gruppe 2: Vorerkrankungen-Detail
* item[2].linkId = "1"
* item[2].text = "Vorerkrankungen-Detail"
* item[2].type = #group
* item[2].required = false
* item[2].item[0].linkId = "1.2"
* item[2].item[0].text = "Frueherer Krankenhausaufenthalt?"
* item[2].item[0].type = #boolean
* item[2].item[0].required = false
* item[2].item[1].linkId = "1.3"
* item[2].item[1].text = "Bekannte Allergien"
* item[2].item[1].type = #text
* item[2].item[1].required = false
* item[2].item[1].extension[https://fhir.cognovis.de/praxis/StructureDefinition/questionnaire-item-clinical-alert].valueBoolean = true

// Gruppe 3: Medikation
* item[3].linkId = "2"
* item[3].text = "Medikation"
* item[3].type = #group
* item[3].required = false
* item[3].item[0].linkId = "2.1"
* item[3].item[0].text = "Aktuelle Dauermedikation"
* item[3].item[0].type = #text
* item[3].item[0].required = false
* item[3].item[1].linkId = "2.2"
* item[3].item[1].text = "Unvertraeglichkeiten bekannt?"
* item[3].item[1].type = #boolean
* item[3].item[1].required = false

// Gruppe 4: Sozialanamnese
* item[4].linkId = "3"
* item[4].text = "Sozialanamnese"
* item[4].type = #group
* item[4].required = false
* item[4].item[0].linkId = "3.1"
* item[4].item[0].text = "Beruf"
* item[4].item[0].type = #string
* item[4].item[0].required = false
* item[4].item[1].linkId = "3.2"
* item[4].item[1].text = "Raucherstatus"
* item[4].item[1].type = #string
* item[4].item[1].required = false
