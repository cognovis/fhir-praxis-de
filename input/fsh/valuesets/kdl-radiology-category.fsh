// KdlRadiologyCategoryVS — ValueSet der KDL-Radiologiekategorien fuer das Category-Slicing
// Enthaelt die vier KDL-Codes fuer Roentgen, CT, MRT und Sonographie.
// ASCII-safe: keine Umlaute in Kommentaren.

ValueSet: KdlRadiologyCategoryVS
Id: kdl-radiology-category
Title: "KDL Radiologie-Kategorien"
Description: "ValueSet der KDL-Klinischen Dokumentenlenkung Codes fuer Radiologiebefund-Kategorien. Enthaelt Roentgenbefund, CT-Befund, MRT-Befund und Sonographiebefund."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/kdl-radiology-category"
* ^status = #active
* ^experimental = false

* http://dvmd.de/fhir/CodeSystem/kdl#DG020110 "Roentgenbefund"
* http://dvmd.de/fhir/CodeSystem/kdl#DG020103 "CT-Befund"
* http://dvmd.de/fhir/CodeSystem/kdl#DG020107 "MRT-Befund"
* http://dvmd.de/fhir/CodeSystem/kdl#DG020111 "Sonographiebefund"
