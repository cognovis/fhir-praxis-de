// Beispiel: CAVE-Flag fuer Patient Weber
// Arzneimittelallergie (Penicillin) als CAVE-Flag

Instance: example-praxis-flag
InstanceOf: PraxisFlag
Title: "CAVE-Flag — Penicillin-Allergie Weber"
Description: "CAVE-Flag: Penicillin-Allergie bei Patient Thomas Weber."
Usage: #example

* status = #active
* category[0].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/flag-kategorie"
* category[0].coding[0].code = #cave
* category[0].coding[0].display = "CAVE"
* code.coding[0].system = "http://snomed.info/sct"
* code.coding[0].code = #419511003
* code.coding[0].display = "Propensity to adverse reactions to drug"
* code.text = "Penicillin-Allergie: Anaphylaktische Reaktion bekannt. Keine Beta-Laktam-Antibiotika!"
* subject = Reference(example-patient)
