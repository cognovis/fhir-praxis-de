---
name: fhir-publish-ig
description: >-
  use when: running, diagnosing, or planning a trusted FHIR IG preflight, release
  tag handoff, registry/GitHub watch, or self-hosted IG Publisher migration for
  fhir-* repos. NOT for: reconciling downstream version pins or regenerating
  Polaris SDK output. boundary: publish/tag/QA orchestration lives here;
  downstream pin sync remains in fhir-sync-versions.
requires_standards: [english-only, no-emoji, judge-layer]
compatibility: {}
metadata: {}
action_boundary:
  risk_class: external-side-effect
  effect_type: network
  proposal_schema: standard://judge-layer/proposals/action-proposal.v1
  judge: agent://judge-default
  requires_mandate: true
---

# fhir-publish-ig

Build, QA-gate, tag, and watch publication of one trusted FHIR IG package.

## Inputs

- An IG repo with `VERSION` and `sushi-config.yaml`; strict repos also provide `scripts/build-package.sh` and `scripts/qa_gate.py`.
- Optional `.fhir-publish.yml` profile for repo-specific required files, commands, artifacts, and pinned Publisher settings.
- Trusted publish context for `publish --execute`: protected `main`, release branch, trusted tag, or explicit operator mandate.
- Registry credentials and release credentials supplied by the caller or workflow environment.

## Outputs

- JSON-envelope doctor, preflight, publish, or watch verdict with phase timings, cache state, warnings, and log artifact paths.
- Durable preflight handoff JSON proving the exact commit SHA that passed local QA.
- A downstream handoff to `fhir-sync-versions --release-audit` after registry verification.

## Workflow

Use the bundled script modes:

- `doctor`: check local toolchain, registry reachability, Publisher pinning, and optionally self-hosted runner labels.
- `preflight`: plan or run prefetch, SUSHI, IG Publisher, QA gate, package build, log capture, and preflight handoff.
- `publish`: create/push a release tag only after trusted context and exact `--preflight-sha` or `--preflight-file` are present.
- `watch`: poll `registry`, `release`, `github-run`, `pr`, or `all`, then hand off to `fhir-sync-versions --release-audit`.

## Repo Profile

Use `.fhir-publish.yml` when a repo does not match the strict FPDE shape or when a release must be reproducible:

```yaml
publisher:
  url: https://github.com/HL7/fhir-ig-publisher/releases/download/1.8.29/publisher.jar
  sha256: "<publisher.jar sha256>"
  jar_path: input-cache/publisher.jar
artifacts:
  log_dir: .fhir-publish/logs
  handoff_file: .fhir-publish/preflight.json
preflight:
  required_files:
    - VERSION
    - sushi-config.yaml
    - scripts/build-package.sh
  prefetch_commands:
    - name: preload-praxis
      command: ["bash", "scripts/prefetch-praxis.sh", "v0.67.0"]
phases:
  qa_gate:
    required: false
  build_package:
    command: ["bash", "scripts/build-package.sh", "--skip-sushi"]
```

Prefer pinned Publisher URL + SHA256 for release jobs. The default `latest` URL remains a compatibility path and is reported as a doctor warning.

## Do NOT

- Do not run self-hosted publish steps for public fork PRs or unknown event context.
- Do not create or push a release tag before preflight passes for the exact commit SHA.
- Do not move downstream pin reconciliation into this skill.

## Resources

| File | Purpose |
|------|---------|
| `scripts/publish_ig.py` | Deterministic `preflight`, `publish`, and `watch` CLI with JSON envelope output |
| `tests/test_publish_ig.py` | Fixture tests for trust decisions, dry-run plans, profile adaptation, handoff files, diagnostics, registry watch, and publish gates |
| `references/self-hosted-runner-runbook.md` | Runner labels, cache plan, security model, workflow snippet, and repo migration guidance |
