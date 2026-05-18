# AW-SST Crosswalk

This page records how `fhir-praxis-de` relates to the KBV PVS archive and
system-change interface ("PVS-Archivierungs- und Wechsel-Schnittstelle",
`kbv.ita.aws`). It is a semantic crosswalk for archive/migration export and
selected onboarding import. It is not an inheritance plan.

## Decision

`fhir-praxis-de` does not use `KBV_PR_AW_*` profiles as parents.

AW-SST is a reference and crosswalk target because it is the closest official
FHIR model for PVS archive/change export. It is not a direct dependency or live
PVS synchronization contract.

See ADR-003:
[AW-SST as Crosswalk Target, Not Profile Parent](https://github.com/cognovis/fhir-praxis-de/blob/main/docs/adr/ADR-003-aw-sst-crosswalk.md).

## Sources Checked

Sources last checked: 2026-05-18.

| Source | Finding |
|---|---|
| [KBV update directory](https://update.kbv.de/ita-update/371-Schnittstellen/PVS-Archivierungs-Wechsel-Schnittstelle/) | Public AW-SST artifacts include FHIR model, bundle/data-area overview, examples, validation service, and FAQ. |
| [Simplifier `kbv.ita.aws`](https://simplifier.net/packages/kbv.ita.aws) | Public FHIR R4 package `kbv.ita.aws` version 1.2.0, described as PVS archive/change interface according to SGB V section 371. |
| Local package inspection of `kbv.ita.aws@1.2.0` | Package depends on old KBV/base package versions and contains broad `KBV_PR_AW_*` export profiles. |
| [INA/gematik AWST analysis](https://www.ina.gematik.de/mitwirken/arbeitskreise/analyse-der-effizienz-der-archiv-und-wechselschnittstelle-awst) | AWST version 1.3 was analyzed as a gap-analysis target. The working group calls out separation of archive and change use cases, versioning, and reusable information-model needs. |

## What This IG Does Better

The local model is optimized for live ambulatory practice workflows, not only
archive export:

| Area | Local advantage |
|---|---|
| Billing layers | Separates `ChargeItem` service lines, `Claim` submission, `Invoice` fiscal/tax invoices, `ChargeItemDefinition` catalog entries, and plan-library templates. |
| Diagnoses | Preserves clinical `asserter` and `evidence.detail` links for laboratory, imaging, reports, and AI-assisted review. |
| Encounters | Models the PVS billing-case/Schein anchor with local Schein identifiers and Scheinart coding. |
| Imaging | Adds IHE IMR, DICOM identifiers, imaging workflow, and radiation-protection traceability. |
| Tax | Models German invoice tax classification and small-business notice requirements outside AW Claim semantics. |
| PVS operation | Supports queue management, PVS writeback status, private billing review, multi-coverage routing, and local adapter semantics. |

AW-SST is stronger as an archive/migration export map. It is especially useful
for Claim structure, archive documents, import/export reports, and a broad list
of PVS data areas.

## Package and Dependency Boundary

| Topic | Decision |
|---|---|
| `kbv.ita.aws` dependency | Do not add to `sushi-config.yaml`. |
| `KBV_PR_AW_*` parent inheritance | Do not use. |
| AW canonical references | May be referenced in documentation, mapping tables, examples, or adapter code where useful. |
| Validation | Local resources validate against local profiles. Exported AW packages may be validated by export tooling against AW-SST if required. |

## Domain Crosswalk

| Domain | Local model | AW-SST target(s) | Decision | Implementation consequence |
|---|---|---|---|---|
| Package boundary | `sushi-config.yaml` dependencies on current local base stack | `kbv.ita.aws` package | Reference only | Keep out of direct dependencies unless a later packaging ADR changes this. |
| Patient | `FPDEPatient` / German base patient use | `KBV_PR_AW_Patient` | Crosswalk | Keep local profile; export mapper can transform to AW patient shape. |
| Practitioner | `PraxisPractitionerDE`, `PraxisPractitionerRoleDE`, KBV base practitioner use | `KBV_PR_AW_Behandelnder`, `KBV_PR_AW_Mitarbeiter`, `KBV_PR_AW_BehandelnderFunktion` | Crosswalk | Preserve local practitioner/role semantics; map LANR/role data on export. |
| Organization and location | `PraxisOrganizationDE`, local identifiers and PVS organization types | `KBV_PR_AW_Betriebsstaette`, `KBV_PR_AW_Organisation`, `KBV_PR_AW_Betriebsstaette_Ort`, `KBV_PR_AW_Hausbesuch_Ort`, `KBV_PR_AW_Unfall_Ort` | Crosswalk | Keep local organization profile; add export mappings for BSNR/IK/location roles. |
| Coverage | `FPDECoverageGKV`, `FPDECoveragePrivat`, multi-coverage Account pattern | `KBV_PR_AW_Krankenversicherungsverhaeltnis` | Crosswalk | Preserve local multi-coverage routing and private billing assignment; map to AW coverage when exporting. |
| Selective contracts | `Contract`, HZV/HVG extensions, `InsurancePlanDE` where needed | `KBV_PR_AW_Selektivvertrag` | Crosswalk | Keep contract identifier and tariff model; export to AW selective-contract representation. |
| Encounter / Schein | `EncounterPraxis` as billing-case/Schein anchor | `KBV_PR_AW_Begegnung` | Partial crosswalk | Do not parent. AW Begegnung is a completed consultation; local Schein remains the billing-case anchor. |
| Home visit | Appointment/Encounter context, local visit semantics where available | `KBV_PR_AW_Hausbesuch`, `KBV_PR_AW_Hausbesuch_Ort` | Crosswalk | If explicit home-visit Encounter profile is needed, align it to AW as export target without changing `EncounterPraxis`. |
| Stationary treatment | Local administrative workflow where present | `KBV_PR_AW_Stationaere_Behandlung` | Adapter/export crosswalk | No immediate local parent/profile change. |
| Diagnosis | `PraxisConditionDE`, older `PraxisCondition`, `DauerdiagnoseExt` | `KBV_PR_AW_Diagnose` | Crosswalk, no parent | Keep `asserter` and `evidence.detail`. Map AW flags such as duration and billing relevance on export/import. |
| Accident | Local BG/accident context and `Procedure`/`Condition` links | `KBV_PR_AW_Unfall`, `KBV_PR_AW_Unfall_Ort` | Crosswalk | Use AW as export target; do not collapse accident handling into diagnosis profile inheritance. |
| Anamnesis freetext | `PraxisComposition`, questionnaires, possible note observations | `KBV_PR_AW_Observation_Anamnese` | Gap | Add lightweight local `Observation.valueString` profile for card-file anamnesis lines if implementation needs freetext extraction/NLP. |
| Finding freetext | `PraxisComposition`, reports, possible note observations | `KBV_PR_AW_Observation_Befund` | Gap | Add lightweight local `Observation.valueString` finding profile; keep structured reports separate. |
| Vital signs and simple observations | `PraxisLabObservation`, `HbA1cObservationDE`, `SmokingStatusDE`, other Observation profiles as needed | `KBV_PR_AW_Observation_Blutdruck`, `_Puls`, `_Koerpertemperatur`, `_Bauchumfang`, `_Hueftumfang`, `_Raucherstatus`, `_Schwangerschaft` | Crosswalk | Preserve standard categories such as `social-history` for smoking; add AW coding as mapping/export detail where useful. |
| Lab observations | `PraxisLabObservation`, `PraxisLabDiagnosticReport`, `PraxisSpecimen` | AW has selected Observation/DiagnosticReport profiles and ring trial/certificate support | Crosswalk | Keep lab profiles; map only overlapping findings and certificates to AW export. |
| Allergy | Currently broad `PraxisFlag` / CAVE concept | `KBV_PR_AW_Allergie` | Gap | Add real `PraxisAllergyIntoleranceDE` for allergies. Keep `PraxisFlag` for broader CAVE, notes, risks, and workflow warnings. |
| Immunization | `PraxisImmunization` with KBV MIO vaccine vocabulary, no MIO parent | `KBV_PR_AW_Impfung` | Crosswalk | Keep local profile; AW is export target. Do not inherit from AW or MIO profile. |
| Procedures | `ProcedureAmbulantDE`, `RoentgenProcedurePraxisDe`, specialty profiles | `KBV_PR_AW_Untersuchung`, `_Therapie`, `_Ambulante_Operation`, `_Genetische_Untersuchung`, `_Kur` | Crosswalk | Local procedure profiles stay richer for OPS, imaging, and radiation protection. Export to AW procedure family as needed. |
| Imaging | IHE IMR ServiceRequest, ImagingStudy, DiagnosticReport, Appointment, Device, radiation-dose extensions | No equivalent AW imaging workflow model | Local better | Keep local model. AW may receive generic Procedure/DocumentReference exports only. |
| Referrals and follow-up | `ServiceRequest`, referral extensions, imaging request profiles | `KBV_PR_AW_Weiterbehandlung_durch`, `KBV_PR_AW_Behandlung_im_Auftrag_Ueberweisung`, `KBV_PR_AW_Ueberweisung_KH_Einweisung` | Crosswalk | Map local ServiceRequest variants to AW request profiles at export boundary. |
| Prescriptions | Local medication code systems and MedicationAdministration; prescription profiles not yet complete | `KBV_PR_AW_Verordnung_Arzneimittel`, `KBV_PR_AW_Medikament`, `KBV_PR_AW_Dauermedikation` | Gap/crosswalk | Use AW to guide future prescription profiles if needed; keep in-practice administration separate. |
| Heilmittel/Hilfsmittel | Local authorization/workflow structures where present | `KBV_PR_AW_Verordnung_Heilmittel`, `KBV_PR_AW_Verordnung_Hilfsmittel`, `KBV_PR_AW_Hilfsmittel` | Crosswalk | Map ServiceRequest/Device semantics on export; no broad profile cloning. |
| AU / incapacity | Local administrative extensions/workflow where present | `KBV_PR_AW_Verordnung_Arbeitsunfaehigkeit` | Crosswalk | Map local AU workflow to AW request when exporting. |
| Krankenbefoerderung | Local ServiceRequest workflow where present | `KBV_PR_AW_Krankenbefoerderung`, `_42019`, `_Befoerderungsmittel` | Crosswalk | Export mapping only unless local workflow requires a dedicated profile. |
| Sprechstundenbedarf | No central local profile yet | `KBV_PR_AW_Anforderung_Sprechstundenbedarf`, bundle profile | Crosswalk | Use AW as reference if demand/order support is added. |
| Prior authorization | `PASClaimDE`, `PASClaimResponseDE`, `PASTaskDE` | AW CoverageEligibilityRequest/Response for Kur, Heilmittel, Psychotherapie | Parallel patterns | Keep PAS for prior authorization. Map to AW eligibility resources only when the use case requires AW archive export. |
| Billing claim | `PASClaimDE` currently exists but is preauthorization only; examples include raw `Claim`; `ChargeItemPraxisDe`; `PraxisInvoiceDE` | `KBV_PR_AW_Abrechnung_Vorlaeufig`, `_vertragsaerztlich`, `_privat`, `_BG`, `_HzV_BesondereVersorgung_Selektiv` | Gap, high priority | Add local submitted-billing Claim profiles aligned with AW split. This is the most important implementation gap. |
| Billing service lines | `ChargeItemPraxisDe`, billing extensions, `ChargeItemDefinition` catalog | AW preliminary Claim item lines and item categories | Crosswalk | Keep ChargeItem as operational source. Export service lines into preliminary AW-style Claim items. |
| Fiscal invoice | `PraxisInvoiceDE` with tax categories, exemption reason, small-business notice | AW private/BG/final Claim with invoice-like metadata | Intentional divergence | Keep Invoice separate. Link or map to private/BG Claim where needed; do not treat AW Claim as tax invoice. |
| Billing patterns | `PraxisBillingPattern`, `PraxisBillingActivity`, `ChargeItemDefinition` | `KBV_PR_AW_Behandlungsbaustein_Definition`, `_Leistungsziffern`, `_Diagnose`, `_Verordnung`, `_Textvorlage`, `_OMIMCode`, `_Sonstige` | Crosswalk, no parent | Keep plan-library/rule-execution boundary from ADR-001. Export or import AW Behandlungsbaustein semantics through mapping. |
| Documents and attachments | `PraxisComposition`; no broad local DocumentReference profile yet | `KBV_PR_AW_Anlage`, `KBV_PR_AW_Gesundheitspass` | Gap/crosswalk | Add archive-oriented DocumentReference profile only if examples/export need attachment metadata beyond Composition. |
| Consents and directives | Local Consent extensions | `KBV_PR_AW_Patientenverfuegung`, `KBV_PR_AW_Vorsorgevollmacht`, `KBV_PR_AW_Notfallbenachrichtigter` | Crosswalk | Keep local consent model; map directive/notification use cases on export. |
| Provenance and audit | Local AI Provenance extensions and Provenance usage | `KBV_PR_AW_Provenienz`, `KBV_PR_AW_Report_Import`, `KBV_PR_AW_Report_Export`, `KBV_PR_AW_Hersteller_Software` | Crosswalk/gap | Add AW archive import/export AuditEvent support if the export pipeline needs explicit reports. |
| Appointment / scheduling | `ImagingAppointmentPraxisDe`, queue management extensions | `KBV_PR_AW_Termin`, `KBV_PR_AW_Bundle_Termin` | Crosswalk | Keep local scheduling profiles; export simple appointment data to AW Termin where needed. |
| Devices and materials | `ImagingDevicePraxisDe`, material/medication coding where present | `KBV_PR_AW_Hersteller_Software`, `KBV_PR_AW_Hilfsmittel`, `KBV_PR_AW_Material_Sache`, `KBV_PR_AW_Ringversuchszertifikat` | Crosswalk | Map only relevant devices/materials. Imaging device profile remains local workflow model. |
| Specialist cancer screening | No general local coverage for all AW screening modules | Many `KBV_PR_AW_Krebsfrueherkennung_*` profiles | Out of current scope | Do not implement unless a concrete fhir-praxis-de workflow requires it. Record as AW-covered domain. |
| Bundles | IG examples and local bundles | `KBV_PR_AW_Bundle_Patientenakte`, `_Adressbuch`, `_Termin`, `_Sprechstundenbedarf`, `_Behandlungsbaustein` | Export packaging | Bundle shape belongs to export tooling, not local profile inheritance. |

## Billing Claim Target Model

The AW Claim split is the strongest finding of the crosswalk. Local billing Claim
profiles should be added rather than reusing `PASClaimDE`.

| Local target profile | AW target | Key behavior |
|---|---|---|
| `PraxisPreliminaryBillingClaimDE` | `KBV_PR_AW_Abrechnung_Vorlaeufig` | Carries the actual billable item lines. AW uses `Claim.use = predetermination`. |
| `PraxisGKVClaimDE` | `KBV_PR_AW_Abrechnung_vertragsaerztlich` | Final GKV claim. References the preliminary claim; normal service items remain in the preliminary claim. |
| `PraxisPrivateClaimDE` | `KBV_PR_AW_Abrechnung_privat` | Final private claim. References the preliminary claim; keeps private receiver/payment/routing semantics distinct from local `Invoice`. |
| `PraxisBGClaimDE` | `KBV_PR_AW_Abrechnung_BG` | Final BG claim. References the preliminary claim and carries BG-specific billing context. |
| `PraxisSelectiveContractClaimDE` | `KBV_PR_AW_Abrechnung_HzV_BesondereVersorgung_Selektiv` | Final selective-contract/HZV claim. References the preliminary claim and contract context. |

`PASClaimDE` remains a prior-authorization/preauthorization profile. It must not
become the submitted billing Claim profile.

## Implementation Follow-Up

Implementation is tracked in bead `fpde-7eg`.

That bead must stay limited to AW-SST consequences:

1. Add AW-aligned local billing Claim profiles and examples.
2. Keep `ChargeItem`, `Claim`, and `Invoice` as separate layers.
3. Add only the local gap profiles needed for the crosswalk: freetext
   anamnesis/finding observations, real AllergyIntolerance, and archive
   DocumentReference/AuditEvent support if required by examples/export.
4. Keep `kbv.ita.aws` out of package dependencies and avoid every
   `Parent: KBV_PR_AW_*`.

## Non-Goals

- Do not clone the full AW-SST profile catalog.
- Do not implement all AW specialist modules.
- Do not convert this IG into an AW-SST export package.
- Do not use AW-SST as a live synchronization API.
- Do not broaden this into a non-AW profile harmonization effort.
