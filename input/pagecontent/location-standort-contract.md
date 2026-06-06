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

## Workplace Function Terminology

### Decision: standard `Location.type` vs local catalog

FHIR `Location.type` binds extensibly to HL7 v3 `ServiceDeliveryLocationRoleType`
(`http://terminology.hl7.org/CodeSystem/v3-RoleCode`). That vocabulary covers broad delivery
settings (e.g. `PROFF` Provider's Office, `LAB` Laboratory, `RADDX` Radiology diagnostics,
`DENT` Dentistry clinic) but does **not** provide practical, room-level ambulatory functions
such as reception/check-in, waiting area, blood draw, vaccination, ECG room, wound care,
sterilization/utility, back office, or telehealth virtual workspace.

**Conclusion:** standard terminology alone is **not sufficient** for ambulatory practice room
configuration. fhir-praxis-de publishes a **hybrid** catalog:

| Artifact | URL |
|----------|-----|
| Local CodeSystem | `https://fhir.cognovis.de/praxis/CodeSystem/praxis-workplace-function` |
| Hybrid ValueSet | `https://fhir.cognovis.de/praxis/ValueSet/praxis-workplace-function` |

`PraxisWorkplaceFunctionVS` includes all `PraxisWorkplaceFunctionCS` codes plus selected v3
`ServiceDeliveryLocationRoleType` codes (`PROFF`, `OF`, `DX`, `LAB`, `RADDX`, `RADO`, `DENT`,
`OPS`) for site- or department-level locations where they fit without ambiguity.

**Room- and area-level** `Location.type` SHOULD use `PraxisWorkplaceFunctionCS` codes.
**Site-level** locations MAY use v3 codes such as `PROFF` when the whole practice site is
described.

No new `Location` profile is introduced; workplace functions are expressed through
`Location.type` on ISiK Location instances.

### Catalog mapping

| Workplace function | Preferred code | System |
|--------------------|----------------|--------|
| Reception / check-in | `reception-check-in` | PraxisWorkplaceFunctionCS |
| Waiting area | `waiting-area` | PraxisWorkplaceFunctionCS |
| Consultation room | `consultation-room` | PraxisWorkplaceFunctionCS |
| Treatment / procedure room | `treatment-procedure-room` or `DX` | local / v3 |
| Blood draw | `blood-draw` | PraxisWorkplaceFunctionCS |
| Vaccination / injection | `vaccination-injection` | PraxisWorkplaceFunctionCS |
| ECG room | `ecg-room` | PraxisWorkplaceFunctionCS |
| Ultrasound room | `ultrasound-room` | PraxisWorkplaceFunctionCS |
| Wound care | `wound-care` | PraxisWorkplaceFunctionCS |
| Specimen / lab handling | `specimen-lab-handling` or `LAB` | local / v3 |
| Imaging / radiology room | `imaging-radiology-room` or `RADDX` | local / v3 |
| Dental treatment room | `dental-treatment-room` or `DENT` | local / v3 |
| Sterilization / utility | `sterilization-utility` | PraxisWorkplaceFunctionCS |
| Back office | `back-office` | PraxisWorkplaceFunctionCS |
| Telehealth / virtual workspace | `telehealth-virtual-workspace` | PraxisWorkplaceFunctionCS |
| Practice site (whole site) | `PROFF` | v3-RoleCode |

All normative codes are PVS-agnostic generic workplace functions. Installation-specific room
labels (e.g. "Room Dr. Meyer") belong in `Location.name` or `Location.alias`, not in
`Location.type`.

### Five separate axes

Do not conflate these concerns on a single code or free-text field:

| Axis | FHIR element | Terminology / profile | Example |
|------|--------------|----------------------|---------|
| **Physical shape** | `Location.physicalType` | `location-physical-type` (`si`, `area`, `ro`, `vi`, …) | Room vs area vs virtual |
| **Operational function** | `Location.type` | `PraxisWorkplaceFunctionVS` | `consultation-room`, `blood-draw` |
| **Offered service** | `HealthcareService.type` / `specialty` | `PraxisHealthcareServiceTypeVS`, BAR2-WBO | General practice offering |
| **Practitioner qualification** | `Practitioner.qualification`, `PractitionerRole` | BAR2-WBO, Genehmigung on Basic | Who may perform a service |
| **Live occupancy / queue state** | `Encounter`, `Appointment`, `Task`, worklist runtime | Not modeled on `Location` | Patient waiting, room in use |

