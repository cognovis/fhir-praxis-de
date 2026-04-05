# Profiles

This Implementation Guide is currently **extension-focused**. It does not define custom StructureDefinition profiles with constraints, but instead provides a rich set of extensions and terminology that apply to standard FHIR R4 resources and existing German base profiles.

Future versions may introduce constrained profiles where invariants or slicing are needed. For now, the IG provides extensions and code systems that any PVS adapter can apply to the following base resources.

## Extended Resources by Domain

### Billing / Abrechnung

| Resource | Usage | Key Extensions |
|----------|-------|----------------|
| **ChargeItem** | Individual billable service (EBM-Ziffer, GOÄ-Leistung) | BillingSystem, BillingCode, BillingPoints, Faktor, GoaeFaktor, LeistungsdatumExt |
| **ChargeItemDefinition** | Billing catalog entry (EBM/GOÄ catalog) | MultiplierMin/Default/Max, BillingRequirements, BillingExclusions, BillingPruefzeit, BillingFachgruppen |
| **Claim** | Submitted billing claim per Schein | AbrechnungsquartalExt, ScheinPositionExt, RabStatusExt |
| **ClaimResponse** | KV response to submitted claims | HonorarbescheidCorrectionSign |
| **Account** | Offene Posten / accounts receivable | RechnungsbetragExt, MahnstufeExt, FaelligkeitsdatumExt |

### Budget / RLV

| Resource | Usage | Key Extensions |
|----------|-------|----------------|
| **Contract** | RLV/QZV budget allocation per quarter | RlvFallwert, RlvZugewiesen, RlvEntbudgetiert, RlvKategorie |
| **Basic** | KV benchmark data (Fachgruppen-Durchschnittswerte) | KvBenchmarkRlvFallwertAk1/2/3, KvBenchmarkDurchschnittFallzahl |

### Remittance / Honorarbescheid

| Resource | Usage | Key Extensions |
|----------|-------|----------------|
| **PaymentReconciliation** | KV quarterly payment statement | HonorarbescheidQuartal, HonorarbescheidBsnr |
| **ClaimResponse** | Individual line-item corrections | HonorarbescheidCorrectionSign |

### Clinical

| Resource | Usage | Key Extensions |
|----------|-------|----------------|
| **Encounter** | Patient visit with queue management | ArrivalTimeExt, EncounterCalledExt, ScheintypExt |
| **Condition** | Diagnoses with German-specific metadata | DauerdiagnoseExt, DiagnoseSeiteExt |
| **ServiceRequest** | Überweisungen (referrals) | UeFachrichtungExt, ReferralSugTypeExt, ReferralOptimizationStatusExt |
| **Communication** | Einweisungen (hospital admissions) | KheKrankenhausExt, KheDiagnoseExt, KheBelegarztExt |
| **CareTeam** | Treatment team (interdisciplinary care coordination) | — |
| **[ProcedureAmbulantDE](StructureDefinition-procedure-ambulant-de.html)** | Ambulante Eingriffe mit OPS-Kodierung | — (OPS via CodingOPS from de.basisprofil.r4) |
| **[PraxisSpecimen](StructureDefinition-praxis-specimen.html)** | Probenmaterial für xDT-Adapter (LDT/GDT) | — (SNOMED-CT + optional LDT-Code) |

### Administrative

| Resource | Usage | Key Extensions |
|----------|-------|----------------|
| **[FPDEPatient](StructureDefinition-fpde-patient.html)** | Patient demographics with maiden name and district support | humanname-own-name, iso21090-ADXP-precinct |
| **Provenance** | AI provenance tracking (EU AI Act) | AiGeneratedExt, AiModelExt, HumanReviewedExt |
| **[FPDECoverageGKV](StructureDefinition-fpde-coverage-gkv.html)** | GKV insurance with Wohnortprinzip (WOP) | gkv/wop |
| **PractitionerRole** | WB-Assistent / Sicherstellungsassistent | WbRolleExt, WbAbrechnenderArztExt |
| **Consent** | Patient consent management | EinwilligungKuerzelExt, EinwilligungTextExt, EinwilligungWiderrufMoeglichExt |

