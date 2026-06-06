// Workplace function scenario — practice site, rooms, shared reception, multi-tenant site
// Bead: fpde-b74

Instance: ExampleWorkplaceMedicalCenterSite
InstanceOf: Location
Title: "Medical office center — Hauptstandort"
Description: "ISiKStandort practice site with managingOrganization for the building operator."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandort"
* status = #active
* name = "Medizinisches Zentrum Nord — Site"
* mode = #instance
* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode"
* type[0].coding[0].code = #PROFF
* type[0].coding[0].display = "Provider's Office"
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #si
* physicalType.coding[0].display = "Site"
* address.line[0] = "Nordallee 100"
* address.city = "Erlangen"
* address.postalCode = "91054"
* address.country = "DE"
* managingOrganization = Reference(ExampleWorkplaceBuildingOperatorOrg)

Instance: ExampleWorkplaceBuildingOperatorOrg
InstanceOf: PraxisOrganizationDE
Title: "Building operator — Medizinisches Zentrum Nord"
Description: "Organization that operates the shared medical office building (not a clinical service provider)."
Usage: #example
* active = true
* name = "MVZ Nord Betriebsgesellschaft mbH"
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_BSNR"
* identifier[0].value = "998877665"

Instance: ExampleWorkplaceSharedReception
InstanceOf: Location
Title: "Shared reception — Medizinisches Zentrum Nord"
Description: "Single physical reception Location shared by multiple tenant practices. Referenced by PractitionerRole.location without duplicating the resource per Organization."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandortRaum"
* status = #active
* name = "Reception — Ground Floor"
* mode = #instance
* type[0].coding[0] = PraxisWorkplaceFunctionCS#reception-check-in
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #ro
* physicalType.coding[0].display = "Room"
* partOf = Reference(ExampleWorkplaceMedicalCenterSite)
* managingOrganization = Reference(ExampleWorkplaceBuildingOperatorOrg)

Instance: ExampleWorkplaceWaitingArea
InstanceOf: Location
Title: "Waiting area — general medicine wing"
Description: "Patient waiting area (physicalType area) within the site."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandort"
* status = #active
* name = "Waiting Area A"
* mode = #instance
* type[0].coding[0] = PraxisWorkplaceFunctionCS#waiting-area
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #area
* physicalType.coding[0].display = "Area"
* partOf = Reference(ExampleWorkplaceMedicalCenterSite)
* managingOrganization = Reference(ExampleWorkplaceOrgGeneral)

Instance: ExampleWorkplaceConsultationRoom
InstanceOf: Location
Title: "Consultation room 2 — general medicine"
Description: "Ambulatory consultation room with workplace function on Location.type."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandortRaum"
* status = #active
* name = "Consultation Room 2"
* mode = #instance
* type[0].coding[0] = PraxisWorkplaceFunctionCS#consultation-room
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #ro
* physicalType.coding[0].display = "Room"
* partOf = Reference(ExampleWorkplaceMedicalCenterSite)
* managingOrganization = Reference(ExampleWorkplaceOrgGeneral)

Instance: ExampleWorkplaceBloodDrawRoom
InstanceOf: Location
Title: "Blood draw room"
Description: "Phlebotomy workplace linked to the general medicine tenant."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandortRaum"
* status = #active
* name = "Blood Draw Room"
* mode = #instance
* type[0].coding[0] = PraxisWorkplaceFunctionCS#blood-draw
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #ro
* physicalType.coding[0].display = "Room"
* partOf = Reference(ExampleWorkplaceMedicalCenterSite)
* managingOrganization = Reference(ExampleWorkplaceOrgGeneral)

Instance: ExampleWorkplaceEcgRoom
InstanceOf: Location
Title: "ECG room"
Description: "Electrocardiography workplace."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandortRaum"
* status = #active
* name = "ECG Room"
* mode = #instance
* type[0].coding[0] = PraxisWorkplaceFunctionCS#ecg-room
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #ro
* physicalType.coding[0].display = "Room"
* partOf = Reference(ExampleWorkplaceMedicalCenterSite)
* managingOrganization = Reference(ExampleWorkplaceOrgGeneral)

