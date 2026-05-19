# ADR-004: CAVE / Flag / Allergy Architecture

**Status:** Accepted
**Date:** 2026-05-19
**Deciders:** Malte Sussdorff
**Affected systems:** `fhir-praxis-de` IG, `adapter` adapter (pvs-x-pvs), platform-v2 engine

---

## Context and Problem Statement

Active adapter beads (adapter-ut6m, adapter-phel) require clarity on four FHIR modelling
questions around `Flag`, `AllergyIntolerance`, and CAVE before implementation can proceed:

1. Are `hzv`/`dmp` categories from `flag_bild_to_code.yaml` valid `flag-kategorie` codes?
2. Does `PraxisAllergyIntoleranceDE` cover NFDM allergy fields, or are extensions needed?
3. Should HZV/DMP enrollment status be persisted as `Flag`? What is the platform-v2 read source?
4. Does the `x-pvs-cave-marker` CodeSystem URL violate the vendor-neutral naming policy?

---

## Decision 1: flag-kategorie CodeSystem Is Complete

**Decided:** The `flag-kategorie` CodeSystem (hinweis, cave, risiko, op, info, dicom) requires
no new codes for the CAVE/Flag/Allergy domain.

**Rationale:** The `hzv` and `dmp` values in `flag_bild_to_code.yaml` are internal YAML
transport labels, not FHIR `Flag.category.code` values. HZV and DMP admin markers are not
clinical flags and should not appear in the clinical flag taxonomy. The `cave` and `sonstige`
YAML categories map naturally to existing `cave`/`hinweis` codes respectively.

**Consequences:**
- No changes to `input/fsh/codesystems/flag-kategorie.fsh`
- No new CodeSystem resources needed in fhir-praxis-de for admin marker categories

---

## Decision 2: PraxisAllergyIntoleranceDE Profile Requires No Changes

**Decided:** `PraxisAllergyIntoleranceDE` is sufficient for NFDM allergy data. Profile changes
are not required.

**Rationale:** All semantically required FHIR elements (`criticality`, `verificationStatus`,
`code.coding`, `reaction.exposureRoute`) are accessible via the base `AllergyIntolerance`
resource. The gap lies in the adapter mapper (`mapNfdmAllergyToAllergyIntolerance`), which
currently uses text-parsing only and does not populate structured fields from NFDM's `Stufe`
and `Reaktionstyp`.

The profile itself exposes the necessary elements. Implementing the structured NFDM mapper
enrichment is a adapter task and does not require a profile change in fhir-praxis-de.

**Consequences:**
- No changes to `input/fsh/profiles/praxis-allergy-intolerance.fsh`
- Follow-up adapter bead: enrich NFDM SQL query + mapper to populate `criticality` from `Stufe`
  and use structured `verificationStatus` from `Reaktionstyp`
- `PraxisAllergyIntoleranceDE` version remains unchanged; no downstream breaking change

---

## Decision 3: HZV and DMP Enrollment — EpisodeOfCare and Coverage Are Canonical

**Decided:** HZV participation is canonical in `EpisodeOfCare`. DMP status is canonical in
`Coverage.dmpIndicator`. Flag resources from `flag_bild_to_code.yaml` are supplementary
provenance only and MUST NOT be used as the read source in the platform-v2 engine.

**Rationale:** The `flag_bild_to_code.yaml` YAML comments explicitly mark the HZV/DMP entries
as "noncanonical" with references to their canonical FHIR homes. The x.pvs data model has
authoritative tables (`HVGPatient`/`HVGVertrag` for HZV; `Schein.DMPKennzeichnung` for DMP)
that map directly to the correct FHIR resources. Using Flag as the engine read source would
create a dual-source dependency with unclear conflict resolution semantics.

**Canonical read sources:**

| Admin Status          | Canonical FHIR Resource | x.pvs Source                  | Status          |
|-----------------------|-------------------------|----------------------------------|-----------------|
| HZV enrollment        | `EpisodeOfCare`         | `HVGPatient`, `HVGVertrag`       | Implemented     |
| DMP program enrollment| `EpisodeOfCare`         | `HVGPatient` (DMP contract rows) | Implemented     |
| DMP Schein-level code | TBD                     | `Schein.DMPKennzeichnung`        | Not yet mapped  |

