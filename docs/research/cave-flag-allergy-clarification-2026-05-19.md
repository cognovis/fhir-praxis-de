# CAVE / Flag / Allergy Architecture Clarification

**Date:** 2026-05-19
**Author:** Malte Sussdorff (via bead fpde-46j)
**Status:** Decided
**Related ADR:** [ADR-004 — CAVE / Flag / Allergy Architecture](../adr/ADR-004-cave-flag-allergy-architecture.md)
**Unblocks:** adapter-ut6m (P0, demo-blocker 2026-06-22), adapter-phel (P1)

---

## Context

Four concrete architectural questions around `Flag`, `AllergyIntolerance`, and CAVE arose from
active adapter beads. This document records the research findings and decisions for each. The
original broader Cross-PVS architecture discussion (Medistar, Pvs, ...) remains out of scope.

**Source files analyzed:**
- `adapter/packages/pvs-x-pvs/config/v2-lookups/flag_bild_to_code.yaml`
- `adapter/packages/pvs-x-pvs/src/lib/mappers/linkdata-safety-mappers.ts`
- `fhir-praxis-de/input/fsh/codesystems/flag-kategorie.fsh`
- `fhir-praxis-de/input/fsh/profiles/praxis-allergy-intolerance.fsh`
- `adapter/packages/pvs-x-pvs/src/lib/pvs-db-types.ts` (`NfdmListItemBaseRow`)

---

## Clarification Point 1: flag-kategorie Completeness Audit

### Finding

`flag-kategorie` CodeSystem currently defines 6 codes:

| Code    | Display               | Semantics                            |
|---------|-----------------------|--------------------------------------|
| hinweis | Hinweis               | General notice                       |
| cave    | CAVE                  | Drug / allergy warning               |
| risiko  | Risiko                | Risk hint (e.g. fall risk)           |
| op      | OP                    | Surgical note                        |
| info    | Info                  | Informational                        |
| dicom   | DICOM-Sicherheitshinweis | MRI/pacemaker contraindication    |

`flag_bild_to_code.yaml` uses a `category` field with values `hzv` and `dmp`. These are
**YAML-internal classification labels**, not FHIR `Flag.category.code` values. They are distinct
from the `flag-kategorie` CodeSystem.

The YAML's active FHIR codes (`hzv-teilnahme-aktiv`, `hzv-teilnahme-endend`, `dmp-diabetes-extern`)
live in the separate `x-pvs-cave-marker` CodeSystem — they are NOT flag-kategorie codes.

### Mapping Table: Adapter YAML category → flag-kategorie

| Adapter YAML `category` | flag-kategorie code | Notes                                                              |
|-------------------------|---------------------|--------------------------------------------------------------------|
| hzv                     | — (none)            | Admin enrollment marker; NOT a clinical flag (see Point 3). Present in current active YAML. |
| dmp                     | — (none)            | Admin enrollment marker; NOT a clinical flag (see Point 3). Present in current active YAML. |
| cave                    | `cave`              | Aligns semantically with the existing `cave` code. Not in current active YAML mappings; hypothetical future mapping. |
| sonstige                | `hinweis` or `info` | Catch-all; map contextually. Not in current active YAML mappings; named in bead description as possible category. |

### Decision

**flag-kategorie is complete for its intended purpose (clinical flags).**

The `hzv` and `dmp` YAML categories do not correspond to clinical flags and therefore require no
new `flag-kategorie` codes. The YAML categories are internal transport labels.

**No follow-up implementation bead needed** for `flag-kategorie` extension.

---

## Clarification Point 2: NFDM-Allergie-Mapping vs. PraxisAllergyIntoleranceDE

### Finding

#### Available NFDM Source Fields (via `NfdmListItemBaseRow`)

| Field           | Type                  | Notes                                    |
|-----------------|-----------------------|------------------------------------------|
| ListItemId      | string                | PK                                       |
| NotfallDatenId  | string                | FK to NFDM dataset                       |
| PatientNummer   | number                | Patient reference                        |
| PatientNfdmId   | string \| null        | NFDM patient ID                          |
| Description     | string \| null        | Free-text substance/allergy description  |
| AdditionalInfo1 | string \| null        | Free-text reaction type or severity label|
| AdditionalInfo2 | string \| null        | Free-text additional reaction detail     |
| PointInTime     | string \| null        | Date of recording                        |
| DateCreated     | string \| Date \| null| Record creation date                     |
| DateModified    | string \| Date \| null| Last modification date                   |

