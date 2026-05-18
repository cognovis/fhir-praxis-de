// PraxisBefundFreeTextObservationDE — Clinical finding freetext observation
// AW-SST crosswalk: maps to KBV_PR_AW_Observation_Befund
// Lightweight Observation.valueString profile for unstructured finding notes (NLP/extraction).

Profile: PraxisBefundFreeTextObservationDE
Parent: Observation
Id: praxis-befund-freetext-observation-de
Title: "Praxis Befund FreeText Observation DE"
Description: "Freitextlicher klinischer Befund fuer die ambulante Praxis. Dient der Erfassung von unstrukturierten Befundtexten aus der Karteikarte fuer NLP/Extraktion. Strukturierte Befunde (Labor, Bildgebung) bleiben in separaten Profilen. Entspricht KBV_PR_AW_Observation_Befund semantisch."

* status 1..1 MS
* status ^short = "Observation status"

// category: exam for clinical findings
* category MS
* category ^short = "Category: exam (clinical finding)"
* category = http://terminology.hl7.org/CodeSystem/observation-category#exam

// LOINC 11506-3: Progress note — general free-text clinical finding
* code MS
* code ^short = "LOINC 11506-3: Progress note (free-text clinical finding)"
* code = http://loinc.org#11506-3

* subject 1..1 MS
* subject only Reference(Patient)
* subject ^short = "Patient"

* effective[x] MS
* effective[x] ^short = "Date/time of the finding"

// Freetext value: only valueString allowed
* value[x] only string
* value[x] 1..1 MS
* value[x] ^short = "Clinical finding freetext content"
* value[x] ^definition = "Unstructured clinical finding text as entered in the practice card file. Used for NLP extraction and archive export. Structured findings (lab, imaging) use dedicated profiles."

// Encounter: optional link to billing case
* encounter MS
* encounter ^short = "Encounter (billing case / Schein)"
