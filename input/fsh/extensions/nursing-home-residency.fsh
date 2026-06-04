// nursing-home-residency.fsh
// Extension carrying the nursing-home Location on the residency episode.
// EpisodeOfCare has no native location element, hence this extension.

Extension: NursingHomeLocationExt
Id: nursing-home-location
Title: "Nursing Home Location"
Description: "Reference to the most-specific PraxisNursingHomeLocationDE where the patient resides (room, else ward, else facility). Facility and ward are resolved via Location.partOf."
Context: EpisodeOfCare
* value[x] only Reference(PraxisNursingHomeLocationDE)
* valueReference.reference 1..1 MS
