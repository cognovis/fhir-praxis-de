# ADR-005: Account-Centered Billing Case Model

**Status:** Accepted
**Date:** 2026-05-26
**Deciders:** Malte, Codex
**Affected systems:** `fhir-praxis-de`, downstream PVS adapters, downstream MIRA/Polaris mapping, AW-SST export tooling

## Context

The PVS `Schein` is a billing case. Earlier `fhir-praxis-de` narrative could be
read as treating `EncounterPraxis` as both the clinical encounter and the
billing-case anchor. That mixed operational concepts that need different FHIR
lifecycles:

- A clinical contact happens on a concrete day and may be a practice visit or a
  home visit.
- A billing case spans a quarter or longer private/selective-contract period and
  carries the Schein identifier, type, coverage, and service period.
- HZV, HVG, and DMP enrollment describe a care-program relationship that may
  cover many contacts and billing cases.

The cross-repo keystone is Polaris bead `polaris-59tj` and Polaris ADR-039. The
matching `fhir-praxis-de` implementation work is tracked by `fpde-cj3`
(`AccountPraxisSchein` plus `EncounterPraxis` re-scope) and `fpde-mub`
(`Claim.diagnosis` quarterly diagnosis contract).

## Decision

`fhir-praxis-de` uses a three-layer model:

| Layer | FHIR resource | Local profile or convention | Meaning |
|---|---|---|---|
| Billing case | `Account` | `AccountPraxisSchein` | The PVS Schein and financial case anchor. It carries `identifier` = ScheinNummer, `type` = Scheinart, `servicePeriod`, `coverage`, `subject`, and open/closed case status. |
| Clinical contact | `Encounter` | `EncounterPraxis` | One live clinical contact, class `AMB` or `HH`. It is billing-agnostic: Scheinart and coverage stay on the Account. |
| Care program | `EpisodeOfCare` | Base R4 `EpisodeOfCare` convention | HZV, HVG, DMP, or similar enrollment/program participation across contacts and billing cases. |

`EncounterPraxis.account` links contacts to the billing case. `EncounterPraxis`
may also link `episodeOfCare` when a contact occurs under an HZV, HVG, DMP, or
similar program.

For HZV/HVG enrollment, this IG uses base R4 `EpisodeOfCare` with documented
type, status, period, managing organization, care manager, and existing HZV/HVG
extensions where needed. This ADR does not introduce an HZV-only
`EpisodeOfCarePraxisHZV` profile for MIRA/Polaris. A future generic
`PraxisProgramEnrollment` profile may be considered if multiple program types
need shared constraints that cannot be expressed clearly with base
`EpisodeOfCare` conventions.

## AW-SST Boundary

The AW-SST mapping remains a crosswalk/export target, not parent inheritance.
Neither `AccountPraxisSchein` nor `EncounterPraxis` derives from
`KBV_PR_AW_*`.

`EncounterPraxis` now crosswalks cleanly to `KBV_PR_AW_Begegnung` as a clinical
contact. It still does not parent on `KBV_PR_AW_Begegnung`, because FHIR
derivation can only tighten constraints. Deriving a live in-flight contact from
the archive-shaped AW profile would force archive-completeness requirements onto
operational contacts. The inspected `kbv.ita.aws@1.2.0` package also brings old
base-package dependency pressure.

`AccountPraxisSchein` has no AW Account equivalent. AW export decomposes the
local Account layer into encounter context (`KBV_PR_AW_Begegnung` or
`KBV_PR_AW_Hausbesuch`), coverage
(`KBV_PR_AW_Krankenversicherungsverhaeltnis`), and per-area Claims
(`KBV_PR_AW_Abrechnung_*`).

Local profiles reuse AW vocabulary and codes where they exist. The model must
not drift into an orthogonal representation that ignores AW semantics.

## Diagnosis Crosswalk

`PraxisConditionDE` and the Claim diagnosis contract crosswalk to
`KBV_PR_AW_Diagnose`. Diagnosis certainty (`A`, `G`, `V`, `Z`) follows KBV-AWS
semantics as recorded by `fpde-mub`:

| Diagnosesicherheit | Condition status mapping |
|---|---|
| `A` | `verificationStatus = refuted`; no `clinicalStatus` required |
| `G` | `verificationStatus = confirmed`; `clinicalStatus = active` |
| `V` | `verificationStatus = provisional` or `differential`; `clinicalStatus = active` |
| `Z` | `verificationStatus = confirmed`; `clinicalStatus = resolved` |

Quarterly billing diagnoses are projected on the Claim layer. Account remains
the billing-case anchor, not a diagnosis carrier.

## Consequences

- `EncounterPraxis` is described only as a clinical contact.
- `AccountPraxisSchein` is the Schein/billing-case anchor.
- `EpisodeOfCare` is reserved for care-program enrollment, including HZV/HVG and
  DMP.
- AW export tooling decomposes Account-centered local data into AW encounter,
  coverage, and Claim resources.
- The Wegegeld home-visit distance and zone data belongs on `EncounterPraxis`
  for `class = HH` contacts. The Wegegeld billing code itself remains a
  `ChargeItem` or `Claim.item`, not an Encounter profile field.

## Rejected Alternatives

### Treat the Schein as the canonical Encounter

Rejected. A Schein is a billing case and may span a quarter, multiple contacts,
or private/selective-contract periods. FHIR `Encounter` is the better fit for a
clinical contact, not the case aggregate.

### Use EpisodeOfCare for the billing case

Rejected. `EpisodeOfCare` is the care-program layer and is already the natural
home for HZV/HVG and DMP enrollment. Reusing it for Schein identity would collide
with program enrollment semantics.

### Parent local profiles directly on AW-SST profiles

Rejected. ADR-003 keeps AW-SST as a crosswalk target. Parent inheritance would
import archive/export constraints and the old package stack into live
operational profiles.

### Introduce an HZV-only EpisodeOfCarePraxisHZV profile now

Rejected. Base R4 `EpisodeOfCare` is sufficient for current MIRA/Polaris HZV/HVG
enrollment needs when paired with type/status/period/organization/care-manager
conventions and existing HZV/HVG extensions. If a reusable program-enrollment
constraint set becomes necessary, the next profile should be generic rather than
HZV-only.

## Revisit Triggers

Reconsider parenting `EncounterPraxis` on `KBV_PR_AW_Begegnung` only if a future
analysis confirms that AW_Begegnung's mandatory element set can be satisfied by
live contacts without archive-completeness leakage and that the AW package stack
is compatible with this IG's base dependencies.

Reconsider a generic `PraxisProgramEnrollment` profile if HZV, HVG, DMP, and
other care programs need shared profile constraints beyond base
`EpisodeOfCare`.

## References

- ADR-003: `docs/adr/ADR-003-aw-sst-crosswalk.md`
- AW-SST crosswalk page: `input/pagecontent/aw-sst-crosswalk.md`
- Claim diagnosis contract page: `input/pagecontent/claim-diagnosis-contract.md`
- `fpde-cj3`: AccountPraxisSchein profile and EncounterPraxis clinical-contact re-scope
- `fpde-mub`: Claim.diagnosis quarterly Behandlungsdiagnosen and KBV-AWS diagnosis certainty mapping
- `polaris-59tj` / Polaris ADR-039: downstream Account-centered billing-case decision
- `polaris-sa2j`: Wegegeld billing code remains ChargeItem/Claim.item
