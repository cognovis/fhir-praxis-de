# Vererbungsarchitektur (Inheritance Architecture)

This page documents the 3-layer profile inheritance chain used in `de.cognovis.fhir.praxis` and its downstream Implementation Guides.

## 3-Layer-Chain Overview

German FHIR IGs for ambulatory practice management follow a three-tier inheritance hierarchy:

```
Layer 1 — KBV Base (kbv.basis 1.8.0)
    KBV_PR_Base_Condition_Diagnosis
    KBV_PR_Base_Patient
    KBV_PR_Base_Practitioner
    KBV_PR_Base_Organization
         |
         | (extends with praxis-specific constraints)
         v
Layer 2 — praxis-de Middle Layer (de.cognovis.fhir.praxis — THIS IG)
    PraxisConditionDE       (praxis-condition-de)
    PraxisPatientDE         (praxis-patient-de)
    PraxisPractitionerDE    (praxis-practitioner-de)
    PraxisOrganizationDE    (praxis-organization-de)
         |
         | (extends with specialty-specific constraints)
         v
Layer 3 — Specialty IGs (e.g. de.cognovis.fhir.dental)
    DentalConditionDE
    DentalPatientDE
    DentalPractitionerDE
    DentalOrganizationDE
```

This design means:
- **KBV Base profiles** define the German regulatory minimum (GKV identifiers, KV-specific codings).
- **praxis-de wrapper profiles** add cross-specialty constraints shared by all German ambulatory practices (asserter restriction, Telematik-ID MS, Kleinunternehmerregelung, AI provenance marker).
- **Specialty IGs** extend the middle layer with domain-specific rules (e.g. dental: ZE/KB/KFO billing codes, ZANR identifier).

## Wrapper Profiles in This IG

| Profile Name | Profile ID | KBV Parent | Key Constraints Added |
|---|---|---|---|
| PraxisConditionDE | `praxis-condition-de` | `KBV_PR_Base_Condition_Diagnosis` | `asserter` restricted to `KBV_PR_Base_Practitioner` (Arzt/Zahnarzt-Vorbehalt); AI Provenance Marker |
| PraxisPatientDE | `praxis-patient-de` | `KBV_PR_Base_Patient` | AI Provenance Marker |
| PraxisPractitionerDE | `praxis-practitioner-de` | `KBV_PR_Base_Practitioner` | `identifier[Telematik-ID]` promoted to Must Support |
| PraxisOrganizationDE | `praxis-organization-de` | `KBV_PR_Base_Organization` | `KleinunternehmerregelungExt` (§ 19 UStG); AI Provenance Marker |

## Praxis-Specific Constraints

### Asserter Restriction (PraxisConditionDE)

German law (BÄO, ZHG § 1 Abs. 5) requires that diagnoses be made by qualified physicians or dentists. The `asserter` field in `PraxisConditionDE` is restricted to `KBV_PR_Base_Practitioner` to enforce this:

- Medical assistants (MFA/ZFA) may be `recorder` but not `asserter`.
- This constraint is inherited by all Layer-3 profiles extending `PraxisConditionDE`.

### Telematik-ID Must Support (PraxisPractitionerDE)

The KBV base profile defines `identifier[Telematik-ID]` as optional. `PraxisPractitionerDE` promotes it to **Must Support** per gematik Telematikinfrastruktur requirements. Any system implementing this profile SHOULD support reading and writing the Telematik-ID.

### Kleinunternehmerregelung (PraxisOrganizationDE)

Practices below the § 19 UStG thresholds (since 2025: EUR 25,000 prior year / EUR 100,000 current year) are exempt from VAT. The `KleinunternehmerregelungExt` on `PraxisOrganizationDE` records this status. When active, invoices must carry the statutory notice "gemäß § 19 UStG wird keine Umsatzsteuer berechnet". Full billing logic is implemented in bead fpde-47a.

### AI Provenance Marker

All four wrapper profiles carry the `AiProvenanceApplicableExt` boolean marker (Context: `DomainResource`). When set to `true`, a corresponding `Provenance` resource with the AI-specific extensions (`AiGeneratedExt`, `AiProviderExt`, `AiModelExt`, `HumanReviewedExt`, etc.) SHOULD be present. This satisfies EU AI Act Art. 13 transparency requirements for AI-assisted clinical documentation.

The marker enables fast filtering (e.g. "show me all AI-assisted diagnoses") without requiring a `Provenance` join on every query.

## KBV Snapshot Generation

KBV publishes `kbv.basis` without snapshots (a known KBV publishing oversight). The CI pipeline runs the `generate-kbv-basis-snapshots` composite action (`.github/actions/generate-kbv-basis-snapshots/`) before SUSHI to inject snapshots, enabling inheritance from KBV base profiles. See bead fpde-shp.5.

## Cross-Reference: fhir-dental-de (fdde-pax)

The downstream IG `de.cognovis.fhir.dental` (fhir-dental-de) depends on this IG's middle-layer profiles. Bead `fdde-pax` in that project implements the Layer-3 dental profiles:

- `DentalConditionDE` extends `PraxisConditionDE` → adds ICNCP/ICD-10-GM dental specifics
- `DentalPatientDE` extends `PraxisPatientDE` → adds dental-specific patient identifiers
- `DentalPractitionerDE` extends `PraxisPractitionerDE` → adds ZANR Must Support
- `DentalOrganizationDE` extends `PraxisOrganizationDE` → adds KZV-specific organization identifiers

When updating the middle-layer profiles in this IG, check for breaking changes that affect fhir-dental-de. The dental IG pins `de.cognovis.fhir.praxis` in its `sushi-config.yaml` and must be updated when a new version of this IG is published.
