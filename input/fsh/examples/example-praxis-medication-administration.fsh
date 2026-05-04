// Beispiel: Injektion in der Praxis
// Vitamin-B12-Injektion fuer Patient Weber

Instance: example-praxis-medication-administration
InstanceOf: PraxisMedicationAdministration
Title: "Vitamin-B12-Injektion — Weber"
Description: "Vitamin-B12-Injektion (1000 mcg i.m.) in der Praxis bei Thomas Weber."
Usage: #example

* status = #completed
* medicationCodeableConcept.coding[0].system = "http://fhir.de/CodeSystem/bfarm/atc"
* medicationCodeableConcept.coding[0].code = #B03BA01
* medicationCodeableConcept.coding[0].display = "Cyanocobalamin"
* medicationCodeableConcept.text = "Vitamin B12 1000 mcg — Injektion i.m."
* subject = Reference(example-patient)
* effectiveDateTime = "2026-01-15T09:30:00+01:00"
* dosage.route.coding[0].system = "http://snomed.info/sct"
* dosage.route.coding[0].code = #78421000
* dosage.route.coding[0].display = "Intramuscular route"
* dosage.dose.value = 1000
* dosage.dose.unit = "mcg"
* dosage.dose.system = "http://unitsofmeasure.org"
* dosage.dose.code = #ug
