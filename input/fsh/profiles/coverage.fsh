// FPDECoverageGKV — GKV-Versicherung
// Parent: coverage-de-gkv aus de.basisprofil.r4 1.6.0-ballot2
// Die WOP-Extension ist bereits im Parent definiert — keine lokale Neudefinition noetig.

Profile: FPDECoverageGKV
Parent: http://fhir.de/StructureDefinition/coverage-de-gkv
Id: fpde-coverage-gkv
Title: "FPDE Coverage GKV"
Description: "GKV-Versicherung. Basiert auf coverage-de-gkv aus de.basisprofil.r4 (inkl. WOP und KrankenversichertenID)."

Invariant: fpde-coverage-privat-type
Description: "Coverage.type muss eine VersicherungsartDeBasis-Kodierung mit PKV oder SEL enthalten."
Expression: "type.coding.where(system = 'http://fhir.de/CodeSystem/versicherungsart-de-basis').where(code = 'PKV' or code = 'SEL').exists()"
Severity: #error

// FPDECoveragePrivat — PKV-/Selbstzahler-Coverage mit optionaler Fremdabrechnung
// de.basisprofil.r4 1.6.0-ballot2 liefert kein spezialisiertes coverage-de-pkv-Profil.
// Daher leitet dieses Profil direkt vom deutschen Coverage-Basisprofil ab.

Profile: FPDECoveragePrivat
Parent: http://fhir.de/StructureDefinition/coverage-de-basis
Id: fpde-coverage-privat
Title: "FPDE Coverage Privat"
Description: "Privat oder selbst zu zahlendes Versicherungsverhaeltnis. Die Coverage ist der Routing-Anker fuer optionale Fremdabrechnung via PVS/Billing Service."

* obeys fpde-coverage-privat-type

* extension contains BillingAssignmentExt named billingAssignment 0..1 MS
* extension[billingAssignment] ^short = "Coverage-spezifische Forderungsabtretung an eine PVS"
* extension[billingAssignment] ^definition = "Referenz auf die Organization (PVS/Billing Service), an die Forderungen aus genau diesem Versicherungsverhaeltnis abgetreten werden."

* type 1..1 MS
* type.coding ^slicing.discriminator.type = #value
* type.coding ^slicing.discriminator.path = "system"
* type.coding ^slicing.rules = #open
* type.coding contains VersicherungsArtDeBasis 1..1 MS
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].system MS
* type.coding[VersicherungsArtDeBasis].code 1..1 MS
* type.coding[VersicherungsArtDeBasis].display MS

* beneficiary 1..1 MS
* subscriber MS
* payor MS
* payor.display MS
