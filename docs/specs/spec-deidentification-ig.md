# Feature Spec: De-Identification IG (`io.cognovis.de-identification.de`)

**Status**: Draft
**Author**: Malte Sussdorff + spec-developer
**Date**: 2026-05-02
**Version**: 1.0
**Bead**: `fpde-7yo` (Epic, this repo)
**Companion ADR**: `consumer-sdk/docs/adr/ADR-027-privacy-and-compliance.md`
**Target repo**: `cognovis/fhir-deidentification-de` (new, separate from this repo)

---

## Section 1: Executive Summary

A FHIR R4 Implementation Guide that declares — for German ambulatory practice
data — *which fields are PII/PHI, which method de-identifies them, and which
trust-zone modes apply per field*. Extends Health Samurai's
`io.health-samurai.de-identification.r4` with DE-specific identifier systems
(LANR, BSNR, KVNR, KIM-Telecom) and DE-specific resource profiles (ChargeItem
EBM/GOÄ, Account, Coverage, CarePlan). Ships a machine-consumable manifest
artefact that consumer-sdk codegen turns into `pii-fields.ts`, eliminating today's
hand-maintained duplicated PII lists. Implements the technical counterpart to
ADR-027 §7 (provenance chain) and provides the field catalogue for the four
trust-zone modes (`agent-readonly`, `analytics`, `hipaa-safe-harbor`,
`llm-anonymized`). Primary consumer: consumer-sdk SDK + LLM-Gateway. Secondary:
optional Aidbox-side de-identification.

---

## Section 2: Problem Statement & Motivation

**Today's pain (from Round 1):**

ConsumerSDK maintains hand-curated `pii-fields.ts` at multiple sites:

1. `packages/fhir-de/src/client/pii-fields.ts` — consumed by `AnonymizingTransport`
2. `packages/adapter-common/src/anonymization/pii-fields.ts` — consumed by mcp-server filter path and PVS extract
3. Hardcoded `FREE_TEXT_FIELDS` + regex patterns in `anonymizing-transport.ts`

These three sites drift. When a new resource type ships in fhir-praxis-de or
fhir-dental-de, every site must be patched. ADR-012 §5 (revised 2026-04-30)
declared the IG as the single source of truth, but the IG itself does not
yet exist.

**Trigger now (from Round 1):**

Dental agents go live in 1–2 weeks. The Charly-PVS data path covers patient,
practitioner, treatment, and claim resources — including BEMA/HZV positions
that fhir-praxis-de's current PII list does not cover. Without the IG, dental
will introduce a fourth hand-maintained PII list.

**Beyond pain reduction (from Round 1):**

The IG also serves as the *normative document* for DSGVO/AI-Act compliance
posture (ADR-027 §10 maps Art. 10 + Annex IV §2 + Art. 26 to the IG as
technical evidence). Public publication on `npm.cognovis.de` makes it
referenceable in audits and supports future external adoption (e.g.
fhir-dental-de, third-party DE-vendor consumers).

**Scope boundary**: This IG declares *what* and *which method* per field
per mode. It does not declare *how* the method is implemented. The
implementation lives in consumer-sdk (codegen + AnonymizingTransport +
LLM-Gateway tokenization). See the consumer-sdk workstream `adr-027-privacy`
label (11 beads) for the implementation side.

---

## Section 3: User Stories / Use Cases

### UC-1: New PII-bearing resource type added to platform
**Actor**: cognovis developer adding e.g. a new DE-Custom-Resource for HZV claims
**Precondition**: Resource type is profiled in fhir-praxis-de or fhir-dental-de
**Trigger**: Resource type passes through AnonymizingTransport without coverage
**Main Flow**:
1. Developer opens PR on `cognovis/fhir-deidentification-de`
2. Adds FSH entries declaring fields + methods + modes
3. CI runs: SUSHI compile + IG Publisher build + negative-test-corpus regression
4. PR merges, tag `vN.M.K` cut, GitHub Actions publishes to `npm.cognovis.de`
5. ConsumerSDK-1bx codegen runs (in consumer-sdk-CI or via `bun update`), `pii-fields.ts` regenerates
6. ConsumerSDK builds; new fields are now redacted / scrubbed / generalized per mode
**Postcondition**: New resource type covered without consumer-sdk-side hand-edits
**Exceptions**: CI rejection if (a) negative-test-corpus matches scrub patterns, (b) version-pin in consumer-sdk stale, (c) coverage regression vs prior version

### UC-2: ConsumerSDK consumes IG at build time
**Actor**: consumer-sdk build pipeline (CI or local `bun run codegen`)
**Precondition**: New IG version published; consumer-sdk pinned to that version in `package.json`
**Trigger**: `bun run codegen` invocation
**Main Flow**:
1. Codegen reads `node_modules/io.cognovis.de-identification.de/package.tgz`
2. Extracts the manifest artefact (`output/manifest/pii-fields.json` or the canonical `Library` resource)
3. Validates manifest schema
4. Emits `packages/fhir-de/src/client/generated/pii-fields.ts` and `free-text-patterns.ts`
5. Emits `packages/llm-gateway/src/generated/quasi-id-generalizers.ts`
6. CI lint gate confirms no manual edits to generated files
**Postcondition**: ConsumerSDK consumers (`AnonymizingTransport`, LLM-Gateway tokenization layer, PVS Faker pipeline) read from regenerated files
**Exceptions**: Codegen aborts on manifest schema mismatch (e.g. unknown method code, missing required field) — fail-closed

### UC-3: Aidbox server-side de-identification (future, optional)
**Actor**: Aidbox FHIR server in a practice deployment
**Precondition**: Aidbox has the IG installed via `$fhir-package-install`; admin enables server-side de-id mode
**Trigger**: FHIR client requests resources with a `de-identification`-mode header
**Main Flow**:
1. Aidbox reads the manifest's ViewDefinitions or `Library` patterns
2. Applies the same algorithm (SHA-256(salt:id), field deletion, generalize) server-side
3. Returns transformed resources
**Postcondition**: Bit-identical anon-IDs produced server-side and client-side for the same input + salt (cross-consumer interop guaranteed by IG-declared algorithm)
**Exceptions**: Algorithm mismatch between Aidbox version and IG version → rejected per ADR-027 §7 boot-time check

### UC-4: External LLM-Gateway tokenization request
**Actor**: consumer-sdk LLM-Gateway processing an `ExternalAnonymizedPrompt` per ADR-027 §6
**Precondition**: Mode `llm-anonymized` selected; request enters gateway
**Trigger**: SDK call `llm.complete(prompt, { pii: 'llm-anonymized', … })`
**Main Flow**:
1. Gateway reads codegen-emitted manifest entries scoped to mode `llm-anonymized`
2. For each PII field: replace with random per-request token `[<RT>-<N>]`
3. For each quasi-ID: apply IG-declared generalizer
4. Apply free-text scrub patterns from IG `Library`
5. Re-ID-risk preflight against IG-declared population thresholds
6. Send anonymized prompt; receive response; output filter; re-substitute tokens
7. Drop mapping
**Postcondition**: LLM provider received anonymous data; caller receives full-PII response
**Exceptions**: Re-ID-preflight blocks request → return 422 to caller

