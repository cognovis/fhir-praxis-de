# Architecture Decisions

This page documents the architectural decisions (ADRs) that shape the design of this Implementation Guide.

## ADR-001: Plan-Library vs. Rule-Execution — Boundary, Profile-Strategy, CPG-Reuse

**Status:** Accepted | **Date:** 2026-04-27

**Summary:** The IG separates Plan-Library resources (PlanDefinition, ActivityDefinition, CarePlan —
emitted by PVS adapters into FHIR servers) from downstream Rule-Execution services. Computability
slots (`condition`, `applicability`, `dynamicValue`) are intentionally not populated in plan-library
resources. Plan variants are differentiated via the `praxis-plan-topic` CodeSystem, not separate profiles.

**Full ADR:** [ADR-001-plan-library-vs-rule-execution.md](https://github.com/cognovis/fhir-praxis-de/blob/main/docs/adr/ADR-001-plan-library-vs-rule-execution.md)

### Key Decisions

| Decision | Rationale |
|---|---|
| Plan-Library in FHIR | Declarative, forward-directed templates belong in FHIR with mature profile support |
| Rule-Execution outside the IG | Billing validation rules are not necessarily CQL-shaped; operational stores can meet performance targets |
| No CPG adoption | EBM/BEMA/HZV rules are quartalsbezogen and Kassen-specific — not mappable to CQL phenotypes |
| Single `PraxisBillingPattern` profile | Job/Chain/DMP/HZV variants differ only in section composition — topic CodeSystem is sufficient |
| No `hkp-status` extension | Da Vinci PAS dual-lifecycle (CarePlan + Claim/ClaimResponse) is already present since v0.40.0 |

### Affected Repositories

- **fhir-praxis-de** (this IG): `praxis-plan-topic` and `praxis-plan-section` CodeSystems; empty computability slots are by design
- **PVS adapters**: `PraxisBillingPattern` remains the single PlanDefinition emission target; `topic` from `praxis-plan-topic`
- **Rule-execution services**: consume Plan-Library via FHIR API without editing computability slots

### Cross-References

- Internal adapter architecture: plan-chargeitem linkage
- Internal rule-execution architecture: Plan-Library vs. Rule-Execution
- Open-brain sessions: 18715, 18716, 18691 (Plan-Library boundary 2026-04-24); 18751 (3-layer billing 2026-04-25)
