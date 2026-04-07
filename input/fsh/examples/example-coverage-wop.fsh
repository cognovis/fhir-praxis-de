// WOP (Wohnortprinzip) auf Coverage
// AK3: WOP Extension aus de.basisprofil.r4 (http://fhir.de/StructureDefinition/gkv/wop)
// Extension wird NICHT neu definiert — sie kommt direkt aus dem Upstream-Paket

Instance: example-coverage-gkv-wop
InstanceOf: FPDECoverageGKV
Title: "GKV-Coverage mit WOP Nordrhein"
Description: "GKV-Krankenversicherungsabdeckung mit Wohnortprinzip-Extension (WOP=38 Nordrhein) aus de.basisprofil.r4."
Usage: #example
* status = #active
* identifier[KrankenversichertenID].system = "http://fhir.de/sid/gkv/kvid-10"
* identifier[KrankenversichertenID].value = "A123456789"
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #GKV
* type.coding[VersicherungsArtDeBasis].display = "gesetzliche Krankenversicherung"
* beneficiary = Reference(example-patient)
* payor[0].display = "AOK Rheinland/Hamburg"
* extension[wop].url = "http://fhir.de/StructureDefinition/gkv/wop"
* extension[wop].valueCoding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ITA_WOP"
* extension[wop].valueCoding.code = #38
* extension[wop].valueCoding.display = "Nordrhein"

Instance: example-coverage-gkv-wop-west
InstanceOf: FPDECoverageGKV
Title: "GKV-Coverage mit WOP Westfalen-Lippe"
Description: "GKV-Krankenversicherungsabdeckung mit Wohnortprinzip-Extension (WOP=17 Westfalen-Lippe)."
Usage: #example
* status = #active
* identifier[KrankenversichertenID].system = "http://fhir.de/sid/gkv/kvid-10"
* identifier[KrankenversichertenID].value = "B987654321"
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #GKV
* beneficiary = Reference(example-patient)
* payor[0].display = "Techniker Krankenkasse"
* extension[wop].url = "http://fhir.de/StructureDefinition/gkv/wop"
* extension[wop].valueCoding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ITA_WOP"
* extension[wop].valueCoding.code = #17
* extension[wop].valueCoding.display = "Westfalen-Lippe"