### UC-5: Compliance auditor traces a treatment back to spec
**Actor**: external auditor (DSGVO Aufsichtsbehörde, AI-Act conformity body, internal compliance reviewer)
**Precondition**: Auditor has questions about a specific PII treatment ("how does cognovis handle KVNR?")
**Trigger**: Auditor request
**Main Flow**:
1. Cognovis points to `io.cognovis.de-identification.de@<version>` published doc
2. Auditor finds `Patient.identifier where system='https://fhir.kbv.de/NamingSystem/KVID-10'` entry
3. Method shown: `cryptoHash` for mode `agent-readonly` / random-token+generalize for `llm-anonymized`
4. Cross-reference to ADR-027 §5/§6 + AVV-MCN §9 mapped via ADR-027 §9
**Postcondition**: Auditor has traceable evidence per field per use case

---

## Section 4: Data Model

### Entity: Manifest Entry (one row per field per mode-applicability)

| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `resourceType` | code | Yes | Must be a valid FHIR R4 resource type or DE-Custom-Resource declared in this IG |
| `path` | string (FHIRPath subset) | Yes | FHIRPath with `.where()` filters; consumers MUST support FHIRPath subset (Round 4 Q3 = (b)) |
| `method` | code | Yes | One of: `redact`, `cryptoHash`, `scrubFreeText`, `replaceToken`, `randomToken`, `generalize:ageGroup`, `generalize:relativeDate`, `generalize:icdCategory`, `generalize:plzPrefix` |
| `appliesIn` | code[] | Yes | Subset of `[agent-readonly, analytics, hipaa-safe-harbor, llm-anonymized]`; non-empty |
| `params` | object | No | Method-specific (e.g. age-bucket boundaries for `generalize:ageGroup`, prefix-length for `generalize:plzPrefix`) |
| `rationale` | string | No | Human-readable justification for compliance-trace purposes |
| `legacyCompat` | boolean | No | True if this entry exists to preserve coverage of legacy hardcoded consumer-sdk PII lists (Round 8 Q4) |

**Storage**: As a `Library` FHIR resource (canonical) with content extracted to JSON sidecar at build (per Round 3 Q3 hybrid: (i) primary, (iv) derived).

### Entity: Free-Text Scrub Pattern (Library content)

| Field | Type | Required |
|-------|------|----------|
| `name` | string | Yes |
| `regex` | string | Yes |
| `replacement` | string | Yes (e.g. `[NAME]`, `[DATE]`) |
| `appliesTo` | string[] | Yes — list of resource paths consuming this pattern |
| `falsePositiveRationale` | string | Yes — documented intentional trade-offs (e.g. "titled-names only, not bare bigrams") |

### Entity: Negative Test Case (TestScript content)

| Field | Type | Required |
|-------|------|----------|
| `term` | string | Yes — medical term that MUST NOT match scrub patterns |
| `category` | code | Yes — one of `icd-top200`, `dental-50`, `edge-case` |
| `source` | string | No — reference (ICD-10-GM 2026, BEMA-Z, …) |

Target corpus size: ~270 entries (Round 7 Q4).

### Entity: Data-Provenance CodeSystem (per AW-9)

| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `code` | code | Yes | One of: `synthetic-faker-generated`, `synthetic-template`, `synthetic-imported`, `production` |
| `display` | string | Yes | Human-readable label |
| `definition` | markdown | Yes | Provenance description; for `production`: explicit warning that this code MUST NEVER appear in IG examples |

Canonical URI: `https://fhir.cognovis.de/CodeSystem/data-provenance`. Reusable across cognovis IGs.

### Entity: Mode Catalogue (constant in IG)

```
mode := agent-readonly | analytics | hipaa-safe-harbor | llm-anonymized
```

| Mode | Trust Zone | Persistence of mapping | Reference (ADR-027) |
|------|-----------|----------------------|--------------------|
| `agent-readonly` | A → A | Salt persistent | §3, §5 |
| `analytics` | A → A | Salt persistent + Demographics retained per whitelist below | §3 |
| `hipaa-safe-harbor` | A → A | Salt persistent (HIPAA §A.1–A.18 mapping per FR-060) | §3 |
| `llm-anonymized` | A → C | Mapping in-memory request-scoped only | §3, §6 |

**`analytics` mode demographics whitelist** (per AW-6):

Retained in `analytics` mode (NOT redacted, NOT scrubbed):
- `Patient.gender`
- `Patient.birthDate` → generalized via `generalize:ageGroup` with 5-year buckets
- `Patient.address.postalCode` → generalized via `generalize:plzPrefix` with `length=2`
- `Patient.address.city` (full retained — not PII per DSGVO §32 when standalone)
- `Patient.maritalStatus` (full retained)
- `Practitioner.qualification.code` (specialty/Facharzt — not PII)

Removed in `analytics` mode (same as `agent-readonly`):
- All direct identifiers (name, identifier, telecom, photo)
- `address.line`, `address.postalCode` (full, before generalization)
- All free-text narrative fields beyond what `scrubFreeText` handles for the resource type

**State machine**: Manifest entries are mode-tagged via `appliesIn[]`. There is no per-request state in the IG itself — modes are declared by the consumer and the IG provides the corresponding field/method matrix.

**Invariants**:
- Every direct identifier (name, identifier, KVNR, LANR, …) MUST appear in entries with `appliesIn` covering all four modes
- Quasi-identifiers MAY differ across modes (e.g. birthDate retained as full date in `agent-readonly`, generalized to ageGroup in `llm-anonymized`)
- Free-text fields MUST appear in entries for every mode that transmits free-text content

### Storage

- **Persistent**: All IG resources (Profiles, Library-pii-fields, TestScript-negative-corpus) live in `input/fsh/` and compile to `fsh-generated/` and `output/`
- **Build-time generated**: `output/manifest/pii-fields.json` (the JSON sidecar derived from the Library)
- **Ephemeral / non-IG**: Per-request mapping (LLM-Gateway, ADR-027 §6) — lives in `@consumer-sdk/llm-gateway` runtime memory, NEVER in the IG

---

## Section 5: Functional Requirements

### Coverage requirements

**FR-001**: The IG MUST declare manifest entries for all 17 resource types covered by `io.health-samurai.de-identification.r4` (Patient, Encounter, Observation, Condition, Claim, EOB, AllergyIntolerance, DiagnosticReport, MedicationRequest, MedicationDispense, MedicationAdministration, Immunization, Procedure, Specimen, DocumentReference, Practitioner, Location).
- **Priority**: Must
- **Acceptance**: For each HS-17 resource type, at least one manifest entry exists in the IG; CI test verifies coverage by enumerating HS-IG resources and asserting coverage in our IG.

