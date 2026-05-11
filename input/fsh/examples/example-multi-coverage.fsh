// Multi-Coverage Linking Pattern Examples
// Three bundles demonstrating the Account.coverage.priority pattern for German multi-payer scenarios.
//
// NOTE: Coverage.order is constrained to max=0 in de.basisprofil.r4 (coverage-de-gkv and coverage-de-basis).
// Therefore Account.coverage.priority is the correct FHIR mechanism for ordering multiple coverages.
// Coverage.subrogation (0..1, FHIR R4 base, not restricted by de.basisprofil.r4) remains available and is used for Beihilfe scenarios.
//
// Bundle 1: ZE (Zahnersatz) — GKV (primary, priority=1) + ZZV/PKV (secondary, priority=2)
// Bundle 2: KFO (Kieferorthopadie) — GKV (primary, priority=1) + PKV-Zusatz (secondary, priority=2)
// Bundle 3: Beamter — PKV (primary, priority=1) + Beihilfe/SKT (secondary, priority=2, subrogation=true)

// ============================================================
// Bundle 1: Zahnersatz (ZE) — GKV + ZZV
// ============================================================

Instance: ExampleCoverageGkvZe
InstanceOf: FPDECoverageGKV
Title: "GKV-Coverage — Zahnersatz (primary)"
Description: "GKV-Versicherung fuer Zahnersatz-Abrechnung. Primaerer Kostentraeger (Account.coverage.priority=1)."
Usage: #example
* status = #active
* identifier[KrankenversichertenID].system = "http://fhir.de/sid/gkv/kvid-10"
* identifier[KrankenversichertenID].value = "A123456789"
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #GKV
* type.coding[VersicherungsArtDeBasis].display = "gesetzliche Krankenversicherung"
* beneficiary = Reference(example-patient)
* payor[0].display = "TK - Techniker Krankenkasse"
* extension[wop].url = "http://fhir.de/StructureDefinition/gkv/wop"
* extension[wop].valueCoding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ITA_WOP"
* extension[wop].valueCoding.code = #38
* extension[wop].valueCoding.display = "Nordrhein"

Instance: ExampleCoverageZzvZe
InstanceOf: FPDECoveragePrivat
Title: "ZZV-Coverage — Zahnzusatzversicherung (secondary)"
Description: "Private Zahnzusatzversicherung fuer Zahnersatz-Anteil. Sekundaerer Kostentraeger (Account.coverage.priority=2)."
Usage: #example
* status = #active
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #PKV
* type.coding[VersicherungsArtDeBasis].display = "private Krankenversicherung"
* beneficiary = Reference(example-patient)
* payor[0].display = "DKV Zahnzusatzversicherung Premium"

Instance: ExampleAccountZe
InstanceOf: Account
Title: "Abrechnungskonto ZE — GKV primary, ZZV secondary"
Description: "Account mit zwei Kostentraegern fuer Zahnersatz: GKV primaer (priority=1), ZZV sekundaer (priority=2). Account.coverage.priority steuert die Abrechnungsreihenfolge, da Coverage.order in de.basisprofil.r4 nicht verfuegbar ist."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#PBILLACCT "patient billing account"
* subject[0] = Reference(example-patient)
* coverage[0].coverage = Reference(ExampleCoverageGkvZe)
* coverage[0].priority = 1
* coverage[1].coverage = Reference(ExampleCoverageZzvZe)
* coverage[1].priority = 2

Instance: ExampleBundleZeMultiCoverage
InstanceOf: Bundle
Title: "Multi-Coverage Bundle: ZE GKV + ZZV"
Description: "Beispiel-Bundle fuer Zahnersatz-Szenario mit GKV als primaeren und ZZV als sekundaeren Kostentraeger. Account.coverage.priority steuert die Abrechnungsreihenfolge."
Usage: #example
* type = #collection
* entry[+].fullUrl = "urn:uuid:example-patient"
* entry[=].resource = example-patient
* entry[+].fullUrl = "urn:uuid:ExampleCoverageGkvZe"
* entry[=].resource = ExampleCoverageGkvZe
* entry[+].fullUrl = "urn:uuid:ExampleCoverageZzvZe"
* entry[=].resource = ExampleCoverageZzvZe
* entry[+].fullUrl = "urn:uuid:ExampleAccountZe"
* entry[=].resource = ExampleAccountZe

