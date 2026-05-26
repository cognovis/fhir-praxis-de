Instance: example-encounter-ambulant
InstanceOf: EncounterPraxis
Title: "Ambulatory Clinical Contact"
Description: "Ambulatory clinical contact linked to a GKV billing case Account."
Usage: #example
* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"
* subject = Reference(example-patient)
* period.start = "2026-04-10"
* period.end = "2026-04-10"
* participant[0].individual = Reference(example-practitioner)
* account[0] = Reference(example-account-schein-gkv)

Instance: example-encounter-hausbesuch
InstanceOf: EncounterPraxis
Title: "Home Visit Clinical Contact"
Description: "Home visit clinical contact linked to a GKV billing case Account."
Usage: #example
* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#HH "home health"
* subject = Reference(example-patient)
* period.start = "2026-04-12"
* period.end = "2026-04-12"
* participant[0].individual = Reference(example-practitioner)
* account[0] = Reference(example-account-schein-gkv)
