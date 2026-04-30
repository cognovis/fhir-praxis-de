// Imaging Workflow Beispiele — MRT-Termin Knie Kombiniertes Szenario
// Drei Profile: ImagingServiceRequestPraxisDe, ImagingAppointmentPraxisDe, ImagingDevicePraxisDe
// Zusaetzliche Hilfsinstanzen: MTR-Practitioner, Prior-ImagingStudy
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $dcm = http://dicom.nema.org/resources/ontology/DCM
Alias: $icd10gm = http://fhir.de/CodeSystem/bfarm/icd-10-gm
Alias: $loinc = http://loinc.org
Alias: $device-maintenance-status = https://fhir.cognovis.de/praxis/CodeSystem/device-maintenance-status
Alias: $appointment-readiness = https://fhir.cognovis.de/praxis/CodeSystem/appointment-readiness

// --- Hilfsinstanz: MTR (Medizinisch-Technische-Radiologieassistentin) ---
Instance: example-practitioner-mtr-knie
InstanceOf: Practitioner
Title: "Sabine Bauer — MTR (MRT Knie)"
Description: "Medizinisch-Technische-Radiologieassistentin fuer den MRT-Knie-Termin."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Bauer"
* name[0].given[0] = "Sabine"

// --- Hilfsinstanz: Prior-ImagingStudy (Vergleichsaufnahme) ---
Instance: example-prior-imaging-study-knie
InstanceOf: ImagingStudy
Title: "ImagingStudy: Prior MRT Knie (Vergleich)"
Description: "Vorherige MRT-Studie des linken Knies fuer Vergleichsbefundung."
Usage: #example
* status = #available
* subject = Reference(example-patient)
* modality[0].system = "http://dicom.nema.org/resources/ontology/DCM"
* modality[0].code = #MR

// --- ImagingDevicePraxisDe: MRT-Geraet ---
Instance: example-imaging-device-mrt-knie
InstanceOf: ImagingDevicePraxisDe
Title: "ImagingDevice: MRT-Geraet Knie"
Description: "MRT-Geraet (3T Siemens Magnetom) fuer den MRT-Knie-Termin. DICOM AE-Title: MRT_KNIE_001."
Usage: #example
* status = #active
* identifier[aeTitle].system = "https://fhir.cognovis.de/praxis/NamingSystem/dicom-ae-title"
* identifier[aeTitle].value = "MRT_KNIE_001"
* deviceName[0].name = "MAGNETOM Vida 3T"
* deviceName[0].type = #manufacturer-name
* manufacturer = "Siemens Healthineers"
* modelNumber = "MAGNETOM Vida"
* type.coding[0].system = "http://dicom.nema.org/resources/ontology/DCM"
* type.coding[0].code = #MR
* type.coding[0].display = "Magnetic Resonance"
* extension[deviceMaintenanceStatus].valueCoding.system = "https://fhir.cognovis.de/praxis/CodeSystem/device-maintenance-status"
* extension[deviceMaintenanceStatus].valueCoding.code = #in-service
* extension[deviceMaintenanceStatus].valueCoding.display = "In Service"

// --- Coverage Hilfsinstanz fuer ServiceRequest ---
Instance: example-coverage-gkv-knie
InstanceOf: FPDECoverageGKV
Title: "GKV-Versicherung Weber (MRT-Knie Szenario)"
Description: "GKV-Versicherung fuer Thomas Weber, AOK Bayern, fuer das MRT-Knie-Szenario."
Usage: #example
* status = #active
* subscriber = Reference(example-patient)
* beneficiary = Reference(example-patient)
* payor[0].display = "AOK Bayern"

