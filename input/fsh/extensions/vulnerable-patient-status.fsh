// vulnerable-patient-status.fsh
// Bead: fpde-0wb
// Complex Patient extension for vulnerable patient master-data modifiers

Extension: VulnerablePatientStatusExt
Id: vulnerable-patient-status
Title: "Vulnerable Patient Status DE"
Description: "Patient master-data modifiers for Pflegegrad, Eingliederungshilfe, and Kooperationsvertrag with temporal validity. Dental BEMA trigger interpretation is delegated to the fhir-dental-de implementation guide (bead fdde-xht)."
Context: Patient
* extension contains
    pflegegradStatus 0..1 and
    eingliederungshilfeStatus 0..1 and
    kooperationsvertragStatus 0..1 and
    kooperationsvertragFacility 0..1 and
    validFrom 0..1 and
    validUntil 0..1
* extension[pflegegradStatus].value[x] only CodeableConcept
* extension[pflegegradStatus].valueCodeableConcept from PflegegradStatusVS (preferred)
* extension[pflegegradStatus] ^short = "Pflegegrad master-data modifier"
* extension[pflegegradStatus] ^comment = "Optional Pflegegrad classification used as a patient master-data modifier."
* extension[eingliederungshilfeStatus].value[x] only CodeableConcept
* extension[eingliederungshilfeStatus].valueCodeableConcept from EingliederungshilfeStatusVS (preferred)
* extension[eingliederungshilfeStatus] ^short = "Eingliederungshilfe master-data modifier"
* extension[eingliederungshilfeStatus] ^comment = "Optional Eingliederungshilfe classification used as a patient master-data modifier."
* extension[kooperationsvertragStatus].value[x] only CodeableConcept
* extension[kooperationsvertragStatus].valueCodeableConcept from KooperationsvertragStatusVS (required)
* extension[kooperationsvertragStatus] ^short = "Kooperationsvertrag status"
* extension[kooperationsvertragStatus] ^comment = "Required local status for the Kooperationsvertrag modifier."
* extension[kooperationsvertragFacility].value[x] only Reference(Organization)
* extension[kooperationsvertragFacility] ^short = "Referenced facility for the Kooperationsvertrag"
* extension[kooperationsvertragFacility] ^comment = "Optional Organization reference for the facility that is part of the Kooperationsvertrag setup."
* extension[validFrom].value[x] only date
* extension[validFrom] ^short = "Validity start date"
* extension[validFrom] ^comment = "Start date of the master-data validity period."
* extension[validUntil].value[x] only date
* extension[validUntil] ^short = "Validity end date"
* extension[validUntil] ^comment = "End date of the master-data validity period."