## PraxisCondition — ICD-10-GM mit Diagnosesicherheit

The `PraxisCondition` profile extends the base FHIR `Condition` resource to standardize diagnosis recording in German ambulatory practice with mandatory KV billing requirements (KVDT 6.06).

### Core Elements

| Element | Cardinality | Notes |
|---------|-------------|-------|
| `code` | 1..1 | Must-Support. ICD-10-GM coding from BFARM CodeSystem. |
| `code.coding[icd10gm]` | 1..* | Sliced by system. Must include at least one ICD-10-GM coding. |
| `code.coding[icd10gm].extension[diagnosesicherheit]` | 0..1 | Must-Support. Upstream extension binding to KBV_VS_SFHIR_ICD_DIAGNOSESICHERHEIT (A/G/V/Z). **Required by KV for billing claims.** |
| `clinicalStatus` | 0..1 | Must-Support. Active, recurrence, remission, resolved. |
| `verificationStatus` | 0..1 | Must-Support. Unconfirmed, provisional, differential, confirmed, refuted, entered-in-error. |
| `subject` | 1..1 | Reference(Patient). The patient who has the condition. |

### Praxis Extensions

| Extension | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| `dauerdiagnose` | boolean | 0..1 | Must-Support. Marks chronic/persistent diagnoses that auto-roll to next quarters. |
| `diagnoseSeite` | CodeableConcept | 0..1 | Must-Support. Side specification (links/rechts/beidseitig). Binds to DiagnoseSeiteVS. Complements KBV bodySite coding. |

### ICD-10-GM Diagnosesicherheit (KVDT 6.06 Compliance)

The KV requires all diagnoses submitted in billing claims to carry a diagnosesicherheit code:

| Code | Meaning | Clinical Status | Verification Status |
|------|---------|-----------------|-------------------|
| **G** | Gesichert (Confirmed) | active / resolved / remission | confirmed |
| **A** | Ausschluss (Ruled out) | — | refuted |
| **V** | Verdacht (Suspected) | active / provisional | provisional |
| **Z** | Zustand nach (History of) | resolved | confirmed |

PVS systems must extract and populate this extension on every diagnosis before sending the claim to the KV. The binding is **required**.

### Integration with German Base Profiles

`PraxisCondition` applies to the standard FHIR R4 `Condition` resource (from `de.basisprofil.r4` or FHIR R4 core). It does not constrain base Condition elements, but requires support for:
- ICD-10-GM coding via BFARM CodeSystem
- Upstream KBV extension for diagnosesicherheit
- Two local extensions (dauerdiagnose, diagnoseSeite)

### Example Use Cases

1. **Confirmed diagnosis for KV claim:** A patient with diabetes mellitus Type 2 (E11.9) marked as gesichert (G), dauerdiagnose=true.
2. **Ruled-out differential:** A suspected infection ruled out during workup, marked as ausgeschlossen (A).
3. **Suspected condition pending confirmation:** A provisional diagnosis marked as verdacht (V).
4. **Post-treatment status:** Patient with resolved fractured arm marked as zustand nach (Z).

### PVS Implementation Note

When recording a diagnosis in the PVS:
1. Create or retrieve a Condition resource
2. Populate ICD-10-GM code from the EBM/clinical context
3. **Always set the diagnosesicherheit extension** based on clinical judgment (G/A/V/Z)
4. If chronic: set dauerdiagnose=true so EHR auto-carries to next quarter
5. If bilateral or sided: set diagnoseSeite (links, rechts, beidseitig)
6. Validate against PraxisCondition profile before submission

See example `example-diagnose` for a complete instance.

## AnamneseQuestionnaire — Anamneseboegen-Profil

The `AnamneseQuestionnaire` profile extends the base FHIR `Questionnaire` resource to standardize ambulatory history-taking forms (Anamneseboegen) in practice management systems. It supports multiple questionnaire types (initial intake, pain assessment, preventive health screening, and follow-up) with structured groups of clinical questions.

