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

### Administrative

| Resource | Usage | Key Extensions |
|----------|-------|----------------|
| **Provenance** | AI provenance tracking (EU AI Act) | AiGeneratedExt, AiModelExt, HumanReviewedExt |
| **Coverage** | Insurance information | KassennameExt, KassennummerExt |
| **PractitionerRole** | WB-Assistent / Sicherstellungsassistent | WbRolleExt, WbAbrechnenderArztExt |
| **Consent** | Patient consent management | EinwilligungKuerzelExt, EinwilligungTextExt, EinwilligungWiderrufMoeglichExt |

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

## Note on Resource Choice

The choice of base resource follows FHIR R4 semantics:

- **Contract** for RLV budgets: Contract represents a binding agreement between KV and physician — the budget allocation is exactly that.
- **Basic** for KV benchmarks: Benchmark data has no natural FHIR resource; Basic is the designated catch-all.
- **PaymentReconciliation** for Honorarbescheid: This normative R4 resource represents payment advice from a payer, which is the function of the Honorarbescheid.
- **Provenance** for AI tracking: Provenance records "who did what" — an AI system generating content is a provenance event.
