# fhir-deidentification-de

Repository: https://github.com/cognovis/fhir-deidentification-de
Package: io.cognovis.de-identification.de
Beads prefix: `fdid-` (separate beads database in target repo)

De-Identification IG bootstrapped in bead `fpde-7yo.1` (closed).
Spec: `docs/specs/spec-deidentification-ig.md` (this repo)
ADR: `ADR-027-privacy-and-compliance.md` (polaris repo)

## Status

Bootstrap complete — `io.cognovis.de-identification.de@0.1.0` shipped via npm.cognovis.de + GitHub Pages site.
Advisory fixes applied during fpde-7yo.1: CS metadata, .gitkeep dirs, CLAUDE.md pointer.

The `fpde-7yo` Epic is **CLOSED**. Content work (10 sub-beads) migrated to the target repo on 2026-05-02 because the work happens there, not here.

## Bead migration map (2026-05-02)

| Old (this repo, closed) | New (target repo, open) | Bead summary |
|------------------------|------------------------|--------------|
| `fpde-7yo.2` | `fdid-c52` | [PROFILE] Patient/Practitioner/RelatedPerson DE-Identifier coverage |
| `fpde-7yo.3` | `fdid-9u3` | [PROFILE] ChargeItem/Account/Coverage/CarePlan DE-Profile |
| `fpde-7yo.4` | `fdid-25a` | [PROFILE] Bundle/Provenance + reference rewriting |
| `fpde-7yo.5` | `fdid-8q5` | [PROFILE] HS-17 remaining 14 resources |
| `fpde-7yo.6` | `fdid-iwt` | [METHOD] scrubFreeText Library + false-positive trade-off |
| `fpde-7yo.7` | `fdid-4sw` | [METHOD] Quasi-ID generalize:* (4 methods) |
| `fpde-7yo.8` | `fdid-f4q` | [DOC] HIPAA Safe Harbor DE-mapping narrative |
| `fpde-7yo.9` | `fdid-8ru` | [BUILD] JSON sidecar codegen |
| `fpde-7yo.10` | `fdid-29d` | [TEST] Negative test corpus TestScript ~270 entries |
| `fpde-7yo.11` | `fdid-b84` | [CI] Quality gates |

Internal dependencies preserved in target repo:
- `fdid-8ru` (BUILD) blocked by `fdid-c52,9u3,25a,8q5,iwt,4sw`
- `fdid-29d` (TEST) blocked by `fdid-iwt`
- `fdid-b84` (CI) blocked by `fdid-8ru,29d`

## Workflow

To work on the IG content, switch to `cognovis/fhir-deidentification-de` and use that repo's beads:

```bash
cd ~/code/fhir-deidentification-de
bd ready                  # show next-actionable beads
bd list --status=open     # show all 10 open beads
```

Wave-orchestrator filter for that repo: `bd list` (all top-level, no Epic).

## Cross-repo references

- Spec source of truth: this repo (`docs/specs/spec-deidentification-ig.md`)
- Privacy ADR (the technical counterpart to AVV §9 + §203): polaris repo (`docs/adr/ADR-027-privacy-and-compliance.md`)
- Polaris consumer workstream (11 beads): polaris repo, label `adr-027-privacy`
