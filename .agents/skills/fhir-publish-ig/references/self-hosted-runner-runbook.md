# Self-Hosted FHIR IG Publisher Runbook

This runbook supports `skills/fhir-publish-ig/scripts/publish_ig.py`.

## Runner Inventory

Verified on 2026-05-23 with `gh api /orgs/cognovis/actions/runners`.

| Runner | Status | Labels | Intended Use |
|---|---|---|---|
| `atlas` | online | `self-hosted`, `Linux`, `X64`, `docker`, `atlas`, `fhir-publisher` | IG Publisher / QA / publish candidate |
| `atlas-2` | online | `self-hosted`, `Linux`, `X64`, `docker`, `atlas`, `atlas-2`, `fhir-publisher` | Secondary parallel capacity / fallback |

`kaji` and `kaji-2` are intentionally excluded from complex FHIR IG Publisher jobs after a 2026-05-23 FPDE main-run hang in the Publisher step. They remain useful for other CI work, but do not carry the `fhir-publisher` label and should not be used for full IG validation or publish jobs until re-qualified.

Use `doctor --check-runners` before changing workflow labels:

```bash
python3 .agents/skills/fhir-publish-ig/scripts/publish_ig.py \
  doctor \
  --repo "$GITHUB_WORKSPACE" \
  --check-runners \
  --github-owner cognovis \
  --json
```

Use the dedicated `fhir-publisher` label together with the `atlas` family label so complex IG jobs cannot route to KAJI or unrelated Docker runners:

```yaml
runs-on: [self-hosted, Linux, X64, docker, atlas, fhir-publisher]
```

Current safe runner label examples:

```yaml
runs-on: [self-hosted, Linux, X64, docker, atlas, fhir-publisher]
runs-on: [self-hosted, Linux, X64, docker, atlas, atlas-2, fhir-publisher]
```

## Security Model

Self-hosted publish jobs must fail closed.

- Allowed events: `workflow_dispatch`, protected `main`, protected `release/*`, and trusted `v*` tags.
- Public fork PRs must not run self-hosted publish jobs.
- Secrets such as `VERDACCIO_TOKEN`, release tokens, and deploy keys must be scoped only to trusted jobs.
- `publish --execute` requires `--preflight-sha` for the exact commit that passed SUSHI, IG Publisher, and QA gate.
- Local operator execution outside GitHub must pass an explicit release mandate and use `--trusted-event`.

## Cache Plan

Keep these caches warm on self-hosted runners:

- `~/.fhir/packages` for FHIR package dependencies.
- `<repo>/input-cache/txcache` for terminology server results.
- `<repo>/input-cache/publisher.jar` or a shared pinned publisher path passed via `--publisher-jar`.
- `~/.npm` for SUSHI and npm package work.
- Ruby gem and Jekyll caches when Jekyll is not preinstalled.

Do not delete caches by default. Add a separate cold-cache job if a clean benchmark is needed.

The script now emits cache state, phase timings, Publisher SHA256, and per-phase log paths. Upload `.fhir-publish/logs/` and `.fhir-publish/preflight.json` as workflow artifacts when diagnosing failures.

## Repo Profile

Strict mode assumes the FPDE shape: `VERSION`, `sushi-config.yaml`, `scripts/build-package.sh`, and `scripts/qa_gate.py`. Repos that are not yet strict should add `.fhir-publish.yml` instead of weakening the skill globally.

Minimal profile for a repo that does not yet have a QA gate:

```yaml
preflight:
  required_files:
    - VERSION
    - sushi-config.yaml
    - scripts/build-package.sh
phases:
  qa_gate:
    required: false
```

Pinned release profile:

```yaml
publisher:
  url: https://github.com/HL7/fhir-ig-publisher/releases/download/1.8.29/publisher.jar
  sha256: "<sha256>"
  jar_path: input-cache/publisher.jar
artifacts:
  log_dir: .fhir-publish/logs
  handoff_file: .fhir-publish/preflight.json
```

Configured preload commands are preferred when scripts need version arguments:

```yaml
preflight:
  prefetch_commands:
    - name: preload-praxis
      command: ["bash", "scripts/prefetch-praxis.sh", "v0.67.0"]
    - name: preload-kbv-terminology
      command: ["bash", "scripts/prefetch-package.sh", "de.cognovis.terminology.kbv", "1.0.0"]
```

