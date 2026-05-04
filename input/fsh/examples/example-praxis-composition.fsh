// Beispiel: Befund-Composition fuer Patient Weber
// Bildet einen strukturierten Befundbericht als Composition ab

Instance: example-praxis-composition
InstanceOf: PraxisComposition
Title: "Befund-Composition Weber — Diabetes-Kontrolle"
Description: "Befundbericht zur Diabetes-Jahreskontrolle von Thomas Weber (Q1 2026)."
Usage: #example

* status = #final
* type.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/dokument-kategorie"
* type.coding[0].code = #befund
* type.coding[0].display = "Befund"
* title = "Diabetes-Jahreskontrolle 2026 — Thomas Weber"
* date = "2026-01-15T10:00:00+01:00"
* author[0] = Reference(example-practitioner)
* subject = Reference(example-patient)

* section[0].title = "Befundzusammenfassung"
* section[0].text.status = #generated
* section[0].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">HbA1c 7,2 % — gut eingestellt. Medikation unveraendert.</div>"
