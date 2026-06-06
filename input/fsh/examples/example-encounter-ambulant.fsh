Instance: example-encounter-ambulant
InstanceOf: EncounterPraxis
Title: "Ambulatory Clinical Contact"
Description: "Ambulatory clinical contact linked to a GKV billing case Account."
Usage: #example
* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"
* subject = Reference(example-patient)
* serviceProvider = Reference(example-praxis)
* period.start = "2026-04-10"
* period.end = "2026-04-10"
* participant[0].individual = Reference(example-practitioner)
* account[0] = Reference(example-account-schein-gkv)

Instance: example-encounter-hausbesuch
InstanceOf: EncounterPraxis
Title: "Home Visit Clinical Contact"
Description: "Home visit to a nursing-home resident at the patient's ISiK room Location, linked to a GKV billing case Account."
Usage: #example
* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#HH "home health"
* subject = Reference(example-patient)
* serviceProvider = Reference(example-praxis)
* partOf = Reference(example-encounter-ambulant)
* period.start = "2026-04-12"
* period.end = "2026-04-12"
* participant[0].individual = Reference(example-practitioner)
* account[0] = Reference(example-account-schein-gkv)
* location[0].location = Reference(ExampleNursingHomeRoom)
* location[0].physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* location[0].physicalType.coding[0].code = #ro
* location[0].physicalType.coding[0].display = "Room"
