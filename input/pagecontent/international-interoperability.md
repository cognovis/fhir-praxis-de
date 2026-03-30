# International Interoperability

This page documents how `de.cognovis.fhir.praxis` concepts map to international FHIR standards. German ambulatory practice management has many domain-specific regulatory structures with no direct international equivalent. Where possible, this IG reuses standard R4 resources and patterns, making international alignment explicit.

## Mapping Overview

| Domain | fhir-praxis-de Approach | International Basis | Notes |
|--------|------------------------|---------------------|-------|
| Queue Management | Encounter extensions | R5 `Encounter.subjectStatus` backport | Partial mapping; queue position has no standard |
| RLV Budget | Contract resource | Loosely inspired by Da Vinci VBPR | Fundamentally different concept |
| Honorarbescheid | PaymentReconciliation + ClaimResponse | X12 835 remittance advice concept | German-specific: quarterly, KV corrections |
| GOÄ Private Billing | Claim.item.factor + ChargeItemDefinition | Native FHIR pricing | Factor range 1.0--3.5 is DE-specific |
| AI Provenance | Provenance with Device agent | FHIR Provenance (R4) | Extends with EU AI Act Art. 50 specifics |
| Zeitbudget | ChargeItemDefinition extension | No international equivalent | German KBV regulatory concept |
| KV Benchmark | Basic resource extensions | No international equivalent | German KV regulatory concept |
| Accounts Receivable | Account extensions | FHIR Account (R4) | Dunning levels (Mahnstufe) are DE-specific |
| Condition Extensions | Condition extensions | FHIR Condition (R4) | Dauerdiagnose has no direct equivalent |

## Detailed Mapping

### Queue Management (Warteraum)

**International basis:** FHIR R5 introduces `Encounter.subjectStatus` with values like `arrived`, `triaged`, and `receiving-care` to track patient flow. This IG backports that concept to R4 via extensions.

**What we add:**
- `ArrivalTimeExt` — Precise arrival timestamp (R5 has the status but not a discrete timestamp)
- `EncounterCalledExt` — Timestamp when the patient is called into the treatment room

**No international standard** exists for queue position or waiting room management beyond the R5 subject status concept. Our extensions fill this gap for German practice workflows.

### RLV Budget (Regelleistungsvolumen)

**International basis:** The Da Vinci [Value-Based Performance Reporting (VBPR)](http://hl7.org/fhir/us/davinci-vbpr/) IG uses similar contract-based patterns for value-based care agreements. However, the German RLV is fundamentally different: it represents a **capitation cap** (Mengensteuerung) imposed by the KV on individual physicians, not a quality-based reporting framework.

**What we model:**
- Contract resource for the budget allocation (RLV-Zuweisung)
- Extensions for Fallwert, zugewiesenes Budget, Entbudgetierung
- Separate QZV (qualifikationsgebundene Zusatzvolumina) tracking

**No international equivalent** exists for physician-level capitation budgets imposed by regional payer associations. This is a unique feature of the German KV system.

### Honorarbescheid (Remittance)

**International basis:** The concept maps to the US **X12 835 remittance advice** — a payer's explanation of payment for submitted claims. FHIR models this with `PaymentReconciliation` (normative in R4) and `ClaimResponse`.

**German specifics:**
- **Quarterly batch processing** — Unlike US real-time adjudication, German KV payments are reconciled per quarter
- **KV correction codes** (CorrectionRuleCS) — Richtigstellungen with codes like UV (Volumenüberschreitung), PL (Plausibilitätsprüfung), WP (Wirtschaftlichkeitsprüfung) that have no international equivalent
- **BSNR-level aggregation** — Payments are tied to the Betriebsstättennummer, not individual claims

### GOÄ Private Billing (Gebührenordnung für Ärzte)

**International basis:** FHIR natively supports fee-schedule billing through:
- `Claim.item.factor` for multipliers
- `ChargeItemDefinition.priceComponent` for base pricing
- `Claim.item.unitPrice` for calculated amounts

**German specifics:**
- **Factor range 1.0--3.5** — The GOÄ Steigerungsfaktor system is unique to Germany
- **Schwellenwert 2.3** — Factors above 2.3x require written justification (Begründungspflicht)
- **Höchstsatz 3.5** — Maximum factor, exceeding requires patient consent
- Our `MultiplierMin/Default/MaxExt` extensions on ChargeItemDefinition encode these regulatory boundaries

The multiplier pattern itself maps well to `Claim.item.factor` in international FHIR — only the specific regulatory rules around the factor values are DE-specific.

### AI Provenance (EU AI Act)

**International basis:** FHIR `Provenance` with a `Device` agent representing the AI system is the natural model. The W3C PROV-O ontology underlies FHIR Provenance, making it internationally compatible.

**What we add for EU AI Act Art. 50:**
- `AiGeneratedExt` — Classifies content as AI-generated vs. AI-assisted (AiProvenanceCS)
- `AiModelExt` — Model version identifier
- `AiPurposeExt` — Purpose of AI usage
- `HumanReviewedExt` / `HumanReviewerExt` / `HumanReviewTimestampExt` — Human-in-the-loop review tracking

**No international FHIR IG** currently standardizes AI provenance tracking. As EU AI Act enforcement begins, we expect international alignment efforts. Our approach is designed to be forward-compatible with emerging standards.

### Zeitbudget (KBV Prüfzeit)

**No international equivalent.** The KBV Prüfzeit is a German regulatory concept where each EBM billing code has an assigned time in minutes. The sum of Prüfzeiten per physician per quarter must not exceed a plausibility threshold.

Our `ZeitbudgetMaxMinutenExt` and `ZeitbudgetAbrechnungskreiseExt` model this on ChargeItemDefinition. There is no international FHIR concept for regulatory time budgets tied to billing codes.

### KV Benchmark (Fachgruppen-Durchschnittswerte)

**No international equivalent.** KV benchmark data provides average billing volumes, case counts, and reimbursement rates by medical specialty group (Fachgruppe) and KV region. This data is published quarterly by each KV and used for internal practice controlling.

We model this on the `Basic` resource since there is no natural FHIR resource for statistical benchmark data. The closest international concept would be quality measure reporting (e.g., US HEDIS), but the German KV benchmark is purely financial/volume-based, not quality-based.

### Accounts Receivable (Offene Posten)

**International basis:** The FHIR `Account` resource is internationally defined and covers patient accounts, billing accounts, and financial tracking.

**German specifics:**
- **Mahnstufe** (dunning level 0--3) — Structured escalation process for overdue invoices
- **Mahnsperre** — Ability to block dunning for specific accounts
- **Mahngebühr** — Dunning fees per level

The dunning workflow is not unique to Germany but the specific Mahnstufen structure and associated fees follow German commercial law (BGB/HGB) conventions.

### Condition Extensions (Diagnosen)

**Dauerdiagnose** (permanent diagnosis): A German concept marking a diagnosis as permanently relevant across quarters. FHIR `Condition.clinicalStatus = active` is similar but not identical — a Dauerdiagnose is specifically an administrative marker that ensures the diagnosis appears on every Abrechnungsschein without re-entry. The clinical status may change independently.

**DiagnoseSeite** (laterality): Supplements the standard FHIR approach of laterality via SNOMED CT body site qualifiers. In German practice management, laterality is typically coded as a simple L/R/B flag alongside the ICD-10-GM code rather than through SNOMED CT post-coordination. Our `DiagnoseSeiteCS` provides these simple codes while remaining mappable to SNOMED CT laterality qualifiers (`7771000` left, `24028007` right, `51440002` bilateral).
