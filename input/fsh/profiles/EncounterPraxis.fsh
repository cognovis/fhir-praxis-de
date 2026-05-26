Profile: EncounterPraxis
Parent: Encounter
Id: encounter-praxis
Title: "Encounter Praxis"
Description: "Clinical contact in ambulatory practice (consultation, home visit). One contact = one Encounter. Encounter.class = AMB (ambulatory) or HH (home visit). Encounter.account references the billing case (AccountPraxisSchein). ScheinNummer and Scheinart are on the Account, not the Encounter."

* status 1..1 MS

* class 1..1 MS
* class from http://terminology.hl7.org/ValueSet/v3-ActEncounterCode (extensible)

* subject 1..1 MS
* subject only Reference(Patient)

* period MS
* period.start MS

* participant MS
* participant.individual MS
* participant.individual only Reference(Practitioner or PractitionerRole)

* account 0..* MS
* account only Reference(AccountPraxisSchein)