// ============================================================
// Bundle 2: Kieferorthopadie (KFO) — GKV + PKV-Zusatz
// ============================================================

Instance: ExamplePatientKfo
InstanceOf: FPDEPatient
Title: "Anna Mueller — GKV-Patientin mit PKV-Zusatz"
Description: "GKV-Patientin mit privater Zusatzversicherung fuer den KFO-Eigenanteil."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Mueller"
* name[0].given[0] = "Anna"
* gender = #female
* birthDate = "1990-03-22"

Instance: ExampleCoverageGkvKfo
InstanceOf: FPDECoverageGKV
Title: "GKV-Coverage — KFO (primary)"
Description: "GKV-Versicherung fuer KFO-Abrechnung. Primaerer Kostentraeger (Account.coverage.priority=1)."
Usage: #example
* status = #active
* identifier[KrankenversichertenID].system = "http://fhir.de/sid/gkv/kvid-10"
* identifier[KrankenversichertenID].value = "B234567890"
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #GKV
* type.coding[VersicherungsArtDeBasis].display = "gesetzliche Krankenversicherung"
* beneficiary = Reference(ExamplePatientKfo)
* payor[0].display = "AOK Bayern"
* extension[wop].url = "http://fhir.de/StructureDefinition/gkv/wop"
* extension[wop].valueCoding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ITA_WOP"
* extension[wop].valueCoding.code = #72
* extension[wop].valueCoding.display = "Bayern"

Instance: ExampleCoveragePkvZusatzKfo
InstanceOf: FPDECoveragePrivat
Title: "PKV-Zusatz-Coverage — KFO Anteil (secondary)"
Description: "Private Zusatzversicherung fuer den ueber den GKV-Festzuschuss hinausgehenden KFO-Anteil. Sekundaerer Kostentraeger (Account.coverage.priority=2)."
Usage: #example
* status = #active
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #PKV
* type.coding[VersicherungsArtDeBasis].display = "private Krankenversicherung"
* beneficiary = Reference(ExamplePatientKfo)
* payor[0].display = "ERGO KFO-Zusatzversicherung"

Instance: ExampleAccountKfo
InstanceOf: Account
Title: "Abrechnungskonto KFO — GKV primary, PKV-Zusatz secondary"
Description: "Account mit zwei Kostentraegern fuer KFO: GKV primaer (priority=1), PKV-Zusatz sekundaer (priority=2)."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#PBILLACCT "patient billing account"
* subject[0] = Reference(ExamplePatientKfo)
* coverage[0].coverage = Reference(ExampleCoverageGkvKfo)
* coverage[0].priority = 1
* coverage[1].coverage = Reference(ExampleCoveragePkvZusatzKfo)
* coverage[1].priority = 2

Instance: ExampleBundleKfoMultiCoverage
InstanceOf: Bundle
Title: "Multi-Coverage Bundle: KFO GKV + PKV-Zusatz"
Description: "Beispiel-Bundle fuer KFO-Szenario mit GKV als primaeren und PKV-Zusatzversicherung als sekundaeren Kostentraeger."
Usage: #example
* type = #collection
* entry[+].fullUrl = "urn:uuid:ExamplePatientKfo"
* entry[=].resource = ExamplePatientKfo
* entry[+].fullUrl = "urn:uuid:ExampleCoverageGkvKfo"
* entry[=].resource = ExampleCoverageGkvKfo
* entry[+].fullUrl = "urn:uuid:ExampleCoveragePkvZusatzKfo"
* entry[=].resource = ExampleCoveragePkvZusatzKfo
* entry[+].fullUrl = "urn:uuid:ExampleAccountKfo"
* entry[=].resource = ExampleAccountKfo

// ============================================================
// Bundle 3: Beamter — PKV (primary) + Beihilfe (secondary, subrogation)
// ============================================================

