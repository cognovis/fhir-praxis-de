// praxis-workplace-function ValueSet
// Hybrid catalog: local ambulatory functions + selected v3 ServiceDeliveryLocationRoleType codes
// Bead: fpde-b74

ValueSet: PraxisWorkplaceFunctionVS
Id: praxis-workplace-function
Title: "Praxis Workplace Function"
Description: "Operational workplace functions for Location.type in ambulatory practice. Prefer PraxisWorkplaceFunctionCS codes at room/area granularity. Selected HL7 v3 ServiceDeliveryLocationRoleType codes are included for site-level or department-level locations where they fit without ambiguity."
* ^status = #active
* ^experimental = false
* include codes from system PraxisWorkplaceFunctionCS
* include #PROFF from system http://terminology.hl7.org/CodeSystem/v3-RoleCode
* include #OF from system http://terminology.hl7.org/CodeSystem/v3-RoleCode
* include #DX from system http://terminology.hl7.org/CodeSystem/v3-RoleCode
* include #LAB from system http://terminology.hl7.org/CodeSystem/v3-RoleCode
* include #RADDX from system http://terminology.hl7.org/CodeSystem/v3-RoleCode
* include #RADO from system http://terminology.hl7.org/CodeSystem/v3-RoleCode
* include #DENT from system http://terminology.hl7.org/CodeSystem/v3-RoleCode
* include #OPS from system http://terminology.hl7.org/CodeSystem/v3-RoleCode
