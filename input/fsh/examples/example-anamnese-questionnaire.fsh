Instance: example-anamnese-erstanamnese
InstanceOf: AnamneseQuestionnaire
Title: "Beispiel Erstanamnese-Questionnaire"
Description: "Beispiel-Template fuer eine allgemeinmedizinische Erstanamnese mit drei Gruppen: Vorerkrankungen, Medikation, Sozialanamnese."
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

// Gruppe 1: Vorerkrankungen
* item[0].linkId = "1"
* item[0].text = "Vorerkrankungen"
* item[0].type = #group
* item[0].required = false
* item[0].item[0].linkId = "1.1"
* item[0].item[0].text = "Bekannte Vorerkrankungen"
* item[0].item[0].type = #text
* item[0].item[0].required = false
* item[0].item[1].linkId = "1.2"
* item[0].item[1].text = "Frueherer Krankenhausaufenthalt?"
* item[0].item[1].type = #boolean
* item[0].item[1].required = false
* item[0].item[2].linkId = "1.3"
* item[0].item[2].text = "Bekannte Allergien"
* item[0].item[2].type = #text
* item[0].item[2].required = false

// Gruppe 2: Medikation
* item[1].linkId = "2"
* item[1].text = "Medikation"
* item[1].type = #group
* item[1].required = false
* item[1].item[0].linkId = "2.1"
* item[1].item[0].text = "Aktuelle Dauermedikation"
* item[1].item[0].type = #text
* item[1].item[0].required = false
* item[1].item[1].linkId = "2.2"
* item[1].item[1].text = "Unvertraeglichkeiten bekannt?"
* item[1].item[1].type = #boolean
* item[1].item[1].required = false

// Gruppe 3: Sozialanamnese
* item[2].linkId = "3"
* item[2].text = "Sozialanamnese"
* item[2].type = #group
* item[2].required = false
* item[2].item[0].linkId = "3.1"
* item[2].item[0].text = "Beruf"
* item[2].item[0].type = #string
* item[2].item[0].required = false
* item[2].item[1].linkId = "3.2"
* item[2].item[1].text = "Raucherstatus"
* item[2].item[1].type = #string
* item[2].item[1].required = false