### Supported Questionnaire Types

| Type | Code | Usage |
|------|------|-------|
| **Erstanamnese** | `erstanamnese` | Comprehensive initial intake form for new patients |
| **Schmerzanamnese** | `schmerzanamnese` | Focused pain assessment questionnaire |
| **Praeventionsanamnese** | `praevention` | Preventive health screening form |
| **Verlaufsanamnese** | `follow-up` | Repeat assessment during treatment course |
| **Fachspezifisch** | `fachspezifisch` | Specialty-specific questionnaire template |

### Profiling Rules

- **status**: Required, must be `#active` for active templates
- **title**: Required, human-readable name of the questionnaire
- **subjectType**: Required, must be `#Patient`
- **useContext[bogentyp]**: Required slice (1..*) to classify the questionnaire type via `AnamneseBogentypVS`
- **extension[kategorie]**: Optional extension for clinical specialty (e.g., "Allgemeinmedizin", "Orthopädie")
- **item**: Required (1..*), each item has linkId, type, and optional required flag

### Supported Question Types

Standard FHIR Questionnaire item types including: `group`, `display`, `boolean`, `decimal`, `integer`, `date`, `dateTime`, `time`, `string`, `text`, `url`, `choice`, `open-choice`, `attachment`, `reference`, `quantity`.

### Integration with QuestionnaireResponse

Patients complete these questionnaires via a QuestionnaireResponse-Builder interface. Each response is linked to the template via `QuestionnaireResponse.questionnaire` reference. PVS systems can then:
- Extract structured data from responses (e.g., previous illnesses, medication, social history)
- Pre-populate clinical note templates
- Track questionnaire completion as part of encounter workflow
- Support both paper-based and digital intake workflows

See example `example-anamnese-erstanamnese` for a complete three-group Erstanamnese template (Previous Conditions, Medication, Social History).

## InsurancePlanDE — GKV/PKV Tarif-Profile

The `InsurancePlanDE` profile extends the base FHIR `InsurancePlan` resource with slicing on `plan` to distinguish GKV (statutory health insurance) and PKV (private health insurance) tariffs.

### Plan Slices

| Slice | Type Code | Usage |
|-------|-----------|-------|
| `plan[gkv]` | `InsurancePlanType#gkv` | GKV Satzungsleistungen und kassenindividuelle Leistungen |
| `plan[pkv]` | `InsurancePlanType#pkv` | PKV GOÄ-Faktoren und Erstattungsregeln |

### Coverage.class → InsurancePlan Reference Pattern (AK3)

FHIR R4 does not provide a direct reference element from `Coverage` to `InsurancePlan`. The recommended pattern for this IG is to use `Coverage.class` to link a patient's Coverage to the specific InsurancePlan tariff by identifier:

```
Coverage.class[type=plan].value  →  InsurancePlan.identifier (Tarif-Identifier)
Coverage.class[type=plan].name   →  InsurancePlan.name (human-readable label)
```

**Example:** A GKV patient with AOK Bayern PZR Satzungsleistung:

```
Coverage.class[0].type  = http://terminology.hl7.org/CodeSystem/coverage-class#plan
Coverage.class[0].value = "aok-bayern-pzr"
Coverage.class[0].name  = "AOK Bayern — Basis + PZR Satzungsleistung"
```

The value `"aok-bayern-pzr"` matches the `InsurancePlan.identifier` of the corresponding `InsurancePlanDE` instance. Systems can look up the full tariff details (benefit limits, GOÄ-Faktoren, Satzungsleistungen) from the referenced InsurancePlan resource using this identifier.

See `example-coverage-aok-tarif` for a complete example.

## CareTeamDE — Behandler-Teams

The `CareTeamDE` profile models treatment teams (Behandler-Teams) in German ambulatory care. It supports interdisciplinary care coordination with role-based participant slicing.

### Core Structure

