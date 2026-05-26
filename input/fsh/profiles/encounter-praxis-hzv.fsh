Profile: EncounterPraxisHZV
Parent: EncounterPraxis
Id: encounter-praxis-hzv
Title: "Encounter Praxis HZV"
Description: "HZV clinical contact (§73b SGB V). Specializes EncounterPraxis for home/primary-care visits under HZV enrollment. The HZV enrollment is tracked via Encounter.episodeOfCare -> EpisodeOfCare(HZV). The billing case (HZV Account) references Coverage(HZV) which carries the contract/Rechnungsschema."

* episodeOfCare 0..* MS
* episodeOfCare ^comment = "HZV enrollment link. References the patient's HZV EpisodeOfCare."