**Note:** `Stufe` (severity level) and `Reaktionstyp` (reaction type) are exposed only as
free text in `AdditionalInfo1`/`AdditionalInfo2`, not as structured columns in the current
SQL query projection.

#### KBV NFDM Structured Fields (not yet surfaced)

KBV NFDM defines structured data that the current DB query projection does not expose:
- `Stufe` → maps to `AllergyIntolerance.criticality` (leicht=low, mittelschwer/schwer=high)
- `Reaktionstyp` (zuverlässig/möglicherweise/nicht eruierbar) → maps to `verificationStatus`
  (confirmed/unconfirmed)
- Substance SNOMED code → `code.coding` with SNOMED CT terminology binding
- Route of exposure → `reaction.exposureRoute`

#### Current Mapper Behavior (`mapNfdmAllergyToAllergyIntolerance`)

The mapper uses `toPseudoKrabllinkSource` to treat NFDM fields as LinkData free-text input,
then applies `parseKrabllinkAllergyText` (regex-based text parsing). This produces:
- `code.text` (substance name, text-extracted)
- `verificationStatus` (confirmed/refuted via negation pattern matching)
- `type` (allergy/intolerance, text-inferred)
- `category` (food/medication/environment, text-inferred)
- `reaction.manifestation` (reaction text, text-extracted)

No structured NFDM-specific extensions are currently emitted. `criticality` is not populated.

#### Profile Gap Analysis

| NFDM Field        | PraxisAllergyIntoleranceDE Element | Gap?        |
|-------------------|-------------------------------------|-------------|
| Description       | code.text                           | Covered     |
| AdditionalInfo1/2 | reaction.manifestation.text, note  | Covered     |
| PointInTime       | recordedDate                        | Covered     |
| Stufe (structured)| criticality                         | Gap in MAPPER (not in profile) |
| Reaktionstyp (structured) | verificationStatus         | Gap in MAPPER (not in profile) |
| Substance SNOMED  | code.coding (SNOMED CT)             | Gap in MAPPER (no SNOMED lookup) |
| Route             | reaction.exposureRoute              | Gap in MAPPER only (field available in base AllergyIntolerance; explicit profiling not required) |

### Decision

**PraxisAllergyIntoleranceDE profile requires NO changes.**

All required FHIR elements (`criticality`, `verificationStatus`, `code.coding`, `reaction`) are
already present in the base `AllergyIntolerance` resource and are accessible through the profile
(they are MS-flagged or available via the base resource).

The gap is **in the adapter mapper**, not the profile:
1. The NFDM SQL query needs to expose `Stufe` and `Reaktionstyp` as structured columns
2. `mapNfdmAllergyToAllergyIntolerance` needs to populate `criticality` from `Stufe`
3. Optionally: SNOMED CT lookup for substance codes (if a lookup table is available)

**Follow-up bead created:** adapter-hse0 — see AK-3 below.

---

## Clarification Point 3: Admin-Marker Decision — HZV / DMP

### Finding

`flag_bild_to_code.yaml` maps CAVE006.png (red X icon) to two admin-marker Flags:
- `hzv-teilnahme-aktiv` — active HZV participation
- `dmp-diabetes-extern` — externally-managed DMP Diabetes
- `hzv-teilnahme-endend` (CAVE021.png) — HZV participation ending

The YAML itself marks these with `annaReview` comments explicitly stating they are
**noncanonical**:
- HZV: "approved 2026-05-19 by Malte - noncanonical admin marker; HVGPatient/EpisodeOfCare remains canonical for enrollment"
- DMP: "approved 2026-05-19 by Malte - noncanonical hint only; canonical DMP source is Schein.DMPKennzeichnung -> Coverage.dmpIndicator"

The x.pvs data model has:
- `HVGPatient` table → maps to `EpisodeOfCare` (HZV and DMP enrollment, canonical; already implemented in adapter recommendation-mappers)
- `Schein.DMPKennzeichnung` → per-Schein DMP billing code; mapping destination is TBD (not yet mapped in adapter). This is a separate, additive concern from enrollment.

