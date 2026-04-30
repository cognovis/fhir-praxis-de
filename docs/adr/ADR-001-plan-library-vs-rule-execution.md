# ADR-001: Plan-Library vs. Rule-Execution — Boundary, Profile-Strategy, CPG-Reuse

**Status:** Accepted
**Date:** 2026-04-27
**Deciders:** Architecture Council (Malte, Claude Opus)
**Affected systems:** `fhir-praxis-de` (this IG), downstream Plan-Library emitters, downstream Rule-Execution engines

## Context

The vertragsärztliche Abrechnung in Germany involves two structurally different concerns that share the same code-systems (EBM, GOÄ, BEMA, HZV) but operate on different temporal and semantic axes:

1. **Forward-driven workflow templates** — what *should* happen together. Examples: source-system jobs (Behandlungsbausteine bestehend aus Doku + Ziffern + Diagnosen), "Komplexe" / "Ziffernketten" (A impliziert B), HKP-Vorlagen (Plan → Genehmigung → Umsetzung → Abrechnung), DMP-/HZV-Plantemplates.
2. **Validation / rule-execution** — what *violates* rules when it actually happened. Examples: 1.086 report-derived rules + ~18 SQL-shaped query types (Ausschlüsse, Frequenzlimits, Plausibilität, faktor-limit, kassenspezifische Constraints), produced and executed against a downstream flat-table layer.

Both concerns reference EBM/GOÄ/BEMA codes. The temptation is to model both inside FHIR PlanDefinition / ActivityDefinition / ChargeItemDefinition by populating their `condition`, `applicability`, `dynamicValue`, and `library` slots — using CQL or FHIRPath for the rule logic. The HL7 **Clinical Practice Guidelines (CPG) IG** provides exactly this pattern via `CPGComputableGuidanceDefinition`, `CPGStrategyDefinition`, `CPGPathwayDefinition` and friends.

This ADR records the decision **not** to follow that pattern, the boundary that replaces it, and the IG-level constraints that follow.

## Decision

### 1. Plan-Library and Rule-Execution are separate layers with different homes

| Layer | Home | Content | Character |
|---|---|---|---|
| **Plan-Library** | FHIR resources emitted by downstream adapters into Aidbox: `PlanDefinition`, `ActivityDefinition`, `CarePlan`, `EpisodeOfCare` | Komplexe, Ketten, Jobs, HKP-Vorlagen, DMP/HZV-Templates | Declarative, forward-directed ("what belongs together") |
| **Rule-Execution** | Rule-definition store + reference-data tables + SQL-shaped query types | Ausschlüsse, Frequenzlimits, Plausibilität, faktor-limit, Kassen-/Quartals-Constraints, report-derived rules | Imperative, validating ("what violates and when") |

### 2. Computability slots in plan-library resources stay empty

The following FHIR slots are **bewusst nicht populiert** in any downstream-emitted resource:

- `PlanDefinition.action.condition`
- `PlanDefinition.action.input.condition`
- `PlanDefinition.action.dynamicValue`
- `PlanDefinition.library` (for rule-bearing CQL libraries — purely descriptive uses are still allowed)
- `ActivityDefinition.dynamicValue`
- `ChargeItemDefinition.applicability`

What FHIR IS allowed to express in plan-library resources:

- **Relationships** between activities — `PlanDefinition.action.relatedAction` for "A impliziert B"-Ketten
- **Plan structure** — nested actions, ordering, grouping
- **Catalog references** — `action.definitionCanonical → ActivityDefinition → ChargeItemDefinition`
- **Plan metadata** — `topic`, `useContext`, `identifier`, `status`, `version`

### 3. Single PlanDefinition profile: PraxisBillingPattern

**No** separate `PraxisJobDefinition` profile is introduced. `PraxisBillingPattern` (existing in this IG since v0.40.0) is the **only** PlanDefinition profile for downstream-emitted plans.

Differentiation between plan variants (Chain vs. Job vs. DMP-Template vs. HZV-Template vs. HKP-Template) is expressed via two new CodeSystems published by this IG:

- `praxis-plan-topic` (bound to `PlanDefinition.topic`):
  `billing-chain | job | dmp-template | hzv-template | hkp-template`
- `praxis-plan-section` (bound to `PlanDefinition.action.code`):
  `behandlungsdoku | ziffern | diagnosen` (extensible)

Mandatory-cardinality rules ("a Job MUST have a behandlungsdoku, ziffern, and diagnosen section") are enforced by:
1. The downstream adapter (write-time check in billing pattern mappers)
2. The downstream library editor (UX prevents saving incomplete jobs)

