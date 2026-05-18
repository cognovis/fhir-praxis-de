Alias: $data-operation = http://terminology.hl7.org/CodeSystem/v3-DataOperation
Alias: $provenance-agent-type = http://terminology.hl7.org/CodeSystem/provenance-participant-type
Alias: $proposal-role = https://fhir.cognovis.de/praxis/CodeSystem/proposal-contribution-role

Instance: example-card-entry-composition
InstanceOf: Composition
Title: "Example Card Entry Composition"
Description: "Example card-entry source used by proposal provenance examples."
Usage: #example
* status = #final
* type = http://loinc.org#11506-3 "Progress note"
* subject = Reference(example-patient)
* date = "2026-05-18T10:05:00+01:00"
* author[0] = Reference(example-practitioner)
* title = "Card Entry"
* section[0].title = "Assessment"
* section[0].text.status = #generated
* section[0].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Patient reports fatigue and elevated glucose readings.</div>"

Instance: example-proposal-engine-device
InstanceOf: Device
Title: "Example Clinical Proposal Engine"
Description: "Example software component that generates structured clinical proposals."
Usage: #example
* type.text = "Clinical proposal engine"
* deviceName[0].name = "Example Clinical Proposal Engine"
* deviceName[0].type = #user-friendly-name
* version[0].value = "2026.05"

Instance: ExampleProposalSuggestionProvenance
InstanceOf: PraxisProposalProvenance
Title: "Proposal Provenance - LLM Suggestion"
Description: "The structured diagnosis proposal was suggested from a card-entry composition."
Usage: #example
* target[0] = Reference(ExampleDiagnose)
* recorded = "2026-05-18T10:15:00+01:00"
* activity = $data-operation#CREATE "create"
* agent[0].type = $provenance-agent-type#assembler "Assembler"
* agent[0].role[0] = $proposal-role#llm-suggested "LLM-suggested"
* agent[0].who = Reference(example-proposal-engine-device)
* entity[0].role = #source
* entity[0].what = Reference(example-card-entry-composition)

Instance: ExampleProposalConfirmationProvenance
InstanceOf: PraxisProposalProvenance
Title: "Proposal Provenance - Clinician Confirmation"
Description: "A clinician confirmed the previously suggested structured diagnosis."
Usage: #example
* target[0] = Reference(ExampleDiagnose)
* recorded = "2026-05-18T10:20:00+01:00"
* activity = $data-operation#UPDATE "revise"
* agent[0].type = $provenance-agent-type#verifier "Verifier"
* agent[0].role[0] = $proposal-role#clinician-confirmed "Clinician-confirmed"
* agent[0].who = Reference(example-practitioner)
* entity[0].role = #revision
* entity[0].what.reference = "Condition/ExampleDiagnose/_history/1"

Instance: ExampleProposalManualEntryProvenance
InstanceOf: PraxisProposalProvenance
Title: "Proposal Provenance - Manual Entry"
Description: "A clinician directly authored the structured diagnosis without an intermediate proposal source."
Usage: #example
* target[0] = Reference(ExampleDiagnose)
* recorded = "2026-05-18T10:25:00+01:00"
* activity = $data-operation#CREATE "create"
* agent[0].type = $provenance-agent-type#author "Author"
* agent[0].role[0] = $proposal-role#manual-entry "Manual entry"
* agent[0].who = Reference(example-practitioner)
