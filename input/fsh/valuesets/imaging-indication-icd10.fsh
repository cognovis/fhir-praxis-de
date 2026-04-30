// ImagingIndicationICD10VS — ICD-10-GM Indikationscodes fuer Bildgebung
// Required binding fuer reasonCode[icd10gm] in ImagingServiceRequestPraxisDe.
// Includes all codes from the ICD-10-GM CodeSystem (BFARM).
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

ValueSet: ImagingIndicationICD10VS
Id: imaging-indication-icd10
Title: "Imaging Indication ICD-10-GM"
Description: "ICD-10-GM Indikationscodes fuer Bildgebungsanforderungen. Required binding fuer reasonCode[icd10gm] in ImagingServiceRequestPraxisDe. Enthaelt alle Codes aus dem ICD-10-GM CodeSystem (BFARM)."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/imaging-indication-icd10"
* ^status = #active
* ^experimental = false

// Include all codes from ICD-10-GM (BFARM)
* include codes from system http://fhir.de/CodeSystem/bfarm/icd-10-gm
