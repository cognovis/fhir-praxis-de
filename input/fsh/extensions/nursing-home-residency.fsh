// nursing-home-residency.fsh
// Extension carrying the nursing-home Location on the residency episode.
// EpisodeOfCare has no native location element, hence this extension.

Extension: NursingHomeLocationExt
Id: nursing-home-location
Title: "Nursing Home Location"
Description: "Reference to the most-specific gematik ISiK Location where the patient resides (ISiKStandortRaum if room is known, else ISiKStandort ward/facility node). Parent places resolve via Location.partOf."
Context: EpisodeOfCare
* value[x] only Reference(ISiKStandort or ISiKStandortRaum or ISiKStandortBettenstellplatz)
* valueReference.reference 1..1 MS
