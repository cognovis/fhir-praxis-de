// ImagingRequestCodeVS — LOINC-Codes fuer Bildgebungsanforderungen
// Preferred binding fuer ServiceRequest.code in ImagingServiceRequestPraxisDe.
// Includes selected radiology imaging procedure codes from LOINC.
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $loinc = http://loinc.org

ValueSet: ImagingRequestCodeVS
Id: imaging-request-code
Title: "Imaging Request Code"
Description: "LOINC-Codes fuer Bildgebungsanforderungen in der deutschen ambulanten Praxis. Preferred binding fuer ServiceRequest.code in ImagingServiceRequestPraxisDe."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/imaging-request-code"
* ^status = #active
* ^experimental = false

// Selected LOINC radiology order codes (MRI, CT, X-ray, US)
* $loinc#36803-5 "MRI of knee"
* $loinc#24558-9 "MRI of head"
* $loinc#36643-5 "CT of thorax"
* $loinc#24727-0 "MRI of pelvis"
* $loinc#24629-8 "CT of chest"
* $loinc#24648-8 "CT of abdomen"
* $loinc#24565-4 "MRI of shoulder"
* $loinc#24698-3 "MRI of abdomen"
* $loinc#24605-8 "CT of head"
* $loinc#24747-8 "XR chest"
* $loinc#24539-9 "US Abdomen"
* $loinc#24691-8 "NM Bone"
