# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Changed

- **codesystems/CorrectionRuleCS**: Backport seed from 7 to 16 KVB prefixes (`kvb-richtigstellung`); legacy codes `PL`, `WP`, `ST`, `KO` preserved with annotation. CodeSystem now contains 20 codes total.
- **docs/codesystems.md**: Added `category` and `direction` columns to the CorrectionRuleCS table; added runtime-growth contract paragraph documenting that additional codes are added at runtime via Aidbox (no SUSHI rebuild needed).

## [0.76.1] - 2026-06-02

### Added

- **practitioner-role**: Added `PraxisFunktionsrolleCS` (gap codes: `billing-lead`, `application-administration`) and `PraxisFunktionsrolleVS` (includes local codes + ESCO subset reference from fhir-terminology-de via `de.cognovis.terminology.esco@1.0.0`). `PraxisPractitionerRoleDE.code` now bound extensible to `PraxisFunktionsrolleVS` with three-axis separation guidance.
- **docs**: Added IG guidance page *Practice Role Functions* documenting qualification/function/scope axis separation and organization-scoped function semantics via `PractitionerRole.organization` + `Organization.partOf` descendants.


## [0.76.0] - 2026-06-01

### Features

- **account/TSVG**: move `AccountTsvgVermittlungsartExt` and `AccountTerminvermittlungsdatumExt` to `AccountPraxisSchein` — TSVG case-level qualifiers now live on the Schein (Account), not on Claim.

### Removed

- **claim/TSVG**: removed `ClaimTsvgVermittlungsartExt` and `ClaimTerminvermittlungsdatumExt` from `PraxisPreliminaryBillingClaimDE` and deleted `claim-tsvg.fsh`.

## [unreleased-release-scripts]

### Features

- **release**: `scripts/release.sh` now tags the release as its final step (Step 4) — after publish/pointer/site succeed it creates + pushes `v<version>` (idempotent: skipped if the tag already exists), which triggers `ig-release.yml` → "Create GitHub Release". Closes the gap where local-first releases published to npm but never produced a git tag / GitHub release. Tags are separate refs (not subject to branch protection), keeping the no-source-commit philosophy intact.
- **release**: `FHIR_PROXY_SSH` env var enables deploying the public package-list pointer + IG website over ssh/netbird, so `release.sh` runs from any machine (e.g. the local releaser laptop) — not only on the host where `/opt/fhir-proxy` is local. `advance-package-list.sh` fetches the public package-list, updates it locally, and `scp`s it back; `release-fhir-ig.sh` uses `rsync -e ssh`. Unset = unchanged local-path behaviour (run on the proxy host).

### Bug Fixes

- **release**: `verify-fhir-release-publication.py` now falls back to the ambient `~/.npmrc` when no `VERDACCIO_TOKEN`/`NODE_AUTH_TOKEN`/`NPM_TOKEN` env var is set — previously the registry check used an env-token-only auth header, so `advance-package-list.sh` / `release.sh` step 2 hit a 401 on the private registry on every local run despite a logged-in `~/.npmrc`

### Features

- **release**: Add `scripts/release.sh` — single, idempotent, drift-safe release orchestrator wiring `release-fhir-packages.sh` → `advance-package-list.sh` → `release-fhir-ig.sh` in one enforced, no-git sequence (ADR-006). Each step gates the next; re-runs are safe (publish skips already-on-registry, pointer re-set, site rebuilt). `--ig`, `--skip-site`, `--dry-run`.

## [0.75.0] - 2026-06-01

### Features

- **billing/TSVG**: new `tsvg-vermittlungsart` CodeSystem + ValueSet and the
  `claim-tsvg-vermittlungsart` / `claim-terminvermittlungsdatum` extensions to
  model TSVG Vermittlungsart on Claim.
- **account**: new Schein flag extensions on `AccountPraxisSchein` —
  `account-abrechnungssperre`, `account-ersatzverfahren`, `account-nachzuegler`,
  `account-arzt-patienten-kontakt`, `account-egk-lesedatum`, and a coded
  `account-scheinuntergruppe` extension.
- **coverage**: new `coverage-kt-abrechnungsbereich` extension.
- **referral**: new `praxis-referral-de` profile.
- **billing**: model Schein non-Account fields on Coverage, Claim, and
  ServiceRequest (preliminary billing claim).

### Changed

