# ADR-006: Local-First Release Pipeline and Elimination of the Aidbox Billing Bundle

**Status:** Accepted
**Date:** 2026-05-30
**Deciders:** Malte, Claude
**Affected systems:** `fhir-praxis-de`, `fhir-terminology-de`, `fhir-dental-de`, `fhir-deidentification-de`, the downstream SDK/codegen layer, the Aidbox runtime, and the downstream practice application that consumes the SDK packages

> Concrete downstream system names, repository paths, and adapter codenames are
> intentionally omitted from this document — this is a public IG surface. The
> full, named cross-repo design lives in the downstream SDK/codegen repository's
> release-orchestrator bead (private tracker).

## Context

Releasing a FHIR IG today fans out across CI:

1. A `v*` tag push triggers a heavy release build on a shared self-hosted runner
   (spinning HDD), builds the full IG Publisher site, publishes the FHIR package
   to `npm.cognovis.de`, deploys GitHub Pages, and sends an `ig-published`
   `repository_dispatch` to downstream repos.
2. Downstream IG repos catch the dispatch and open version-pin-bump PRs, each
   re-running heavy CI.
3. The dispatch chain reaches the downstream SDK/codegen layer, which regenerates
   its FHIR types, rebuilds its package chain, republishes to `npm.cognovis.de`,
   and rebuilds the Aidbox seed.

Three structural problems were observed in production:

- **Runner contention.** A small pool of shared self-hosted runners serves four
  IG repos plus the SDK/codegen layer. One multi-repo release serializes into a
  long queue; a single release effectively blocks the fleet for a long
  wall-clock window.
- **Silent dispatch failure.** The `v0.71.0` release built and published
  successfully, but the downstream dispatch was a no-op — `DOWNSTREAM_DISPATCH_TOKEN`
  was not configured, so no pin-bump PRs opened. The release "succeeded" while
  its core feature did nothing.
- **Two-pin drift for Aidbox.** Practice profiles reach the Aidbox runtime via a
  billing meta-package (`de.cognovis.bundle.praxis-billing-de`) that *re-pins*
  the IG version, separately from the codegen pin. The two drift: `0.71.0`
  reached the codegen pin while the meta-package still pinned `0.70.2`, so the
  Aidbox runtime never saw the new IG.

The deeper observation: this dispatch/fleet machinery coordinates a
multi-contributor, multi-machine release process that does not exist. There is
exactly one trusted releaser on one fast local machine (SSD). The
CI-built-release model solves a problem we do not have, at the cost of speed, a
misconfigurable secret, and a drift class.

Two facts make a simpler model possible:

- `fhir-versions.lock.yaml` is already the single source of truth for the pinned
  FHIR package set (it records each package's `consumers`).
- The billing meta-package is consumed *only* by the Aidbox installer. Codegen
  consumes the individual IG packages (`de.cognovis.fhir.praxis`,
  `de.cognovis.fhir.dental`) directly; the downstream practice application
  consumes the SDK packages. Nothing else references the meta-package. It is
  effectively an npm-serialized copy of the lock set, created so a
  container-based installer could fetch one pinned artifact.

## Decision

Move heavy build + publish off CI to **local, deliberate, idempotent scripts**,
and **eliminate the billing meta-package** in favour of a single lock-driven
source of truth.

### 1. Three scripts

| Script | Repo | Responsibility | Git? |
|---|---|---|---|
| **Script 1** `scripts/release-fhir-packages.sh` | `fhir-praxis-de` (hub) | Build (SUSHI, no IG Publisher) and `npm publish` **all** FHIR packages (IG + terminology leaves) across sibling checkouts, driven by `fhir-versions.lock.yaml`. Idempotent (skip versions already on `npm.cognovis.de`). **Verify-and-refuse** if a sibling checkout's version ≠ the pin. | No git. "Push" = `npm publish` only. |
| **Script 2** (downstream SDK/codegen repo) | SDK/codegen layer | Lock-driven orchestrator, all-or-nothing: pin-vs-npm gate → call Script 1 for any package behind → codegen → build SDK package chain → `npm publish` → **git commit + push** → install pinned leaves into Aidbox **directly from the lock** → optional Aidbox reload. | Commits/pushes its own generated output + pins. |
| **Script 3** (local) | per IG repo | IG Publisher HTML site for **changed IGs only**, tag-driven. The only place IG Publisher runs. Docs/site concern, decoupled from package publishing. | Tied to the git tag step. |

Rationale for Script 2 being one go: the SDK packages are consumed by the
downstream practice application as well as by the SDK/codegen layer itself. If
npm got ahead of the committed state, the consumer would observe drift.
Publishing, committing, and seeding Aidbox in one deliberate run keeps npm, git,
and the runtime in lockstep.

### 2. Eliminate the billing meta-package

The Aidbox installer no longer downloads and walks
`de.cognovis.bundle.praxis-billing-de`. The Aidbox package set is resolved
**directly from `fhir-versions.lock.yaml`**. The adapter → package-set selection
currently encoded in the installer (a hardcoded `adapter → meta-package@version`
map) moves to a lock-derived filter or a small adapter config in the SDK/codegen
repo. The meta-packages (`de.cognovis.bundle.praxis-billing-de`,
`de.cognovis.bundle.dental-billing-de`) are removed from `fhir-terminology-de`.

This collapses two pins into one source of truth and **deletes the drift class
that caused the `0.71.0`-did-not-reach-Aidbox incident.**

The lock-driven Aidbox seeding must load private IG CodeSystems through Aidbox's
**terminology-import (FHIR-package) path, not plain FHIR REST PUT** — REST PUT does
not populate Aidbox's concept index, leaving private code systems unresolvable by
the local terminology engine and breaking validation of value-set bindings such
as `Account.type`. Restoring the package-import path for private CodeSystems is
part of the installer refactor.

### 3. CI is reduced to cheap validation

CI keeps only fast PR gates on `ubuntu-latest` (vendor-leak, lint, structural /
SUSHI compile). The heavy self-hosted build-on-push, the tag-triggered heavy
release build, and the entire `repository_dispatch` / `DOWNSTREAM_DISPATCH_TOKEN`
machinery are retired.

### 4. Versioning / pins stay explicit and committed

Bumping versions and pins (`VERSION`, `sushi-config.yaml`,
`fhir-versions.lock.yaml`, `cross_pins`) remains a deliberate **committed git
step ("step 0")** performed before running the scripts — `fhir-sync-versions`
already reconciles most of it. Script 1 never commits; it builds and publishes
exactly what the committed pins declare.

### Release sequence

0. Bump + commit pins (`fhir-sync-versions`). — the deliberate decision.
1. **Script 1** → FHIR packages live on `npm.cognovis.de`.
2. **Script 2** → SDK/codegen regen + publish + commit/push + Aidbox.
3. **Script 3** (optional, tag) → IG Publisher HTML for changed IGs.

## Consequences

**Positive**

- Fast local SSD builds; no shared-runner contention.
- One source of truth (`fhir-versions.lock.yaml`); the Aidbox two-pin drift class
  is gone.
- No `repository_dispatch` secret to misconfigure; no silent no-op releases.
- Simpler mental model: a release is "run two scripts (plus an optional docs tag)".

**Negative / risks**

- Releasing requires the local machine and `npm.cognovis.de` credentials
  (supplied locally; never via 1Password per the standing ban).
- Loss of CI-built provenance for the npm packages. Mitigated by: cheap PR
  validation still gates correctness, and Script 1's verify-and-refuse guards
  checkout-vs-pin.
- The Aidbox installer requires a refactor (meta-package walk → lock-driven). The
  deployed/containerized Aidbox seed must bake in the lock (or a derived
  manifest) instead of fetching the meta-package from npm.

**Migration**

- `fhir-praxis-de` bead (this repo): Script 1, Script 3, step-0 pin flow, CI
  reduction. Tracked by `fpde-9go`.
- Downstream SDK/codegen repo bead: Script 2, lock-driven Aidbox installer
  (meta-package elimination), Aidbox install, codegen/SDK/commit, and removing
  the meta-packages from `fhir-terminology-de`. Tracked in that repo's private
  tracker.

## Alternatives considered

- **Keep CI; configure the dispatch token, add build caching, add a dedicated
  release runner.** Rejected: still elaborate fleet coordination for a
  single-releaser reality, and it does not address the two-pin Aidbox drift.
- **Keep the meta-package but build/publish it from Script 2.** Rejected: retains
  the second IG pin and therefore the drift class.

## References

- `v0.71.0` release: dispatch no-op (`DOWNSTREAM_DISPATCH_TOKEN not configured`)
  and meta-package pin lag — the incident that motivated this ADR.
- `fhir-versions.lock.yaml` (single source of truth for pinned FHIR versions).
- `fhir-publish-ig` skill (trusted local preflight → publish model).


## Addendum (fpde-x8r): canonical home of fhir-versions.lock.yaml

The lock manifest's canonical home is **`fhir-praxis-de`** (the orchestration hub),
not `fhir-terminology-de`. Rationale: the hub drives releases (Script 1) and is the
natural owner of the single source of truth; keeping the manifest beside the
consumed terminology repo was an accident of history.

Resolution order for all consumers (Script 1, the downstream SDK/codegen Script 2,
terminology ETL, the `fhir-sync-versions` skill):

1. `$FHIR_LOCK_FILE` (explicit override)
2. the local hub copy (`fhir-praxis-de/fhir-versions.lock.yaml`)
3. the sibling hub path (`../fhir-praxis-de/fhir-versions.lock.yaml`) for non-hub repos
4. legacy `fhir-terminology-de/fhir-versions.lock.yaml` (transition fallback only)

The terminology-local copy removal and its ETL/CI consumer repointing are owned by
the active downstream SDK/codegen cleanup bead (cross-repo terminology cleanup);
this bead only establishes the hub as canonical and points the hub's own Script 1
at it. The fallback (4) keeps every consumer working until that bead repoints to
the hub.
