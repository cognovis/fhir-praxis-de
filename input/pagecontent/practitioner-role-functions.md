# Practice Role Functions

This page documents the FHIR modelling of practice functions on `PractitionerRole.code`
and the three-axis separation of qualification, function, and scope.

## Three-Axis Separation

Practice staff authorization uses three separate FHIR elements:

| Axis | FHIR Element | Semantics |
|---|---|---|
| Qualification/Profession | `Practitioner.qualification.code` | Formal qualification (e.g. Arzt, MFA, MTRA) |
| Practice Function | `PractitionerRole.code` | What the practitioner does in this role (e.g. billing lead, application administration) |
| Organization Scope | `PractitionerRole.organization` + `Organization.partOf` | The organizational unit and its descendant units covered by the function |

**Key rule:** Do not model practice functions as qualifications and do not use location labels
(`mfa-anmeldung`, `mfa-labor`) as authorization roles. Location (`PractitionerRole.location`)
is routing and filter context, not authorization.

## Organization-Scoped Function Semantics

A function code on a `PractitionerRole` resource applies to:
- The `PractitionerRole.organization` (the directly referenced organization), and
- All descendant organizations reachable via `Organization.partOf` links.

This means that a practitioner with the `billing-lead` function on the top-level practice
organization also holds that function for all sub-units (departments, satellite locations)
that reference the top-level organization via `Organization.partOf`.

Authorization consumers MUST traverse the `Organization.partOf` hierarchy when evaluating
whether a function applies to a given organizational unit.

## Practice Function CodeSystem

Local gap codes are defined in `PraxisFunktionsrolleCS`
(`https://fhir.cognovis.de/praxis/CodeSystem/praxis-funktionsrolle`):

| Code | Display | Semantics |
|---|---|---|
| `billing-lead` | Billing Lead | Billing authority over the assigned organization scope and all descendants via `Organization.partOf`. Responsible for billing oversight and authorization. |
| `application-administration` | Application Administration | Staff-administration function: maintains users, staff assignments, and recorded staff capabilities. Does not grant global technical admin bypass. Scope limited to the assigned organization and its descendants. |

## ESCO Integration

Standard occupations (billing clerk, medical administrative assistant, practice manager,
receptionist, healthcare manager, ICT system administrator, doctors' surgery assistant)
are referenced from the fhir-terminology-de ESCO subset
(`https://fhir.cognovis.de/ValueSet/esco-practice-functions`).

The ESCO subset is provided by the `de.cognovis.terminology.esco` dependency
declared in `sushi-config.yaml`. `PraxisFunktionsrolleVS` includes the canonical
ValueSet reference so IG Publisher can resolve the ESCO practice-function codes
without copying ESCO CodeSystem content into this IG.

## Conformance Example

The following example shows a practitioner assigned the billing lead function for a
practice organization:

```json
{
  "resourceType": "PractitionerRole",
  "id": "example-billing-lead",
  "practitioner": { "reference": "Practitioner/example-practitioner" },
  "organization": { "reference": "Organization/example-praxis" },
  "code": [
    {
      "coding": [
        {
          "system": "https://fhir.cognovis.de/praxis/CodeSystem/praxis-funktionsrolle",
          "code": "billing-lead",
          "display": "Billing Lead"
        }
      ]
    }
  ]
}
```

Note: This example uses only the local CodeSystem code. System-specific claim
projections (identity providers, EHR-specific RBAC attributes, etc.) are out of
scope for this IG.
