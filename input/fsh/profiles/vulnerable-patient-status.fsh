Profile: VulnerablePatientStatusDE
Parent: Patient
Id: vulnerable-patient-status-de
Title: "Vulnerable Patient Status DE"
Description: "Patient profile adding Pflegegrad, Eingliederungshilfe, and Kooperationsvertrag master data modifiers. Dental BEMA trigger interpretation is delegated to fhir-dental-de:fdde-xht."

* extension contains VulnerablePatientStatusExt named vulnerablePatientStatus 0..1 MS
* extension[vulnerablePatientStatus] ^short = "Patient master-data modifiers for Pflegegrad, Eingliederungshilfe, and Kooperationsvertrag"
* extension[vulnerablePatientStatus] ^comment = "Use this extension to carry vulnerable patient master-data modifiers and their temporal validity. Dental BEMA trigger interpretation is delegated to fhir-dental-de:fdde-xht."
