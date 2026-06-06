# Location / ISiK Standort Contract

This page documents how fhir-praxis-de uses gematik ISiK Location profiles for nursing-home
placement, home visits, and in-practice physical sites.

## Package Dependency

`sushi-config.yaml` declares `de.gematik.isik-basismodul@4.0.3`. Nursing-home and practice
Location references use the published ISiK profiles directly — there is no local shadow
`Location` profile in this IG.

| ISiK profile | Use in ambulatory practice |
|---|---|
| `ISiKStandort` | Facility/site, ward/station, or practice main site |
| `ISiKStandortRaum` | Room (nursing-home room, treatment room, consultation room) |
| `ISiKStandortBettenstellplatz` | Bed placement when bed-level granularity is known |

Canonical URLs: `https://gematik.de/fhir/isik/StructureDefinition/{profile}`.

## Nursing-Home Placement

`PraxisNursingHomeResidencyDE` (EpisodeOfCare) carries the patient's place via
`NursingHomeLocationExt`:

- Reference the **most-specific** known ISiK Location (`ISiKStandortRaum` when room is known,
  otherwise the deepest `ISiKStandort` ward or facility node).
- Resolve parent places through `Location.partOf` — do not duplicate ward/facility as free text.
- Free-text station, room-number, and seating-group extensions are **not** part of the contract.

Typical hierarchy:

```
ISiKStandort (facility, type NCCF)
  └── ISiKStandort (ward, physicalType wa)
        └── ISiKStandortRaum (room, physicalType ro)
```

## Encounter and PractitionerRole Locations

`EncounterPraxis.location.location` accepts `ISiKStandort`, `ISiKStandortRaum`, and
`ISiKStandortBettenstellplatz`:

- **Home visit (class=HH)** to a nursing-home resident: reference the patient's nursing-home
  ISiK Location. Together with an active `PraxisNursingHomeResidencyDE`, this enables
  nursing-home EBM code selection and Mitbesuch (EBM 01413) detection when multiple patients
  share the same Location on the same day.
- **In-practice contact (class=AMB)**: reference the practice `ISiKStandort` site or a
  specific `ISiKStandortRaum` treatment/consultation room.

`PractitionerRole.location` and `PraxisHealthcareServiceDE.location` should use the same ISiK
profiles for routing and filter context (see *HealthcareService Contract*).

## Migration from 0.79.x–0.80.x

Version 0.79.0 introduced a local `PraxisNursingHomeLocationDE` shadow profile. That profile is
**removed** as of this release:

| Before | After |
|---|---|
| `meta.profile` = `.../praxis-nursing-home-location-de` | `https://gematik.de/fhir/isik/StructureDefinition/ISiKStandort` or `ISiKStandortRaum` |
| `NursingHomeLocationExt` → `PraxisNursingHomeLocationDE` | → `ISiKStandort` / `ISiKStandortRaum` / `ISiKStandortBettenstellplatz` |
| `EncounterPraxis.location` → `PraxisNursingHomeLocationDE` or bare `Location` | → ISiK Location profiles only |

Consumers must update `meta.profile`, instance validation, and `targetProfile` assertions.

## Downstream Impact

### Adapter repository (owner: Location resource provisioning)

- Consume the updated `de.cognovis.fhir.praxis` package and regenerate FHIR constants/types.
- Provision nursing-home and practice `Location` resources with ISiK `meta.profile` URLs.
- Map legacy `PraxisNursingHomeLocationDE` instances to the appropriate ISiK profile by
  `physicalType` (facility/ward → `ISiKStandort`, room → `ISiKStandortRaum`).
- Write `PractitionerRole.location[]` and `HealthcareService.location[]` using ISiK profiles.
- Do not reintroduce a local shadow Location profile in the adapter layer.

### Worklist consumer (owner: read/consume only)

- Consume canonical ISiK Location references through worklist and default-location contracts.
- Update tests and readers that assert `praxis-nursing-home-location-de`.
- Do not write `Location` resources in the worklist layer; normalization belongs in the adapter
  or FHIR contract.

### Out of scope for fhir-praxis-de

- Adapter seeding and type-regeneration implementation.
- Worklist rule or UI changes.
- Rebasing `EncounterPraxis` on an ISiK Encounter profile.