| Element | Cardinality | Profile Constraint |
|---------|-------------|-------------------|
| `status` | 0..1 | MS; proposed \| active \| suspended \| inactive \| entered-in-error |
| `category` | 0..* | MS; typically LOINC LA27975-4 (Encounter-focused care team) |
| `name` | 0..1 | MS; human-readable team name (e.g. "Zahnarztpraxis Dr. Mueller") |
| `subject` | 0..1 | MS; Reference(Patient) — the patient for whom the team provides care |
| `period` | 0..1 | MS; start and end times for team engagement |
| `participant` | 0..* | MS; sliced by role (BehandlerRolleVS) |
| `participant[behandler].member` | 0..1 | MS; Reference(Practitioner \| PractitionerRole \| Organization) |
| `participant[behandler].role` | 0..* | MS; bound to [BehandlerRolleVS](ValueSet-behandler-rolle.html) (required) |
| `managingOrganization` | 0..* | Reference(Organization) — the practice or facility managing the team |

### Participant Slicing

Participants are sliced on the `role` element to distinguish treatment roles:

| Slice | Role CodeSystem | Usage |
|-------|---|---|
| `participant[behandler]` | BehandlerRolleCS | Individual health professionals or organizations with a clinical role on the team |

Each `participant[behandler]` slice must include:
- A `role` from `BehandlerRolleVS` (Zahnarzt, Arzt, ZFA, MFA, WB-Assistent, Physiotherapeut)
- A `member` Reference to the Practitioner, PractitionerRole, or Organization holding that role
- Optionally, a `period` (start/end) for that participant's engagement

### Use Cases

1. **Dental Practice Team:** A Zahnarztpraxis with a dentist (Zahnarzt), dental assistant (ZFA), and training resident (WB-Assistent), covering Q1 2024.
2. **General Medical Team:** A GP practice with physician (Arzt) and medical assistant (MFA).
3. **Inactive Historical Team:** An archived team from 2023 with status=inactive.
4. **Multidisciplinary Center (MVZ):** An MVZ with 5+ participants across dental, medical, physiotherapy disciplines.

### PVS Integration Pattern

A PVS adapter should:
1. Create a `CareTeamDE` instance for each patient-facing treatment team.
2. Populate participant slices by extracting role information from the PVS's internal role/function tables.
3. Use `period.start` / `period.end` to track when the team composition was active.
4. Reference patient, practitioners, and the managing organization via FHIR identifiers.

See examples: `example-care-team`, `example-care-team-small`, `example-care-team-inactive`, `example-care-team-mvz`.

## PraxisDevice — Medizingeräte und Laboranalyzatoren

The `PraxisDevice` profile extends the base FHIR `Device` resource for medical devices and lab analyzers in German ambulatory practice. It integrates with GDT 3.5 device data (FK 8402 Gerätekennung) and provides structured coding for device identification.

### Core Structure

| Element | Cardinality | Profile Constraint |
|---------|-------------|-------------------|
| `status` | 0..1 | MS; active \| inactive \| entered-in-error |
| `identifier` | 0..* | MS; sliced by system (gdtId) |
| `identifier[gdtId]` | 0..1 | MS; GDT device identifier (FK 8402) with system = gdt-device-id |
| `deviceName` | 0..* | MS; device name(s) with type classification |
| `deviceName.name` | 1..1 | MS; human-readable device name |
| `deviceName.type` | 1..1 | MS; manufacturer-name \| user-friendly-name \| patient-reported-name |
| `manufacturer` | 0..1 | MS; device manufacturer (e.g., "Roche Diagnostics") |
| `modelNumber` | 0..1 | MS; device model (e.g., "Cobas 6000") |
| `version` | 0..* | MS; software/firmware version (optional but recommended) |
| `type` | 0..1 | MS; device type, preferably SNOMED-CT (e.g., automated analyzer, ECG device) |

### Use Cases

1. **Lab Analyzer:** A fully-automated clinical chemistry analyzer (e.g., Roche Cobas 6000) with complete identification and version tracking.
2. **ECG Device:** A portable EKG device (e.g., Schiller AT-102) with minimal required fields.
3. **PVS Device Registry:** Practice management systems maintain a registry of devices with GDT identifiers for test ordering and result routing.