- **terminology**: retire the local `Scheinuntergruppe` CodeSystem and ValueSet;
  rebind ConceptMaps and the Scheinuntergruppe coding to the KBV
  `KBV_VS_SFHIR_KBV_SCHEINART` ValueSet (extensible). **Breaking** for consumers
  referencing the local `kvdt-scheinuntergruppe` ValueSet URL.

### Fixed

- **privacy**: redact the PVS vendor name from the Scheinuntergruppe extension
  (vendor-leak guard).

## [0.74.1] - 2026-05-31

### Bug Fixes

- **release**: Republish praxis 0.74.1 with `WegegeldHausbesuchExtProfile` — 0.74.0 shipped from a stale IG Publisher `output/` that silently dropped the wegegeld-hausbesuch conformance resource
- **build-package.sh**: Add stale-`output/` verify-and-refuse guard — refuse to pack if `output/` is missing conformance resources present in fresh SUSHI output (the wegegeld-hausbesuch 0.74.0 regression guard)
- **release**: Script 1 (release-fhir-packages.sh) falls back to ambient ~/.npmrc when VERDACCIO_TOKEN is unset
- **release-sync**: Neutralize downstream project codename in script comments (vendor-leak guard)

### Features

- **fpde-q6l**: Add scripts/release-fhir-ig.sh — ADR-006 Script 3: local IG website build (IG Publisher), QA-gate (verify-and-refuse), rsync deploy to /opt/fhir-proxy/html/<ig>/, and post-deploy version verify; --dry-run for build+gate without deploy
- **release-sync**: Add scripts/sync-release-versions.sh — ADR-006 step-0 automation: discover IG versions, bump lock anchors, key-based + range-operator-preserving dependency propagation, drift-guard gate, commit/push
- **fpde-x8r**: Make fhir-praxis-de the canonical home of fhir-versions.lock.yaml

## [0.73.0] - 2026-05-30

### Bug Fixes

- **fpde-qsc**: Set PACKAGE_LIST_EXACT_PATH_ONLY=true in local advance

### Features

- **fpde-9go**: Local-first FHIR release pipeline (ADR-006)
- **fpde-qsc**: Move package-list advance from CI to verify-before-write local step
- **fpde-qsc**: Move package-list advance from CI to local verify-before-write step

### Miscellaneous

- Bump version to 0.73.0

## [0.72.0] - 2026-05-30

### Bug Fixes

- **fpde-9go**: Use sushi binary directly in ig-ci.yml SUSHI compile step
- **fpde-9go**: Delegate per-repo build/publish; fix 5 review findings
- **fpde-9go**: Move delegate-existence checks into verify-and-refuse
- **fpde-9go**: Address INFRA pre-push advisory blockers
- **fpde-9go**: Prevent base64 line-wrap in npmrc auth (preload + release)

### Documentation

- **fpde-9go**: Add ADR-006 local-first release pivot; scan ADRs in vendor-leak guard
- **fpde-9go**: Note terminology-import seeding constraint in ADR-006

### Features

- **fpde-9go**: Local-first FHIR release pipeline (ADR-006)

### Miscellaneous

- **fpde-9go**: Session-close changelog update
- Bump version to 0.72.0

## [0.71.0] - 2026-05-30

### Features

- **fpde-9j1**: Dispatch ig-published to fhir-dental-de and fhir-terminology-de

### Miscellaneous

- **fpde-9j1**: Add implementation manifest and evidence ledger
- **fpde-9j1**: Add changelog entry and run artifacts
- Release 0.71.0

## [0.70.2] - 2026-05-30

### Bug Fixes

- **fpde-60x**: Open identifier slicing, relax scheinNummer to 0..1, add abrechnungsquartal NamingSystem and pre-writeback example
- **fpde-60x**: Remove vendor term from pre-writeback example description
- Rename kvbm-qzv-gops → kv-benchmark-qzv-gops to match canonical IG naming convention

### CI/CD

- **fpde-pv0**: Bump node20 actions to node24 (upload-artifact v6, configure-pages v6, action-gh-release v3)

### Documentation

- Add 0.70.1 and 0.70.0 changelog entries

### Miscellaneous

- Release 0.70.2
- Remove vendor term from 0.70.2 changelog entry

## [0.70.1] - 2026-05-26

### Bug Fixes

- **examples**: Correct KBV Diagnosesicherheit #V display name

### CI/CD

- Run IG validate on main only, drop redundant PR run
- Bump checkout and deploy-pages to v5 (Node 24)

### Miscellaneous

- Bump version to 0.70.1

## [0.70.0] - 2026-05-26

### Bug Fixes

