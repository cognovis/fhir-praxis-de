Instance: hzv-encounter-example
InstanceOf: EncounterPraxisHZV
Title: "HZV Clinical Contact AOK Bayern"
Description: "Example HZV clinical contact. The billing case is linked through Encounter.account."
Usage: #example

* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"
* subject = Reference(example-patient)
* period.start = "2026-04-10"
* period.end = "2026-04-10"
* participant[0].individual = Reference(example-practitioner)
* account[0] = Reference(example-account-schein-hzv)