### GDT Integration Pattern

GDT 3.5 device data (FK 8402 Gerätekennung) maps to `PraxisDevice.identifier[gdtId].value`. The practice management system uses this identifier to:
- Route lab orders to the correct device
- Match incoming GDT results (Satzart 6310) to the originating device
- Track device metadata (manufacturer, model, version) for quality assurance

See examples: `example-cobas-6000`, `example-schiller-at102`.

### PVS Integration Pattern

A PVS adapter should:
1. Create a `PraxisDevice` instance for each device managed by the practice.
2. Populate the `identifier[gdtId].value` with the GDT device identifier from the PVS.
3. Use `deviceName`, `manufacturer`, `modelNumber`, `version`, and `type` to encode device metadata.
4. Update device status (`active` / `inactive`) to reflect the device's current operational state in the practice.

## ProcedureAmbulantDE — Ambulante Eingriffe mit OPS-Kodierung

The `ProcedureAmbulantDE` profile extends the base FHIR `Procedure` resource to support ambulatory procedures (Eingriffe) in German practice management. Procedure coding uses the OPS (Operationen- und Prozedurenschlüssel) via the `CodingOPS` profile from `de.basisprofil.r4`, which includes the Seitenlokalisation extension for laterality.

### Must-Support Elements

| Element | Cardinality | Description |
|---------|-------------|-------------|
| `status` | 1..1 | MS; procedure status (e.g., `completed`, `in-progress`) |
| `code` | 1..1 | MS; procedure code — sliced to allow OPS coding |
| `code.coding[ops]` | 0..1 | MS; OPS coding using `CodingOPS` profile from de.basisprofil.r4 |
| `code.coding[ops].system` | 1..1 | Fixed: `http://fhir.de/CodeSystem/bfarm/ops` |
| `code.coding[ops].version` | 1..1 | OPS catalog year (e.g., `"2024"`) — required by CodingOPS |
| `code.coding[ops].code` | 1..1 | OPS code (e.g., `1-650.1`) |
| `subject` | 1..1 | MS; Reference(Patient) |
| `performed[x]` | 0..1 | MS; date or period when the procedure was performed |
| `bodySite` | 0..* | MS; detailed body site (supplementary to Seitenlokalisation in OPS coding) |

### OPS Seitenlokalisation

Laterality (Seitenlokalisation) is modeled as an extension on the `code.coding[ops]` element, as defined by the `CodingOPS` profile:

```
code.coding[ops].extension[seitenlokalisation].valueCoding
  system: https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_SEITENLOKALISATION
  code: L | R | B
```

The `bodySite` element may additionally carry more granular anatomical location information (e.g., for multi-site procedures).

### Use Cases

1. **Ambulante Koloskopie:** A diagnostic colonoscopy coded as OPS 1-650.1, status completed, linked to a GKV patient.
2. **Wundversorgung links:** A wound care procedure (OPS 5-916.00) with `Seitenlokalisation = L` (links) recorded as an extension on the OPS coding.

See examples: `example-procedure-koloskopie`, `example-procedure-wundversorgung-links`.

## FPDEPatient — Patient-Demografie-Erweiterungen

The `FPDEPatient` profile extends the base FHIR `Patient` resource to support German-specific demographic attributes required by practice management systems. It adds support for maiden name (Geburtsname) and district/neighborhood (Ortsteil) information.

### Core Elements

| Element | Cardinality | Extension | Description |
|---------|-------------|-----------|-------------|
| `name` | 0..* | | MS; supports official, nickname, and maiden name uses |
| `name[].use` | 0..1 | | Can be `#official`, `#nickname`, `#maiden`, etc. |
| `name[].family` | 0..1 | `humanname-own-name` | MS; family name. When use=maiden, the `humanname-own-name` extension captures the original maiden name |
| `address` | 0..* | | MS; patient's residential address |
| `address[].extension` | 0..* | `iso21090-ADXP-precinct` | MS; neighborhood/district (Ortsteil, Stadtteil) of the address |

