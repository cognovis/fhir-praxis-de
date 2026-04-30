# German Practice Management FHIR Profiles (R4)

FHIR R4 Implementation Guide for German ambulatory practice management (Praxisverwaltung).

## Scope

Extensions, CodeSystems, and ValueSets for:
- **Billing** — EBM/GOÄ procedure codes, billing types, correction rules
- **Budget Management** — RLV/QZV quota tracking, Honorarbescheid (remittance)
- **Queue Management** — patient flow and waiting room workflows
- **AI Provenance** — EU AI Act compliant provenance tracking
- **Administrative Workflows** — Scheinart, approvals, task types

## Design Principles

- Based on **German base profiles** (`de.basisprofil.r4`, KBV, DGUV) — not US Core
- Billing codes bind to **EBM** (GKV) and **GOÄ** (PKV) — not CPT
- Diagnoses use **ICD-10-GM** — not ICD-10-CM
- Budget structures follow **KV/KBV** specifications (RLV, QZV, Fallwert)

## Architecture

Key architectural decisions are documented in `docs/adr/`:

- [ADR-001: Plan-Library vs. Rule-Execution](docs/adr/ADR-001-plan-library-vs-rule-execution.md) — separates adapter-emitted FHIR Plan-Library resources from downstream rule execution; defines the boundary between `PraxisBillingPattern` resources and rule-definition stores

## Build

```bash
npm install -g fsh-sushi
sushi .
```

### Full IG Publisher Build

```bash
./_updatePublisher.sh   # download IG Publisher JAR
./_genonce.sh           # run full build
```

## License

CC-BY-4.0 — see [LICENSE](LICENSE)