**FR-002**: The IG MUST declare DE-specific identifier-system + telecom-pattern overrides:
- `https://fhir.kbv.de/NamingSystem/Base-ANR` (LANR) — `where(system=...)` filter
- `https://fhir.kbv.de/NamingSystem/Base-BSNR` (BSNR) — `where(system=...)` filter
- `https://fhir.kbv.de/NamingSystem/KVID-10` (KVNR / KVID-10) — `where(system=...)` filter
- KIM-Telecom (per AW-3): value-pattern match on `Practitioner.telecom.where(system='email' and value.matches('.*\\.kim\\.telematik$'))` plus the same on `Organization.telecom`
- **Priority**: Must
- **Acceptance**: Manifest entries exist for each; FHIRPath validation passes against fhir-praxis-de profile stack; integration test confirms pattern matches sample KIM addresses and does not match non-KIM emails.

**FR-003**: The IG MUST declare manifest entries for DE-specific resource extensions: `ChargeItem` (EBM, GOÄ, HZV positions), `Account`, `Coverage` (Krankenkassen-Nummer), `CarePlan`.
- **Priority**: Must
- **Acceptance**: Profiles + manifest entries exist; validate against fhir-praxis-de profile stack.

**FR-004**: The IG MUST declare manifest entries that ensure de-identification of `Bundle.entry.fullUrl` and `Provenance.target` references.
- **Priority**: Must
- **Acceptance**: `Bundle.entry.fullUrl` entry uses method `cryptoHash` for `agent-readonly` and `randomToken` for `llm-anonymized`; reference rewriting consistent with resource ID hashing.

### Methods catalogue

**FR-010**: The IG MUST define the method `redact` — drops the field from output entirely.
- **Priority**: Must
- **Acceptance**: Method documented in `Library` content; example consumer behavior in IG narrative.

**FR-011**: The IG MUST define the method `cryptoHash` — `SHA-256(salt:id).substring(0,12)` with `anon-` prefix; bit-identical across consumers using the same salt.
- **Priority**: Must
- **Acceptance**: Algorithm specification in IG normative section; ADR-027 §5 cross-reference.

**FR-012**: The IG MUST define the method `scrubFreeText` — applies regex patterns from the IG `Library-scrub-patterns` to free-text fields.
- **Priority**: Must
- **Acceptance**: `Library` resource lists patterns with replacement tokens; consumer behaviour documented.

**FR-013**: The IG MUST define the method `replaceToken` — substitutes the field value with a fixed token (e.g. `display` next to `reference` → `[NAME]`).
- **Priority**: Must
- **Acceptance**: Method documented; default tokens declared.

**FR-014**: The IG MUST define the method `randomToken` — substitutes with a random per-request token of form `[<ResourceType>-<N>]`. Cross-request unlinkable. Within-request consistent (same value gets same token).
- **Priority**: Must
- **Acceptance**: Method semantics documented in IG normative section; ADR-027 §6 cross-reference.

**FR-015**: The IG MUST define four `generalize:*` methods:
- `generalize:ageGroup` (params: `buckets` array; default for `llm-anonymized`: `[0-17, 18-30, 31-50, 51-65, 66-80, 81+]`; default for `analytics`: 5-year buckets `[0-4, 5-9, ..., 95-99, 100+]`)
- `generalize:relativeDate` (params: `referencePoint` — closed enumeration per AW-4: `encounter.start` | `encounter.end` | `today` | `request-time` | `condition.recordedDate`; consumer raises error if reference point unresolvable)
- `generalize:icdCategory` (params: `level` — `3char` (default) | `1char`)
- `generalize:plzPrefix` (params: `length` — default `2`)
- **Priority**: Must
- **Acceptance**: Each method documented with parameter schema, default values, and example invocation; consumer-side test fixtures verify each generalizer with at least three input/output pairs.

### Mode declaration

**FR-020**: Each manifest entry MUST declare a non-empty `appliesIn[]` mode list.
- **Priority**: Must
- **Acceptance**: Schema validation rejects entries with empty/missing `appliesIn`.

**FR-021**: The IG MUST cover at least one entry per mode for the four direct-identifier resource types (Patient, Practitioner, RelatedPerson, Person).
- **Priority**: Must
- **Acceptance**: CI test asserts coverage matrix.

### Build artefacts

**FR-030**: The IG build MUST produce a JSON sidecar `output/manifest/pii-fields.json` derived from the canonical `Library` resource.
- **Priority**: Must
- **Acceptance**: Build script produces sidecar; format matches schema published in IG narrative.

**FR-031**: The IG build MUST produce a TypeScript-importable snapshot for consumer-sdk codegen consumption (file path TBD with consumer-sdk-1bx — see AW-1).
- **Priority**: Should
- **Acceptance**: consumer-sdk-1bx codegen successfully consumes the artefact; integration test in consumer-sdk CI.

### Quality gates

**FR-040**: CI MUST run the negative-test-corpus regression — every term in the TestScript MUST NOT match any scrub pattern.
- **Priority**: Must
- **Acceptance**: CI fails build if any term matches.

**FR-041**: CI MUST verify that examples in `input/examples/` carry a synthetic-data marker (per Round 8 Q3 revised).
- **Priority**: Must
- **Acceptance**: CI fails build if any example file lacks the marker.

**FR-042**: CI MUST verify reverse-coverage against the legacy consumer-sdk hardcoded list (per Round 8 Q4).
- **Priority**: Must
- **Acceptance**: CI loads the legacy list (committed as a snapshot in this IG repo for reference) and asserts every legacy entry has a corresponding manifest entry tagged `legacyCompat: true`.

**FR-043**: CI MUST refuse manual edits to build-time generated files (`fsh-generated/`, `output/manifest/`).
- **Priority**: Must
- **Acceptance**: Lint gate inspects header markers; rejects modifications.

### HIPAA Safe Harbor DE-mapping (per AW-7)

**FR-060**: The IG MUST ship a normative narrative document at `input/pagecontent/hipaa-safe-harbor-de-mapping.md` mapping each HIPAA §A.1–§A.18 to its DE-equivalent FHIR path or marking it N/A in DE practice context.
- **Priority**: Must
- **Acceptance**: Each of §A.1 through §A.18 has exactly one row in the mapping table: either a FHIRPath expression matching the equivalent DE field, or an explicit "N/A in DE clinical-practice context — <reason>" annotation.

**FR-061**: The IG MUST cover all rows of the HIPAA mapping table that are not marked N/A with manifest entries in mode `hipaa-safe-harbor`.
- **Priority**: Must
- **Acceptance**: CI test cross-references the mapping table against manifest entries; reports any mismatch.

### CodeSystem for synthetic-data marker (per AW-9)

