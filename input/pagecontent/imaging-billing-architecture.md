# Imaging Billing Architecture

This page describes the 3-layer architecture for imaging billing in the German practice management FHIR IG. It covers the role of external FHIR ConceptMaps, the ChargeItemDefinition catalog, the MIRA rule engine, and the R4 Subscription pattern used for workflow event triggers.

## Overview: 3-Layer Model

The imaging billing pipeline is structured in three distinct layers. Each layer has a clearly scoped responsibility:

| Layer | FHIR Mechanism | Location | Responsibility |
|-------|---------------|----------|---------------|
| **Terminology** | `ConceptMap` (external package) | `de.cognovis.terminology.imaging` | Modality-to-billing-code suggestion tables |
| **Catalog** | `ChargeItemDefinition` | This IG | Billing item definitions with pricing and applicability |
| **Business Logic** | MIRA Rule Engine | External service | Validation, budget limits, audit, final billing decision |

### Layer 1 — Terminology (FHIR ConceptMaps, External Package)

The suggestion-table ConceptMaps are defined in the external package `de.cognovis.terminology.imaging@2026.0.0`. They are NOT part of this IG — they are a dependency declared in `sushi-config.yaml`.

**ConceptMaps are suggestion-tables only — they are NOT the billing engine.**

| ConceptMap | Canonical URL | Mapping |
|-----------|--------------|---------|
| ModalityToGoaeSuggestion | `https://fhir.cognovis.de/imaging/ConceptMap/modality-to-goae-suggestion` | DICOM CID 29 Modality + Body-Part → GOA billing suggestion |
| ImagingStudyToEbmGop | `https://fhir.cognovis.de/imaging/ConceptMap/imaging-study-to-ebm-gop` | Modality + Body-Part → EBM GOP suggestion |
| GoaeContrastAgentBilling | `https://fhir.cognovis.de/imaging/ConceptMap/goae-contrast-agent-billing` | Contrast Agent → GOA billing code |

PVS adapters and MIRA use `ConceptMap/$translate` to look up initial billing code candidates. These suggestions feed into the ChargeItemDefinition catalog lookup and the MIRA rule engine for final validation.

**Important**: A `$translate` match is a recommendation, not a billing decision. The MIRA rule engine always makes the final billing decision after applying budget constraints (RLV/QZV), patient context, and Kassenspezifische rules.

### Layer 2 — Catalog (ChargeItemDefinition)

`ChargeItemDefinition` resources in this IG define the formal billing items: pricing, applicable payer types, and catalog metadata. They are referenced from `PlanDefinition` actions via `definitionCanonical`.

The catalog is the authoritative source for billing item properties. ConceptMap suggestions point into the catalog; the catalog does not point back to ConceptMaps.

### Layer 3 — Business Logic (MIRA Rule Engine)

MIRA is an external rule engine. It:

- Receives FHIR Subscription notifications (see below)
- Queries `ConceptMap/$translate` for billing code suggestions
- Looks up `ChargeItemDefinition` for pricing and applicability
- Applies budget rules (RLV/QZV quarter limits)
- Applies Kassenspezifische constraints
- Emits validated `ChargeItem` resources to the PVS

MIRA rule definitions live outside this IG. See [Plan-Library vs. Rule-Execution Boundary](plan-library-boundary.html) for the general boundary rationale.

## R4 Subscription Pattern

### Why R4, Not R5 SubscriptionTopic

This IG targets FHIR R4 (4.0.1). R5 introduced `SubscriptionTopic` as a structured mechanism for defining subscription event types. In R4, subscriptions use a criteria-based approach: the `Subscription.criteria` field contains a FHIR search URL that defines the trigger condition.

R5 `SubscriptionTopic` migration is a future task. For now, the R4 `Subscription` backport pattern is used with the following conventions:

- `status = #requested` — marks the resource as a template, not a live subscription
- `criteria` — FHIR search URL defining the trigger condition
- `channel.type = #rest-hook` — webhook delivery to the consuming service
- `channel.payload = application/fhir+json` — full FHIR resource delivered on trigger

MIRA instantiates these templates at runtime, replacing the placeholder `channel.endpoint` with the real service URL.

### Subscription Event Triggers

Three Subscription templates are defined as examples in this IG:

| Instance | Criteria | Downstream Target | Purpose |
|----------|---------|------------------|---------|
| `example-subscription-report-distributed` | `DiagnosticReport?status=final` | Webhook distribution service | Automated report delivery (PDF, referrer notification) |
| `example-subscription-study-signed` | `DiagnosticReport?status=preliminary` | Workflow engine | Radiologist sign-off handoff |
| `example-subscription-appointment-arrived` | `Appointment?status=arrived` | Worklist service | DICOM MWL update on patient arrival |

### R4 Extension Filtering Limitation (SubscriptionStudySigned)

The `report-substatus` extension on `DiagnosticReport` carries substatus values such as `signed`, `draft`, and `amended`. R4 Subscription criteria cannot filter by extension values — only by standard search parameters.

The `example-subscription-study-signed` template uses `DiagnosticReport?status=preliminary` as the broad trigger. The MIRA subscription handler post-filters by the `report-substatus` extension value (`signed`) after receiving the notification. Only reports with `status=preliminary AND report-substatus=signed` are processed as signed study events.

This is a known limitation of the R4 pattern. R5 `SubscriptionTopic` will allow extension-based filter criteria.

## Relationship to Other IG Pages

- [Plan-Library vs. Rule-Execution Boundary](plan-library-boundary.html) — general boundary between FHIR-expressed plans and external rule engines
- [Architecture Decisions](architecture.html) — ADR index