### Supported Extensions

#### `humanname-own-name` — Maiden Name (Geburtsname)

The FHIR standard extension `http://hl7.org/fhir/StructureDefinition/humanname-own-name` is used to capture the patient's maiden name when `name.use = #maiden`. This extension is defined in the base FHIR specification and allows recording the original family name before marriage.

**Example:**
```
name[1].use = #maiden
name[1].family = "Schmidt"
name[1]._family.extension[0].url = "http://hl7.org/fhir/StructureDefinition/humanname-own-name"
name[1]._family.extension[0].valueString = "Schmidt"
```

#### `iso21090-ADXP-precinct` — District/Neighborhood (Ortsteil)

The ISO 21090 standard extension `http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-precinct` is used to capture the neighborhood or district (Ortsteil, Stadtteil) as part of the patient's address. This is a German-common requirement where practices need to differentiate between districts of larger cities.

**Example:**
```
address[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-precinct"
address[0].extension[0].valueString = "Kreuzberg"
```

### Use Cases

1. **Patient with maiden name:** Anna Mueller (official) formerly Schmidt (maiden) — recorded with two name entries, the second using `use=maiden` with the `humanname-own-name` extension.
2. **Patient with district:** Maria Gonzalez living in Berlin-Kreuzberg — the Ortsteil is captured in the address extension.
3. **Patient with both:** Patient has official name, maiden name, and resides in a specific neighborhood — all three attributes are captured.
4. **Patient without maiden name:** Thomas Bauer — maiden name is optional; patients without it validate correctly.

### PVS Implementation Note

When recording patient demographics in a PVS:
1. Create a `Patient` resource
2. Populate `name[0]` with the official name (use=official)
3. If the patient provides a maiden name, add `name[1]` with `use=maiden` and populate `name[1].family` with the maiden name. Add the `humanname-own-name` extension to `name[1]._family` to explicitly store the value.
4. For the address, populate standard address elements (`line`, `city`, `postalCode`, `country`).
5. If the patient's residence includes a district/neighborhood, add the `iso21090-ADXP-precinct` extension to `address[].extension`.
6. Validate the instance against `FPDEPatient` before submission.

See examples: `example-patient-geburtsname`, `example-patient-ohne-geburtsname`, `example-patient-ortsteil`.

## FPDECoverageGKV — GKV Insurance with Wohnortprinzip (WOP)

The `FPDECoverageGKV` profile extends the base FHIR `Coverage` resource to support German statutory health insurance (GKV — gesetzliche Krankenversicherung) with the Wohnortprinzip (WOP — residence-based principle) designation. The WOP indicates the regional KV (Kassenärztliche Vereinigung) responsible for the patient's care based on their place of residence.

### Core Elements

| Element | Cardinality | Extension | Description |
|---------|-------------|-----------|-------------|
| `status` | 0..1 | | Coverage status (active, inactive, entered-in-error, etc.) |
| `type` | 1..1 | | Must code GKV using `http://fhir.de/CodeSystem/versicherungsart-de-basis` |
| `beneficiary` | 1..1 | | Reference(Patient) — the insured patient |
| `payor` | 1..* | | Reference to the insurance carrier (Krankenkasse) |
| `extension` | 0..* | `gkv/wop` | MS; Wohnortprinzip (WOP) code from KBV CodeSystem |

### Supported Extension

#### `gkv/wop` — Wohnortprinzip (WOP)

The extension `http://fhir.de/StructureDefinition/gkv/wop` from `de.basisprofil.r4` is used to specify the regional KV responsible for the patient. The value is a Coding from the KBV CodeSystem `https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ITA_WOP`, which lists all German KV regions (e.g., 38 = Nordrhein, 17 = Westfalen-Lippe).

**Example:**
```
extension[0].url = "http://fhir.de/StructureDefinition/gkv/wop"
extension[0].valueCoding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ITA_WOP"
extension[0].valueCoding.code = "38"
extension[0].valueCoding.display = "Nordrhein"
```

### WOP Codes (Auswahl)

