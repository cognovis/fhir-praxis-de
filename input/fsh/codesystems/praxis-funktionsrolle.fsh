// praxis-funktionsrolle.fsh
// Local practice function CodeSystem for PractitionerRole.code gap codes.
// Standard ESCO occupations are referenced via fhir-terminology-de.
// Bead: fpde-970

CodeSystem: PraxisFunktionsrolleCS
Id: praxis-funktionsrolle
Title: "Praxis Funktionsrolle"
Description: "Local gap CodeSystem for practice function codes on PractitionerRole.code. Contains only codes not adequately covered by ESCO standard occupations. Standard occupations (billing clerk, practice manager, receptionist, etc.) are referenced via the fhir-terminology-de ESCO subset ValueSet."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-funktionsrolle"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #billing-lead "Billing Lead" "Billing authority over the assigned organization scope, including descendant organization units via Organization.partOf. Responsible for billing oversight and authorization within the assigned organizational scope."
* #application-administration "Application Administration" "Staff-administration function: maintains users, staff assignments, and recorded staff capabilities. Does not grant global technical admin bypass; scope is limited to the assigned organization and its descendants via Organization.partOf."
