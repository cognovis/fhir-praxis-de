// FPDECoverageGKV — GKV-Versicherung mit Wohnortprinzip (WOP)
// AK3: WOP Extension aus de.basisprofil.r4 (http://fhir.de/StructureDefinition/gkv/wop)
// Extension wird NICHT neu definiert — direkt aus Upstream-Paket verwendet

Profile: FPDECoverageGKV
Parent: Coverage
Id: fpde-coverage-gkv
Title: "FPDE Coverage GKV"
Description: "GKV-Versicherung mit Wohnortprinzip (WOP). Erweitert Coverage um die GKV-WOP-Extension aus de.basisprofil.r4."
* extension contains
    http://fhir.de/StructureDefinition/gkv/wop named wop 0..1 MS