// --- ImagingServiceRequestPraxisDe: MRT-Knie Untersuchungsauftrag ---
Instance: example-imaging-service-request-mrt-knie
InstanceOf: ImagingServiceRequestPraxisDe
Title: "ImagingServiceRequest: MRT Knie (Weber)"
Description: "Bildgebungsauftrag MRT linkes Knie fuer Thomas Weber. Indikation: M23.2 ICD-10-GM. Prior-Study als supportingInfo. GKV-Coverage."
Usage: #example
* status = #active
* intent = #order
* identifier[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/pvs-id"
* identifier[0].value = "SR-MRT-KNIE-2026-001"
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #36803-5
* code.coding[0].display = "MRI of knee"
* subject = Reference(example-patient)
* requester = Reference(example-practitioner)
* reasonCode[icd10gm][0].coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[icd10gm][0].coding[0].code = #M23.2
* reasonCode[icd10gm][0].coding[0].display = "Meniskusschaden durch altes Trauma"
* insurance[0] = Reference(example-coverage-gkv-knie)
* supportingInfo[0] = Reference(example-prior-imaging-study-knie)
* priority = #routine

// --- ImagingAppointmentPraxisDe: MRT-Knie Termin ---
Instance: example-imaging-appointment-mrt-knie
InstanceOf: ImagingAppointmentPraxisDe
Title: "ImagingAppointment: MRT Knie (Weber)"
Description: "Bildgebungstermin MRT linkes Knie fuer Thomas Weber. Modalitaet MR, Geraet MRT_KNIE_001, MTR Sabine Bauer."
Usage: #example
* status = #booked
* serviceType[0].coding[0].system = "http://loinc.org"
* serviceType[0].coding[0].code = #36803-5
* serviceType[0].coding[0].display = "MRI of knee"
* start = "2026-05-10T10:00:00+02:00"
* end = "2026-05-10T10:45:00+02:00"
* basedOn[0] = Reference(example-imaging-service-request-mrt-knie)

// AppointmentModalityExt: Modalitaet MR + Device-Referenz
* extension[appointmentModality].extension[modality].valueCoding.system = "http://dicom.nema.org/resources/ontology/DCM"
* extension[appointmentModality].extension[modality].valueCoding.code = #MR
* extension[appointmentModality].extension[modality].valueCoding.display = "Magnetic Resonance"
* extension[appointmentModality].extension[device].valueReference = Reference(example-imaging-device-mrt-knie)

// AppointmentPreparationExt: Vorbereitung 15min, Recovery 5min, Patientenhinweis
* extension[appointmentPreparation].extension[prepDuration].valueDuration.value = 15
* extension[appointmentPreparation].extension[prepDuration].valueDuration.unit = "min"
* extension[appointmentPreparation].extension[prepDuration].valueDuration.system = "http://unitsofmeasure.org"
* extension[appointmentPreparation].extension[prepDuration].valueDuration.code = #min
* extension[appointmentPreparation].extension[recoveryDuration].valueDuration.value = 5
* extension[appointmentPreparation].extension[recoveryDuration].valueDuration.unit = "min"
* extension[appointmentPreparation].extension[recoveryDuration].valueDuration.system = "http://unitsofmeasure.org"
* extension[appointmentPreparation].extension[recoveryDuration].valueDuration.code = #min
* extension[appointmentPreparation].extension[patientInstruction].valueString = "Bitte keine metallischen Gegenstaende mitbringen. Kontrastmittel-Allergieanamnese erforderlich."

// AppointmentReadinessExt: Bereitschaftsstatus
* extension[appointmentReadiness].valueCoding.system = "https://fhir.cognovis.de/praxis/CodeSystem/appointment-readiness"
* extension[appointmentReadiness].valueCoding.code = #preparation-complete
* extension[appointmentReadiness].valueCoding.display = "Preparation Complete"

// Participant Slicing: Modalitaets-Geraet und MTR
* participant[modalityDevice].actor = Reference(example-imaging-device-mrt-knie)
* participant[modalityDevice].status = #accepted
* participant[mtrPractitioner].actor = Reference(example-practitioner-mtr-knie)
* participant[mtrPractitioner].status = #accepted