- **fpde-mub**: Fix FSH extension authoring for laterality+certainty Conditions
- **fpde-mub**: Remove vendor-specific terms from IG content and manifest
- **fpde-hms**: Add ^short/^definition to Wegegeld extension slices per repo convention
- **fpde-hms**: Remove vendor codename from wegegeld zone ^definition
- **fpde-hms**: Add missing artifact:related-links to evidence ledger
- **fpde-hms**: Remove explicit .url assignments from Wegegeld extension slices

### CI/CD

- Retrigger checks
- Retrigger vendor-leak-check
- Retrigger checks
- Trigger vendor-leak-check

### Documentation

- **fpde-mub**: Add changelog entry for Claim.diagnosis quarter-diagnosis contract
- Record account-centered billing model
- **fpde-hms**: Add changelog entry for Account-centered billing model and Wegegeld extension
- **fpde-hms**: Update CHANGELOG for account-centered billing model and Wegegeld

### Features

- **fpde-03c**: Add serviceProvider + partOf to EncounterPraxis, update examples
- **fpde-mub**: Add Claim.diagnosis quarter-diagnosis contract to praxis Claim profiles
- Add Wegegeld home visit extension

### Miscellaneous

- Bump version to 0.69.1
- **fpde-mub**: Add implementation manifest and evidence ledger
- **fpde-mub**: Bump version to 0.69.1
- Record fpde-hms evidence
- Use vendor-neutral public references
- **fpde-hms**: Update manifest with full 7-commit history
- Bump version to 0.70.0

## [0.69.0] - 2026-05-26

### Bug Fixes

- Verify public package list sync
- Scan served package list paths
- Skip unreadable package list roots
- Deploy package list to public host
- Sync package list on netbird runner
- Limit package list sync to public path
- Harden FHIR release verification
- **fpde-cj3**: Normalize manifest AC status to schema values
- **fpde-cj3**: Address pair-loop findings iteration 1 - HZV example HH class and unique title
- **fpde-cj3**: Update aw-sst-crosswalk.md to reflect AccountPraxisSchein as billing-case anchor
- **fpde-cj3**: Update index.md HZV contract reference from retired extension to AccountPraxisSchein
- **fpde-cj3**: Address codex adversarial findings - close identifier slicing, add class AMB/HH signal
- **fpde-cj3**: Narrow Encounter.class binding to required AMB/HH ValueSet

### Features

- **fpde-cj3**: AccountPraxisSchein + re-scope EncounterPraxis to clinical contact

### Miscellaneous

- **clc-3gmp**: Install samurai aidbox skills
- Bump version to 0.69.0
- Bump version to 0.69.0

## [0.68.0] - 2026-05-23

### Bug Fixes

- **fpde-c7f**: Correct flag-bemerkung extension context from Flag.extension to Flag
- **ci**: Vendor FHIR publish helper

### CI/CD

- Move IG release build to self-hosted fhir publish
- Use shared fhir publish runner cache
- Run IG validation on fhir publisher runners
- Avoid duplicate PR branch validation
- Pin FHIR publish jobs to atlas runners

### Features

- **fpde-c7f**: Add flag-bemerkung Extension StructureDefinition

### Miscellaneous

- Vendor fhir sync library artifacts
- Normalize library lock paths

## [0.66.1] - 2026-05-22

### Bug Fixes

- **fhir-term-d4z.5**: Address review findings iteration 1
- Remove vendor-specific references from public IG surfaces

### CI/CD

- Add vendor-leak-guard workflow on push + PR to main

### Documentation

- **fhir-term-d4z.5**: Add changelog entry for imaging pin flip to 1.0.0
- Document PR-based merge workflow + vendor-leak hard-fail policy

### Features

- **fhir-term-d4z.5**: Flip terminology.imaging pin to 1.0.0
- **fhir-term-e24 follow-up**: Add interventionelle-radiologie + mrt-mamma to genehmigung-leistungsbereich

### Miscellaneous

- Untrack dist/ build artifacts and gitignore them
- Release praxis 0.66.1

## [0.66.0] - 2026-05-19

### Bug Fixes

- **adapter-7ihe**: Replace fabricated hvg-vertrag codes with actual YAML-derived slugs (24 entries)

### Features

- **adapter-7ihe**: Add hvg-vertrag and hvg-vertragsart CodeSystems

### Miscellaneous

- **fpde-yw5**: Update changelog for 0.66.0
- Bump version to 0.66.0

### Merge

- Worktree-bead-fpde-yw5

### Task

- **fpde-yw5**: Add SGB V legal basis comment to ZulassungStatusConcepts ruleset

