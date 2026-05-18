# Foundation Source Register

This register closes the source-review gate for the Praxis-DE Foundation v1.0
epic (`fpde-shp`). It records repository evidence for each foundation slice and
marks claims that still depend on external standards or legal interpretation.

The register is intentionally conservative. It uses repository artifacts and
bead close evidence as the source of truth. It does not renew legal, tax, or
package-version assertions from memory. When an assertion depends on current
external material and is not proven by this repository, the status is
`external verification unresolved`.

## Scope Boundary

The foundation layer is cross-specialty. Billing and coverage features that were
first discovered through dental workflows remain valid in `fhir-praxis-de` when
they model ambulatory-practice primitives rather than specialty-specific
clinical content.

This is especially relevant for non-dental self-pay and supplemental-insurance
workflows, such as gynecology self-pay services, private invoices, additional
private insurance, mixed payer routing, and external billing services. Dental
examples in this IG are examples of those primitives; they do not make the
primitive dental-only.

## Evidence Status Terms

| Status | Meaning |
|---|---|
| Repository evidence | Local FSH, pagecontent, tests, or workflow files demonstrate the claim. |
| Bead evidence | `bd` close reasons record implementation, review, and verification status. |
| External verification unresolved | The repository contains the model, but this review did not independently re-check the current external legal, regulatory, or standards source. |

## Foundation Slice Register

| Slice | Repository evidence | Source status | Downstream consequence |
|---|---|---|---|
| KBV base and inheritance boundary | `sushi-config.yaml` pins `kbv.basis: 1.8.0`; `input/pagecontent/inheritance-architecture.md`; `input/fsh/profiles/PraxisConditionDE.fsh`, `PraxisPatientDE.fsh`, `PraxisPractitionerDE.fsh`, `PraxisOrganizationDE.fsh`; `.github/actions/generate-kbv-basis-snapshots/README.md` | Repository evidence for current dependency and wrapper strategy. External verification unresolved for broad claims about everything KBV base does or does not cover. | Downstream IGs should inherit only where the Praxis-DE middle layer adds real cross-specialty constraints. Do not add wrapper profiles solely to mirror KBV. |
| Tax and VAT classification | `input/pagecontent/steuer-compliance.md`; `input/fsh/extensions/tax-category.fsh`; `input/fsh/extensions/tax-exemption-reason.fsh`; `input/fsh/extensions/ku-hinweis-pflicht.fsh`; `input/fsh/extensions/kleinunternehmer.fsh`; `input/fsh/profiles/PraxisInvoiceDE.fsh`; `input/fsh/valuesets/tax-category-de.fsh`; `input/fsh/codesystems/ust-befreiungsgrund.fsh`; `input/fsh/examples/example-invoice-tax.fsh`; `input/fsh/examples/example-chargeitemdef-tax.fsh` | Repository evidence for the FHIR pattern, UNECE-5305 system use, and invoice/profile constraints. External verification unresolved for current tax-law thresholds, exact legal interpretation, and claims about the absence of other IG solutions. | Keep tax modeling in Praxis-DE because self-pay, private billing, and mixed VAT/service contexts are cross-specialty. Final legal classification stays with the PVS and tax advisor. |
| Multi-coverage routing | `input/pagecontent/multi-coverage.md`; `input/fsh/examples/example-multi-coverage.fsh`; `input/fsh/profiles/coverage.fsh`; `sushi-config.yaml` page entry | Repository evidence for the local Account-based pattern and examples. Bead evidence from `fpde-shp.2` records SUSHI 0/0 and notes that `Coverage.order` was confirmed unavailable in the German base profiles. External verification unresolved for future changes in de.basisprofil.r4. | This is relevant for any GKV plus supplemental-insurance or PKV plus Beihilfe workflow, including non-dental self-pay and gynecology supplemental-insurance cases. |
| Condition asserter and evidence linking | `input/fsh/profiles/PraxisConditionDE.fsh`; `input/fsh/tests/test-condition-asserter-zfa-violation.fsh`; `input/fsh/examples/example-condition-constraints-bundle.fsh`; `input/pagecontent/inheritance-architecture.md` | Repository evidence for `asserter` targetProfile restriction and `evidence.detail` narrowing to Observation, ImagingStudy, and DiagnosticReport. External verification unresolved for the legal statement behind the physician/dentist asserter rule. | Local diagnosis profiles can keep clinical authorship and evidence links while still deriving from KBV base. Do not collapse this into AW archive profile inheritance. |
| Risk modifier observations | `input/fsh/profiles/lab-observation.fsh`; `input/fsh/examples/example-condition-constraints-bundle.fsh`; `input/pagecontent/aw-sst-crosswalk.md`; `input/pagecontent/profiles.md` | Repository evidence for `HbA1cObservationDE`, `SmokingStatusDE`, and their use as Condition evidence. External verification unresolved for any clinical guideline claim about risk scoring thresholds. | Risk modifiers are modeled as normal Observations linked from Conditions; downstream systems should not hard-code them into diagnosis codes. |
| ImagingStudy foundation | `input/fsh/profiles/imaging-study-praxis-de.fsh`; `input/fsh/profiles/PraxisConditionDE.fsh`; `input/fsh/examples/example-imaging-study-praxis-de.fsh`; `input/fsh/examples/example-condition-constraints-bundle.fsh`; `input/pagecontent/imaging-billing-architecture.md` | Repository evidence for the local ImagingStudy profile and for allowing ImagingStudy as diagnosis evidence. External verification unresolved for any claim that KBV has no current ImagingStudy profile outside the pinned package context. | Imaging remains a local operational model for PACS/RIS workflow and diagnosis evidence. Archive/export tooling may map only generic documents or procedures where needed. |
| AI and proposal provenance | `input/fsh/extensions/ai-provenance-applicable.fsh`; `input/fsh/codesystems/ai-provenance.fsh`; `input/fsh/profiles/praxis-proposal-provenance.fsh`; `input/fsh/codesystems/proposal-contribution-role.fsh`; `input/fsh/valuesets/proposal-contribution-role-vs.fsh`; `input/pagecontent/proposal-provenance.md`; `tests/test_proposal_provenance_constraints.py` | Repository evidence for the marker extension and the Provenance profile. External verification unresolved for EU AI Act legal interpretation beyond the data-model pattern. | Downstream applications should consume the generated profile and CodeSystem through their package pin/codegen path, not by duplicating proposal role vocabularies. |
| AW-SST billing crosswalk | `docs/adr/ADR-003-aw-sst-crosswalk.md`; `input/pagecontent/aw-sst-crosswalk.md`; `input/fsh/profiles/praxis-preliminary-billing-claim.fsh`; `input/fsh/profiles/praxis-gkv-claim.fsh`; `input/fsh/profiles/praxis-private-claim.fsh`; `input/fsh/profiles/praxis-bg-claim.fsh`; `input/fsh/profiles/praxis-selective-contract-claim.fsh`; `tests/test_aw_sst_billing_constraints.py` | Repository evidence for the local AW-aligned Claim split and for the no-parent/no-dependency decision. External verification unresolved for future AW-SST package changes after the inspected package version. | Downstream adapters must not stamp existing itemized Claims as final AW Claims. They must either emit a preliminary/final pair or keep PAS/unprofiled flows where the semantics are not submitted billing. |

