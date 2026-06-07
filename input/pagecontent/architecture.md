# Architecture Overview

This page documents the normative architecture decisions that shape the design
of this Implementation Guide. Published IG pages are self-contained contracts;
decision outcomes are stated here rather than delegated to internal repository
documents.

## AW-SST as Crosswalk Target, Not Profile Parent

**Status:** Accepted | **Date:** 2026-05-18

**Summary:** The IG treats KBV AW-SST/PVS-AWS as a semantic crosswalk target for
archive and system-change export, not as a profile parent layer. Local profiles
must not derive from `KBV_PR_AW_*`, and `kbv.ita.aws` remains outside direct
package dependencies. The main implementation follow-up is an AW-aligned local
Claim profile set while preserving the local `ChargeItem`/`Claim`/`Invoice`
separation.

**Crosswalk:** [AW-SST Crosswalk](aw-sst-crosswalk.html)

### Key Decisions

| Decision | Rationale |
|---|---|
| No AW parent inheritance | AW-SST is archive/export-shaped and would remove needed live-workflow semantics |
| No direct `kbv.ita.aws` dependency | The published package stack is older than this IG stack and is not needed for local validation |
| AW as crosswalk target | AW-SST remains the official semantic reference for PVS archive/change export |
| Claim implementation required | AW's preliminary/final Claim split is useful and should be reflected in local billing Claim profiles |
| Scope kept narrow | Follow-up is tracked as one AW bead, not a broad profile-harmonization program |

## Plan-Library vs. Rule-Execution Boundary

**Status:** Accepted | **Date:** 2026-04-27

**Summary:** The IG separates Plan-Library resources (PlanDefinition, ActivityDefinition, CarePlan —
emitted by PVS adapters into FHIR servers) from downstream Rule-Execution services. Computability
slots (`condition`, `applicability`, `dynamicValue`) are intentionally not populated in plan-library
resources. Plan variants are differentiated via the `praxis-plan-topic` CodeSystem, not separate profiles.

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

- [Plan-Library vs. Rule-Execution — IG Boundary](plan-library-boundary.html)
- [AW-SST Crosswalk](aw-sst-crosswalk.html)
