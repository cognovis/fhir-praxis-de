# ADR-007: HealthcareService — ISiK Alignment Without Package Dependency

**Status:** Accepted  
**Date:** 2026-06-06  
**Bead:** fpde-ir8

## Context

Downstream systems must publish and consume ambulatory service offerings using a
canonical `HealthcareService` contract. gematik ISiK Terminplanung Stufe 5 defines
`ISiKMedizinischeBehandlungseinheit` (`https://gematik.de/fhir/isik/StructureDefinition/ISiKMedizinischeBehandlungseinheit`)
as the hospital-oriented treatment-unit profile on `HealthcareService`.

fhir-praxis-de already avoids undeclared ISiK package dependencies where registry resolution
is unreliable (see nursing-home Location modelling, CHANGELOG 0.79.0).

## Decision

**Use a local profile `PraxisHealthcareServiceDE` on base FHIR R4 `HealthcareService`, structurally
aligned with ISiK `ISiKMedizinischeBehandlungseinheit` cardinalities and semantics.**

Do **not** declare `de.gematik.isik-terminplanung` as an IG dependency. SUSHI cannot resolve
that package from the public FHIR package registry (verified 2026-06-06).

### Compatibility target

| Aspect | ISiK reference | fhir-praxis-de implementation |
|--------|----------------|-------------------------------|
| Canonical compatibility URL | `https://gematik.de/fhir/isik/StructureDefinition/ISiKMedizinischeBehandlungseinheit` | Documented mapping target; not inherited |
| Profile URL | — | `https://fhir.cognovis.de/praxis/StructureDefinition/praxis-healthcare-service-de` |
| `active` | 1..1 MS | 1..1 MS |
| `name` | 1..1 MS | 1..1 MS |
| `type` | 1..* MS | 1..* MS, bound to `PraxisHealthcareServiceTypeVS` |
| `specialty` | 1..* MS, IHE Fachrichtung slice | 1..* MS, bound to `PraxisHealthcareServiceSpecialtyVS` (KBV BAR2-WBO); IHE mapping documented |
| `providedBy` | optional in base | 1..1 MS → `PraxisOrganizationDE` (ambulatory org anchor) |
| `location` | supported | 0..* MS → `Location` |

### Terminology separation

- **`HealthcareService.type`**: PVS-agnostic service-offering category (`PraxisHealthcareServiceTypeCS`).
  Not `GenehmigungenLeistungsbereichCS` — approval evidence stays on `Basic` Genehmigung resources.
- **`HealthcareService.specialty`**: Ambulatory Fachgruppe via KBV BAR2-WBO (`PraxisHealthcareServiceSpecialtyVS`).
  Consumers needing ISiK/IHE Fachrichtung codes apply the documented crosswalk in
  `healthcare-service-contract.md`.

## Consequences

- Downstream consumers MUST use profile URL `https://fhir.cognovis.de/praxis/StructureDefinition/praxis-healthcare-service-de`.
- Hospital ISiK consumers can map `PraxisHealthcareServiceDE` instances to
  `ISiKMedizinischeBehandlungseinheit` using the field mapping table in the contract page.
- No transitive dependency on unpublished or registry-missing ISiK packages.
- Genehmigung evidence remains on `Basic` + `GenehmigungenExt`; it is linked to practitioners and
  organizations, not duplicated on `HealthcareService.type`.
