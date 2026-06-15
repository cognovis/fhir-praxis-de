# PoPP Check-in Workflow

This page describes how this Implementation Guide models patient check-in when a
Proof of Patient Presence (PoPP) signal is available. PoPP is treated as a
cryptographic patient presence proof for TI 2.0 workflows. In this IG, the
FHIR model records the treatment context and a local token anchor; validation of
the cryptographic token stays behind an adapter boundary.

> **Adapter boundary stub:** PoPP token validation is a stub in this IG. The
> `popp-token-anchor` extension records only the local token identifier anchor.
> Cryptographic validation is deferred until TI connector availability and the
> productive PoPP service are available to adapters.

## FHIR Contract

The PoPP check-in sketch is represented by
[`EncounterPraxisPoPP`](StructureDefinition-encounter-praxis-popp.html), which
extends [`EncounterPraxis`](StructureDefinition-encounter-praxis.html). The
profile requires the
[`treatment-context`](StructureDefinition-treatment-context.html) extension and
allows the [`popp-token-anchor`](StructureDefinition-popp-token-anchor.html)
extension.

The treatment context captures the reception check-in event by fixing the
workplace function to
[`PraxisWorkplaceFunctionCS#reception-check-in`](CodeSystem-praxis-workplace-function.html).
The token anchor uses a local identifier system at
`https://fhir.cognovis.de/praxis/NamingSystem/popp-token-id`; this is an
adapter hand-off anchor, not a validated PoPP token.

## Phase 1: Stationary eGK Check-in

In the first entry path, the patient presents the electronic health card at the
practice reception desk. The PVS or local adapter receives the card-read event,
classifies it as a reception check-in, and creates or updates the
`EncounterPraxisPoPP` resource for the visit.

The resulting Encounter carries the `treatment-context` extension with
`PraxisWorkplaceFunctionCS#reception-check-in` and a check-in timestamp. If the
local PoPP-capable component returns a token reference, the adapter also writes
`popp-token-anchor`. Until the TI connector can validate PoPP tokens
cryptographically, downstream systems must treat that anchor as a correlation
identifier only.

For appointment coordination, stationary eGK check-in usually corresponds to
[`AppointmentModeCS#in-person`](CodeSystem-appointment-mode.html). Post-check-in
workflow states can continue to use
[`AppointmentReadinessCS`](CodeSystem-appointment-readiness.html) where a
domain workflow needs readiness after `Appointment.status = checked-in`.

## Phase 2: GesundheitsID Online Check-in

In the second entry path, the patient starts check-in remotely through a
GesundheitsID-capable application. The app or upstream service establishes a
virtual patient-presence signal and passes a token reference to the PVS adapter.
The adapter creates or updates the same `EncounterPraxisPoPP` shape used for
stationary check-in.

The Encounter still records a treatment context with
`PraxisWorkplaceFunctionCS#reception-check-in`; for a virtual front-desk process,
this code identifies the administrative check-in function rather than a
physical room. The appointment mode can distinguish the care pathway, for
example [`AppointmentModeCS#video`](CodeSystem-appointment-mode.html) for an
online consultation or
[`AppointmentModeCS#in-person`](CodeSystem-appointment-mode.html) when the
online check-in precedes an in-practice visit.

Consent handling remains separate from the PoPP token anchor. Existing local
[`Consent`](profiles.html#consent) modeling and
[`Consent` extensions](extensions.html#consent--einwilligung) continue to cover
ePA release or other authorization contexts. This workflow does not modify
Consent definitions, Appointment mode terminology, Appointment readiness
terminology, or workplace function terminology.

## Upstream Dependency

As of 2026-06-15, this workflow depends on the Gematik PoPP specification
V1.0.0 RC draft. The adapter boundary will be resolved when the specification is
final and the PoPP service is productive. Until then, FHIR resources produced by
this IG must expose only the local token anchor and must not claim completed
cryptographic PoPP validation.