## [0.65.1] - 2026-05-19

### Bug Fixes

- Remove vendor-specific bead IDs from historical CHANGELOG entries
- **fpde-46j**: Correct DMP canonical — Coverage.dmpIndicator tracked in adapter-0x2a.3

### Features

- **fhir-term-e24 follow-up**: Expand genehmigung-leistungsbereich CS with labor + AO blocks (0.65.1)

## [0.64.2] - 2026-05-19

### Bug Fixes

- **fpde-46j**: Review fixes — ADR-004 format, Point 2 table contradiction, YAML quote, AK-4 references
- **fpde-46j**: Codex adversarial fixes — vendor leak, DMP canonical, stale refs

### Documentation

- Add foundation source register
- **fpde-46j**: CAVE/Flag/Allergy architecture clarification + ADR-004
- **fpde-46j**: Update changelog for CAVE/Flag/Allergy architecture research

### Miscellaneous

- **fpde-46j**: Bump version to 0.64.1, update changelog
- Bump version to 0.64.2

### Merge

- Worktree-bead-fpde-46j

## [0.64.0] - 2026-05-18

### Bug Fixes

- **fpde-7eg**: Enforce AW billing claim constraints — related 1..*, item 0..0 final, item 1..* preliminary, subType discriminator, remove BG accident
- **fpde-7eg**: Type final related.claim to PreliminaryClaimDE, related 1..1, type=professional fixed, structural regression tests
- **clc-8gy**: Explicit empty worktree_bootstrap to prevent legacy .env fallback

### Features

- **clc-8gy**: Add orchestrator-config.yml for fhir-praxis-de
- **clc-8gy**: Add orchestrator-config.yml (dev_server concurrency key rename)
- **clc-8gy**: Note no worktree_bootstrap needed (shared Aidbox)
- **fpde-ctx**: Add proposal provenance profile

### Miscellaneous

- **fpde-7eg**: Bump version to 0.63.1 — AW-SST crosswalk implementation

## [0.63.0] - 2026-05-18

### Bug Fixes

- Remove vendor-specific bead IDs from historical CHANGELOG entries
- **fpde-7eg**: Allowlist v3-ActIncidentCode resolution error in QA gate

### Documentation

- Document AW-SST crosswalk decision
- **fpde-7eg**: Update changelog for AW-SST billing claim profiles and gap profiles

### Features

- **fpde-7eg**: Add billing claim profiles, freetext obs, AllergyIntolerance, update crosswalk
- **fpde-7eg**: Add AW-SST billing claim profiles, freetext obs, AllergyIntolerance

### Merge

- Worktree-bead-fpde-7eg

### Test

- **fpde-7eg**: Red -- add AW-SST profile existence tests

## [0.62.3] - 2026-05-17

### Features

- **genehmigung**: Add cockpit-item-id sub-extension (adapter-5yeg)

## [0.62.2] - 2026-05-17

### Features

- **genehmigung**: Add status sub-extension (active|expired|revoked)

## [0.62.1] - 2026-05-17

### Bug Fixes

- **fpde-hcq**: Remove hardcoded system URI from ZANR definition prose
- **adapter-d1vy**: Vendor-neutral wording in PvsWritebackStatusCS description

### Features

- **adapter-d1vy**: Add PvsWritebackStatusCS — pvs-writeback-error tag for adapter writeback failures

### Miscellaneous

- **fpde-1cn**: Session close — shared ZulassungStatusConcepts RuleSet v0.62.0
- Bump version to 0.62.1
- Bump version to 0.62.1 — publish PvsWritebackStatusCS

### Refactoring

- **fpde-1cn**: Shared ZulassungStatusConcepts RuleSet for aktiv/abgelaufen/entzogen

### Merge

- Feat/adapter-d1vy-pvs-writeback-status — add PvsWritebackStatusCS

## [0.62.0] - 2026-05-16

### Bug Fixes

- **fpde-e0o**: Address review findings iteration 1
- **fpde-e0o**: Address codex adversarial findings

### Documentation

- **fpde-e0o**: Add changelog entry for v0.62.0

### Features

- **fpde-e0o**: AK-1 extend genehmigung-leistungsbereich with 130+ codes and block hierarchy
- **fpde-e0o**: AK-2 wb-befugnis extension and PractitionerRole profile
- **fpde-e0o**: AK-3 ermaechtigung profile, extensions, codesystems
- **fpde-e0o**: AK-4 sitz-vakanz extensions, sitz-status and arzt-status codesystems
- **fpde-e0o**: AK-5 ZANR identifier slice on PraxisPractitionerDE

