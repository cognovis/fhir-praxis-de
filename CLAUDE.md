# fhir-praxis-de — German Practice Management FHIR Profiles (R4)

## Overview

FHIR R4 Implementation Guide for German ambulatory practice management (Praxisverwaltung).
Covers billing (EBM/GOÄ), budget management (RLV/QZV), remittance, queue management,
AI provenance (EU AI Act), and administrative workflows.

- **Package ID:** `de.cognovis.fhir.praxis`
- **Canonical:** `https://fhir.cognovis.de/praxis`
- **Published IG:** https://cognovis.github.io/fhir-praxis-de/
- **QA Report:** https://cognovis.github.io/fhir-praxis-de/qa.html

## Build

```bash
sushi .                    # Compile FSH → FHIR JSON
# IG Publisher runs in CI (GitHub Actions), not locally
```

## Local Testing with Aidbox

```bash
docker compose up -d       # Start Aidbox + Postgres
# Wait for Aidbox to be ready (~30s)
curl -s http://localhost:8080/health
```

### Slash Commands

| Command | Purpose |
|---------|---------|
| `/install-ig` | Load this IG into local Aidbox |
| `/test-cs <Name>` | Test a CodeSystem via $lookup |
| `/test-vs <Name>` | Test a ValueSet via $expand + $validate-code |
| `/test-profile <Name>` | Test a Profile via $validate with valid/invalid examples |
| `/review-qa` | Parse QA report and create fix plan |

### Aidbox Access

- **URL:** http://localhost:8080
- **FHIR Base:** http://localhost:8080/fhir
- **Auth:** `Basic basic:secret`
- **Validation:** `POST /fhir/{ResourceType}/$validate`
- **ValueSet Expand:** `GET /fhir/ValueSet/$expand?url=...`

## Conventions

- All profiles are written in FSH (FHIR Shorthand) in `input/fsh/`
- Generated JSON goes to `fsh-generated/` (by SUSHI) and `output/` (by IG Publisher)
- Do NOT edit files in `fsh-generated/` or `output/` — they are auto-generated
- Test files use `.http` format (httpyac compatible)
- On test errors: report first, don't auto-fix immediately
