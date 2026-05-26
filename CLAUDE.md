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
- `/aidbox-ig-development` - IG development lifecycle, validation, IG Publisher, SUSHI/FSH
- `/aidbox` - Aidbox FHIR API, $validate, $fhir-package-install
- `/aidbox-sql-on-fhir` - SQL on FHIR, ViewDefinitions, $materialize
- `/hs-search` - Search health-samurai.io docs, blog, examples
- `/atomic-generate-types` - FHIR type generation with @atomic-ehr/codegen
- `/fhir-validation` - FHIR Schema, $validate responses, and OperationOutcome debugging
- `/fhir-publish-ig` - trusted preflight, release tag handoff, and publish/watch workflows
- `/fhir-sync-versions` - downstream fhir-* version pin reconciliation

## Build

```bash
sushi .                    # Compile FSH → FHIR JSON
# IG Publisher runs in CI (GitHub Actions), not locally
```

## Branch Protection & Merge Workflow

`main` is protected. **Direct push is blocked.** All changes flow through pull requests.

### Branch-protection settings (`cognovis/fhir-praxis-de`, `main`)

- `required_status_checks: ["check"]` — the `vendor-leak-check` workflow (`.github/workflows/vendor-leak-check.yml`) must pass before merge
- `enforce_admins: true` — repo admins (including the owner) cannot bypass the protection
- `allow_force_pushes: false` — no force-push to main outside temporary, audited rewrite windows
- `allow_deletions: false` — main cannot be deleted

### Vendor leak policy — **HARD FAIL, no bypass**

The `vendor-leak-check / check` workflow runs `scripts/check-ig-vendor-leaks.sh`. The script scans repository surfaces (`README.md`, `CHANGELOG.md`, `CLAUDE.md`, `AGENTS.md`, `.beads`, `docs/`, `input/fsh/`, `input/pagecontent/`, `test/`) for third-party PVS vendor names and cognovis-internal project codenames (encoded TERMS list in the script itself).

**A vendor-leak finding on any PR fails the check, which blocks the merge.** There is no override path:

- `SKIP_SUSHI_CHECK=1`, `SKIP_COPYRIGHT_CHECK=1`, `SKIP_VENDOR_LEAK_CHECK=1`, and `git push --no-verify` only suppress the LOCAL pre-push hook — they do not reach the server-side workflow.
- Admin bypass is disabled (`enforce_admins: true`).
- The branch protection rule cannot be temporarily relaxed without going through the documented rewrite-window procedure, which is reserved for coordinated history rewrites (see `fhir-term-ikl`), not for routine merges.

If the check fails on your PR:

1. Read the failure output and identify the leaked term and file.
2. **Fix** the leak in your branch — rename, redact, or move the reference out of the scanned scope per the guard's `PATHS=` list.
3. Push a new commit to the feature branch; CI re-runs automatically.
4. If the failure represents a **legitimate** reference that the guard should not catch (e.g. a new exempt path or a term that genuinely belongs on a public IG surface), open a **separate** PR that updates `scripts/check-ig-vendor-leaks.sh` with rationale. Get that PR merged first, then rebase your original PR.

This policy exists because vendor leaks have happened before and required remediation commits on main (see commit `17405f2` for the 2026-05-19 incident). The cost of one fix-forward commit is small; the cost of vendor refs sitting in published IG surfaces and indexed history is high.

### Standard PR workflow

**Self-merge is allowed and intended.** No human reviewer is required by branch protection (`required_pull_request_reviews: null`). The PR flow exists to gate on **CI checks**, not on human approval. The same person (or agent) creates the PR, waits for green CI, and runs `gh pr merge` — all in the same session. Total latency: ~30–90 seconds for CI, no human bottleneck.

```bash
git pull --rebase origin main
git checkout -b <feature-branch>
# ... make changes ...
git commit -m "..."
git push -u origin <feature-branch>
gh pr create --base main --head <feature-branch> --title "..." --body "..."
gh pr checks --watch                              # wait for vendor-leak-check + other required checks
gh pr merge <pr-number> --merge --delete-branch   # merges once all required checks are green
```

`bd dolt push` still goes direct to the Dolt remote — beads are not subject to git branch protection.

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
