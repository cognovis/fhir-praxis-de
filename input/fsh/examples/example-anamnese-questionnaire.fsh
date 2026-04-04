Instance: example-anamnese-erstanamnese
InstanceOf: AnamneseQuestionnaire
Title: "Beispiel Erstanamnese-Questionnaire"
Description: "Beispiel-Template fuer eine allgemeinmedizinische Erstanamnese mit drei Gruppen: Persoenliche Angaben, Aktuelle Beschwerden, Vorerkrankungen und Medikamente."
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

// Gruppe 1: Persoenliche Angaben
* item[0].linkId = "1"
* item[0].text = "Persoenliche Angaben"
* item[0].type = #group
* item[0].required = false
* item[0].item[0].linkId = "1.1"
* item[0].item[0].text = "Geburtsdatum"
* item[0].item[0].type = #date
* item[0].item[0].required = true
* item[0].item[1].linkId = "1.2"
* item[0].item[1].text = "Geburtsort"
* item[0].item[1].type = #string
* item[0].item[1].required = false
* item[0].item[2].linkId = "1.3"
* item[0].item[2].text = "Staatsangehoerigkeit"
* item[0].item[2].type = #string
* item[0].item[2].required = false

// Gruppe 2: Aktuelle Beschwerden
* item[1].linkId = "2"
* item[1].text = "Aktuelle Beschwerden"
* item[1].type = #group
* item[1].required = false
* item[1].item[0].linkId = "2.1"
* item[1].item[0].text = "Hauptbeschwerde"
* item[1].item[0].type = #text
* item[1].item[0].required = true
* item[1].item[1].linkId = "2.2"
* item[1].item[1].text = "Beschwerdedauer in Tagen"
* item[1].item[1].type = #integer
* item[1].item[1].required = false
* item[1].item[2].linkId = "2.3"
* item[1].item[2].text = "Schmerzen vorhanden?"
* item[1].item[2].type = #boolean
* item[1].item[2].required = false

// Gruppe 3: Vorerkrankungen und Medikamente
* item[2].linkId = "3"
* item[2].text = "Vorerkrankungen und Medikamente"
* item[2].type = #group
* item[2].required = false
* item[2].item[0].linkId = "3.1"
* item[2].item[0].text = "Bekannte Vorerkrankungen"
* item[2].item[0].type = #text
* item[2].item[0].required = false
* item[2].item[1].linkId = "3.2"
* item[2].item[1].text = "Aktuelle Dauermedikation"
* item[2].item[1].type = #text
* item[2].item[1].required = false
* item[2].item[2].linkId = "3.3"
* item[2].item[2].text = "Bekannte Allergien"
* item[2].item[2].type = #text
* item[2].item[2].required = false
