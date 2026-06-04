// example-nursing-home-residency.fsh

Instance: ExampleNursingHomeLocation
InstanceOf: Location
Title: "Example Nursing Home Location"
Description: "Nursing-home address for a care facility."
Usage: #example
* status = #active
* name = "Sonnenschein Care Home"
* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode"
* type[0].coding[0].code = #NURS
* type[0].coding[0].display = "Nursing home"
* address.line[0] = "Care Home Street 12"
* address.city = "Munich"
* address.postalCode = "80331"
* address.country = "DE"

Instance: ExampleNursingHomeResidency
InstanceOf: PraxisNursingHomeResidencyDE
Title: "Example Nursing Home Residency"
Description: "Patient residency with room, station, and seating group placement."
Usage: #example
* meta.profile[0] = "https://fhir.cognovis.de/praxis/StructureDefinition/praxis-nursing-home-residency-de"
* status = #active
* patient = Reference(example-patient)
* period.start = "2024-03-01"
* extension[nursingHomeLocation].valueReference = Reference(ExampleNursingHomeLocation)
* extension[station].valueString = "North Wing"
* extension[roomNumber].valueString = "214"
* extension[seatingGroup].valueString = "Group A"
