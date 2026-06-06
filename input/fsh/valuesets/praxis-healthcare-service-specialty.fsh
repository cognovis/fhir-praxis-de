// praxis-healthcare-service-specialty ValueSet
// KBV BAR2-WBO for ambulatory Fachgruppe on HealthcareService.specialty
// Bead: fpde-ir8

ValueSet: PraxisHealthcareServiceSpecialtyVS
Id: praxis-healthcare-service-specialty
Title: "Praxis Healthcare Service Specialty"
Description: "Ambulatory specialty (Fachgruppe) codes for HealthcareService.specialty using KBV BAR2-WBO. ISiK ISiKMedizinischeBehandlungseinheit binds specialty to IHE XDS practice setting; use the mapping table in healthcare-service-contract.md when exchanging with ISiK hospital systems."
* ^status = #active
* ^experimental = false
* include codes from system https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BAR2_WBO
