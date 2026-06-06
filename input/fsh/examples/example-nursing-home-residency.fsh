// example-nursing-home-residency.fsh
// Nursing-home facility / ward / room hierarchy using gematik ISiK Location profiles.

Instance: ExampleNursingHomeOrganization
InstanceOf: Organization
Title: "Example Nursing Home Operator"
Description: "Managing organization for the nursing-home ISiK Location hierarchy."
Usage: #example
* active = true
* name = "Sonnenschein Care GmbH"

Instance: ExampleNursingHomeFacility
InstanceOf: Location
Title: "Example Nursing Home Facility"
Description: "Nursing-home facility node (ISiKStandort, type NCCF)."
Usage: #example
* meta.profile[0] = ISiKStandort
* status = #active
* mode = #instance
* name = "Sonnenschein Care Home"
* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode"
* type[0].coding[0].code = #NCCF
* type[0].coding[0].display = "Nursing or custodial care facility"
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #si
* physicalType.coding[0].display = "Site"
* address.line[0] = "Care Home Street 12"
* address.city = "Munich"
* address.postalCode = "80331"
* address.country = "DE"
* managingOrganization = Reference(ExampleNursingHomeOrganization)

Instance: ExampleNursingHomeWard
InstanceOf: Location
Title: "Example Nursing Home Ward"
Description: "Ward/station node (ISiKStandort, physicalType wa), part of the facility."
Usage: #example
* meta.profile[0] = ISiKStandort
* status = #active
* mode = #instance
* name = "North Wing"
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #wa
* physicalType.coding[0].display = "Ward"
* partOf = Reference(ExampleNursingHomeFacility)
* managingOrganization = Reference(ExampleNursingHomeOrganization)

Instance: ExampleNursingHomeRoom
InstanceOf: Location
Title: "Example Nursing Home Room"
Description: "Room node (ISiKStandortRaum), part of the ward."
Usage: #example
* meta.profile[0] = ISiKStandortRaum
* status = #active
* mode = #instance
* name = "214"
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #ro
* physicalType.coding[0].display = "Room"
* partOf = Reference(ExampleNursingHomeWard)
* managingOrganization = Reference(ExampleNursingHomeOrganization)

Instance: ExampleNursingHomeResidency
InstanceOf: PraxisNursingHomeResidencyDE
Title: "Example Nursing Home Residency"
Description: "Active residency referencing the most-specific ISiK Location (room). Ward and facility resolve via Location.partOf."
Usage: #example
* meta.profile[0] = "https://fhir.cognovis.de/praxis/StructureDefinition/praxis-nursing-home-residency-de"
* status = #active
* patient = Reference(example-patient)
* period.start = "2024-03-01"
* extension[nursingHomeLocation].valueReference = Reference(ExampleNursingHomeRoom)
