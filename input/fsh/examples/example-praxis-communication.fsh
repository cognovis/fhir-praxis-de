// Beispiel: Notiz-Communication (Krankenblatt-Eintrag)
// Allgemeine Notiz im Krankenblatt von Thomas Weber

Instance: example-praxis-communication
InstanceOf: PraxisCommunication
Title: "Notiz — Rueckruf Patient Weber"
Description: "Notiz im Krankenblatt: Patient Weber hat wegen Laborbefund zurueckgerufen."
Usage: #example

* status = #completed
* category[praxis-kategorie].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-communication-category"
* category[praxis-kategorie].coding[0].code = #tp
* category[praxis-kategorie].coding[0].display = "Telefonat/Protokoll"
* subject = Reference(example-patient)
* sent = "2026-01-15T11:30:00+01:00"
* payload[0].contentString = "Patient Weber hat wegen HbA1c-Laborbefund angerufen. Ergebnis erklaert, keine Medikationsaenderung notwendig. Naechste Kontrolle in 6 Monaten."
