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
| **Patient** | Patient demographics and administration | PatientSeitExt |
| **Provenance** | AI provenance tracking (EU AI Act) | AiGeneratedExt, AiModelExt, HumanReviewedExt |
| **Coverage** | Insurance information | KassennameExt, KassennummerExt |
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

## Note on Resource Choice

The choice of base resource follows FHIR R4 semantics:

- **Contract** for RLV budgets: Contract represents a binding agreement between KV and physician — the budget allocation is exactly that.
- **Basic** for KV benchmarks: Benchmark data has no natural FHIR resource; Basic is the designated catch-all.
- **PaymentReconciliation** for Honorarbescheid: This normative R4 resource represents payment advice from a payer, which is the function of the Honorarbescheid.
- **Provenance** for AI tracking: Provenance records "who did what" — an AI system generating content is a provenance event.
