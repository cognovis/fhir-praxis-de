// example-nursing-home-residency.fsh

Instance: ExampleNursingHomeFacility
InstanceOf: PraxisNursingHomeLocationDE
Title: "Example Nursing Home Facility"
Description: "Nursing-home facility node (physicalType bu, type NURS)."
Usage: #example
* status = #active
* name = "Sonnenschein Care Home"
* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode"
* type[0].coding[0].code = #NURS
* type[0].coding[0].display = "Nursing home"
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #bu
* physicalType.coding[0].display = "Building"
* address.line[0] = "Care Home Street 12"
* address.city = "Munich"
* address.postalCode = "80331"
* address.country = "DE"

Instance: ExampleNursingHomeWard
InstanceOf: PraxisNursingHomeLocationDE
Title: "Example Nursing Home Ward"
Description: "Ward/station node (physicalType wa), part of the facility."
Usage: #example
* status = #active
* name = "North Wing"
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #wa
* physicalType.coding[0].display = "Ward"
* partOf = Reference(ExampleNursingHomeFacility)

Instance: ExampleNursingHomeRoom
InstanceOf: PraxisNursingHomeLocationDE
Title: "Example Nursing Home Room"
Description: "Room node (physicalType ro), part of the ward."
Usage: #example
* status = #active
* name = "214"
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #ro
* physicalType.coding[0].display = "Room"
* partOf = Reference(ExampleNursingHomeWard)

Instance: ExampleNursingHomeResidency
InstanceOf: PraxisNursingHomeResidencyDE
Title: "Example Nursing Home Residency"
Description: "Active residency referencing the most-specific Location (room). Ward and facility resolve via Location.partOf."
Usage: #example
* meta.profile[0] = "https://fhir.cognovis.de/praxis/StructureDefinition/praxis-nursing-home-residency-de"
* status = #active
* patient = Reference(example-patient)
* period.start = "2024-03-01"
* extension[nursingHomeLocation].valueReference = Reference(ExampleNursingHomeRoom)
