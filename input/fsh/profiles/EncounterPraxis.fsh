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

* serviceProvider 1..1 MS
* serviceProvider only Reference(Organization)

* partOf 0..1 MS
* partOf only Reference(Encounter)

* period MS
* period.start MS

* participant MS
* participant.individual MS
* participant.individual only Reference(Practitioner or PractitionerRole)

* account 0..* MS
* account only Reference(AccountPraxisSchein)

* location 0..* MS
* location.location 1..1 MS
* location.location only Reference(PraxisNursingHomeLocationDE or Location)
* location.physicalType MS
* location ^short = "Place the contact occurred at; for nursing-home home visits (class=HH) reference the PraxisNursingHomeLocationDE"
* location ^comment = "ISiK Standort-aligned. For a Hausbesuch to a nursing-home resident, set location.location to the nursing-home Location. Combined with an active PraxisNursingHomeResidencyDE this signals nursing-home EBM codes, and a shared Location across patients on the same day enables Mitbesuch (EBM 01413) detection."

* extension contains WegegeldHausbesuchExt named wegegeldHausbesuch 0..1 MS
* extension[wegegeldHausbesuch] ^short = "Home-visit distance and zone for class=HH contacts"
* extension[wegegeldHausbesuch] ^comment = "Use only for home-visit contacts (class=HH). Distance is sourced from Patient.EntfernungZurPraxis in km. Zone is sourced from Schein.Zonenkennzeichen, with Patient.Zonenkennzeichen as the default. Downstream edits write back to those source columns per ADR-002. The Wegegeld billing code remains ChargeItem/Claim.item."
