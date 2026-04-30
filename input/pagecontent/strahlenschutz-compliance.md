# Strahlenschutz-Compliance (§83/§85 StrlSchG)

This page explains how the profiles in this IG map to the German radiation protection law requirements (Strahlenschutzgesetz — StrlSchG and Strahlenschutzverordnung — StrlSchV).

## Legal Basis

| Paragraph | Requirement | FHIR Mapping |
|-----------|-------------|--------------|
| §83 StrlSchG / §119 StrlSchV | Rechtfertigende Indikation — a physician must justify every radiation exposure | `Procedure.reasonCode[rechtfertigende-indikation]` (1..* required, ICD-10-GM) |
| §85 StrlSchG / §117 StrlSchV | Aufzeichnungspflicht — records must document date, exposure parameters, and responsible personnel | `Procedure.performedDateTime` (1..1 MS), `extension[radiationDose]`, `Procedure.performer[anwender]` |
| §14 StrlSchV | Fachkunde Strahlenschutz — the person applying radiation must hold the appropriate qualification | `extension[anwender-fachkunde]` on `Procedure.performer[anwender]` |

## Profiles

### RoentgenProcedurePraxisDe

The `RoentgenProcedurePraxisDe` profile extends the IPS `Procedure-uv-ips` profile to represent a radiation procedure in German ambulatory radiology.

Key constraints:

- **`category`** fixed to SNOMED `103693007` (Diagnostic procedure)
- **`code`** bound to `ImagingProcedureVS` (extensible) — covers DVT, OPG, conventional X-ray, CT, and other modalities
- **`performedDateTime`** 1..1 MS — mandatory date/time of exposure (§85 StrlSchV)
- **`performer[anwender]`** (1..*) — the person performing the radiation application; function coded as `RadiologyRoleCS#MTR`; optional `extension[anwender-fachkunde]` holds the Fachkunde Strahlenschutz category
- **`performer[strahlenschutzverantwortlicher]`** (0..1) — the supervising physician; function coded as `RadiologyRoleCS#SupervisingRadiologist`
- **`reasonCode[rechtfertigende-indikation]`** (1..*) — required binding to `RechtfertigendeIndikationVS` (ICD-10-GM codes); carries the `rechtfertigende-indikation-attest` extension for attestation metadata

### Extensions

| Extension | URL | Context | Purpose |
|-----------|-----|---------|---------|
| `radiation-dose` | `https://fhir.cognovis.de/praxis/StructureDefinition/radiation-dose` | `Procedure` | DAP, effective dose, kVp, tube current, exposure time |
| `rechtfertigende-indikation-attest` | `https://fhir.cognovis.de/praxis/StructureDefinition/rechtfertigende-indikation-attest` | `Procedure.reasonCode` | Assessor (Practitioner), assessment date, free-text justification |
| `anwender-fachkunde` | `https://fhir.cognovis.de/praxis/StructureDefinition/anwender-fachkunde` | `Procedure.performer` | Fachkunde Strahlenschutz category (from `FachkundeStrahlenschutzVS`) |

## FHIR Linkage Pattern: ChargeItem.service → RoentgenProcedurePraxisDe

For billing codes that represent radiation procedures (contained in `RadiationRelevantBillingCodeVS`), the `ChargeItemPraxisDe` profile enforces via FHIRPath invariant `radiation-service-required` that `ChargeItem.service` must reference a `Procedure` resource:

```
code.coding.where(memberOf('https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes')).empty()
or service.where(resolve() is Procedure).exists()
```

This ensures that every billable radiation service (e.g. GOÄ 5370 — CT Schädel) is linked to the corresponding `RoentgenProcedurePraxisDe` documentation record, creating a complete audit trail.

```
ChargeItem (GOÄ 5370)
  └── service ──► RoentgenProcedurePraxisDe
                    ├── performedDateTime (§85 StrlSchV)
                    ├── performer[anwender] → MTR + Fachkunde
                    ├── performer[strahlenschutzverantwortlicher] → Facharzt
                    ├── reasonCode[rechtfertigende-indikation] → ICD-10-GM + Attest
                    └── extension[radiation-dose] → DAP, kVp, …
```

## Röntgenbuch (§85 StrlSchV)

The §85 StrlSchV Röntgenbuch requirement is fulfilled through a search-based aggregation pattern — not by a dedicated FHIR resource:

```
GET [base]/Procedure?
  _profile=https://fhir.cognovis.de/praxis/StructureDefinition/roentgen-procedure-praxis-de
  &performer.organization=[organization-id]
  &date=ge2026-01-01&date=le2026-12-31
```

This returns all `RoentgenProcedurePraxisDe` instances for a given organization and time period, forming the Röntgenbuch. Each record contains:

- Patient reference
- Date/time of exposure (`performedDateTime`)
- Radiation application personnel (`performer[anwender]`) with Fachkunde
- Supervising physician (`performer[strahlenschutzverantwortlicher]`)
- Justifying indication (`reasonCode[rechtfertigende-indikation]`) with attestation metadata
- Radiation dose parameters (`extension[radiation-dose]`)

## Reference

See `architecture.md` (ADR-001) for the Plan-Library vs. Rule-Execution boundary decision that governs how `ChargeItemPraxisDe` integrates with the billing workflow.
