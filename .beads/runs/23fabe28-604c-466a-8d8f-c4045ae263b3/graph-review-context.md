## Graph Review Context

- provider: codebase-memory
- provider_status: ok
- confidence: high
- routes_in_context: 0

### Changed Files
- .agents/skills/fhir-sync-versions/SKILL.md
- .github/workflows/ig-release.yml

### Relevant Context Files
- none

### Symbols
- repository_dispatch
- yml
- praxis
- dispatch
- client_payload
- version
- new_version
- main
- package_id
- DOWNSTREAM_DISPATCH_TOKEN
- bump
- payload
- Automate
- PRs
- Intent
- Goal

### Call Path Symbols
- none

### Evidence Commands
- grep -E 'event_type.*ig-published|version.*IG_VERSION|package_id' .github/workflows/ig-release.yml -> exit 0 (verify dispatch payload keys)
- git push -u origin feat/fpde-9j1-bump-praxis-pin-receiver (fhir-dental-de) -> exit 0 (push receiver workflow to fhir-dental-de)
- gh pr create (fhir-dental-de) -> exit 0 (open PR for receiver workflow in fhir-dental-de)
- git push -u origin feat/fpde-9j1-bump-praxis-pin-receiver (fhir-terminology-de) -> exit 0 (push receiver workflow to fhir-terminology-de)
- gh pr create (fhir-terminology-de) -> exit 0 (open PR for receiver workflow in fhir-terminology-de)
- git commit (fhir-praxis-de worktree) -> exit 0 (commit ig-release.yml dispatch update and skill doc update)

### Downstream Impacts
- fhir-dental-de: new bump-praxis-pin.yml workflow (PR #22)
- fhir-terminology-de: new bump-praxis-pin.yml workflow (PR #3)

### Scope Changes
- none

### Skipped Checks
- live dispatch trigger test: requires pushing a real release tag to fhir-praxis-de — too destructive for bead validation; verified by workflow review instead
- 5-minute timing verification (AC4): verified by design: ubuntu-latest runner with simple sed/python steps; no heavy processing
