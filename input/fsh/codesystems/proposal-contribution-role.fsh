CodeSystem: ProposalContributionRoleCS
Id: proposal-contribution-role
Title: "Proposal Contribution Role"
Description: "Roles that describe how a participant contributed to a structured clinical proposal lifecycle."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #software-suggested "Software-suggested" "A deterministic parser or rule engine extracted the proposal from structured source data."
* #llm-suggested "LLM-suggested" "A large-language-model component extracted the proposal from free text or other unstructured source data."
* #clinician-confirmed "Clinician-confirmed" "A clinician reviewed and confirmed a previously suggested proposal."
* #linked-existing "Linked to existing record" "A proposal was resolved by linking to an existing clinical record instead of creating a new resource."
* #manual-entry "Manual entry" "A clinician created a structured resource directly without an intermediate proposal step."
