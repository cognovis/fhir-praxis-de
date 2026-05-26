// HZV Hausbesuch contact — demonstrates HZV clinical contact with class=HH (home visit)
// The billing case (HZV Account) is linked via Encounter.account.
// The HZV enrollment is tracked via Encounter.episodeOfCare -> EpisodeOfCare(HZV).

Instance: hzv-encounter-example
InstanceOf: EncounterPraxisHZV
Title: "HZV Home Visit Clinical Contact"
Description: "Example HZV home visit clinical contact (class=HH). The billing case is linked through Encounter.account. HZV enrollment tracked via episodeOfCare."
Usage: #example

* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#HH "home health"
* subject = Reference(example-patient)
* period.start = "2026-04-10"
* period.end = "2026-04-10"
* participant[0].individual = Reference(example-practitioner)
* account[0] = Reference(example-account-schein-hzv)
