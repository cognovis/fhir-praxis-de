# fhir-praxis-de — German Practice Management FHIR Profiles (R4)

## Overview

FHIR R4 Implementation Guide for German ambulatory practice management (Praxisverwaltung).
Covers billing (EBM/GOÄ), budget management (RLV/QZV), remittance, queue management,
AI provenance (EU AI Act), and administrative workflows.

- **Package ID:** `de.cognovis.fhir.praxis`
- **Canonical:** `https://fhir.cognovis.de/praxis`
- **Published IG:** https://cognovis.github.io/fhir-praxis-de/
- **QA Report:** https://cognovis.github.io/fhir-praxis-de/qa.html

## Session Start

Always load these skills at the beginning of every session:
- `/samurai-skills:aidbox-ig-development` — IG development lifecycle, validation, IG Publisher, SUSHI/FSH
- `/samurai-skills:aidbox` — Aidbox FHIR API, $validate, $fhir-package-install
- `/samurai-skills:aidbox-sql-on-fhir` — SQL on FHIR, ViewDefinitions, $materialize
- `/samurai-skills:hs-search` — Search health-samurai.io docs, blog, examples
- `/samurai-skills:atomic-generate-types` — FHIR type generation with @atomic-ehr/codegen

## Build

```bash
sushi .                    # Compile FSH → FHIR JSON
# IG Publisher runs in CI (GitHub Actions), not locally
```

## Local Testing with Aidbox

Uses the local Aidbox instance on localhost:8080.
After IG migration: fresh Aidbox with strict validation enabled globally.
Current state: shared Aidbox container, use `$validate` with explicit profile parameter.

### IG Testing

All IG testing (install, test-cs, test-vs, test-profile, review-qa) is handled by the global `/aidbox` skill (`references/ig-testing.md`).
Always invoke `/aidbox` before manually curl-debugging — it contains learnings that prevent common errors.


### Aidbox Access

- **URL:** http://localhost:8080
- **FHIR Base:** http://localhost:8080/fhir
- **Auth:** `Basic basic:secret`
- **Admin Auth:** See the neighboring deployment environment (`AIDBOX_ADMIN_ID` / `AIDBOX_ADMIN_PASSWORD`)
- **Validation:** `POST /fhir/{ResourceType}/$validate`
- **ValueSet Expand:** `GET /fhir/ValueSet/$expand?url=...`

## Versioning

**Two files must always have the same version:**
- `VERSION` — source of truth for CI/CD (release workflow reads this)
- `sushi-config.yaml` `version:` field — source of truth for SUSHI/IG Publisher (package.tgz version)

When bumping the version, update BOTH files. If they diverge, the published package will have the wrong version.

## Downstream Dependencies

When publishing a new version of fhir-praxis-de:
- **fhir-dental-de** pins `de.cognovis.fhir.praxis` in `sushi-config.yaml` → must be updated to the new version
- Downstream TypeScript codegen fetches `@latest` from GitHub Pages → picks up new version automatically after IG Publisher deploys, but codegen must be re-run to regenerate TypeScript types

## Conventions

- All profiles are written in FSH (FHIR Shorthand) in `input/fsh/`
- Generated JSON goes to `fsh-generated/` (by SUSHI) and `output/` (by IG Publisher)
- Do NOT edit files in `fsh-generated/` or `output/` — they are auto-generated
- Test files use `.http` format (httpyac compatible)
- On test errors: report first, don't auto-fix immediately