### Miscellaneous

- **fpde-e0o**: Bump version 0.61.0 → 0.62.0
- **fpde-e0o**: Session close — Practitioner-Berechtigungs-Strukturen v0.62.0

### Merge

- Worktree-bead-fpde-e0o

## [0.61.0] - 2026-05-12

### Bug Fixes

- **qa-gate**: Parser color + row format + allowlist pattern wording

## [0.60.0] - 2026-05-12

### Bug Fixes

- **fpde-838**: Address review findings iteration 1
- **fpde-838**: Address codex adversarial findings

### Features

- **fpde-838**: Green — qa_gate.py parser + allowlist matcher (10/10 tests pass)
- **fpde-838**: QA release gate — allowlist, workflow integration, docs
- **fpde-838**: CI release gate — block tag/release when QA errors exceed allowlist

### Miscellaneous

- Commit generated files before bead merge (worktree-bead-fpde-838)
- Bump version 0.59.0 → 0.60.0

### Merge

- Worktree-bead-fpde-838 — resolve CHANGELOG.md conflict

### Test

- **fpde-838**: Red — QA gate test suite (10 scenarios, all failing)

## [0.59.0] - 2026-05-12

### Bug Fixes

- **qa**: Anamnese questionnaire structure — beschwerden/vorerkrankungen top-level

## [0.58.0] - 2026-05-12

### Bug Fixes

- **qa**: Manual cleanup of remaining 18 internal QA errors → v0.58.0

### Miscellaneous

- Close beads fpde-95o and fpde-bxv — v0.57.0 shipped

## [0.57.0] - 2026-05-11

### Bug Fixes

- **fpde-95o**: FullUrl absolute URIs in bundle examples — 12 relative + 10 urn:uuid
- **fpde-95o**: LOINC display corrections — 88031-0 Smokeless tobacco status, 24558-9 US Abdomen, 36803-5→24802-1 MR Knee, 24558-9→18748-4 for dental reports
- **fpde-95o**: Invalid code references — v3-ActCode BILLED removed, versicherungsart SKT→BEI, IG URL pattern suppression added
- **fpde-95o**: Address review findings iteration 1
- **fpde-95o**: Address codex adversarial findings — CT of thorax code, US study display, SmokingStatus LOINC code

### Miscellaneous

- **fpde-95o**: Version bump 0.56.0→0.57.0, QA audit doc, changelog
- **fpde-95o**: Update changelog with codex regression fixes
- **fpde-95o**: Session-close — finalize changelog for v0.57.0

### Merge

- Worktree-bead-fpde-95o

## [0.56.0] - 2026-05-11

### Bug Fixes

- **fpde-bxv**: Add iso21090-EN-qualifier extension to all Dr. prefixes
- **fpde-bxv**: Fix DVMD KDL DG020110 display — Röntgenbefund
- **fpde-bxv**: Fix ParticipationMode MAILWRIT/TYPEWRIT displays
- **fpde-bxv**: Fix Fachkunde DVT display and remove invalid LOINC 36218-5
- **fpde-bxv**: Add external error suppressions to ignoreWarnings.txt
- **fpde-bxv**: Fix ku-hinweis-required invariant FHIRPath expression
- **fpde-bxv**: Address review findings iteration 1
- **fpde-bxv**: Address codex adversarial findings — CHANGELOG count consistency

### Documentation

- **changelog**: Move shp.8 entries to v0.55.0 + note epic close
- **fpde-bxv**: Add QA audit doc for v0.55.0 errors

### Miscellaneous

- Commit generated files before bead merge (worktree-bead-fpde-bxv)
- **fpde-bxv**: Version bump 0.55.0 → 0.56.0 + changelog entry
- **fpde-bxv**: Session-close — finalize changelog for v0.56.0

### Merge

- Worktree-bead-fpde-bxv

## [0.55.0] - 2026-05-11

### Bug Fixes

- **fpde-shp.8**: Address review findings iteration 1

### Features

- **fpde-shp.8**: Implement Condition constraints bundle (AC 1-10)

### Miscellaneous

- **fpde-shp.8**: Update changelog for v0.55.0
- **fpde-shp.8**: Session-close — regenerate changelog for v0.55.0

### Merge

- Worktree-bead-fpde-shp.8

## [0.54.0] - 2026-05-11

### Bug Fixes

- **fpde-shp.9**: Address review findings — typo, unused aliases, broken URL

