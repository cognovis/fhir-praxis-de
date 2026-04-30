// RadiologyRoleVS — ValueSet der Radiologierollen aus RadiologyRoleCS
// ASCII-safe: keine Umlaute in Kommentaren.

ValueSet: RadiologyRoleVS
Id: radiology-role
Title: "Radiology Role"
Description: "ValueSet der Radiologierollen fuer PractitionerRole.code. Enthaelt MTR, Radiologin, Reading Radiologist und Supervising Radiologist."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/radiology-role"
* ^status = #active
* ^experimental = false

* include codes from system RadiologyRoleCS
