Invariant: provenance-source-required-for-derived
Description: "If agent.role contains software-suggested, llm-suggested, or linked-existing, then entity must be present."
Expression: "agent.role.coding.where(system = 'https://fhir.cognovis.de/praxis/CodeSystem/proposal-contribution-role' and (code = 'software-suggested' or code = 'llm-suggested' or code = 'linked-existing')).exists() implies entity.exists()"
Severity: #error

Profile: PraxisProposalProvenance
Parent: Provenance
Id: praxis-proposal-provenance
Title: "Praxis Proposal Provenance"
Description: "Vendor-neutral Provenance profile for clinical proposal lifecycles: software or LLM suggestions, clinician confirmations, links to existing clinical records, and direct manual entries."
* obeys provenance-source-required-for-derived
* target 1..*
* recorded 1..1
* activity 1..1
* agent 1..*
* agent.type 1..1
* agent.role 1..*
* agent.role from ProposalContributionRoleVS (required)
* agent.who 1..1
* entity 0..*
* activity ^short = "FHIR DataOperation for this proposal provenance event"
* activity ^definition = "Use CREATE for proposal creation, UPDATE for confirmation or structured-resource update events, and other FHIR DataOperation codes where appropriate."
* agent.type ^short = "Standard FHIR provenance participant type"
* agent.role ^short = "Proposal contribution role"
* agent.role ^definition = "Classifies the participant's contribution to the proposal lifecycle, such as LLM suggestion, deterministic software suggestion, clinician confirmation, existing-record linkage, or manual entry."
* entity ^short = "Source or revision input for derived proposal events"
* entity ^definition = "Source entities are optional for direct manual entry, but required by invariant for software-suggested, LLM-suggested, and linked-existing events."
