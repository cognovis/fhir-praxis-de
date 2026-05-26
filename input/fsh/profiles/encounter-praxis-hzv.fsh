Profile: EncounterPraxisHZV
Parent: EncounterPraxis
Id: encounter-praxis-hzv
Title: "Encounter Praxis HZV"
Description: "HZV clinical contact (§73b SGB V). Specializes EncounterPraxis for home/primary-care visits under HZV enrollment. The HZV enrollment is tracked via Encounter.episodeOfCare -> EpisodeOfCare(HZV). The billing case (HZV Account) references Coverage(HZV) which carries the contract/Rechnungsschema."
* ^purpose = "EpisodeOfCare(HZV) means base R4 EpisodeOfCare with HZV/HVG type, status, period, managing organization, care manager, and existing HZV/HVG extensions where needed. This IG does not define an HZV-only EpisodeOfCarePraxisHZV profile for downstream adapters; a future profile should be a generic PraxisProgramEnrollment profile if shared program-enrollment constraints become necessary."

* episodeOfCare 0..* MS
* episodeOfCare ^comment = "HZV enrollment link. References the patient's base R4 EpisodeOfCare carrying HZV/HVG type, status, period, organization, care manager, and existing HZV/HVG extensions where needed."