## Child Bead Evidence Map

All `fpde-shp` child beads are closed. The important close evidence is:

| Child bead | Evidence summary |
|---|---|
| `fpde-shp.2` | Multi-coverage page and three example bundles; SUSHI 0/0; Account coverage priority selected over unavailable `Coverage.order`. |
| `fpde-shp.5` | KBV basis snapshot pre-generator action; SUSHI 0 errors; all acceptance criteria verified. |
| `fpde-shp.6` | Four KBV wrapper profiles, `KleinunternehmerregelungExt`, `AiProvenanceApplicableExt`, inheritance page; SUSHI 0 errors. |
| `fpde-shp.7` | Tax/VAT bundle, invoice tax examples, compliance documentation; SUSHI 0 errors. |
| `fpde-shp.8` | Condition constraints, HbA1c and smoking profiles, evidence detail examples; SUSHI 0 errors. |
| `fpde-shp.9` | Tax extension context expanded to ChargeItemDefinition and UNECE-5305 migration; SUSHI 0 errors and 0 warnings. |

Legacy child beads consolidated into the bundle beads above:

| Consolidated bead | Bundle |
|---|---|
| `fpde-47a`, `fpde-49o`, `fpde-d18`, `fpde-shp.1` | `fpde-shp.7` |
| `fpde-6xf`, `fpde-shp.3`, `fpde-shp.4` | `fpde-shp.8` |

## Downstream Notes

| Downstream area | Source-backed conclusion | Follow-up handling |
|---|---|---|
| AW billing adapters | Local AW Claim profiles are available in the Praxis package. Existing itemized adapter Claims require a semantic migration decision before profile assignment. | Track AW billing adoption separately from package pin/codegen work. |
| Proposal provenance consumers | `PraxisProposalProvenance` and `ProposalContributionRoleCS/VS` are package artifacts. | Consume through pin/codegen. Do not duplicate role CodeSystems downstream. |
| Specialty IG reuse | Specialty reuse assumptions are limited to cross-specialty primitives: tax, multi-coverage, ImagingStudy evidence, and package dependency behavior. | Specialty-specific billing/material work remains separate and should not block AW adoption in general practice adapters. |
| Non-dental self-pay | Self-pay gynecology, private billing, supplemental-insurance, and mixed payer workflows validate keeping tax, multi-coverage, private Claim, and Invoice patterns in Praxis-DE. | Treat dental-origin billing examples as reusable cross-specialty patterns when the FHIR primitive is not dental-specific. |

## Close Gate

Before closing `fpde-shp`, run a current SUSHI build and record the result in the
bead close reason or notes. If Aidbox or IG Publisher QA is not rerun locally,
record the latest available CI or release signal instead of implying fresh local
validation.
