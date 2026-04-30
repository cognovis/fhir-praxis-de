# Plan-Library vs. Rule-Execution — IG Boundary

This Implementation Guide deliberately separates two concerns that share the same code-systems (EBM, GOÄ, BEMA, HZV) but operate on different semantic axes:

- **Plan-Library** — declarative, forward-directed templates ("what belongs together"): `PlanDefinition`, `ActivityDefinition`, `CarePlan`, `EpisodeOfCare`. Lives in FHIR, emitted by PVS adapters.
- **Rule-Execution** — imperative validation ("what violates and when"): rule definitions, frequency limits, faktor-limits, Kassen-/Quartals-Constraints. Lives in downstream rule-execution services, not in FHIR.

The full rationale is in [ADR-001 — Plan-Library vs. Rule-Execution Boundary](https://github.com/cognovis/fhir-praxis-de/blob/main/docs/adr/ADR-001-plan-library-vs-rule-execution.md).

## Slots intentionally NOT populated

The following FHIR slots are **out-of-profile-scope by intent** in this IG and in adapter-emitted plan-library resources. Profile descriptions and validators MUST NOT treat them as semantically meaningful:

| Resource | Slot | Reason |
|---|---|---|
| `PlanDefinition` | `action.condition` | Rule semantics live outside the IG, not in FHIR |
| `PlanDefinition` | `action.input.condition` | Same |
| `PlanDefinition` | `action.dynamicValue` | Same |
| `PlanDefinition` | `library` (rule-bearing CQL) | Descriptive uses still allowed; rule libraries excluded |
| `ActivityDefinition` | `dynamicValue` | Same |
| `ChargeItemDefinition` | `applicability` | Same |

Consumers MUST NOT expect these slots to carry validation semantics. To filter for plan-library resources, query by `meta.profile = .../praxis-billingpattern` and `topic.coding.code` from the [praxis-plan-topic](CodeSystem-praxis-plan-topic.html) CodeSystem.

## What the Plan-Library DOES express

- **Relationships** between activities — `PlanDefinition.action.relatedAction` for "A implies B" chains
- **Plan structure** — nested actions, ordering, grouping
- **Catalog references** — `action.definitionCanonical → ActivityDefinition → ChargeItemDefinition`
- **Plan metadata** — `topic`, `useContext`, `identifier`, `status`, `version`
- **Plan-kind discriminators** — via [praxis-plan-topic](CodeSystem-praxis-plan-topic.html) (chain/job/komplex/dmp/hzv/hkp/par/kfo/ze)
- **Action-section markers** — via [praxis-plan-section](CodeSystem-praxis-plan-section.html) (behandlungsdoku/ziffern/diagnosen)

## Single PlanDefinition profile: PraxisBillingPattern

This IG ships **one** PlanDefinition profile for adapter-emitted plans: [PraxisBillingPattern](StructureDefinition-praxis-billingpattern.html). Plan variants (Chain, Job, DMP-Template, HZV-Template, HKP-Template) are differentiated via `topic`, not via separate profiles.

Section-cardinality rules (e.g. "a Job typically has Doku + Ziffern + Diagnosen") are conventions enforced by adapters and authoring tools, **not** by FHIR slice constraints. A Hausbesuchs-Job legitimately may not have a Diagnosen-Section.

## Rule derivation is explicit and versioned

When a downstream rule engine derives a `RuleDefinition` from a plan-library resource, the derivation is recorded via `Provenance` with `target = derived RuleDefinition` and `entity[].what = source PlanDefinition canonical+version`. Implicit derivation without provenance is not allowed. See ADR-001 §4 for the full pattern.
