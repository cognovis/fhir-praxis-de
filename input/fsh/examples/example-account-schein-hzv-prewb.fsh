Instance: example-account-schein-hzv-prewb
InstanceOf: AccountPraxisSchein
Title: "HZV Account Praxis Schein (Pre-Writeback)"
Description: "Pre-writeback HZV billing case Account. No scheinNummer yet -- assigned by PVS after Schein creation. Used for polaris Schein-as-Account writeback architecture (ADR-039)."
Usage: #example
* meta.profile = "https://fhir.cognovis.de/praxis/StructureDefinition/account-praxis-schein"
* status = #active
* type = https://fhir.cognovis.de/praxis/CodeSystem/scheinart#hzv "HZV"
* identifier[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/abrechnungsquartal"
* identifier[0].value = "2026-Q2"
* servicePeriod.start = "2026-04-01"
* subject = Reference(example-patient)
