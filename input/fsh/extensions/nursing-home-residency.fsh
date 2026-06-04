// nursing-home-residency.fsh
// Extensions for nursing-home room, station, and seating group placement.

Extension: NursingHomeStationExt
Id: nursing-home-station
Title: "Nursing Home Station"
Description: "Station or ward name for a patient residency in a nursing home."
Context: EpisodeOfCare
* value[x] only string
* valueString ^maxLength = 50

Extension: NursingHomeRoomNumberExt
Id: nursing-home-room-number
Title: "Nursing Home Room Number"
Description: "Room number for a patient residency in a nursing home."
Context: EpisodeOfCare
* value[x] only string
* valueString ^maxLength = 10

Extension: NursingHomeSeatingGroupExt
Id: nursing-home-seating-group
Title: "Nursing Home Seating Group"
Description: "Seating group for a patient residency in a nursing home."
Context: EpisodeOfCare
* value[x] only string
* valueString ^maxLength = 50

Extension: NursingHomeLocationExt
Id: nursing-home-location
Title: "Nursing Home Location"
Description: "Reference to the nursing-home Location where the patient is currently placed."
Context: EpisodeOfCare
* value[x] only Reference(Location)
* valueReference.reference 1..1 MS
