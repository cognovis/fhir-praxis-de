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

### Local Developer Build

Use the local wrapper when running the full IG Publisher build on a developer
machine:

```bash
scripts/build-local-ig.sh
```

The wrapper does three local-only things before delegating to `_genonce.sh`:

- Adds Homebrew Ruby and its gem binary directory to `PATH`, so Jekyll is found.
- Finds private FHIR dependency versions in `sushi-config.yaml` and preloads
  them from `npm.cognovis.de` into `~/.fhir/packages`.
- Preloads the previous `de.cognovis.fhir.praxis` release for IG Publisher
  previous-version comparison.

Supported token sources for private packages:

- Existing `~/.npmrc` auth for `npm.cognovis.de`
- `VERDACCIO_TOKEN` (CI-compatible basic auth)
- `BOX_FHIR_NPM_PACKAGE_REGISTRY_TOKEN`
- `POLARIS_STACK_NPM_TOKEN`
- `NPM_TOKEN`

Recommended one-time local toolchain setup:

```bash
HOMEBREW_NO_AUTO_UPDATE=1 brew install ruby
export PATH="$(brew --prefix ruby)/bin:$("$(brew --prefix ruby)/bin/ruby" -rrubygems -e 'print Gem.bindir'):$PATH"
gem install jekyll
```

## License

CC-BY-4.0 — see [LICENSE](LICENSE)
