// PraxisAllergyIntoleranceDE — Allergy and intolerance profile
// AW-SST crosswalk: maps to KBV_PR_AW_Allergie
// Distinct from PraxisFlag which handles broader CAVE/workflow flags.
// This profile covers clinical allergy/intolerance recording.

Profile: PraxisAllergyIntoleranceDE
Parent: AllergyIntolerance
Id: praxis-allergy-intolerance-de
Title: "Praxis AllergyIntolerance DE"
Description: "Allergie- und Unvertraeglichkeitsprofil fuer die deutsche ambulante Praxis. Bildet klinisch relevante Allergien und Unvertraeglichkeiten ab. Separat von PraxisFlag (CAVE, Hinweise, Workflow-Warnungen). Entspricht KBV_PR_AW_Allergie semantisch."

* patient 1..1 MS
* patient only Reference(Patient)
* patient ^short = "Patient"

* clinicalStatus MS
* clinicalStatus ^short = "Clinical status (active, inactive, resolved)"

* verificationStatus MS
* verificationStatus ^short = "Verification status (confirmed, unconfirmed, refuted, entered-in-error)"

* type MS
* type ^short = "allergy | intolerance"

* category MS
* category ^short = "food | medication | environment | biologic"

* criticality MS
* criticality ^short = "low | high | unable-to-assess"

* code MS
* code ^short = "Substance code (SNOMED CT or local coding)"
* code ^definition = "Allergy or intolerance substance. Use SNOMED CT where available. Local coding systems may be used as additional codings."

* onset[x] MS
* onset[x] ^short = "Date/time or age of onset"

* recordedDate MS
* recordedDate ^short = "Date allergy was recorded"

* recorder MS
* recorder only Reference(Practitioner or PractitionerRole)
* recorder ^short = "Who recorded the allergy"

* reaction MS
* reaction ^short = "Adverse reaction details"
* reaction.substance MS
* reaction.substance ^short = "Specific substance that caused the reaction"
* reaction.manifestation MS
* reaction.manifestation ^short = "Clinical symptoms/signs"
* reaction.severity MS
* reaction.severity ^short = "mild | moderate | severe"
