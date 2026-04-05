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

### Administrative

| Resource | Usage | Key Extensions |
|----------|-------|----------------|
| **[FPDEPatient](StructureDefinition-fpde-patient.html)** | Patient demographics with maiden name and district support | humanname-own-name, iso21090-ADXP-precinct |
| **Provenance** | AI provenance tracking (EU AI Act) | AiGeneratedExt, AiModelExt, HumanReviewedExt |
| **[FPDECoverageGKV](StructureDefinition-fpde-coverage-gkv.html)** | GKV insurance with Wohnortprinzip (WOP) | gkv/wop |
| **PractitionerRole** | WB-Assistent / Sicherstellungsassistent | WbRolleExt, WbAbrechnenderArztExt |
| **Consent** | Patient consent management | EinwilligungKuerzelExt, EinwilligungTextExt, EinwilligungWiderrufMoeglichExt |

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

## Note on Resource Choice

The choice of base resource follows FHIR R4 semantics:

- **Contract** for RLV budgets: Contract represents a binding agreement between KV and physician — the budget allocation is exactly that.
- **Basic** for KV benchmarks: Benchmark data has no natural FHIR resource; Basic is the designated catch-all.
- **PaymentReconciliation** for Honorarbescheid: This normative R4 resource represents payment advice from a payer, which is the function of the Honorarbescheid.
- **Provenance** for AI tracking: Provenance records "who did what" — an AI system generating content is a provenance event.
