Instance: example-account-schein-hzv
InstanceOf: AccountPraxisSchein
Title: "HZV Account Praxis Schein"
Description: "HZV billing case Account for Q2 2026."
Usage: #example
* status = #active
* type = https://fhir.cognovis.de/praxis/CodeSystem/scheinart#hzv "HZV"
* identifier[scheinNummer].system = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* identifier[scheinNummer].value = "HZV-2026-Q2-00042"
* servicePeriod.start = "2026-04-01"
* servicePeriod.end = "2026-06-30"
* coverage[0].coverage = Reference(example-coverage-hzv)
* subject = Reference(example-patient)