## Prepared Runner Requirements

Install these on the runner image or host:

- Java 17.
- Node 20 and npm.
- `fsh-sushi` or ability to run `npx sushi`.
- Ruby and Jekyll.
- `httpyac`.
- `jq`, `curl`, `git`, and `npm`.
- A pinned `publisher.jar` or a pinned cache/download policy.

Do not bake private npm/FHIR packages or secrets into an image. Fetch private packages at runtime with scoped credentials.

## Workflow Snippet

This is a migration starting point for IG repos. Keep the repo-local release workflow responsible for GitHub Release assets until direct publish from a self-hosted runner is intentionally adopted.

```yaml
name: Trusted IG Publish

on:
  workflow_dispatch:
  push:
    branches: [main]

jobs:
  preflight:
    if: github.event_name == 'workflow_dispatch' || github.ref == 'refs/heads/main'
    runs-on: [self-hosted, Linux, X64, docker, atlas, fhir-publisher]
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: FHIR IG preflight
        run: |
          python3 .agents/skills/fhir-publish-ig/scripts/publish_ig.py \
            preflight \
            --repo "$GITHUB_WORKSPACE" \
            --handoff-file "$GITHUB_WORKSPACE/.fhir-publish/preflight.json" \
            --json
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: fhir-publish-preflight
          path: |
            .fhir-publish/preflight.json
            .fhir-publish/logs/

  publish-tag:
    needs: preflight
    if: github.ref == 'refs/heads/main' && github.ref_protected == true
    runs-on: [self-hosted, Linux, X64, docker, atlas, fhir-publisher]
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: actions/download-artifact@v4
        with:
          name: fhir-publish-preflight
          path: .
      - name: Create trusted release tag
        run: |
          python3 .agents/skills/fhir-publish-ig/scripts/publish_ig.py \
            publish \
            --repo "$GITHUB_WORKSPACE" \
            --trusted-event \
            --preflight-file "$GITHUB_WORKSPACE/.fhir-publish/preflight.json" \
            --execute \
            --json

  watch:
    needs: publish-tag
    runs-on: [self-hosted, Linux, X64, docker, atlas, fhir-publisher]
    permissions:
      contents: read
      actions: read
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Watch release and registry
        run: |
          python3 .agents/skills/fhir-publish-ig/scripts/publish_ig.py \
            watch \
            --repo "$GITHUB_WORKSPACE" \
            --target all \
            --json
```

The handoff file is the release gate. Do not replace it with a recomputed SHA in the publish job.

## Migration Guidance

`fhir-praxis-de`:

- First candidate for migration because it already has `scripts/qa_gate.py`.
- Replace duplicated GitHub-hosted main/tag Publisher work with one self-hosted preflight before tag creation.
- Keep registry publication in the tag release workflow initially, then watch with `publish_ig.py watch`.
- Add pinned Publisher URL + SHA256 before making self-hosted publish the only release path.

`fhir-dental-de`:

- Add or align `scripts/qa_gate.py` before adopting the strict preflight gate.
- Keep praxis preloading explicit, but avoid duplicated version literals in comments and workflow steps.
- Use the self-hosted cache for `~/.fhir/packages`, publisher jar, and txcache.
- Until the repo has a QA gate, use `.fhir-publish.yml` with `phases.qa_gate.required: false`.
- Because direct `main` pushes may be rejected by branch protection, use PR watch before tag publish when changing release workflow files.

`fhir-deidentification-de`:

- Add or align `scripts/qa_gate.py` before strict adoption.
- Preserve private package preload from `npm.cognovis.de`.
- After registry watch succeeds, run `fhir-sync-versions --release-audit` so Polaris pins and generated de-identification files can be regenerated in a separate workstream.

## Failure Triage

`watch` and `doctor` classify common failures observed during the FPDE and Polaris sync:

- `repo-rules` for repository rules checks.
- `lint` for formatter/linter failures.
- `qa-gate` for IG QA allowlist failures.
- `missing-jekyll` for local or runner Publisher prerequisites.
- `verdaccio-auth` and `registry-unreachable` for registry checks.
- `missing-fhir-package` for unresolved private package preloads.
- `vendor-leak` for bundled vendor artifact guards.
- `branch-protection` and `tag-exists` for GitHub release handoff problems.
- `shell-portability` for scripts that depend on Bash but run under another shell.