**FR-070**: The IG MUST define a `CodeSystem` at canonical URI `https://fhir.cognovis.de/CodeSystem/data-provenance` with codes:
- `synthetic-faker-generated` — deterministic seed via `@faker-js/faker`
- `synthetic-template` — hand-crafted minimal example
- `synthetic-imported` — derived from third-party synthetic dataset with attribution
- `production` — real data (MUST NEVER appear in IG examples per NB-8)
- **Priority**: Must
- **Acceptance**: CodeSystem FSH ships in `input/fsh/codesystems/`; designed for downstream IG reuse (fhir-praxis-de, fhir-dental-de) via dependency.

### Versioning & Publication

**FR-050**: The IG MUST follow CalVer-aligned versioning consistent with fhir-praxis-de's convention (file `VERSION` + `sushi-config.yaml` `version` field synchronized).
- **Priority**: Must
- **Acceptance**: Tag pattern `vN.M.K`; release workflow asserts file/tag agreement.

**FR-051**: The IG MUST be published to `npm.cognovis.de` on every tag.
- **Priority**: Must
- **Acceptance**: GitHub Actions workflow `ig-release.yml` (1:1 copy of fhir-praxis-de's, with HS-IG vendor pre-load adjusted) runs successfully.

**FR-052**: The IG MUST publish a documentation site to GitHub Pages on every tag.
- **Priority**: Must
- **Acceptance**: `cognovis.github.io/fhir-deidentification-de/` reachable; QA report passes.

### Preserved Behavior (Brownfield → consumer-sdk migration)

**FR-P-001**: The IG MUST cover every field currently in consumer-sdk's hand-maintained `PII_FIELDS = { Patient: ['name', 'identifier', 'address', 'telecom', 'photo'], Practitioner: ['name', 'telecom', 'address', 'photo'], RelatedPerson: ['name', 'telecom', 'address'] }` for mode `agent-readonly`. (See FR-042 reverse-coverage gate.)

**FR-P-002**: The IG MUST cover every field currently in consumer-sdk's hand-maintained `FREE_TEXT_FIELDS = { DocumentReference: ['description'], AllergyIntolerance: ['note[].text'] }` for mode `agent-readonly`.

**FR-P-003**: The IG free-text scrub patterns MUST preserve the consumer-sdk intentional false-positive trade-off: titled-names only (`Dr.`, `Hr.`, `Fr.` + name), NOT bare `Capitalised Capitalised` bigrams. Negative test corpus enforces this.

**FR-P-004**: The IG-declared algorithm for `cryptoHash` MUST produce bit-identical anon-IDs to the current consumer-sdk `hashId(salt, id)` function for the same `(salt, id)` input.

---

## Section 6: Non-Functional Requirements

### Performance (Round 7 Q3 — recommendations, not hard SLOs)

**NFR-001**: Consumer implementations of `AnonymizingTransport`-style pseudonymization SHOULD achieve `<20ms p95 for Bundle ≤ 100 resources`, `<200ms p95 for Bundle ≤ 1000 resources`. The IG documents these as recommendations; consumer compliance is not enforced by the IG.

**NFR-002**: Consumer implementations of LLM-Gateway tokenization (mode `llm-anonymized`) SHOULD achieve `<50ms p95 for typical prompt ≤ 50KB`. Output filter post-LLM should achieve similar latency.

**NFR-003** (Re-ID-risk preflight thresholds, per AW-5 — informative): The IG RECOMMENDS, for `llm-anonymized` mode consumers, the following Re-ID-preflight thresholds:
- k-anonymity floor: `k = 5` (a quasi-ID combination must apply to at least 5 patients in the target population, otherwise block the request)
- Conservative population assumption: `≤ 2000 patients` per practice when actual size is unknown (DE small-practice baseline)
- These are RECOMMENDATIONS; deployments may override with documented justification per ADR-027 §6. The IG itself does not enforce these; the recommendations exist to make consumer implementations more uniform across deployments.

### Security

**NFR-010**: The IG MUST reference ADR-027 §5 salt requirements (≥256 bit entropy, secret-manager storage, fail-closed on missing salt).

**NFR-011**: The IG MUST NOT contain real or realistic-name PHI in any example or fixture (per FR-041).

### Compliance

**NFR-020**: The IG MUST cross-reference DSGVO Art. 4(5) (Pseudonymisierung), Art. 28 (AVV), Art. 32 (TOM), ErwGr. 26 (Anonymisierung) in normative sections.

**NFR-021**: The IG MUST cross-reference §203 StGB (Berufsgeheimnis) and the AVV-MCN §9 mapping in normative sections (counterpart to ADR-027 §9).

**NFR-022**: The IG MUST cross-reference EU AI Act Art. 10 (Data Governance), Art. 13 (Transparency), Art. 14 (Human Oversight), Art. 26 (Deployer obligations), Annex IV §2 (technical documentation) per ADR-027 §10.

### Maintainability

**NFR-030**: The IG MUST document the upgrade-loop SLA (Round 2 Q4 = (c)): Issue → IG-PR → Release → ConsumerSDK-Codegen-Run, target end-to-end latency ≤ 1 working day for security-relevant fixes.

**NFR-031**: The IG MUST add-only when bumping HS-IG dependency version (no silent removal of fields). Coverage regression CI gate asserts this.

### Internationalization

**NFR-040**: The IG narrative is in English (FHIR convention). Code system labels and patient-facing examples follow DE locale.

---

## Section 7: API / Interface Contracts

This IG does not expose an HTTP API. It exposes three machine-readable artefacts that consumers integrate with.

### Artefact 1: FHIR Package (`io.cognovis.de-identification.de-<version>.tgz`)

**Distribution**: `https://npm.cognovis.de/io.cognovis.de-identification.de/-/io.cognovis.de-identification.de-<version>.tgz`
**Auth**: per `npm.cognovis.de` access policy
**Consumers**: consumer-sdk codegen, Aidbox `$fhir-package-install`

### Artefact 2: JSON Manifest Sidecar

**Path within package**: `output/manifest/pii-fields.json`

**Schema** (informative — full JSON-Schema in IG narrative):
```json
{
  "$schema": "https://fhir.cognovis.de/de-identification/manifest-schema-v1.json",
  "version": "1.0.0",
  "modes": ["agent-readonly", "analytics", "hipaa-safe-harbor", "llm-anonymized"],
  "entries": [
    {
      "resourceType": "Patient",
      "path": "identifier.where(system='https://fhir.kbv.de/NamingSystem/KVID-10').value",
      "method": "cryptoHash",
      "appliesIn": ["agent-readonly", "analytics", "hipaa-safe-harbor"],
      "rationale": "KVNR is direct identifier per HIPAA §A.1 / DSGVO Art. 4(1)"
    },
    {
      "resourceType": "Patient",
      "path": "identifier.where(system='https://fhir.kbv.de/NamingSystem/KVID-10').value",
      "method": "randomToken",
      "appliesIn": ["llm-anonymized"],
      "rationale": "External LLM boundary requires non-deterministic token per ADR-027 §6"
    },
    {
      "resourceType": "Patient",
      "path": "birthDate",
      "method": "generalize:ageGroup",
      "params": { "buckets": ["0-17", "18-30", "31-50", "51-65", "66-80", "81+"] },
      "appliesIn": ["llm-anonymized"]
    }
  ]
}
```

### Artefact 3: FHIR `Library` Resource (canonical source)

**Resource id**: `pii-fields-manifest`
**Type**: `Library` with `content[].contentType = 'application/json'`
**Reachable via**: FHIR REST after `$fhir-package-install`: `GET /fhir/Library/pii-fields-manifest`

### Versioning strategy

- Add-only minor bumps (new fields, new modes)
- Major bump on breaking changes (field removal, method semantic change, mode rename)
- Patch bump on rationale/doc fixes that don't change manifest content

---

## Section 8: Error Handling Strategy

**Error classification:**
- **Manifest schema errors** (build time): SUSHI compile failure, JSON-schema validation failure → CI fails build
- **Coverage regression** (build time): negative-test-corpus match, missing legacy-compat entry, missing HS-17 resource type → CI fails build
- **Synthetic-marker missing** (build time, FR-041) → CI fails build
- **Manual edit to generated file** (build time, FR-043) → CI fails build
- **Consumer-side runtime errors** (out of IG scope): handled per consumer; ADR-027 §6 mandates `llm-anonymized`-mode block-on-doubt, ADR-027 §7 mandates IG-version mismatch hard-error in production

**Error message guidelines** (build-time errors):
- Reference the specific manifest entry (resource type + path)
- Reference the failing rule (FR-NNN or test-script step)
- Provide remediation hint where feasible

**Logging & alerting**:
- IG itself does not produce runtime logs (it is data, not code)
- Consumer-side observability: per ADR-027 §6 (audit emits metadata only, never matched values)

**Degraded-mode behavior**:
- Consumer cannot read manifest → consumer fails closed (consumer responsibility, not IG's)
- Consumer reads stale IG version → ADR-027 §7 boot-time check raises hard error in production

---

## Section 9: Edge Cases & Boundary Conditions

### EC-1: Consumer reads manifest field for ResourceType not declared
**Scenario**: ConsumerSDK consumer encounters a resource type the IG does not list (e.g. zukünftiger FHIR R5 type, or DE-Custom-Resource added after IG was last bumped).
**Expected Behavior**: ADR-027 §6 + Round 5 Q1 = (a) `agent-readonly` fail-closed default. The IG narrative MUST recommend this; the IG itself cannot enforce it.
**Risk if Unhandled**: New resource type leaks PII through to consumers.

### EC-2: FHIRPath filter matches zero values
**Scenario**: Manifest entry `Practitioner.identifier.where(system='LANR').value` matched against a Practitioner without a LANR (e.g. a non-physician practitioner).
**Expected Behavior**: No-op; non-matching entries do not error. Per FHIRPath semantics.
**Risk if Unhandled**: Build error on legitimate data.

### EC-3: Same patient appears multiple times in single Bundle
**Scenario**: Bundle with Encounter + Observation both referring to Patient/123.
**Expected Behavior**: For mode `agent-readonly`: same `cryptoHash` produced (deterministic). For mode `llm-anonymized`: same `randomToken` produced within request; different across requests.
**Risk if Unhandled**: Inconsistent token assignment breaks LLM identity reasoning.

### EC-4: `Bundle.entry.fullUrl` rewriting order
**Scenario**: Bundle entry has `resource.id = "p-123"` and `fullUrl = "https://server/fhir/Patient/p-123"`. After hashing, both must agree on the new ID.
**Expected Behavior**: Per consumer-sdk current implementation: rewrite `fullUrl` based on the *original* `resource.id` BEFORE hashing the resource.id — order-sensitive.
**Risk if Unhandled**: `fullUrl` and `resource.id` diverge after hashing → broken Bundle.

### EC-5: HS-IG bumps and adds a new field to existing resource
**Scenario**: HS releases `io.health-samurai.de-identification.r4@1.1.0` adding `Patient.maritalStatus` to redact list. Our IG pinned `@1.0.0`.
**Expected Behavior**: Coverage regression CI gate (FR-031, FR-042) detects new field; either we explicitly add it to our manifest with `legacyCompat: false` OR document why it's intentionally omitted. No silent skip.
**Risk if Unhandled**: New PII leaks while we lag HS.

### EC-6: Negative-test-corpus updated with a term that DOES match an existing pattern
**Scenario**: Corpus PR adds "Frau Holle" (Grimm fairy tale character) — would match `(?:Hr\.|Fr\.) name` pattern.
**Expected Behavior**: CI fails — either the pattern needs adjustment OR the term is the wrong test case (decision by reviewer).
**Risk if Unhandled**: False-positive trade-off doctrine slips silently.

### EC-7: Empty `appliesIn` array submitted in PR
**Scenario**: Developer adds entry with `appliesIn: []` by mistake.
**Expected Behavior**: SUSHI / JSON-Schema validation rejects; CI fails build.
**Risk if Unhandled**: Field declared but never applied — silent gap.

### EC-8: Cross-resource consistency for `Bundle.entry` of mixed resource types
**Scenario**: Bundle contains Patient/123 + Encounter/456 (with subject=Patient/123). After `cryptoHash`, Patient.id becomes `anon-X`, Encounter.subject must also become `Patient/anon-X`.
**Expected Behavior**: Recursive reference rewriting per consumer-sdk current behavior (see ADR-027 §5).
**Risk if Unhandled**: Broken referential integrity in pseudonymized output.

### EC-9: IG used standalone without fhir-praxis-de
**Scenario**: External adopter installs `io.cognovis.de-identification.de` but not `de.cognovis.fhir.praxis`.
**Expected Behavior** (Round 6 Q2 = (a)): IG-validation against fhir-praxis-de profiles fails. IG narrative documents the dependency. Round 6 noted: external standalone use is a "nice to have", not a Tag-1 requirement; revisit if external adopter materializes.
**Risk if Unhandled**: External adopter confused by validation errors.

---

## Section 10: Dependencies & Integration Points

### Upstream FHIR-IG dependencies

- `io.health-samurai.de-identification.r4` — strict pin per Round 6 Q1 = (a). Distribution method: **vendored** at `vendor/io.health-samurai.de-identification.r4/` per AW-2 (HS package not on `npm.cognovis.de` and not registry-fetchable from our CI environment). The `pre_load_vendor` step in `ig-release.yml` populates the FHIR cache from `vendor/` before SUSHI runs (mirrors fhir-praxis-de's existing pattern for `de.cognovis.terminology.imaging`). Version pin determined at first vendor by inspecting HS distribution; subsequent bumps via explicit PR.
- `de.basisprofil.r4` (≥1.6.0-ballot2 — same as fhir-praxis-de)
- `de.cognovis.fhir.praxis` — for DE-First profiling (Round 6 Q2 = (a))
- `hl7.terminology.r4` (≥7.1.0)

### Downstream consumers (identified)

- `@consumer-sdk/fhir-de` codegen (consumer-sdk-1bx) — primary
- `@consumer-sdk/llm-gateway` tokenization layer (consumer-sdk-9qg6 et al.) — primary
- `@consumer-sdk/adapter-common` PVS Faker pipeline (consumer-sdk-oah) — secondary (field list only; Faker generators stay outside IG)
- Aidbox server-side `$de-identify` (future, optional)

### Migration

- consumer-sdk currently runs hand-maintained `pii-fields.ts`; codegen migration in consumer-sdk-1bx replaces it. Reverse-coverage CI gate (FR-042) prevents regression.
- Aidbox-side de-identification not in current production setup; future work, not blocked by this IG.

### Backward compatibility

- Add-only on minor bumps (NFR-031)
- Major bump triggers consumer-sdk semver-major (downstream)
- Deprecation: when an HS field is removed in a future HS bump, our IG keeps the entry with `legacyCompat: true` for one major cycle, then drops on next major

### Rollout strategy — single-track toward 1.0.0

No staged feature rollouts. v0.1.0 ships the full v1.0.0-content scope; subsequent
0.x.x releases are bug fixes and missing-field additions discovered during
consumer-sdk consumption.

**v0.1.0 content** (full scope, status: draft):
- HS-17 coverage + DE-Identifier-Overrides + Bundle/Provenance + ChargeItem/Account/Coverage/CarePlan profiles
- All four modes: `agent-readonly`, `analytics`, `hipaa-safe-harbor`, `llm-anonymized`
- All five method families: `redact`, `cryptoHash`, `scrubFreeText`, `replaceToken`, `randomToken`, plus four `generalize:*` methods
- `Library-pii-fields-manifest` (canonical) + JSON sidecar at `output/manifest/pii-fields.json`
- `Library-scrub-patterns` with documented intentional false-positive trade-offs
- `TestScript-negative-corpus` (~270 entries: ICD-10 Top-200 + 50 dental + 20 edge cases)
- `CodeSystem-data-provenance` (synthetic-marker codes per AW-9)
- HIPAA Safe Harbor DE-mapping table (`input/pagecontent/hipaa-safe-harbor-de-mapping.md`)
- HS-IG vendored at `vendor/io.health-samurai.de-identification.r4/`

**v0.x.x patches**: bug fixes, missing-field additions, scrub-pattern refinements that surface during consumer-sdk-1bx and consumer-sdk-9qg6 consumption. Each adds a coverage row, never removes (NFR-031).

**v1.0.0 trigger** (status flips from `draft` to `active`):
- consumer-sdk-1bx codegen has consumed the IG cleanly for ≥ 30 days
- consumer-sdk-9qg6 LLM-Gateway tokenization has consumed the IG cleanly for ≥ 30 days  
- No outstanding coverage-regression CI failures in the IG repo
- No `legacyCompat: true` entries waiting on consumer-side migration

This mirrors the fhir-praxis-de pattern (still 0.40.5 at this writing — long
0.x lifetime, internal consumption is the gate, not external publishing).
External adoption (simplifier.net registry, public announcement) deferred to
post-v1.0.0 and is out of scope for this spec.

---

## Section 11: Behavioral Contract

Declarative observable-behavior statements. Each is verifiable in isolation.

**BC-1**: When a manifest entry has `appliesIn: ['agent-readonly']` only, the manifest MUST NOT influence consumer behavior in any other mode.

**BC-2**: When a consumer requests mode `llm-anonymized` and a manifest entry's `appliesIn[]` includes `llm-anonymized`, the consumer applies the entry's method per IG narrative.

**BC-3**: When two consumers (e.g. consumer-sdk and Aidbox) process the same input resource with the same salt and the same IG version, they produce bit-identical `cryptoHash` output.

**BC-4**: When the negative-test-corpus contains a term that matches a free-text scrub pattern, the IG build MUST fail.

**BC-5**: When the IG repository receives a PR that modifies a generated file (`fsh-generated/`, `output/manifest/`) without a corresponding source change in `input/fsh/`, CI MUST fail.

**BC-6**: When an IG example file lacks the synthetic-data marker, CI MUST fail.

**BC-7**: When the IG's coverage of legacy consumer-sdk hardcoded fields drops vs the prior version, CI MUST fail.

**BC-8**: When a tag is pushed in the form `v<X>.<Y>.<Z>`, the IG MUST publish to `npm.cognovis.de` and to GitHub Pages within the workflow's success path.

**BC-9**: When an IG version is published, the manifest schema version (in `output/manifest/pii-fields.json`) MUST match the IG version's major release (semver-aligned schema versioning).

**BC-10**: When a consumer specifies an unknown mode (not in the four declared), the consumer's behavior is undefined by the IG (consumer responsibility); however, the IG MUST NOT silently coerce unknown modes to a default mode (no `if mode not in known: default-to-agent-readonly` logic in any IG-derived artefact).

**BC-11**: When an IG entry's `path` cannot be evaluated against a given resource (FHIRPath returns empty), the consumer's no-op behavior is correct; the IG MUST NOT require an error.

**BC-12**: When the HS-IG dependency is bumped, the IG release notes MUST list every newly covered field (added) — silent additions are forbidden.

---

## Section 12: Explicit Non-Behaviors

**NB-1**: The IG MUST NOT declare a default mode. Consumers MUST explicitly select one of the four declared modes per request. Reason: per Round 8 Q2 = (a). Trust-zone selection is never a default-decision; defaulting hides bugs.

**NB-2**: The IG MUST NOT instruct consumers to redact identifier slices outside the explicitly listed system URIs. Naive `Patient.identifier` whole-field redaction would discard legitimate non-PII slices (e.g. internal practice IDs). Reason: Round 8 Q1 = (a). Consumer implementations MUST apply FHIRPath `where()` filters per manifest entries.

**NB-3**: The IG MUST NOT extend its free-text scrub patterns to include bare `Capitalised Capitalised` bigrams. Reason: false-positive cost — clinical terms like `Diabetes Mellitus`, `Akute Otitis`, `Bilaterale Pneumonie`, `Morbus Crohn`, `Ductus Arteriosus Botalli` would be incorrectly scrubbed. Negative test corpus (FR-040) enforces this rule by blocking PRs that introduce such matches.

**NB-4**: The IG MUST NOT declare a Faker generator catalogue. Faker-replacement is a consumer-sdk-side mechanism (`@consumer-sdk/pvs-charly/src/lib/anonymize.ts`) — the IG declares which fields are PII; the choice of Faker generator vs `cryptoHash` vs `redact` is consumer-side. Reason: Faker's surface (50+ generators) is too rich and use-case-specific to express declaratively in FHIR.

**NB-5**: The IG MUST NOT define request-mapping storage mechanics. The mapping (for mode `llm-anonymized`) lives in the consumer's runtime memory only. Reason: per ADR-027 §6 — mapping persistence is a property of the LLM-Gateway implementation, not of the IG.

**NB-6**: The IG MUST NOT specify a salt-rotation policy. Salt lifecycle is operational and lives in the consumer-sdk-5bdl runbook. The IG only states the salt requirements (≥256 bit entropy, fail-closed). Reason: per Round 4 Q1 + ADR-027 §5.

**NB-7**: The IG MUST NOT silently drop coverage when bumping the HS-IG dependency. Add-only invariant per NFR-031 + BC-12. Reason: silent removals are stealth privacy regressions.

**NB-8**: The IG MUST NOT contain real PII in `input/examples/`. Examples MUST be synthetic, generated via deterministic Faker seeds (consistent with `consumer-sdk/packages/install-pvs/` and `install-dental-pvs/` patterns), and each example file MUST carry a `meta.tag` referencing the data-provenance CodeSystem (FR-070):

```json
"meta": {
  "tag": [{
    "system": "https://fhir.cognovis.de/CodeSystem/data-provenance",
    "code": "synthetic-faker-generated"
  }]
}
```

Reason: per Round 8 Q3 (revised). "Mustermann" is also forbidden — too obvious a placeholder, doesn't reflect realistic German naming distributions, and creates the meta-bug of "what does PII look like when Mustermann itself becomes a real patient". Faker-generated realistic names with documented provenance via `meta.tag` are the right balance: realistic enough to test scrub patterns; documented as synthetic so a reader is never confused about whether a name is real.

---

## Section 13: Integration Boundaries

### `npm.cognovis.de` (private package registry)

- **Data Flow In**: `package.tgz` upload via GitHub Actions on tag push
- **Data Flow Out**: `package.tgz` download by consumer-sdk codegen, by Aidbox `$fhir-package-install`
- **Failure Mode**: registry unreachable at consume-time → consumer-sdk CI build fails (vendored fallback is the runbook escape per fhir-praxis-de's `vendor/` pattern, FR-051)
- **Timeout Strategy**: consumer-sdk codegen: 60s download timeout; vendored fallback if registry returns 5xx

### Health Samurai upstream (`io.health-samurai.de-identification.r4`)

- **Data Flow In**: HS package consumed at SUSHI compile time
- **Data Flow Out**: none
- **Failure Mode**: HS package unavailable → vendored copy in our `vendor/` dir (mirrors fhir-praxis-de pattern); CI step `pre_load_vendor` ensures cache populated
- **Timeout Strategy**: same as fhir-praxis-de release workflow (60s with vendor fallback)

### ConsumerSDK codegen (`@consumer-sdk/fhir-de`)

- **Data Flow In**: this IG's manifest sidecar
- **Data Flow Out**: regenerated `pii-fields.ts`, `free-text-patterns.ts`, `quasi-id-generalizers.ts` in consumer-sdk repo
- **Failure Mode**: schema mismatch → consumer-sdk build fails (consumer-side); IG repository's CI is unaffected (consumer responsibility)
- **Timeout Strategy**: codegen runs synchronously in consumer-sdk CI

### Aidbox (`$fhir-package-install`)

- **Data Flow In**: this IG's `package.tgz` URL
- **Data Flow Out**: none (read-only consume)
- **Failure Mode**: install fails → operator manual intervention; production smoke test catches drift via ADR-027 §7 boot-time check
- **Timeout Strategy**: per Aidbox default (~120s)

### GitHub Pages (documentation site)

- **Data Flow In**: IG Publisher output (`output/`) on tag push
- **Data Flow Out**: human-readable doc site at `https://cognovis.github.io/fhir-deidentification-de/`
- **Failure Mode**: deploy fails → release workflow logs failure; not blocking for npm.cognovis.de publication (independent step)
- **Timeout Strategy**: GitHub Actions default

---

## Section 14: Ambiguity Warnings

All AW items resolved 2026-05-02. Resolutions are now part of the spec
contract; entries are retained here as decision-log entries for traceability.

**AW-1 (RESOLVED)**: ConsumerSDK-codegen artefact format = **both**, with explicit roles.
- Canonical source: `Library` FHIR resource (FHIR-native, validatable, Aidbox-loadable)
- Build-time-derived: JSON sidecar at `output/manifest/pii-fields.json` (simple format optimized for consumer-sdk codegen — no FHIR machinery required in consumer-sdk build step)
- The build script extracts the JSON from the Library's `content[0].data`. ConsumerSDK-1bx reads the JSON sidecar; Aidbox `$fhir-package-install` consumes the Library. See FR-030 + FR-031 for acceptance.

**AW-2 (RESOLVED)**: HS-IG version pin handled via vendoring.
- HS package `io.health-samurai.de-identification.r4` is not yet on `npm.cognovis.de` and not HEAD-accessible on `simplifier.net` from our environment.
- **Solution**: Vendor the HS package into `vendor/io.health-samurai.de-identification.r4/` exactly like fhir-praxis-de vendors `de.cognovis.terminology.imaging`.
- The `pre_load_vendor` step in `ig-release.yml` populates the FHIR cache before SUSHI runs.
- Specific version: pin to whichever version the HS article (linked from the bead description) references at first vendor — currently assumed `1.0.0`; first PR in the new repo confirms by inspecting the actual `package.json` of HS's distribution. See setup bead.

**AW-3 (RESOLVED)**: KIM-Telecom uses value-pattern matching, not NamingSystem.
- KIM addresses are recognizable on `telecom.value` (pattern: `<localpart>@<provider>.kim.telematik`), not on a `system` URI.
- **Solution**: The IG manifest entry uses FHIRPath value matching:
  ```
  Practitioner.telecom.where(system='email' and value.matches('.*\\.kim\\.telematik$'))
  ```
- No local NamingSystem needed for KIM. If gematik later publishes a canonical URI, we add a second entry with `where(system='<gematik-uri>')` (add-only per NFR-031). FR-002 acceptance updated accordingly.

**AW-4 (RESOLVED)**: `generalize:relativeDate` reference points are an enumerated closed list (no free-form FHIRPath — security and performance reasons).
- Legal `referencePoint` values:
  - `encounter.start` (default)
  - `encounter.end`
  - `today` (fallback when no encounter context)
  - `request-time` (the time the LLM-Gateway processes the request — for cross-resource consistency within a single LLM call)
  - `condition.recordedDate` (when the resource is a Condition or references one)
- Consumer evaluates the enum value against the resource context; raises an error if the reference point is unresolvable. FR-015 updated.

**AW-5 (RESOLVED)**: IG publishes RECOMMENDED Re-ID-preflight thresholds in informative section.
- Recommended `k`-anonymity floor: **`k=5`**
- Recommended conservative population assumption: **≤ 2000 patients** (small DE practice baseline)
- These are RECOMMENDATIONS (`SHOULD`), not normative requirements. Deployments override per ADR-027 §6.
- Added as new NFR-NNN below (see updated Section 6).

**AW-6 (RESOLVED)**: `analytics` mode demographics whitelist is explicit.
- **Retained** in `analytics` mode: `gender`, `birthDate` generalized to 5-year bucket (`generalize:ageGroup` with `buckets:["0-4","5-9",...,"95-99","100+"]` for finer stratification than the LLM default), `address.postalCode` generalized to 2-digit prefix (`generalize:plzPrefix`), `address.city` (full retained — not PII per §32 DSGVO when standalone), `maritalStatus` (full retained), Practitioner specialty (Practitioner.qualification.code retained).
- **Removed** in `analytics` mode (same as `agent-readonly`): direct identifiers (name, identifier, telecom, photo), address.line, address.postalCode-full, all free-text fields beyond what scrubFreeText handles.
- Added explicit Mode Catalogue subsection in Section 4.

**AW-7 (RESOLVED)**: `hipaa-safe-harbor` mode follows DE-equivalent mapping documented in IG narrative.
- IG ships a normative table mapping each HIPAA §A.1–§A.18 to its DE-equivalent FHIR path (or marks irrelevant in DE practice context).
- Examples:
  - §A.1 (Names) → `Patient.name`, `Practitioner.name`, `RelatedPerson.name` (universal — same as `agent-readonly`)
  - §A.3 (Dates) → all date fields except year-only (DE follows the same generalization principle); birthDate generalized to year-only
  - §A.7 (SSN) → no DE equivalent (USA-only); intentionally skipped, documented as N/A
  - §A.5 (ZIP code) → `address.postalCode`, generalized to 3-digit prefix (HIPAA's "first three digits if population > 20k"; for DE we use 2-digit prefix as smaller-region equivalent)
  - §A.13 (Vehicle identifiers) → N/A in clinical-practice context; documented as not applicable
- Full mapping table delivered as IG narrative (`input/pagecontent/hipaa-safe-harbor-de-mapping.md`).

**AW-8 (RESOLVED)**: No `OperationDefinition` resources in v1.0.0.
- Aidbox provides its own `$de-identify` operation natively when using `de-identification`-style extensions on ViewDefinitions.
- We do not define our own operation surface; consumers invoke their own.
- Re-evaluate post-v1.0.0 if Aidbox-side adoption becomes a Tag-1 use case.

**AW-9 (RESOLVED)**: Synthetic-marker uses a new shared CodeSystem at the cognovis canonical base.
- **CodeSystem URI**: `https://fhir.cognovis.de/CodeSystem/data-provenance`
- **Codes**:
  - `synthetic-faker-generated` — programmatically generated via `@faker-js/faker` with deterministic seed (matches consumer-sdk install-pvs/install-dental-pvs convention)
  - `synthetic-template` — hand-crafted template (e.g. minimal example for narrative documentation)
  - `synthetic-imported` — derived from a third-party synthetic dataset with attribution
  - `production` — real data; MUST NEVER appear in any IG examples directory
- Designed to be reusable across cognovis IGs (fhir-praxis-de, fhir-dental-de can adopt later via add-only PR).
- FSH definition lives in this IG; downstream IGs reference via dependency.

---

## Section 15: Open Questions / Risks

- **OQ-1 (RESOLVED 2026-05-02)**: Single-track v0.1.0 ships all four modes + all generalizers + full content. No staged feature rollout. See updated Section 10.

- **OQ-2**: Does the published IG need to be registered on `simplifier.net`? — Round 2 said "deklarativ, nice if compatible". — **Owner**: Malte. — **Risk Level**: Low. — **Suggested resolution**: defer to post-v1.0.0; not blocking for internal consumption.

- **OQ-3 (RESOLVED 2026-05-02)**: Cross-repo bead-coordination handled via documentation in fpde-7yo notes; wave-orchestrator dispatches IG repo first, consumer-sdk workstream (`bd list --label=adr-027-privacy`) consumes the published artefact.

- **OQ-4 (RESOLVED 2026-05-02)**: `status: draft` for v0.1.0 through v0.x.x; flips to `status: active` at v1.0.0 once the consumer-sdk consumption gate (≥30 days clean consumption by consumer-sdk-1bx + consumer-sdk-9qg6) is satisfied. See updated Section 10.

- **OQ-R-1** (Risk): HS-IG could change semantics on a minor bump (e.g. method name change) breaking our compose-on-top model. — **Mitigation**: Strict pin (FR-Round-6-Q1) + bump-review-PR process.

- **OQ-R-2** (Risk): ConsumerSDK-1bx might find that the IG's manifest schema doesn't match what their codegen wants to consume. — **Mitigation**: AW-1 resolved before IG v0.1.0; cross-team review during sub-bead 1 (Format-Entscheidung).

- **OQ-R-3** (Risk): Re-ID-preflight thresholds (AW-5) being deployment config could lead to inconsistent privacy posture across customer deployments. — **Mitigation**: ADR-027 §6 documents this as deployment responsibility; IG can publish recommendations as informative.

---

## Section 16: Glossary

| Term | Definition |
|------|-----------|
| **PII** | Personally Identifiable Information (US-leaning term) |
| **PHI** | Protected Health Information (HIPAA term) |
| **Pseudonymisierung** | DSGVO Art. 4(5): processing such that personal data can no longer be attributed to a specific data subject without additional information |
| **Anonymisierung** | DSGVO ErwGr. 26: data rendered anonymous such that the data subject is not or no longer identifiable |
| **§203 StGB** | German criminal-law clause on professional confidentiality (Berufsgeheimnis); §203(4) covers "sonstige mitwirkende Personen" since 2017 |
| **AVV** | Auftragsverarbeitungsvertrag — DSGVO Art. 28 data-processor contract |
| **HS-IG** | `io.health-samurai.de-identification.r4` — upstream FHIR IG providing the R4 baseline |
| **Mode** | One of `agent-readonly`, `analytics`, `hipaa-safe-harbor`, `llm-anonymized` — declared per request by the consumer |
| **Trust Zone** | Per ADR-027 §2: A (praxis-controlled), B (cognovis-controlled dev/sync), C (external services without §203 sub-processor coverage) |
| **Tokenization** | Random-per-request token assignment with in-memory mapping; ADR-027 §6 mechanism for Zone-A → Zone-C boundary |
| **Quasi-Identifier** | Indirect identifier (birthDate, PLZ-prefix, ICD-category) that enables linkage attacks even after direct-identifier removal |
| **Re-ID Risk** | Probability that pseudonymized/anonymized output can be re-linked to an individual via combination of quasi-identifiers and auxiliary information |
| **TestScript** | FHIR resource type used here to encode the negative-test-corpus regression suite |
| **Library** | FHIR resource type used here as the canonical container for free-text scrub patterns |

---
