// praxis-healthcare-service-type ValueSet
// Bead: fpde-ir8

ValueSet: PraxisHealthcareServiceTypeVS
Id: praxis-healthcare-service-type
Title: "Praxis Healthcare Service Type"
Description: "PVS-agnostic service-offering categories for HealthcareService.type in ambulatory practice management."
* ^status = #active
* ^experimental = false
* include codes from system PraxisHealthcareServiceTypeCS
