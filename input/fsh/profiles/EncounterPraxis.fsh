Profile: EncounterPraxis
Parent: Encounter
Id: encounter-praxis
Title: "Encounter Praxis"
Description: "Clinical contact in ambulatory practice (consultation, home visit). One contact = one Encounter. Encounter.class = AMB (ambulatory) or HH (home visit). Encounter.account references the billing case (AccountPraxisSchein). ScheinNummer and Scheinart are on the Account, not the Encounter."

* status 1..1 MS

* class 1..1 MS
* class from https://fhir.cognovis.de/praxis/ValueSet/encounter-praxis-class (required)
* class ^short = "AMB | HH — ambulatory contact or home visit"
* class ^comment = "For ambulatory practice contacts, use AMB (ambulatory) or HH (home health / home visit). Binding is required to enforce clinical contact scope."

* subject 1..1 MS
* subject only Reference(Patient)

* period MS
* period.start MS

* participant MS
* participant.individual MS
* participant.individual only Reference(Practitioner or PractitionerRole)

* account 0..* MS
* account only Reference(AccountPraxisSchein)