Instance: ExamplePatientBeamter
InstanceOf: FPDEPatient
Title: "Klaus Schneider — Beamter (PKV + Beihilfe)"
Description: "Verbeamteter Lehrer mit privater Krankenversicherung und Beihilfeanspruch."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Schneider"
* name[0].given[0] = "Klaus"
* gender = #male
* birthDate = "1968-11-05"

Instance: ExampleCoveragePkvBeamter
InstanceOf: FPDECoveragePrivat
Title: "PKV-Coverage — Beamter (primary)"
Description: "Privatkrankenversicherung des Beamten. Primaerer Kostentraeger (Account.coverage.priority=1)."
Usage: #example
* status = #active
* type.coding[VersicherungsArtDeBasis].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[VersicherungsArtDeBasis].code = #PKV
* type.coding[VersicherungsArtDeBasis].display = "private Krankenversicherung"
* beneficiary = Reference(ExamplePatientBeamter)
* payor[0].display = "Allianz Private Krankenversicherung"

// NOTE: ExampleCoverageBeihilfe uses coverage-de-basis directly (NOT FPDECoveragePrivat)
// because the fpde-coverage-privat-type invariant only allows PKV or SEL.
// Beihilfe must use type=SKT (Sonstige Kostentraeger) as there is no dedicated Beihilfe code
// in the versicherungsart-de-basis CodeSystem.
Instance: ExampleCoverageBeihilfe
InstanceOf: http://fhir.de/StructureDefinition/coverage-de-basis
Title: "Beihilfe-Coverage (secondary, subrogation)"
Description: "Beihilfeanspruch des Beamten. Sekundaerer Kostentraeger (Account.coverage.priority=2). subrogation=true als pragmatisches Marker-Flag fuer das koordinierte Leistungsverhaeltnis (Beihilfe und PKV sind parallele Zahler). Typ=SKT (Sonstige Kostentraeger), da kein dedizierter Beihilfe-Code im CodeSystem versicherungsart-de-basis existiert."
Usage: #example
* status = #active
* subrogation = true
* type.coding[0].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[0].code = #SKT
* type.coding[0].display = "Sonstige Kostentraeger (Beihilfe)"
* beneficiary = Reference(ExamplePatientBeamter)
* payor[0].display = "Beihilfestelle Land Baden-Wuerttemberg"

Instance: ExampleAccountBeihilfe
InstanceOf: Account
Title: "Abrechnungskonto — PKV primary, Beihilfe secondary"
Description: "Account mit zwei Kostentraegern fuer Beamten-Szenario: PKV primaer (priority=1), Beihilfe sekundaer (priority=2, subrogation=true auf der Coverage)."
Usage: #example
* status = #active
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#PBILLACCT "patient billing account"
* subject[0] = Reference(ExamplePatientBeamter)
* coverage[0].coverage = Reference(ExampleCoveragePkvBeamter)
* coverage[0].priority = 1
* coverage[1].coverage = Reference(ExampleCoverageBeihilfe)
* coverage[1].priority = 2

Instance: ExampleBundleBeihilfeMultiCoverage
InstanceOf: Bundle
Title: "Multi-Coverage Bundle: PKV + Beihilfe"
Description: "Beispiel-Bundle fuer Beamten-Szenario mit PKV als primaeren und Beihilfe als sekundaeren Kostentraeger (subrogation=true auf der Beihilfe-Coverage)."
Usage: #example
* type = #collection
* entry[+].fullUrl = "urn:uuid:ExamplePatientBeamter"
* entry[=].resource = ExamplePatientBeamter
* entry[+].fullUrl = "urn:uuid:ExampleCoveragePkvBeamter"
* entry[=].resource = ExampleCoveragePkvBeamter
* entry[+].fullUrl = "urn:uuid:ExampleCoverageBeihilfe"
* entry[=].resource = ExampleCoverageBeihilfe
* entry[+].fullUrl = "urn:uuid:ExampleAccountBeihilfe"
* entry[=].resource = ExampleAccountBeihilfe
