// praxis-healthcare-service-type.fsh
// PVS-agnostic ambulatory service-offering categories for HealthcareService.type
// Bead: fpde-ir8

CodeSystem: PraxisHealthcareServiceTypeCS
Id: praxis-healthcare-service-type
Title: "Praxis Healthcare Service Type"
Description: "PVS-agnostic categories for ambulatory practice service offerings published via HealthcareService.type. Distinct from GenehmigungenLeistungsbereichCS, which models KV authorization evidence on Basic resources."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #general-practice "General Practice" "Primary care / general medicine ambulatory service offering"
* #internal-medicine "Internal Medicine" "Internal medicine ambulatory service offering"
* #radiology "Radiology" "Radiology and diagnostic imaging service offering"
* #psychosomatic-basic-care "Psychosomatic Basic Care" "Psychosomatische Grundversorgung ambulatory service offering"
