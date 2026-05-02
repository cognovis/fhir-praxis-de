# ADR-002: Radiation Dose — Extension on Procedure vs. Separate RadiationDoseObservation Profile

**Status:** Accepted
**Date:** 2026-05-02
**Deciders:** Architecture Council (Malte, Claude Sonnet)
**Affected systems:** `fhir-praxis-de` (this IG), downstream Aidbox instances, MCN Schwabach CT/MRI/X-ray workflow

## Context

The `radiation-dose` extension (`https://fhir.cognovis.de/praxis/StructureDefinition/radiation-dose`) is attached to `Procedure` resources and captures the following sub-fields:

| Field | UCUM Unit | Meaning |
|---|---|---|
| `dap` | uGy.m2 | Dose Area Product (Dosis-Flaechenprodukt, DFP/DAP) |
| `effectiveDose` | uSv | Effective dose (effektive Dosis) |
| `kvp` | kV | Peak tube voltage (Roehrenspannung) |
| `tubeCurrent` | mA | Tube current (Roehrenstrom) |
| `exposureTime` | s | Exposure time (Belichtungszeit) |

A DICOMweb coverage gap analysis raised the question of whether this extension is sufficient for German regulatory compliance, or whether a separate `RadiationDoseObservation` FHIR profile — analogous to DICOM TID 10007 or DICOM CID 10050 "Radiation Dose" patterns — is required.

### Legal context: §85 StrlSchG / §127 StrlSchV

§85 of the Strahlenschutzgesetz (StrlSchG) establishes the examination recordkeeping duty: the person responsible for radiation protection must keep written records ("Aufzeichnungen") for each individual examination. §127 of the Strahlenschutzverordnung 2018 (StrlSchV, BGBl. I S. 2034) governs record retention and availability, specifying how long records must be kept and that they must be accessible for inspection by radiation protection authorities (Strahlenschutzbehoerde). The required record elements are:

1. Date and time of the examination
2. Patient identification (name, date of birth)
3. Body region examined
4. Radiation quality (Strahlungsqualitaet) — kVp, filtration
5. Geometry of the beam path
6. Dose Area Product (Dosis-Flaechenprodukt/DAP) or equivalent dose quantity
7. Total patient dose / effective dose

The regulation does not prescribe any specific IT format, data model, or resource type. It mandates that the data is recorded and accessible for inspection by radiation protection authorities (Strahlenschutzbehoerde).

### Practice context

The primary deployment context for this IG in the MCN Schwabach pilot is ambulatory practice management, covering:

- Dental X-ray (2D panoramic, bitewing, periapical)
- Conventional X-ray (skeleton, thorax)
- CT (referral-based, less frequent)
- MRI (referral-based, no ionizing radiation — §85 StrlSchG / §127 StrlSchV do not apply)

For simple 2D X-ray in dental/ambulatory practice, dose measurement produces at most two or three numeric values (DAP, kVp, mA, exposure time). This is fundamentally different from CT multi-series dose reporting, where DICOM Dose SR (Structured Report) objects and DICOM TID 10007 / CID 10050 semantics are the appropriate primary records at the DICOM level.

## Decision

**Option A — Extension on Procedure is sufficient. No separate `RadiationDoseObservation` profile will be created for this IG.**

The `radiation-dose` extension on `Procedure`, combined with the contextual data already present on `Procedure`, satisfies §85 StrlSchG (examination recordkeeping duty) and §127 StrlSchV (record retention) requirements for ambulatory practice management.

## Reasoning

### 1. All §85 StrlSchG / §127 StrlSchV required fields are covered

§85 StrlSchG and §127 StrlSchV require the following data elements. The table below shows how each is covered:

| §85 StrlSchG / §127 StrlSchV requirement | Where covered |
|---|---|
| Date and time | `Procedure.performedDateTime` or `Procedure.performedPeriod` |
| Patient identification | `Procedure.subject` → Patient (name, birthDate) |
| Body region / examination type | `Procedure.code` (SNOMED / OPS / LOINC) + `Procedure.bodySite` |
| Radiation quality (kVp, filtration) | `radiation-dose.kvp` |
| Area dose product (DAP/DFP) | `radiation-dose.dap` |
| Effective dose | `radiation-dose.effectiveDose` |
| Exposure geometry / time | `radiation-dose.tubeCurrent` + `radiation-dose.exposureTime` |

All required fields are covered by the combination of the standard `Procedure` resource and the extension. No additional resource type is needed.

### 2. No German national IG mandates discrete Observation resources for ambulatory radiation dose

German national IGs (KBV, gematik, Medizinformatik Initiative / MII) do not mandate standalone `Observation` resources for radiation dose in an ambulatory FHIR IG. The MII Kerndatensatz Bildgebung uses extensions on imaging-related resources (e.g. `ImagingStudy`) for dose parameters, not standalone Observations. Introducing a `RadiationDoseObservation` profile in this IG would diverge from established German practice without legal or interoperability justification.

### 3. §85 StrlSchG / §127 StrlSchV do not mandate FHIR Observations

The regulation is technology-agnostic. It requires the data to be recorded and accessible, not that it be expressed as a specific FHIR resource type. A FHIR `Extension` carrying the same dose values is legally equivalent to a FHIR `Observation` — both are records of the required data elements.