### Documentation

- **fpde-shp.9**: Extend steuer-compliance.md with CID pattern diagram and UNECE migration notes

### Features

- **fpde-shp.9**: Extend tax extension context to include ChargeItemDefinition.propertyGroup.priceComponent
- **fpde-shp.9**: Migrate TaxCategoryDE ValueSet from local CS to UNECE-5305 URN
- **fpde-shp.9**: Add ChargeItemDefinition demo examples with UNECE-5305 tax category

### Miscellaneous

- Commit generated files before bead merge (worktree-bead-fpde-shp.9)
- **fpde-shp.9**: Bump version to 0.54.0
- **fpde-shp.9**: Update changelog for v0.54.0 release

### Merge

- Worktree-bead-fpde-shp.9

## [0.52.0] - 2026-05-11

### Bug Fixes

- **fpde-shp.2**: Address review findings iteration 1
- **fpde-shp.2**: Address codex adversarial findings
- **fpde-shp.7**: Address review findings iteration 1
- **fpde-shp.7**: Address codex adversarial findings
- **fpde-shp.7**: Add steuer-compliance to navigation menu

### Documentation

- **fpde-shp.2**: Add changelog entry for multi-coverage linking pattern

### Features

- **fpde-shp.2**: Add multi-coverage linking pattern documentation and examples
- **fpde-shp.2**: Add multi-coverage linking pattern for GKV + Zusatz/PKV/Beihilfe
- **fpde-shp.7**: Add UStBefreiungsgrundCS, TaxCategoryDE, ext-tax-category, ext-tax-exemption-reason, ext-ku-hinweis-pflicht
- **fpde-shp.7**: Green — PraxisInvoiceDE profile + invoice tax examples
- **fpde-shp.7**: Green — steuer-compliance pagecontent + version 0.52.0

### Miscellaneous

- **fpde-shp.7**: Update changelog for v0.52.0 release

### Merge

- Worktree-bead-fpde-shp.7
- Worktree-bead-fpde-shp.2

## [0.51.0] - 2026-05-10

### Bug Fixes

- **fpde-shp.6**: Address review findings iteration 1

### Documentation

- **fpde-shp.6**: Add changelog entry for kbv wrapper profiles

### Features

- **fpde-shp.6**: Green — 4 KBV wrapper profiles + kleinunternehmer ext + inheritance doc

### Miscellaneous

- Commit generated files before bead merge (worktree-bead-fpde-shp.6)
- **fpde-shp.6**: Update changelog for v0.51.0 release

### Merge

- Worktree-bead-fpde-shp.6

### Test

- **fpde-shp.6**: Red — test profiles extending PraxisDE wrappers (not yet created)

## [0.50.0] - 2026-05-10

### Bug Fixes

- **fpde-shp.5**: Address review findings (version pinning, file handles, dead import)
- **fpde-shp.5**: Ensure kbv.basis downloaded before snapshot generation (CI fresh runner fix)

### Documentation

- **fpde-shp.5**: Add changelog entry for kbv.basis snapshot composite action

### Features

- **fpde-shp.5**: Green — generate-kbv-basis-snapshots composite action + workflow integration
- **fpde-shp.5**: Add generate-kbv-basis-snapshots CI composite action

### Miscellaneous

- Commit generated files before bead merge (worktree-bead-fpde-shp.5)
- Bump version to 0.50.0

### Merge

- Worktree-bead-fpde-shp.5

### Test

- **fpde-shp.5**: Red — TestKBVCondition FSH fails without kbv.basis snapshots

## [0.49.0] - 2026-05-04

### Bug Fixes

- **fpde-daz**: Replace kbv.mio.impfpass with cognovis vocab repackage to drop de.basisprofil.r4@0.9.12 transitive dep
- **fpde-daz**: Pre-load kbv.mio.impfpass.vocab from npm.cognovis.de in CI

## [0.48.0] - 2026-05-04

### Features

- **fpde-daz**: Bind KBV-MIO-Impfpass vocabulary to PraxisImmunization + bump to 0.48.0

## [0.47.0] - 2026-05-04

### Bug Fixes

- Replace vendor-specific terms in public IG surfaces
- Remove remaining PVS product name from IG spec surfaces
- **ci**: Use _auth base64 token for Verdaccio instead of _password+username
- **fpde-daz**: Address review findings iteration 1

### Documentation

- **fpde-7yo**: Close epic + migrate Wave-2/3 sub-beads to fhir-deidentification-de

### Features

