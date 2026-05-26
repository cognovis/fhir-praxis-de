Instance: example-coverage
InstanceOf: FPDECoverageGKV
Title: "GKV Coverage Example"
Description: "GKV coverage used by the AccountPraxisSchein GKV example."
Usage: #example
* status = #active
* identifier[KrankenversichertenID].system = "http://fhir.de/sid/gkv/kvid-10"
* identifier[KrankenversichertenID].value = "A123456789"
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #GKV
* type.coding[VersicherungsArtDeBasis].display = "gesetzliche Krankenversicherung"
* beneficiary = Reference(example-patient)
* payor[0].display = "AOK Bayern"

Instance: example-account-schein-gkv
InstanceOf: AccountPraxisSchein
Title: "GKV Account Praxis Schein"
Description: "GKV billing case Account for Q2 2026."
Usage: #example
* status = #active
* type = https://fhir.cognovis.de/praxis/CodeSystem/scheinart#gkv "GKV"
* identifier[scheinNummer].system = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* identifier[scheinNummer].value = "GKV-2026-Q2-00042"
* servicePeriod.start = "2026-04-01"
* servicePeriod.end = "2026-06-30"
* coverage[0].coverage = Reference(example-coverage)
* subject = Reference(example-patient)
