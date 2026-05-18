// PraxisAnamneseFreeTextObservationDE — Anamnesis freetext observation
// AW-SST crosswalk: maps to KBV_PR_AW_Observation_Anamnese
// Lightweight Observation.valueString profile for card-file anamnesis lines (NLP/extraction).

Profile: PraxisAnamneseFreeTextObservationDE
Parent: Observation
Id: praxis-anamnese-freetext-observation-de
Title: "Praxis Anamnese FreeText Observation DE"
Description: "Freitextliche Anamnesebeobachtung fuer die ambulante Praxis. Dient der Erfassung von Karteikartenzeilen (Anamnese) als unstrukturierter Text fuer NLP/Extraktion. Entspricht KBV_PR_AW_Observation_Anamnese semantisch."

* status 1..1 MS
* status ^short = "Observation status"

// category: survey for anamnesis
* category MS
* category ^short = "Category: survey (anamnesis)"
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey

// LOINC 10164-2: History of Present Illness Narrative
* code MS
* code ^short = "LOINC 10164-2: History of Present Illness Narrative"
* code = http://loinc.org#10164-2

* subject 1..1 MS
* subject only Reference(Patient)
* subject ^short = "Patient"

* effective[x] MS
* effective[x] ^short = "Date/time of the anamnesis recording"

// Freetext value: only valueString allowed
* value[x] only string
* value[x] 1..1 MS
* value[x] ^short = "Anamnesis freetext content"
* value[x] ^definition = "Unstructured anamnesis text as entered in the practice card file. Used for NLP extraction and archive export."

// Encounters: optional link to billing case
* encounter MS
* encounter ^short = "Encounter (billing case / Schein)"