- **fpde-daz**: Add PraxisComposition and PraxisCommunication profiles
- **fpde-daz**: Add PraxisFlag and PraxisMedicationAdministration profiles
- **fpde-daz**: Add PraxisAnamneseQuestionnaireResponse and PraxisImmunization profiles
- **fpde-daz**: Bump version to 0.47.0 and update CHANGELOG

### Miscellaneous

- **fpde-daz**: Update changelog for session close

### Merge

- Worktree-bead-fpde-daz

## [0.46.0] - 2026-05-02

### Documentation

- **fpde-7yo.1**: Track fhir-deidentification-de external repo bootstrap
- **fpde-7yo.1**: Update external repo tracking with advisory fix status
- **fpde-7yo.1**: Add changelog entry for de-identification IG bootstrap

### Features

- **fpde-7yo.1**: Bootstrap cognovis/fhir-deidentification-de repo

### Miscellaneous

- Bump version to 0.46.0

### Merge

- Resolve CHANGELOG conflict with origin/main (fpde-7yo.1)

## [0.45.2] - 2026-05-02

### Documentation

- **fpde-7yo**: Add de-identification IG spec — 4 modes, all AW resolved, single-track v1.0.0

### Miscellaneous

- Bump version to 0.45.2

## [0.45.1] - 2026-05-02

### Bug Fixes

- **ci**: Fetch terminology.imaging from Verdaccio with VERDACCIO_TOKEN
- **imaging**: Pin AccessionNumber identifier.system to pvs-id NamingSystem

### Features

- **fpde-nzb**: Add DicomwebEndpointPraxisDe profile with connectionType constraint

### Miscellaneous

- Bump version to 0.45.1 + reconcile CHANGELOG

### Merge

- Worktree-bead-fpde-nzb

## [0.45.0] - 2026-05-02

### Miscellaneous

- Bump version to 0.45.0

### Merge

- Worktree-bead-fpde-8c1
- Resolve CHANGELOG conflict with origin/main (fpde-5h0 + 0.44.1)
- Worktree-bead-fpde-5h0

## [0.44.1] - 2026-05-02

### Bug Fixes

- **fpde-5h0**: Add type.coding discriminator to requestedProcedureId identifier slice
- **fpde-5h0**: Use v2-0203#FILL type coding instead of non-existent local CodeSystem
- **fpde-8c1**: Require value 1..1 and system 1..1 on accessionNumber slice
- **fpde-8c1**: Update changelog for accessionNumber slice on ImagingStudyPraxisDe
- **fpde-z4n**: Correct legal citation from §14 StrlSchV to §85 StrlSchG / §127 StrlSchV
- **fpde-z4n**: Replace vendor-specific references in ADR-002 with neutral wording

### Documentation

- **fpde-z4n**: Add ADR-002 confirming radiation-dose extension satisfies §14 StrlSchV

### Features

- **fpde-5h0**: Add requestedProcedureId identifier slice to ImagingServiceRequestPraxisDe

### Miscellaneous

- **fpde-5h0**: Update changelog for requestedProcedureId identifier slice
- **fpde-z4n**: Update changelog for radiation-dose extension legal review
- Bump version to 0.44.1

### Merge

- Worktree-bead-fpde-z4n
- Resolve CHANGELOG conflict from origin/main (fpde-z4n + fpde-8c1)

### Task

- **fpde-8c1**: Add identifier:accessionNumber ACSN slice to ImagingStudyPraxisDe

## [0.44.0] - 2026-05-01

### Bug Fixes

- **fpde-9fq**: Remove HvgVertragsartCS stub, use dmp-kennzeichen-de in example
- **fpde-9fq**: Use correct numeric DMP Kennzeichen code 01 for DM2
- **fpde-9fq**: Update CHANGELOG for HvgVertragsartCS stub removal
- **fpde-bra**: Remove unused ZuzahlungsstatusCS and ZuzahlungsstatusVS
- **fpde-bra**: Remove stale dist/package artifacts, test fixtures, and oids.ini entries

### Miscellaneous

- **fpde-bra**: Update changelog for ZuzahlungsstatusCS removal
- Bump version to 0.44.0
- Merge worktree-bead-fpde-bra — remove ZuzahlungsstatusCS stub

### Merge

- Worktree-bead-fpde-9fq

## [0.43.1] - 2026-05-01

### Bug Fixes

- **ci**: Pre-load terminology.imaging in release workflow before SUSHI

## [0.43.0] - 2026-04-30

### Miscellaneous

