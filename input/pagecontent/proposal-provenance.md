# Proposal Provenance

This page defines a vendor-neutral Provenance pattern for structured clinical proposals. A proposal is a structured clinical resource that may have been suggested by software, extracted from free text, linked to an existing record, confirmed by a clinician, or entered manually.

The proposed clinical resource remains a normal FHIR resource such as `Condition`, `Observation`, `AllergyIntolerance`, `ServiceRequest`, or `ChargeItem`. The proposal lifecycle is recorded with one or more [PraxisProposalProvenance](StructureDefinition-praxis-proposal-provenance.html) resources.

## Contribution Roles

The [ProposalContributionRoleCS](CodeSystem-proposal-contribution-role.html) CodeSystem classifies how a Provenance agent contributed to the proposal lifecycle.

| Code | Meaning | Typical agent |
|------|---------|---------------|
| `software-suggested` | A deterministic parser or rule engine suggested the structured resource from source data. | `Device` |
| `llm-suggested` | A large-language-model component suggested the structured resource from free text or unstructured source data. | `Device` |
| `clinician-confirmed` | A clinician reviewed and confirmed a previously suggested resource. | `Practitioner` |
| `linked-existing` | A proposed entry was resolved by linking to an existing clinical record instead of creating a duplicate. | `Practitioner` or `Device` |
| `manual-entry` | A clinician created the structured resource directly without an intermediate proposal source. | `Practitioner` |

The ValueSet [ProposalContributionRoleVS](ValueSet-proposal-contribution-role-vs.html) is bound with required strength to `Provenance.agent.role` in the profile.

## Event Model

Use separate Provenance resources for separate lifecycle events. A software or LLM suggestion and a clinician confirmation are different events and should not be collapsed into a single all-purpose Provenance resource.

### Suggestion Event

For a derived proposal, use a `CREATE` activity and reference the source material through `Provenance.entity`.

```json
{
  "resourceType": "Provenance",
  "meta": {
    "profile": [
      "https://fhir.cognovis.de/praxis/StructureDefinition/praxis-proposal-provenance"
    ]
  },
  "target": [
    { "reference": "Condition/example-diagnosis" }
  ],
  "recorded": "2026-05-18T10:15:00+01:00",
  "activity": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/v3-DataOperation",
        "code": "CREATE"
      }
    ]
  },
  "agent": [
    {
      "type": {
        "coding": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/provenance-participant-type",
            "code": "assembler"
          }
        ]
      },
      "role": [
        {
          "coding": [
            {
              "system": "https://fhir.cognovis.de/praxis/CodeSystem/proposal-contribution-role",
              "code": "llm-suggested"
            }
          ]
        }
      ],
      "who": { "reference": "Device/example-proposal-engine" }
    }
  ],
  "entity": [
    {
      "role": "source",
      "what": { "reference": "Composition/example-card-entry" }
    }
  ]
}
```

### Confirmation Event

For clinician confirmation, use a separate `UPDATE` Provenance that references the previously suggested resource version as a revision source.

```json
{
  "resourceType": "Provenance",
  "meta": {
    "profile": [
      "https://fhir.cognovis.de/praxis/StructureDefinition/praxis-proposal-provenance"
    ]
  },
  "target": [
    { "reference": "Condition/example-diagnosis" }
  ],
  "recorded": "2026-05-18T10:20:00+01:00",
  "activity": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/v3-DataOperation",
        "code": "UPDATE"
      }
    ]
  },
  "agent": [
    {
      "type": {
        "coding": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/provenance-participant-type",
            "code": "verifier"
          }
        ]
      },
      "role": [
        {
          "coding": [
            {
              "system": "https://fhir.cognovis.de/praxis/CodeSystem/proposal-contribution-role",
              "code": "clinician-confirmed"
            }
          ]
        }
      ],
      "who": { "reference": "Practitioner/example-practitioner" }
    }
  ],
  "entity": [
    {
      "role": "revision",
      "what": { "reference": "Condition/example-diagnosis/_history/1" }
    }
  ]
}
```

### Manual Entry

Manual entry is valid without a source entity. The authoring clinician is represented as the Provenance agent.

```json
{
  "resourceType": "Provenance",
  "meta": {
    "profile": [
      "https://fhir.cognovis.de/praxis/StructureDefinition/praxis-proposal-provenance"
    ]
  },
  "target": [
    { "reference": "Condition/example-diagnosis" }
  ],
  "recorded": "2026-05-18T10:25:00+01:00",
  "activity": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/v3-DataOperation",
        "code": "CREATE"
      }
    ]
  },
  "agent": [
    {
      "type": {
        "coding": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/provenance-participant-type",
            "code": "author"
          }
        ]
      },
      "role": [
        {
          "coding": [
            {
              "system": "https://fhir.cognovis.de/praxis/CodeSystem/proposal-contribution-role",
              "code": "manual-entry"
            }
          ]
        }
      ],
      "who": { "reference": "Practitioner/example-practitioner" }
    }
  ]
}
```

## Source Requirement

The profile keeps `Provenance.entity` optional so that direct manual entry can be represented without inventing a synthetic source. It also defines an invariant: when any agent role is `software-suggested`, `llm-suggested`, or `linked-existing`, `entity` must be present. Derived proposals must always identify their source or linked record.