### 4. CT/MRI dose reporting is primarily a DICOM-level concern

For CT examinations, the primary dose record is the DICOM Dose SR (Structured Report) object, which uses DICOM PS3.16 TID 10007 and CID 10050 semantics. The FHIR layer in an ambulatory practice IG is not the authoritative dose record for CT — the DICOM modality and PACS are. FHIR receives a summary. Modeling a full `RadiationDoseObservation` profile at the FHIR level for CT would create a competing record that is less authoritative than the DICOM SR, without providing additional compliance value.

### 5. Dental/ambulatory 2D X-ray use case does not warrant Observation overhead

For the primary use case (dental panoramic, bitewing, periapical X-ray), dose parameters are a small, well-bounded set of scalars. Modeling these as standalone `Observation` resources would require:

- A new profile with `Observation.code` bound to a ValueSet of DICOM CID 10050 or SNOMED codes for each parameter
- `Observation.focus` or `Observation.partOf` reference back to the `Procedure`
- Additional FHIR resource instances per exposure (5 Observations per X-ray instead of 1 Procedure + 1 extension)

This complexity adds no regulatory value and increases system overhead for the simplest imaging use case.

### 6. The DICOMweb coverage gap (G-3) is an interoperability note, not a compliance gap

The gap analysis flags that the FHIR IG does not use DICOM CID 10050 DCM codes (e.g. DCM#113722, DCM#113839) for dose semantics. This is an interoperability enhancement to consider for future DICOMweb integration, not a current legal compliance gap. DICOM semantic alignment can be added incrementally as DICOM concept mappings in the extension definition without requiring a new Observation profile.

## Consequences

### For `fhir-praxis-de` (this IG)

- No new profile is added. `RadiationDoseObservation` will not be created.
- The `radiation-dose` extension description SHOULD be updated to reference §85 StrlSchG / §127 StrlSchV explicitly, so that consumers understand the regulatory context.
- DICOM CID 10050 / TID 10007 alignment (adding DCM concept mappings) may be added to the extension in a future iteration as an interoperability enhancement, tracked as a separate bead.

### For downstream Aidbox instances

- No structural change. The `radiation-dose` extension on `Procedure` continues to be the mechanism for capturing dose data.
- `$validate` against `RoentgenProcedurePraxisDe` (or whichever profile binds this extension) remains the validation path.

### For MCN Schwabach CT/MRI/X-ray workflow

- The current extension is sufficient for §85 StrlSchG / §127 StrlSchV compliance in ambulatory practice.
- This decision does NOT block the DentalNow/medworkx pilot.
- If MCN Schwabach requires DICOM SR ingestion and full FHIR dose reporting at the CT level, a separate architecture decision (potentially outside this IG) would be needed. That is a future bead, not a current blocker.

## Option B: Separate RadiationDoseObservation Profile — Rejected

A standalone `RadiationDoseObservation` FHIR profile was considered and rejected for the following reasons:

1. **No legal mandate**: §85 StrlSchG / §127 StrlSchV do not require FHIR Observation resources. Legal compliance is achieved by recording the data, not by the resource type used.
2. **No German national precedent**: No national German IG mandates `Observation`-based dose reporting in an ambulatory FHIR context.
3. **Unnecessary complexity for the primary use case**: Ambulatory 2D X-ray dose parameters are a small scalar set. Modeling each as an Observation creates 5x resource overhead per examination with no compliance benefit.
4. **DICOM SR is the authoritative record for CT**: For CT, the DICOM modality produces the authoritative dose record. A FHIR Observation would be a less-authoritative copy.
5. **Interoperability alignment (DICOM CID 10050) is incremental**: DCM concept mappings can be added to the existing extension without requiring a new profile.

## References

- §85 Strahlenschutzgesetz (StrlSchG) — Aufzeichnungspflicht bei Strahlenexposition (examination recordkeeping duty): https://www.gesetze-im-internet.de/strlschg/__85.html
- §127 Strahlenschutzverordnung 2018 (StrlSchV, BGBl. I S. 2034) — Aufbewahrung und Weitergabe von Aufzeichnungen (record retention and availability): https://www.gesetze-im-internet.de/strlschv_2018/__127.html
- DICOM PS3.16 CID 10050 (Radiation Dose) — DICOM concept codes for dose quantities
- DICOM PS3.16 TID 10007 (Radiation Dose) — DICOM Template for Dose Structured Reports
- Extension definition: `input/fsh/extensions/radiation-dose.fsh`
- DICOMweb coverage gap analysis (internal architecture review)

## Revisit Triggers

This ADR should be revisited if any of the following becomes true:

- A German national IG (KBV, gematik, MII) publishes mandatory `Observation`-based radiation dose profiles for ambulatory FHIR IGs
- MCN Schwabach or a downstream consumer requires machine-readable FHIR Observation resources for dose reporting (e.g. for cross-institutional dose registries)
- The IG expands to cover interventional radiology or nuclear medicine, where DICOM SR ingestion and full Observation-based dose tracking are standard practice
- A FHIR IPS (International Patient Summary) or EU cross-border exchange requirement mandates Observation-based dose records