### Decision

**HZV/DMP Flags are non-canonical supplementary provenance only.**

The authoritative FHIR resources for enrollment/program status are:

| Admin Status         | Canonical FHIR Resource    | Source (x.pvs)                  | Status               |
|----------------------|----------------------------|------------------------------------|----------------------|
| HZV enrollment       | `EpisodeOfCare`            | `HVGPatient`, `HVGVertrag`         | Implemented          |
| DMP program enrollment| `EpisodeOfCare`           | `HVGPatient` (DMP contract rows)   | Implemented          |
| DMP Schein-level code| TBD                        | `Schein.DMPKennzeichnung`          | Not yet mapped       |

**platform-v2 Engine read source:** The rule engine MUST read HZV status from `EpisodeOfCare` and
DMP status from `Coverage.dmpIndicator`. Flag resources from `flag_bild_to_code.yaml` MUST NOT
be used as the read source.

**Persistence:** The 3 existing CAVE-icon mappings MAY be retained in `flag_bild_to_code.yaml`
for migration audit and worklist purposes (e.g., surfacing "HZV endet" warnings in the UI).
If retained, they must include `Flag.meta.tag` or a `note` marking them as
`supplementary-provenance` to prevent engine misuse.

**No migration/deletion of existing Flag data required.** Existing imported Flags remain valid
as audit trail.

**Follow-up bead created:** Architectural guardrail in adapter platform-v2 engine to prevent
Flag-based HZV/DMP reads — see AK-3 below.

---

## Clarification Point 4: Vendor-Leak in Adapter CodeSystem URL

### Finding

`flag_bild_to_code.yaml` declares:
```yaml
codeSystem: https://fhir.cognovis.de/CodeSystem/x-pvs-cave-marker
```

The URL segment `x-pvs` is a PVS vendor name. The fhir-praxis-de IG enforces vendor-neutral
URLs via `scripts/check-ig-vendor-leaks.sh`. While this CodeSystem is Cognovis-internal (not
IG-published), the same naming discipline applies to all Cognovis FHIR URLs for consistency and
to avoid vendor lock-in leakage into data.

### Decision

**Rename CodeSystem URL to `https://fhir.cognovis.de/CodeSystem/cave-marker`.**

This CodeSystem:
- Is Cognovis-internal (NOT published in the fhir-praxis-de IG)
- Must be loaded into Aidbox as an internal CodeSystem resource
- Must NOT contain vendor-specific path segments (`x-pvs`, `pvs`, `medistar`, etc.)

The rename affects:
1. `flag_bild_to_code.yaml` → `codeSystem:` field
2. Aidbox CodeSystem resource (if already created)
3. Any FHIR Flags already persisted with the old CodeSystem URL (migration: `coding.system` update)

**Follow-up bead created:** adapter Implementation Bead for URL rename — see AK-3 below.

---

## AK-3: Follow-up Beads

| # | Scope         | Title                                                             | Project      | Bead ID        |
|---|---------------|-------------------------------------------------------------------|--------------|----------------|
| 1 | Point 2       | NFDM allergy mapper enrichment (Stufe, Reaktionstyp structured)  | adapter      | adapter-hse0   |
| 2 | Point 3       | platform-v2 engine guardrail: no HZV/DMP reads from Flag              | adapter      | adapter-kylm   |
| 3 | Point 4       | Rename x-pvs-cave-marker CodeSystem URL to cave-marker        | adapter      | adapter-4qbg   |

---

## AK-4: Downstream Bead References

The decisions above unblock the following active beads:

- **adapter-ut6m** (P0, demo-blocker 2026-06-22): The admin-marker decision (Point 3) clarifies
  that HZV/DMP flag data is supplementary only. The platform-v2 engine must use EpisodeOfCare and
  Coverage as canonical read sources. This decision removes the Flag-vs-EpisodeOfCare ambiguity
  blocking the rule engine implementation.

- **adapter-phel** (P1): The NFDM mapper gap analysis (Point 2) confirms that
  `PraxisAllergyIntoleranceDE` needs no profile changes. The mapper enrichment (follow-up bead)
  is additive and does not block adapter-phel's current work. Adapter-phel can proceed with the
  existing profile; the enriched NFDM fields will be added in the follow-up bead without
  breaking changes.
