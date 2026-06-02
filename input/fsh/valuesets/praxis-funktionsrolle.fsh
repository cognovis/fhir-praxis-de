// praxis-funktionsrolle.fsh
// Practice function ValueSet for PractitionerRole.code.
// Combines local gap codes and ESCO standard occupations from fhir-terminology-de.
// The ESCO subset is resolved through the de.cognovis.terminology.esco package
// dependency declared in sushi-config.yaml.
// Bead: fpde-970

ValueSet: PraxisFunktionsrolleVS
Id: praxis-funktionsrolle
Title: "Praxis Funktionsrolle"
Description: "Practice function ValueSet for PractitionerRole.code. Includes local gap codes from PraxisFunktionsrolleCS and standard ESCO occupations from fhir-terminology-de (billing clerk, medical administrative assistant, practice manager, receptionist, healthcare manager, ICT system administrator, doctors' surgery assistant). Extensible binding allows additional codes from ESCO or other recognized systems."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/praxis-funktionsrolle"
* ^status = #active
* ^experimental = false

* include codes from system PraxisFunktionsrolleCS
* include codes from valueset https://fhir.cognovis.de/ValueSet/esco-practice-functions
