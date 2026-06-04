// nursing-home-residency.fsh
// EpisodeOfCare profile for patient residency in a nursing home.

Profile: PraxisNursingHomeResidencyDE
Parent: EpisodeOfCare
Id: praxis-nursing-home-residency-de
Title: "Praxis Nursing Home Residency DE"
Description: "Patient residency in a nursing home. Links the patient to a nursing-home Location and carries room, station, and seating-group placement details."

* patient 1..1 MS
* status 1..1 MS
* period 0..1 MS
* extension contains
    NursingHomeLocationExt named nursingHomeLocation 1..1 MS and
    NursingHomeStationExt named station 0..1 MS and
    NursingHomeRoomNumberExt named roomNumber 0..1 MS and
    NursingHomeSeatingGroupExt named seatingGroup 0..1 MS
* extension[nursingHomeLocation] ^short = "Nursing-home Location reference"
* extension[nursingHomeLocation] ^definition = "Canonical link from the patient residency episode to the nursing-home Location resource."
* extension[station] ^short = "Station or ward name"
* extension[roomNumber] ^short = "Room number"
* extension[seatingGroup] ^short = "Seating group"
