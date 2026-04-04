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

### Administrative

| Resource | Usage | Key Extensions |
|----------|-------|----------------|
| **Patient** | Patient demographics and administration | PatientSeitExt |
| **Provenance** | AI provenance tracking (EU AI Act) | AiGeneratedExt, AiModelExt, HumanReviewedExt |
| **Coverage** | Insurance information | KassennameExt, KassennummerExt |
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

## Note on Resource Choice

The choice of base resource follows FHIR R4 semantics:

- **Contract** for RLV budgets: Contract represents a binding agreement between KV and physician — the budget allocation is exactly that.
- **Basic** for KV benchmarks: Benchmark data has no natural FHIR resource; Basic is the designated catch-all.
- **PaymentReconciliation** for Honorarbescheid: This normative R4 resource represents payment advice from a payer, which is the function of the Honorarbescheid.
- **Provenance** for AI tracking: Provenance records "who did what" — an AI system generating content is a provenance event.
