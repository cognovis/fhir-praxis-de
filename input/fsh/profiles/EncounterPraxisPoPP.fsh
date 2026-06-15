Profile: EncounterPraxisPoPP
Parent: EncounterPraxis
Id: encounter-praxis-popp
Title: "Encounter Praxis PoPP"
Description: "Encounter profile sketch for PoPP-supported patient check-in workflows. The profile records the treatment context and a stub PoPP token anchor while cryptographic validation remains outside this Implementation Guide boundary."

* extension contains
    TreatmentContextExt named treatmentContext 1..1 MS and
    PoPPTokenAnchorExt named poppTokenAnchor 0..1 MS
* extension[treatmentContext] ^short = "Treatment context established by patient check-in"
* extension[treatmentContext].extension[workplaceFunction] 1..1 MS
* extension[treatmentContext].extension[workplaceFunction].valueCoding 1..1 MS
* extension[treatmentContext].extension[workplaceFunction].valueCoding = PraxisWorkplaceFunctionCS#reception-check-in
* extension[treatmentContext].extension[checkInTimestamp] MS
* extension[poppTokenAnchor] ^short = "Stub anchor for the PoPP token linked to the check-in"
* extension[poppTokenAnchor] ^comment = "Adapter boundary: this profile carries only a PoPP token anchor. Cryptographic PoPP token validation is deferred until TI connector availability and productive Gematik PoPP services."
