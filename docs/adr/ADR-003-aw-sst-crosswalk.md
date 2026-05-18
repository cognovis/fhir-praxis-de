# ADR-003: AW-SST as Crosswalk Target, Not Profile Parent

**Status:** Accepted
**Date:** 2026-05-18
**Deciders:** Malte, Codex
**Affected systems:** `fhir-praxis-de`, downstream PVS adapters, downstream archive/migration export tooling

## Context

The KBV PVS archive and migration interface is published as the FHIR package
`kbv.ita.aws` ("PVS-Archivierungs- und Wechsel-Schnittstelle"). The public
Simplifier package currently exposes `kbv.ita.aws` version 1.2.0 as an FHIR R4
package. The package is explicitly for archive and system-change use cases, not
for live operational PVS synchronization.

The package overlaps with several `fhir-praxis-de` domains:

- Encounters and home visits
- Diagnoses, accidents, anamnesis, findings, vital signs, allergies, and vaccinations
- Claims for GKV, private, BG, and selective-contract billing
- Treatment building blocks via PlanDefinition and ActivityDefinition
- Prescriptions, referrals, authorizations, documents, consents, import/export audit reports
- Stammdaten such as patient, practitioner, organization, location, and coverage

The tempting option is to derive local profiles directly from `KBV_PR_AW_*`
profiles. That would make the overlap visible in the inheritance chain, but it
would also import the archive/export shape into day-to-day operational profiles.

## Decision

`fhir-praxis-de` will not use any `KBV_PR_AW_*` profile as a parent.

AW-SST is used as:

1. A semantic crosswalk target for archive and system-change export.
2. A reference model for selected onboarding import mappings.
3. A source of useful billing and archive vocabulary where local profiles need
   explicit mappings.

AW-SST is not used as:

1. A direct package dependency in `sushi-config.yaml`.
2. A parent profile layer.
3. A live PVS synchronization contract.
4. A reason to clone every AW profile into this IG.

## Rationale

### AW-SST is archive-shaped

Several AW profiles constrain data for export completeness and historical
handover. Examples include required narrative text, fixed export profile
metadata, completed encounters, and bundled history-style exports. These are
reasonable for archive and migration packages, but too rigid for live PVS
workflows.

### The local model is operationally richer

`fhir-praxis-de` separates concerns that AW-SST compresses:

- `ChargeItem` is the operational billable service line.
- `Claim` is the billing submission layer.
- `Invoice` is the fiscal and tax invoice layer.
- `ChargeItemDefinition` is the catalog layer.
- `PlanDefinition` and `ActivityDefinition` describe plan-library templates.

This separation is important for pricing, tax, rule execution, PVS writeback,
private billing workflows, and auditability.

### Some AW constraints would remove required local semantics

For diagnoses, `KBV_PR_AW_Diagnose` is useful as an export target, but its shape
is not appropriate as a parent for `PraxisConditionDE`. In particular, the local
profile preserves clinical authorship and evidence links. Those are needed for
practice documentation, imaging/laboratory traceability, and AI-assisted
documentation review.

For encounters, `KBV_PR_AW_Begegnung` is a completed consultation encounter.
`EncounterPraxis` is closer to the PVS "Schein" / billing case anchor and carries
local Schein identifiers and Scheinart coding. Those are different concepts and
should not be forced into one inheritance path.

### The published package stack is older than this IG stack

The inspected `kbv.ita.aws` package is version 1.2.0 and depends on old KBV/base
package versions. This IG already depends on newer German base and KBV packages.
Adding `kbv.ita.aws` as a hard dependency would risk version pressure and
terminology/profile conflicts without providing operational benefits.

### External analysis also treats AWST as incomplete for efficient exchange

The INA/gematik AWST working group documented the need for a gap analysis
against AWST version 1.3, separation of archive and change use cases, a stronger
versioning strategy, and a more reusable interoperable information model. That
supports using AW-SST as a reference and crosswalk target, not as an unquestioned
local inheritance layer.

## Consequences

### For this IG

- Keep `kbv.ita.aws` out of `sushi-config.yaml` dependencies.
- Do not introduce `Parent: KBV_PR_AW_*` anywhere.
- Publish an AW-SST crosswalk page that maps local domains to AW targets and
  records intentional divergence.
- Add local profiles only where the crosswalk identifies real operational gaps.

### Required implementation follow-up

The concrete implementation follow-up is tracked in bead `fpde-7eg`.

The bead is limited to AW-SST consequences:

- Add local billing Claim profiles aligned with AW's preliminary/final claim
  split for GKV, private, BG, and selective-contract billing.
- Keep `PASClaimDE` scoped to prior authorization.
- Preserve `ChargeItem` and `Invoice` as separate local layers.
- Add lightweight local profiles only for high-value AW crosswalk gaps, such as
  freetext anamnesis/finding observations, real AllergyIntolerance separate from
  broad CAVE flags, and archive-oriented DocumentReference/AuditEvent support if
  needed.

### For adapters

Adapters should map from local operational resources to AW-SST export resources
at archive/migration boundaries. They should not emit AW profile instances for
normal live PVS operation unless the explicit export use case requires it.

## Rejected Alternatives

### Use AW-SST profiles as direct parents

Rejected. It would import archive/export constraints into live operational
profiles, force old package dependencies, and break local semantics in diagnosis,
encounter, billing, and plan-library domains.

### Add `kbv.ita.aws` as a direct dependency but avoid parent inheritance

Rejected for now. The IG can cite AW canonicals and document mapping decisions
without taking on the old dependency stack. If future tooling requires package
resolution for validation, this should be revisited as a dedicated packaging
decision.

### Ignore AW-SST entirely

Rejected. AW-SST is the most relevant official semantic reference for PVS archive
and system-change export. Ignoring it would make migration/onboarding harder and
would miss useful billing and archive structure, especially around Claim.

## References

- KBV update directory for PVS archive/change interface artifacts:
  https://update.kbv.de/ita-update/371-Schnittstellen/PVS-Archivierungs-Wechsel-Schnittstelle/
- Simplifier package `kbv.ita.aws`:
  https://simplifier.net/packages/kbv.ita.aws
- INA/gematik AWST efficiency working group:
  https://www.ina.gematik.de/mitwirken/arbeitskreise/analyse-der-effizienz-der-archiv-und-wechselschnittstelle-awst
- IG crosswalk page: `input/pagecontent/aw-sst-crosswalk.md`
