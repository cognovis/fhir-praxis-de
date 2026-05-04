// Beispiel: Ausgefuellter Anamnesebogen
// Erstanamnese von Thomas Weber (vereinfacht)

Instance: example-praxis-anamnese-questionnaire-response
InstanceOf: PraxisAnamneseQuestionnaireResponse
Title: "Erstanamnese Weber — Ausgefuellt"
Description: "Ausgefuellter Erstanamnese-Bogen von Patient Thomas Weber (2026-01-15)."
Usage: #example

* questionnaire = "https://fhir.cognovis.de/praxis/Questionnaire/erstanamnese-standard"
* status = #completed
* subject = Reference(example-patient)
* authored = "2026-01-15T09:00:00+01:00"

// Frage 1: Hauptbeschwerden
* item[0].linkId = "beschwerden"
* item[0].text = "Schildern Sie bitte Ihre aktuellen Beschwerden."
* item[0].answer[0].valueString = "Gelegentliche Muedigkeit, keine akuten Beschwerden."

// Frage 2: Vorerkrankungen
* item[1].linkId = "vorerkrankungen"
* item[1].text = "Haben Sie bekannte Vorerkrankungen?"
* item[1].answer[0].valueString = "Diabetes mellitus Typ 2, Hypertonie"