| Code | Display | Region |
|------|---------|--------|
| **38** | Nordrhein | Nordrhein (North Rhine) |
| **17** | Westfalen-Lippe | Westfalen-Lippe (Westphalia-Lippe) |
| **33** | Baden-Württemberg | Baden-Württemberg |
| **52** | Saarland | Saarland |
| (and others) | | See KBV CodeSystem for complete list |

### Use Cases

1. **Patient with GKV coverage in Nordrhein:** Coverage for AOK Rheinland/Hamburg with WOP=38 (Nordrhein).
2. **Patient moving to different KV region:** Update coverage with new WOP code reflecting the new region of residence.
3. **Multi-regional insurance:** A patient may have multiple Coverage entries with different WOP codes if they have special arrangements.
4. **Coverage without WOP:** GKV coverage may be recorded without a WOP extension (WOP is optional); the profile validates correctly in both cases.

### PVS Implementation Note

When recording GKV coverage in a PVS:
1. Create a `Coverage` resource
2. Set `status = #active` (or appropriate status)
3. Populate `type` with GKV coding from `http://fhir.de/CodeSystem/versicherungsart-de-basis`
4. Set `beneficiary` to a Reference(Patient)
5. Set `payor` to the insurance carrier (Krankenkasse) name or reference
6. If the patient's residence is within a specific KV region, add the `gkv/wop` extension with the appropriate WOP code
7. Validate the instance against `FPDECoverageGKV` before submission

**Upstream Dependency:** The `gkv/wop` extension is provided by the `de.basisprofil.r4` package and is **not redefined** in this IG. It is reused as-is.

See examples: `example-coverage-gkv-wop`, `example-coverage-gkv-wop-west`.

## PraxisSpecimen — Probenmaterial für xDT-Adapter

The `PraxisSpecimen` profile extends the base FHIR `Specimen` resource to standardize specimen (Probenmaterial) documentation in German ambulatory practice. It is designed for xDT adapters (LDT, GDT 3.5) that exchange laboratory order and result information. The profile ensures that specimen identifiers and material types are captured in a PVS-agnostic manner, compatible with laboratory systems.

### Core Elements

| Element | Cardinality | Profile Constraint |
|---------|-------------|-------------------|
| `identifier` | 0..* | Optional; labs may assign their own specimen identifiers using system-specific URLs |
| `type` | 1..1 | MS; sliced by coding system (SNOMED-CT + optional LDT) |
| `type.coding[snomed]` | 1..1 | MS; SNOMED-CT coding (extensible) using [ProbenmaterialSnomedVS](ValueSet-probenmaterial-snomed.html) |
| `type.coding[snomed].system` | 1..1 | Fixed: `http://snomed.info/sct` |
| `type.coding[snomed].code` | 1..1 | MS; SNOMED-CT code for specimen material |
| `type.coding[ldt]` | 0..1 | Optional; LDT FK 8428 material designation using [LdtMaterialbezeichnungCS](CodeSystem-ldt-materialbezeichnung.html) |
| `type.coding[ldt].system` | 1..1 | Fixed: `https://fhir.cognovis.de/praxis/CodeSystem/ldt-materialbezeichnung` |
| `type.coding[ldt].code` | 1..1 | LDT FK 8428 code (e.g., EDTA-Blut, Serum, Urin-MSU) |
| `subject` | 1..1 | MS; Reference(Patient) — the patient providing the specimen |
| `collection` | 0..1 | MS; capture collection method, timing, and body site |
| `collection.collectedDateTime` | 0..1 | MS; when the specimen was collected |
| `collection.method` | 0..1 | MS; SNOMED-CT or LDT code for collection technique (venipuncture, swab, etc.) |
| `collection.bodySite` | 0..1 | MS; anatomical location of specimen collection |
| `container` | 0..* | MS; tube type and container information |
| `container.type` | 0..1 | MS; SNOMED-CT code for container type (EDTA tube, serum separator, etc.) |

### Specimen Identifier Pattern (No Shared NamingSystem)

