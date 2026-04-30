// ImagingStudyPraxisDe Beispiele
// Beispiel 1: MRT Knie Links mit KM-Gabe (Gadolinium intravenoese)
// Beispiel 2: CT Abdomen ohne KM
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $dcm = http://dicom.nema.org/resources/ontology/DCM
Alias: $sct = http://snomed.info/sct
Alias: $atc = http://www.whocc.no/atc

// --- Hilfsinstanz: Ueberweisender Arzt ---
// Wird in beiden ImagingStudy-Beispielen als referrer verwendet.
Instance: example-practitioner-referring
InstanceOf: Practitioner
Title: "Dr. Klaus Schmidt — Ueberweisender Hausarzt"
Description: "Ueberweisender Hausarzt fuer Bildgebungs-Beispiele. Referrer-Pflichtfeld fuer KV-Abrechnungs-Tracking."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Schmidt"
* name[0].given[0] = "Klaus"
* name[0].prefix[0] = "Dr."

// --- Hilfsinstanz: WADO-RS Endpunkt ---
Instance: example-endpoint-wado-rs
InstanceOf: Endpoint
Title: "WADO-RS Endpunkt Radiologie"
Description: "DICOM WADO-RS Verbindungsendpunkt fuer den Abruf von Bildmaterial aus dem PACS."
Usage: #example
* status = #active
* connectionType.system = "http://terminology.hl7.org/CodeSystem/endpoint-connection-type"
* connectionType.code = #dicom-wado-rs
* connectionType.display = "DICOM WADO-RS"
* name = "PACS WADO-RS Endpunkt"
* payloadType[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/endpoint-payload-type"
* payloadType[0].coding[0].code = #any
* payloadType[0].coding[0].display = "Any"
* address = "https://pacs.example.org/wado/rs"

// ============================================================
// Beispiel 1: MRT Knie Links mit KM-Gabe (Gadolinium)
// ============================================================
// Modalitaet: MR — DICOM CID 29
// Koerperregion: Knie (SNOMED 72696002)
// Lateralitaet: Links (SNOMED 7771000)
// KM: Gadolinium (ATC V08CA01 = Gadopentetic acid / Gadopentetate dimeglumine = Magnevist), 15 ml iv
// Technik: TR=800ms, TE=15ms, Schichtdicke=3mm
// Referrer: Dr. Klaus Schmidt (Pflicht fuer KV-Abrechnung)
Instance: example-imaging-study-mrt-knie-km
InstanceOf: ImagingStudyPraxisDe
Title: "ImagingStudy: MRT Knie Links mit KM-Gabe"
Description: "MRT-Studie des linken Knies mit intravenoese Gadolinium-KM-Gabe. Vollstaendige Demonstration des ImagingStudyPraxisDe Profils mit KM-Extension und Technikparametern."
Usage: #example
* status = #available
* subject = Reference(example-patient)
* started = "2026-04-30T10:00:00+02:00"

// Modalitaet: MRT (DICOM CID 29)
* modality[0].system = "http://dicom.nema.org/resources/ontology/DCM"
* modality[0].code = #MR
* modality[0].display = "Magnetic Resonance"

// Referrer: Ueberweisender Arzt (1..1 Pflicht fuer KV-Abrechnung)
* referrer = Reference(example-practitioner-referring) "Dr. Klaus Schmidt"

// WADO-RS Endpoint
* endpoint[0] = Reference(example-endpoint-wado-rs)

// KM-Gabe Extension: Gadolinium intravenoese, 15 ml
* extension[kmAdministration].extension[administered].valueBoolean = true
* extension[kmAdministration].extension[agent-atc].valueCodeableConcept.coding[0].system = "http://www.whocc.no/atc"
* extension[kmAdministration].extension[agent-atc].valueCodeableConcept.coding[0].code = #V08CA01
* extension[kmAdministration].extension[agent-atc].valueCodeableConcept.coding[0].display = "Gadopentetic acid"
* extension[kmAdministration].extension[agent-name].valueString = "Magnevist 0,5 mmol/ml"
* extension[kmAdministration].extension[dose-ml].valueQuantity.value = 15
* extension[kmAdministration].extension[dose-ml].valueQuantity.unit = "mL"
* extension[kmAdministration].extension[dose-ml].valueQuantity.system = "http://unitsofmeasure.org"
* extension[kmAdministration].extension[dose-ml].valueQuantity.code = #mL
* extension[kmAdministration].extension[route].valueCodeableConcept.coding[0].system = "http://snomed.info/sct"
* extension[kmAdministration].extension[route].valueCodeableConcept.coding[0].code = #47625008
* extension[kmAdministration].extension[route].valueCodeableConcept.coding[0].display = "Intravenous route"
* extension[kmAdministration].extension[goae-reference].valueReference = Reference(example-charge-item-def-goae-km)

// Serie 0: MRT Knie Links — sagittale PD-Sequenz
* series[0].uid = "2.16.840.1.113883.19.5.99.1.1"
* series[0].number = 1
* series[0].modality.system = "http://dicom.nema.org/resources/ontology/DCM"
* series[0].modality.code = #MR
* series[0].modality.display = "Magnetic Resonance"
* series[0].description = "SAG PD FS Knie Links"
* series[0].bodySite.system = "http://snomed.info/sct"
* series[0].bodySite.code = #72696002
* series[0].bodySite.display = "Knee region structure"
* series[0].laterality.system = "http://snomed.info/sct"
* series[0].laterality.code = #7771000
* series[0].laterality.display = "Left"

// Technikparameter: MRT-Sequenz-Parameter
* series[0].extension[techniqueParameter].extension[tr-ms].valueDecimal = 800
* series[0].extension[techniqueParameter].extension[te-ms].valueDecimal = 15
* series[0].extension[techniqueParameter].extension[slice-thickness-mm].valueDecimal = 3.0

// Pflichtfeld IPS: mindestens eine Instanz pro Serie
* series[0].instance[0].uid = "2.16.840.1.113883.19.5.99.1.1.1"
* series[0].instance[0].sopClass.system = "urn:ietf:rfc:3986"
* series[0].instance[0].sopClass.code = #urn:oid:1.2.840.10008.5.1.4.1.1.4

// --- Hilfsinstanz: GOAe ChargeItemDefinition fuer Gadolinium KM-Gabe ---
Instance: example-charge-item-def-goae-km
InstanceOf: ChargeItemDefinition
Title: "GOAe 5730 — Gadolinium KM-Gabe"
Description: "GOAe Ziffer 5730 fuer die Gabe von gadoliniumhaltigen Kontrastmitteln bei MRT-Untersuchungen."
Usage: #example
* url = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/goae-5730"
* status = #active
* code.coding[0].system = "https://fhir.de/CodeSystem/bak/goae"
* code.coding[0].code = #5730
* code.coding[0].display = "Gadolinium-haltige Kontrastmittelgabe MRT"

// ============================================================
// Beispiel 2: CT Abdomen ohne KM
// ============================================================
// Modalitaet: CT — DICOM CID 29
// Koerperregion: Abdomen (SNOMED 818983003)
// Keine Lateralitaet (Rumpf)
// Kein KM
// Technik: kV=120, mAs=200, Schichtdicke=5mm
// Referrer: Dr. Klaus Schmidt (Pflicht fuer KV-Abrechnung)
Instance: example-imaging-study-ct-abdomen
InstanceOf: ImagingStudyPraxisDe
Title: "ImagingStudy: CT Abdomen ohne KM"
Description: "CT-Studie des Abdomens ohne Kontrastmittel-Gabe. Demonstration des ImagingStudyPraxisDe Profils mit CT-Technikparametern (kV, mAs)."
Usage: #example
* status = #available
* subject = Reference(example-patient)
* started = "2026-04-30T09:00:00+02:00"

// Modalitaet: CT (DICOM CID 29)
* modality[0].system = "http://dicom.nema.org/resources/ontology/DCM"
* modality[0].code = #CT
* modality[0].display = "Computed Tomography"

// Referrer: Ueberweisender Arzt (1..1 Pflicht fuer KV-Abrechnung)
* referrer = Reference(example-practitioner-referring) "Dr. Klaus Schmidt"

// WADO-RS Endpoint
* endpoint[0] = Reference(example-endpoint-wado-rs)

// Serie 0: CT Abdomen — Nativ ohne KM
* series[0].uid = "2.16.840.1.113883.19.5.99.2.1"
* series[0].number = 1
* series[0].modality.system = "http://dicom.nema.org/resources/ontology/DCM"
* series[0].modality.code = #CT
* series[0].modality.display = "Computed Tomography"
* series[0].description = "CT Abdomen nativ"
* series[0].bodySite.system = "http://snomed.info/sct"
* series[0].bodySite.code = #818983003
* series[0].bodySite.display = "Abdomen"

// Technikparameter: CT-Aufnahme-Parameter
* series[0].extension[techniqueParameter].extension[kv].valueDecimal = 120
* series[0].extension[techniqueParameter].extension[mas].valueDecimal = 200
* series[0].extension[techniqueParameter].extension[slice-thickness-mm].valueDecimal = 5.0

// Pflichtfeld IPS: mindestens eine Instanz pro Serie
* series[0].instance[0].uid = "2.16.840.1.113883.19.5.99.2.1.1"
* series[0].instance[0].sopClass.system = "urn:ietf:rfc:3986"
* series[0].instance[0].sopClass.code = #urn:oid:1.2.840.10008.5.1.4.1.1.2