**Permitted use of HZV/DMP Flags:** The 3 active CAVE-icon mappings may be retained in
`flag_bild_to_code.yaml` for worklist/UI purposes (e.g., "HZV endet" warning surface). When
retained, the resulting `Flag` resources MUST carry supplementary-provenance tagging to prevent
engine misuse.

**Consequences:**
- platform-v2 engine rule implementations MUST NOT query `Flag` for HZV or DMP enrollment status
- A guardrail (lint rule or engine-layer type constraint) should be added in adapter to prevent
  accidental Flag-based reads (follow-up bead)
- No semantic migration required: existing HZV/DMP Flag resources remain valid as audit trail data.
  The URL rename migration (Decision 4) is a separate concern — it updates `coding.system`, not the
  Flag's enrollment semantics.

---

## Decision 4: CodeSystem URL Rename — x-pvs-cave-marker → cave-marker

**Decided:** Rename `https://fhir.cognovis.de/CodeSystem/x-pvs-cave-marker` to
`https://fhir.cognovis.de/CodeSystem/cave-marker`.

**Rationale:** Cognovis enforces vendor-neutral FHIR canonical URLs. The segment `x-pvs`
is a PVS vendor name and violates this policy. The CodeSystem is internal to Cognovis (not
published in fhir-praxis-de IG) but the same naming discipline applies to all Cognovis FHIR
URLs, including internal ones loaded into Aidbox.

**Migration scope** (adapter Implementation Bead):
1. Update `flag_bild_to_code.yaml` → `codeSystem:` field
2. Update Aidbox CodeSystem resource (if already created)
3. Update any persisted `Flag.code.coding[].system` values (data migration)

**Consequences:**
- Adapter code change: `flag_bild_to_code.yaml` + CodeSystem loader
- Aidbox: re-create CodeSystem resource with new URL
- Data: migrate existing Flag resources (if any have been persisted with the old URL)
- No changes to fhir-praxis-de IG (the CodeSystem is Cognovis-internal, not IG-published)

---

## Alternatives Considered

### Decision 3 Alternative: Remove HZV/DMP Flags Entirely

Deleting the 3 CAVE-icon YAML tuples would be cleaner architecturally. Rejected because:
- The YAML comment indicates they were explicitly approved (`approved 2026-05-19 by Malte`)
  for supplementary worklist use
- Removing them would lose the worklist surface for "HZV endet" warnings before a canonical
  UI feature is built
- The risk of engine misuse is addressed by the guardrail bead, not by deletion

### Decision 4 Alternative: Absorb Codes into flag-kategorie

If Point 1 had concluded that `hzv`/`dmp` are valid clinical flag categories, the entire
`x-pvs-cave-marker` CodeSystem could be absorbed. Since Point 1 concluded they are admin
markers (not clinical flags), absorption is not appropriate.

---

## Implementation Follow-up Beads

| Bead | Project | Scope |
|------|---------|-------|
| adapter-hse0 | adapter | NFDM allergy mapper enrichment (Stufe/Reaktionstyp structured mapping) |
| adapter-kylm | adapter | platform-v2 engine guardrail: prohibit Flag reads for HZV/DMP status |
| adapter-4qbg | adapter | Rename x-pvs-cave-marker → cave-marker (YAML + Aidbox + data migration) |

---

## References

- Research document: `docs/research/cave-flag-allergy-clarification-2026-05-19.md`
- `input/fsh/codesystems/flag-kategorie.fsh` — current 6-code flag taxonomy
- `input/fsh/profiles/praxis-allergy-intolerance.fsh` — current AllergyIntolerance profile
- `adapter/packages/pvs-x-pvs/config/v2-lookups/flag_bild_to_code.yaml` — CAVE-icon mappings
- `adapter/packages/pvs-x-pvs/src/lib/mappers/linkdata-safety-mappers.ts` — NFDM/LinkData mappers
- `adapter/packages/pvs-x-pvs/src/lib/pvs-db-types.ts` — `NfdmListItemBaseRow` type definition