They are **not** enforced via FHIR slice constraints, because section-cardinality is convention, not a categorical FHIR validation rule (e.g. a Hausbesuchs-Job legitimately may not have a Diagnosen-Section).

### 4. Rule-derivation from plans is explicit and versioned

If a downstream rule engine derives a `RuleDefinition` from a plan-library resource (typical case: a `fehlende-ziffer`-rule auto-generated from a `PlanDefinition.action.relatedAction` chain), the derivation MUST:

- Record provenance: `RuleDefinition.derivedFromPlan = <PlanDefinition.url>@<version>`
- Be re-runnable: changing the source plan invalidates the derived rule and triggers regeneration
- Be versioned: `meta.versionId` of the derived `RuleDefinition` advances on each regeneration
- Be filterable in the dashboard: derived rules carry category `derived` so practice staff can distinguish hand-curated from plan-derived rules

Implicit derivation (e.g. background heuristics that mutate rules without provenance) is **not allowed**.

### 5. HKP-Status follows the Da Vinci PAS dual-lifecycle pattern

The Heil- und Kostenplan (HKP) has two orthogonal lifecycles. Both are modeled with existing resources in this IG; **no new `hkp-status` extension** is introduced.

- Clinical lifecycle: `DentalCarePlanDE.status` (FHIR-standard `draft | active | on-hold | revoked | completed`)
- Administrative lifecycle: `PASClaimDE` (Claim) + `PASClaimResponseDE` (ClaimResponse) — Da Vinci PAS pattern, present in this IG since v0.40.0

The two are linked via `Claim.basedOn → CarePlan`. `ChargeItem.supportingInformation` references the `CarePlan` (clinically correct: billing references the treatment plan, not the authorization request).

An aggregate "HKP-Phase" view (Plan / Genehmigung / Umsetzung / Abrechnung) is computed at display time from `(CarePlan.status, Claim.status, ClaimResponse.outcome)` — never persisted as its own field. Downstream rule-engine architecture documentation owns the full status mapping table.

## Considered Alternatives

### A. Adopt CPG (Clinical Practice Guidelines IG) and populate `condition` / `applicability` / `dynamicValue` with CQL

This is the most natural alternative — CPG provides a complete, FHIR-native, computable approach exactly for the use case "describe rules and workflows in the same FHIR resources." We rejected this for three reasons:

#### A.1 The EBM/BEMA/HZV rule reality is not CQL-shaped

CPG works in the US clinical-quality-measures domain because USPSTF recommendations and HEDIS/CMS quality measures are FHIR-shaped phenotypes (patient cohort definitions, observation-based criteria). German vertragsärztliche Abrechnung is a different domain:

- **Quartalsbezug**: rules are scoped to billing quarters with retroactive validity (Faktor-Limit-Tiers shift mid-quarter, applicability dates are tied to KVDT cycles)
- **Kassen-Selektivverträge**: rule applicability depends on the patient's Coverage and on Praxis-specific contracts that change per Vertrag-Quartal
- **Retrospective reports**: ~5.000 retrospective practice-management reports yield ~1.086 deduplicated rules, none of which are expressible as a single CQL phenotype
- **Faktor-Limits**: BEMA-Steigerungssatz validation requires lookup against context that has no FHIR-native representation

Translating these to CQL would not produce a clean library — it would produce a CQL pseudo-translation of SQL queries, with all the original irregularity preserved and the additional cost of a CQL runtime.

#### A.2 The SQL-based rule engine is already built and meets performance targets

Downstream rule-engine architecture documents a SQL-based rule architecture against flat tables (`chargeitem_flat`, `encounter_flat`, `condition_flat`) with persistent memoization (`rule_check_results`) and streamed results. Sub-second performance for daily-protocol checks (50 encounters) and ~2-5 second batches for full-quarter audits (130K encounters) are achieved without CQL.

Adopting CPG would require:
- Translating ~1.086 report-derived rules into CQL
- Translating ~18 SQL query types into CQL
- Integrating a CQL runtime (XML/JSON parsing overhead — explicitly called out as inefficiency in §9 of rule-engine.md)
- Building the rule-derivation pipeline twice (once for CQL-emitted, once for SQL-derived)

High effort, no clear benefit.

#### A.3 The two-layer split is justified by the domain, not by laziness

The Plan-Library is **declarative** ("what belongs together") — FHIR is the right home, with mature standards (PlanDefinition, ActivityDefinition, CarePlan).

The Rule-Execution layer is **imperative and quartal-/Kassen-/Praxis-aggregated** ("what violates and when") — SQL against flat tables is the right home, because the engine must execute reductions over practice-wide data with quartal- and Kasse-specific filters.