Specimen identifiers are **lab-specific**. No shared NamingSystem is defined for specimen identifiers. Each laboratory assigns identifiers using its own system URL:

```
identifier[0].system = "https://<lab-specific-url>/proben-id"
identifier[0].value  = "<lab-specific-specimen-id>"
```

**Example:** A specimen from "Labor Beispiel" might use:
```
system = "https://labor-beispiel.de/proben-id"
value  = "BL-2026-00147"
```

Different laboratories can have different URL structures; there is no registry of these URLs — they are internal to each laboratory system.

### Material Type Coding: SNOMED-CT + LDT

**SNOMED-CT** (extensible) provides internationally recognized coding for specimen types:
- `122555007` — Venous blood specimen
- `122575003` — Urine specimen
- `258529004` — Throat swab
- etc. (see [ProbenmaterialSnomedVS](ValueSet-probenmaterial-snomed.html))

**LDT FK 8428** (optional) adds German-specific material designation from the KBV LDT3 specification:
- `EDTA-Blut` — EDTA-Blut (venous blood in EDTA tube)
- `Serum` — Blutserum
- `Urin-MSU` — Mittelstrahl urine
- `Abstrich` — Swab / smear
- `Liquor` — Cerebrospinal fluid
- `Stuhl` — Stool sample

Both coding systems can coexist; SNOMED-CT is mandatory, LDT is optional. xDT adapters can map between the two at transformation time.

### Integration with KBV Labor Befund

The `kbv.mio.laborbefund` (KBV MIO Laboratory Report) ImplementationGuide defines specimen handling for laboratory results in Germany. `PraxisSpecimen` is inspired by `KBV_PR_MIO_LAB_Specimen` but is **not constrained to it** because:

1. The KBV parent profile lacks a published snapshot in some package versions
2. `PraxisSpecimen` must remain **PVS-agnostic** — applicable to any ambulatory practice system, not tied to a specific MIO workflow
3. The profile uses the base FHIR `Specimen` resource as parent, ensuring broad compatibility

Refer to the KBV MIO Laboratory Report guide for context on laboratory workflow integration.

### PVS Implementation Note

When capturing specimen information in a PVS:
1. Create a `Specimen` resource
2. **Always populate `type.coding[snomed]`** with the appropriate SNOMED-CT code
3. Optionally add `type.coding[ldt]` if the PVS maintains LDT material designations
4. Populate `subject` with a reference to the patient
5. Record collection metadata (`collection.collectedDateTime`, `collection.method`, `collection.bodySite`)
6. Container information (`container.type`) aids downstream laboratory processing
7. Validate the instance against `PraxisSpecimen` before transmission

### Use Cases

1. **Venous blood for laboratory analysis:** SNOMED-CT `122555007` (Venous blood specimen) + LDT `EDTA-Blut` (EDTA-Blut), collected by venipuncture, in EDTA tube.
2. **Urine culture:** SNOMED-CT `122575003` (Urine specimen) + LDT `Urin-MSU` (Mittelstrahl urine), mid-stream collection.
3. **Throat swab for microbiology:** SNOMED-CT `258529004` (Throat swab), collected by swab technique from pharynx.

See examples: `example-specimen-blut-edta`, `example-specimen-urin-msu`, `example-specimen-rachenabstrich`.

## Note on Resource Choice

The choice of base resource follows FHIR R4 semantics:

- **Contract** for RLV budgets: Contract represents a binding agreement between KV and physician — the budget allocation is exactly that.
- **Basic** for KV benchmarks: Benchmark data has no natural FHIR resource; Basic is the designated catch-all.
- **PaymentReconciliation** for Honorarbescheid: This normative R4 resource represents payment advice from a payer, which is the function of the Honorarbescheid.
- **Provenance** for AI tracking: Provenance records "who did what" — an AI system generating content is a provenance event.
- **Device** for medical equipment: Device is the FHIR R4 standard resource for medical instruments, analyzers, and other equipment used in clinical care. The PraxisDevice profile constrains it for German ambulatory practice with GDT integration.
