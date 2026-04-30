// EncounterPraxis — Abrechnungsschein-Profil der deutschen Praxisverwaltung
// Modelliert den Schein als FHIR Encounter mit Scheinart-Slicing auf Encounter.type.
// Slice 1 (kbv-scheinart):   KBV KVDT-Scheinart-Codes (amtliche Schluessel)
// Slice 2 (praxis-scheinart): PVS-interne Scheinart-Codes (ScheinartCS)

Profile: EncounterPraxis
Parent: Encounter
Id: encounter-praxis
Title: "Encounter Praxis"
Description: "Abrechnungsschein in der ambulanten Praxisverwaltung. Bildet den Schein (GKV/PKV/BG/IGeL) als FHIR Encounter ab. Encounter.type tragt die Scheinart in zwei Slices: KBV SFHIR-Schluesseltabelle und PVS-interne Kodierung."

// Identifier: Schein-Nummer (mandatory)
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains scheinNummer 1..1 MS
* identifier[scheinNummer].system 1..1 MS
* identifier[scheinNummer].system = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* identifier[scheinNummer].value 1..1 MS

// Status: Pflicht
* status 1..1 MS

// Class: ambulant / stationaer / Notfall (v3-ActCode)
* class 1..1 MS
* class from http://terminology.hl7.org/ValueSet/v3-ActEncounterCode (extensible)

// Type: Scheinart-Slicing
* type MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.system"
* type ^slicing.rules = #open
* type ^short = "Scheinart (KBV SFHIR und/oder PVS-intern)"

* type contains
    kbv-scheinart 0..1 MS and
    praxis-scheinart 0..1 MS

* type[kbv-scheinart] ^short = "Scheinart gemaess KBV SFHIR Schluessel KBV_VS_SFHIR_KBV_SCHEINART"
* type[kbv-scheinart] ^definition = "Amtliche KBV-Scheinart-Kodierung aus der KVDT-Schluessel­tabelle S_KBV_SCHEINART."
* type[kbv-scheinart].coding 1..* MS
* type[kbv-scheinart].coding.system 1..1 MS
* type[kbv-scheinart].coding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* type[kbv-scheinart].coding.code 1..1 MS
* type[kbv-scheinart].coding from https://fhir.kbv.de/ValueSet/KBV_VS_SFHIR_KBV_SCHEINART (required)

* type[praxis-scheinart] ^short = "PVS-interne Scheinart (ScheinartCS)"
* type[praxis-scheinart] ^definition = "PVS-eigene Scheinart-Kodierung (gkv, pkv, bg, ue, not, igel)."
* type[praxis-scheinart].coding 1..* MS
* type[praxis-scheinart].coding.system 1..1 MS
* type[praxis-scheinart].coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/scheinart"
* type[praxis-scheinart].coding.code 1..1 MS
* type[praxis-scheinart].coding from https://fhir.cognovis.de/praxis/ValueSet/scheinart (required)

// ServiceType: Behandlungsart (optional)
* serviceType 0..1 MS
* serviceType ^short = "Behandlungsart / Leistungsbereich"

// Subject: Patient (Pflicht)
* subject 1..1 MS
* subject only Reference(Patient)

// Period: Behandlungszeitraum
* period MS
* period.start MS

// Participant: Behandelnder Arzt
* participant MS
* participant.individual MS
* participant.individual only Reference(Practitioner or PractitionerRole)