- Merge origin/main — resolve CHANGELOG and sushi-config conflicts (fpde-cpw.5 + fpde-cpw.6)
- Bump version to 0.43.0

## [0.42.0] - 2026-04-30

### Bug Fixes

- **ci**: Show full SUSHI output on error instead of tail -5
- **ci**: Use tee to stream SUSHI output and capture exit code correctly
- **ci**: Pre-load de.cognovis.terminology.imaging from npm.cognovis.de
- **ci**: Vendor de.cognovis.terminology.imaging for CI FHIR cache
- **fpde-cpw.6**: Address review findings iteration 1
- **fpde-cpw.6**: Address codex adversarial findings
- **fpde-cpw.5**: Address review findings iteration 1
- **fpde-cpw.5**: Replace vendor-specific term with vendor-neutral 'rule engine' in public IG surfaces

### Documentation

- **fpde-cpw.5**: Update changelog with imaging subscriptions, translate tests, architecture page

### Features

- **fpde-cpw.6**: Green — RoentgenProcedurePraxisDe, radiation-dose ext, ChargeItemPraxisDe invariant, IG page
- **fpde-cpw.6**: Add Strahlenschutz-Compliance & Röntgenbuch profiles (StrlSchG §83/§85)
- **fpde-cpw.5**: Add subscription templates, $translate tests, imaging billing architecture page

### Miscellaneous

- Update dist/package with imaging profiles from fpde-cpw.2 and fpde-cpw.4
- **fpde-cpw.5**: Update CHANGELOG for imaging subscriptions and ConceptMap tests
- Bump version to 0.42.0

### Merge

- Worktree-bead-fpde-cpw.5

### Test

- **fpde-cpw.6**: Red — stub FSH profiles and extensions

## [0.41.4] - 2026-04-30

### Bug Fixes

- **fpde-cpw.2**: Fix binding paths and endpoint payloadType for SUSHI compilation
- **fpde-cpw.2**: Address review findings iteration 1
- **fpde-cpw.2**: Address codex adversarial findings
- **fpde-cpw.4**: Address codex adversarial findings - use #profile discriminator for participant slicing

### Documentation

- Update changelog with fpde-cpw.4 imaging workflow profile entries

### Features

- **fpde-cpw.2**: Add hl7.fhir.uv.ips 1.1.0 dependency
- **fpde-cpw.2**: Add image-km-administration extension
- **fpde-cpw.2**: Add technique-parameter extension
- **fpde-cpw.2**: Add ImagingStudyPraxisDe profile on IPS ImagingStudy-uv-ips
- **fpde-cpw.2**: Add ImagingStudy examples (MRT Knie KM, CT Abdomen)
- **fpde-cpw.2**: Add ImagingStudy profile with DE extensions and IPS base
- **fpde-cpw.4**: Green -- imaging workflow profiles ServiceRequest, Appointment, Device
- **fpde-cpw.4**: Add imaging workflow profiles ServiceRequest, Appointment, Device

### Miscellaneous

- **fpde-cpw.4**: Bump version to 0.41.4 for imaging workflow profiles

### Merge

- Worktree-bead-fpde-cpw.2

### Test

- **fpde-cpw.4**: Red -- imaging workflow profiles not yet defined

## [0.41.3] - 2026-04-30

### Bug Fixes

- **fpde-cpw.3**: Address review findings iteration 1

### Documentation

- Update changelog for fpde-cpw.3 imaging diagnostic report profile
- Update changelog for fpde-cpw.3 imaging diagnostic report profile

### Features

- **fpde-cpw.3**: Add IHE IMR and KDL dependencies to sushi-config
- **fpde-cpw.3**: Add report-substatus and report-distribution extensions
- **fpde-cpw.3**: Add ImagingDiagnosticReportPraxisDe profile
- **fpde-cpw.3**: Add imaging diagnostic report examples
- **fpde-cpw.3**: Update dist package with imaging profile and new deps

### Miscellaneous

- **fpde-cpw.3**: Bump version to 0.41.3 for imaging diagnostic report profile

## [0.41.2] - 2026-04-30

### Bug Fixes

- **fpde-cpw.1b**: Address review findings iteration 1

### Features

- **fpde-cpw.1b**: Migrate cpw.1 terminology to external imaging package

### Miscellaneous

- **fpde-cpw.1b**: Update changelog for imaging terminology migration
- **fpde-cpw.1b**: Bump version to 0.41.2 for imaging terminology migration

## [0.41.1] - 2026-04-30

### Miscellaneous

- Vendor-clear public baseline v0.41.1