CPG attempts to model both in one layer. That is the wrong abstraction for our domain. Forcing both into CPG would not unify the layers — it would only obscure that they are different.

### B. Define a separate `PraxisJobDefinition` profile alongside `PraxisBillingPattern`

Rejected. A Job differs from a Chain only in section composition (Doku + Ziffern + Diagnosen vs. Ziffern only). FHIR profile validation should reject *categorically wrong* data — section-cardinality of a Job is a UX/Convention rule, not a categorical validation. A Hausbesuchs-Job without Diagnosen is legitimate; a profile slice forcing three sections would reject it.

Differentiation via `topic`-CodeSystem is more flexible (new variants without profile bumps), idiomatically FHIR (`topic` is the standard slot for "what is this plan about"), and avoids profile-version churn.

### C. Define an `extension:hkp-status` on CarePlan

Rejected. `de.cognovis.fhir.praxis@0.40.0` already ships `PASClaimDE` and `PASClaimResponseDE` for the administrative HKP lifecycle (Da Vinci PAS pattern). A separate extension on CarePlan would create a competing source of administrative truth, with drift-risk between `CarePlan.hkp-status` and `ClaimResponse.outcome`. The two-resource pattern is correct as-is.

## Consequences

### For `fhir-praxis-de` (this IG)

- Add: `praxis-plan-topic` CodeSystem + ValueSet
- Add: `praxis-plan-section` CodeSystem + ValueSet
- Add: `PraxisBillingActivity` (ActivityDefinition profile) — constraint on EBM/GOÄ/HZV codes, mandatory `definitionCanonical → ChargeItemDefinition`
- Add: `PraxisCarePlanDE` (CarePlan profile, parallel to `DentalCarePlanDE`)
- Document: `condition`, `applicability`, `dynamicValue` are out-of-profile-scope by intent (profile-note / IG-narrative section, referencing this ADR)

### For downstream Plan-Library emitters

- `PraxisBillingPattern` remains the single PlanDefinition emission target
- Mappers write `topic` from `praxis-plan-topic` and section markers via `action.code` from `praxis-plan-section`
- `ChargeItem.supportingInformation` continues to reference the relevant `CarePlan` (when applicable), never the `Claim`

### For downstream Rule-Execution engines

- Rule Engine remains in its own rule-definition store with SQL-based architecture
- Library-Editor consumes Plan-Library via Aidbox FHIR API but does not edit `condition` / `applicability` / `dynamicValue` slots
- Rule-derivation pipeline (separate bead, TBD) writes `RuleDefinition.derivedFromPlan` on every derived rule; manual and derived rules coexist with provenance distinction

### For external consumers

External consumers of FHIR data emitted by downstream adapters MUST NOT expect `condition` / `applicability` / `dynamicValue` to carry semantics — these are reserved for the rule engine. To filter for plan-library resources, query by `meta.profile = .../praxis-billingpattern` and `topic.coding.code` from `praxis-plan-topic`.

## Revisit Triggers

This ADR should be revisited if any of the following becomes true:

- A German national IG (KBV, gematik) publishes computable rule-bearing profiles that align with our domain
- The volume or shape of rule_definitions changes such that SQL-against-flat-tables no longer meets performance targets
- A multi-IG, multi-vendor consumer ecosystem develops where CPG-style FHIR-native rule exchange becomes a coordination bottleneck
- An aggregate, anonymized cross-installation dataset enables ML-based rule synthesis that benefits from CQL representation

## References

- Downstream rule-engine architecture documentation — full Rule Engine architecture, especially Plan-Library vs. Rule-Execution and CQL/FHIR pragmatic decision
- Downstream adapter repository policy — IG-Only Policy, FHIR-Architecture rules
- HL7 FHIR PlanDefinition: https://build.fhir.org/plandefinition.html
- HL7 Clinical Practice Guidelines IG: https://hl7.org/fhir/uv/cpg/
- Da Vinci PAS IG: https://hl7.org/fhir/us/davinci-pas/
- Downstream Library Editor Architecture Spike

## Session Memory References (open-brain)

The following open-brain memory IDs document the sessions in which the Plan-Library vs. Rule-Execution boundary was analyzed and the downstream interface decisions were made:

- Memory 18715 — Plan-Library / Rule-Execution boundary analysis (2026-04-24)
- Memory 18716 — Plan-Library / Rule-Execution boundary analysis, continued (2026-04-24)
- Memory 18691 — Interface design decisions (2026-04-24)
- Memory 18751 — 3-layer billing architecture decision (2026-04-25)
