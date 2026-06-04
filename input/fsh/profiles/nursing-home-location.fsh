// nursing-home-location.fsh
// ISiK-aligned Location profile for the physical places of a nursing home.

Profile: PraxisNursingHomeLocationDE
Parent: Location
Id: praxis-nursing-home-location-de
Title: "Praxis Nursing Home Location DE"
Description: "Physical location within or representing a nursing home (Pflegeheim): the facility itself, a ward/station, or a room. Locations form a partOf hierarchy (facility -> ward -> room), structurally aligned with the gematik ISiK Standort modelling (Location.physicalType + Location.partOf) without depending on the ISiK package. Used by ambulatory billing to detect that a patient resides in a nursing home (active PraxisNursingHomeResidencyDE) and to group co-located patients for Mitbesuch (EBM 01413)."

* status MS
* name 1..1 MS
* name ^short = "Human-readable name (facility name, ward/station name, or room number)"

* type MS
* type ^short = "Use type = NURS (v3-RoleCode) on the facility node"

* physicalType 1..1 MS
* physicalType from http://hl7.org/fhir/ValueSet/location-physical-type (required)
* physicalType ^short = "bu (facility/building) | wa (ward/station) | ro (room)"
* physicalType ^comment = "Facility node: bu. Station/ward node: wa. Room node: ro. The level is derived from this code; ward and room are NOT free-text fields."

* partOf 0..1 MS
* partOf only Reference(PraxisNursingHomeLocationDE)
* partOf ^short = "Parent place in the facility -> ward -> room hierarchy"
* partOf ^comment = "A room references its ward; a ward references the facility. The facility node has no partOf."
