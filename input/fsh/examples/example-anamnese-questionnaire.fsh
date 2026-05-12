Instance: example-anamnese-erstanamnese
InstanceOf: AnamneseQuestionnaire
Title: "Beispiel Erstanamnese-Questionnaire"
Description: "Beispiel-Template fuer eine allgemeinmedizinische Erstanamnese mit Hauptbeschwerden und drei Gruppen: Vorerkrankungen, Medikation, Sozialanamnese."
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

// Frage 0: Hauptbeschwerden (Freitext, kein Gruppen-Wrapper)
* item[0].linkId = "beschwerden"
* item[0].text = "Schildern Sie bitte Ihre aktuellen Beschwerden."
* item[0].type = #text
* item[0].required = false

// Gruppe 1: Vorerkrankungen
* item[1].linkId = "1"
* item[1].text = "Vorerkrankungen"
* item[1].type = #group
* item[1].required = false
* item[1].item[0].linkId = "vorerkrankungen"
* item[1].item[0].text = "Bekannte Vorerkrankungen"
* item[1].item[0].type = #text
* item[1].item[0].required = false
* item[1].item[1].linkId = "1.2"
* item[1].item[1].text = "Frueherer Krankenhausaufenthalt?"
* item[1].item[1].type = #boolean
* item[1].item[1].required = false
* item[1].item[2].linkId = "1.3"
* item[1].item[2].text = "Bekannte Allergien"
* item[1].item[2].type = #text
* item[1].item[2].required = false
* item[1].item[2].extension[https://fhir.cognovis.de/praxis/StructureDefinition/questionnaire-item-clinical-alert].valueBoolean = true

// Gruppe 2: Medikation
* item[2].linkId = "2"
* item[2].text = "Medikation"
* item[2].type = #group
* item[2].required = false
* item[2].item[0].linkId = "2.1"
* item[2].item[0].text = "Aktuelle Dauermedikation"
* item[2].item[0].type = #text
* item[2].item[0].required = false
* item[2].item[1].linkId = "2.2"
* item[2].item[1].text = "Unvertraeglichkeiten bekannt?"
* item[2].item[1].type = #boolean
* item[2].item[1].required = false

// Gruppe 3: Sozialanamnese
* item[3].linkId = "3"
* item[3].text = "Sozialanamnese"
* item[3].type = #group
* item[3].required = false
* item[3].item[0].linkId = "3.1"
* item[3].item[0].text = "Beruf"
* item[3].item[0].type = #string
* item[3].item[0].required = false
* item[3].item[1].linkId = "3.2"
* item[3].item[1].text = "Raucherstatus"
* item[3].item[1].type = #string
* item[3].item[1].required = false