Instance: ExampleWorkplaceRadiologyRoom
InstanceOf: Location
Title: "Radiology room — in-practice imaging"
Description: "Imaging room using v3 RADDX at room level where the standard code fits the department function."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandortRaum"
* status = #active
* name = "X-Ray Room 1"
* mode = #instance
* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode"
* type[0].coding[0].code = #RADDX
* type[0].coding[0].display = "Radiology diagnostics"
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #ro
* physicalType.coding[0].display = "Room"
* partOf = Reference(ExampleWorkplaceMedicalCenterSite)
* managingOrganization = Reference(ExampleWorkplaceOrgGeneral)

Instance: ExampleWorkplaceDentalRoom
InstanceOf: Location
Title: "Dental treatment room — tenant practice"
Description: "Dental operatory for the co-located dental tenant organization."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandortRaum"
* status = #active
* name = "Dental Operatory 1"
* mode = #instance
* type[0].coding[0] = PraxisWorkplaceFunctionCS#dental-treatment-room
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #ro
* physicalType.coding[0].display = "Room"
* partOf = Reference(ExampleWorkplaceMedicalCenterSite)
* managingOrganization = Reference(ExampleWorkplaceOrgDental)

Instance: ExampleWorkplaceTelehealthEndpoint
InstanceOf: Location
Title: "Telehealth virtual workspace"
Description: "Virtual care endpoint Location (no physical room); operational function only."
Usage: #example
* meta.profile[0] = "https://gematik.de/fhir/isik/StructureDefinition/ISiKStandort"
* status = #active
* name = "Video Consultation Endpoint"
* mode = #instance
* type[0].coding[0] = PraxisWorkplaceFunctionCS#telehealth-virtual-workspace
* physicalType.coding[0].system = "http://terminology.hl7.org/CodeSystem/location-physical-type"
* physicalType.coding[0].code = #vi
* physicalType.coding[0].display = "Virtual"
* partOf = Reference(ExampleWorkplaceMedicalCenterSite)
* managingOrganization = Reference(ExampleWorkplaceOrgGeneral)

Instance: ExampleWorkplaceOrgGeneral
InstanceOf: PraxisOrganizationDE
Title: "Hausarztpraxis Nord — tenant"
Description: "General medicine tenant practice within the shared medical center."
Usage: #example
* active = true
* name = "Hausarztpraxis Nord"
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_BSNR"
* identifier[0].value = "554433221"

Instance: ExampleWorkplaceOrgDental
InstanceOf: PraxisOrganizationDE
Title: "Zahnarztpraxis Nord — tenant"
Description: "Dental tenant practice sharing the building reception with general medicine."
Usage: #example
* active = true
* name = "Zahnarztpraxis Nord"
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_BSNR"
* identifier[0].value = "665544332"

Instance: ExampleWorkplaceRoleGeneralReception
InstanceOf: PraxisPractitionerRoleDE
Title: "MFA at shared reception — general medicine"
Description: "PractitionerRole references the single shared reception Location; no duplicate Location per Organization."
Usage: #example
* active = true
* practitioner = Reference(example-practitioner)
* organization = Reference(ExampleWorkplaceOrgGeneral)
* location[0] = Reference(ExampleWorkplaceSharedReception)
* code[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
* code[0].coding[0].code = #doctor

Instance: ExampleWorkplaceRoleDentalReception
InstanceOf: PraxisPractitionerRoleDE
Title: "MFA at shared reception — dental tenant"
Description: "Second tenant references the same physical reception Location for routing context."
Usage: #example
* active = true
* practitioner = Reference(example-practitioner-wb)
* organization = Reference(ExampleWorkplaceOrgDental)
* location[0] = Reference(ExampleWorkplaceSharedReception)
* code[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
* code[0].coding[0].code = #doctor

Instance: ExampleWorkplaceRoleConsultation
InstanceOf: PraxisPractitionerRoleDE
Title: "Physician consultation room assignment"
Description: "Staff role tied to a specific consultation room workplace function."
Usage: #example
* active = true
* practitioner = Reference(example-practitioner)
* organization = Reference(ExampleWorkplaceOrgGeneral)
* location[0] = Reference(ExampleWorkplaceConsultationRoom)
* code[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
* code[0].coding[0].code = #doctor