`HealthcareService.location` links a **service offering** to a site or room; it does not replace
`Location.type` workplace function. `PractitionerRole.location` assigns staff to a workplace for
routing; it does not encode qualification. Queue position and occupancy are runtime state on
encounters, appointments, or tasks — not normative `Location` codes.

### Hierarchy and organization linkage

Typical in-practice hierarchy:

```
ISiKStandort (site, physicalType si, type PROFF)
  ├── ISiKStandort (waiting area, physicalType area, type waiting-area)
  ├── ISiKStandortRaum (consultation room, physicalType ro, type consultation-room)
  ├── ISiKStandortRaum (blood draw, physicalType ro, type blood-draw)
  └── ISiKStandortRaum (shared reception, physicalType ro, type reception-check-in)
```

- `partOf` links child places to parent site or wing.
- `managingOrganization` identifies the organization responsible for the Location record
  (building operator or tenant practice).
- `EncounterPraxis.location`, `Task.location`, `Appointment` participant locations, and
  `Schedule` actors may reference the most specific known ISiK Location.

### Shared reception / shared site

When multiple tenant organizations share one physical building:

1. Publish **one** `Location` resource for the shared reception (or other shared area).
2. Set `managingOrganization` to the building operator or the organization that maintains the
   master Location record.
3. Each tenant `PractitionerRole.location` references the **same** Location id — do **not**
   duplicate physical Locations per `Organization`.
4. Tenant-specific routing uses `PractitionerRole.organization` + shared `location` reference.

See `ExampleWorkplaceSharedReception` with `ExampleWorkplaceRoleGeneralReception` and
`ExampleWorkplaceRoleDentalReception` in the workplace location examples.

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
- **Seed and update room Locations** with stable business identifiers, `physicalType`, `partOf`
  hierarchy, `managingOrganization`, and `Location.type` from `PraxisWorkplaceFunctionVS`.
- Prefer `PraxisWorkplaceFunctionCS` codes at room/area granularity; use v3 `PROFF`/`RADDX`/etc.
  only where the mapping table above applies.
- For shared reception or shared site scenarios, publish one physical Location and reference it
  from multiple tenant `PractitionerRole` records — never fork duplicate Locations per
  Organization.
- Installation display names go in `Location.name` / `alias`; normative `type` codes stay
  PVS-agnostic.

Mandatory terminology URLs for workplace functions:

| Purpose | URL |
|---------|-----|
| `Location.type` (room/area) | `https://fhir.cognovis.de/praxis/ValueSet/praxis-workplace-function` |
| Local workplace codes | `https://fhir.cognovis.de/praxis/CodeSystem/praxis-workplace-function` |

### Worklist consumer (owner: read/consume only)

- Consume canonical ISiK Location references through worklist and default-location contracts.
- Update tests and readers that assert `praxis-nursing-home-location-de`.
- Do not write `Location` resources in the worklist layer; normalization belongs in the adapter
  or FHIR contract.
- **Display and configure** workplaces using `Location.type` codes from `PraxisWorkplaceFunctionVS`
  for filters, icons, and default routing — not `Location.name` alone.
- Distinguish workplace function (`Location.type`) from offered service (`HealthcareService`) and
  from live queue/occupancy state (runtime encounter/task data).
- For shared reception, resolve the single canonical Location reference across tenant contexts;
  scope worklist rules by `PractitionerRole.organization` when multiple tenants share a site.

## Examples

| Instance | Scenario |
|----------|----------|
| `ExampleWorkplaceMedicalCenterSite` | Practice site with `PROFF` and `physicalType` si |
| `ExampleWorkplaceSharedReception` | Shared reception referenced by two tenant roles |
| `ExampleWorkplaceWaitingArea` | Waiting area (`physicalType` area) |
| `ExampleWorkplaceConsultationRoom` | Consultation room with local workplace code |
| `ExampleWorkplaceBloodDrawRoom` | Blood draw workplace |
| `ExampleWorkplaceEcgRoom` | ECG workplace |
| `ExampleWorkplaceRadiologyRoom` | Imaging room with v3 `RADDX` |
| `ExampleWorkplaceDentalRoom` | Dental treatment room for co-located tenant |
| `ExampleWorkplaceTelehealthEndpoint` | Virtual workspace (`physicalType` vi) |
| `ExampleWorkplaceRoleGeneralReception` / `ExampleWorkplaceRoleDentalReception` | Shared reception without Location duplication |

### Out of scope for fhir-praxis-de

- Adapter seeding and type-regeneration implementation.
- Worklist rule or UI changes.
- Rebasing `EncounterPraxis` on an ISiK Encounter profile.
