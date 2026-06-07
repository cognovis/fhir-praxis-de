# Claim Diagnosis Contract

This page defines the quarter diagnosis contract for Praxis Claim profiles. The
primary carrier is `PraxisPreliminaryBillingClaimDE`, because it carries the
quarterly billing context and service items. Final claims may echo the same
diagnosis list when needed for downstream submission or audit.

## Carrier

`Claim.diagnosis` carries quarterly treatment diagnoses (`Behandlungsdiagnosen`).
Each entry should use `diagnosisReference` to reference the source
`PraxisCondition` that contributed the billing diagnosis. When no Condition
resource is available, `diagnosisCodeableConcept` may carry the ICD-10-GM coding
directly.

Source Conditions are retained as clinical documentation. They are never deleted
or destructively merged just because a billing tuple collapses for Claim output.
Rule predicates, such as "any confirmed diabetes diagnosis in the quarter", are
derived from the source Conditions.

## Billing Tuple

The uniqueness key for `Claim.diagnosis` is the exact billing tuple:

| Tuple part | Source |
|---|---|
| ICD code | `Condition.code.coding` using ICD-10-GM |
| Diagnosesicherheit | `http://fhir.de/StructureDefinition/icd-10-gm-diagnosesicherheit` |
| Seitenlokalisation | `http://fhir.de/StructureDefinition/seitenlokalisation` |
| Mehrfachcodierungskennzeichen | `http://fhir.de/StructureDefinition/icd-10-gm-mehrfachcodierungs-kennzeichen` |

Only exact tuple duplicates may collapse in the Claim diagnosis list. A naked ICD
code is not a valid deduplication key. For example, the same ICD with `G` and
`V`, or with `R` and `L`, produces separate `Claim.diagnosis` entries. There is
no generic `G > V > Z > A` precedence rule.

## Diagnosesicherheit Resolution

The KBV-AWS diagnosis certainty semantics resolve to Condition status as follows:

| Diagnosesicherheit | Meaning | `Condition.verificationStatus` | `Condition.clinicalStatus` |
|---|---|---|---|
| `G` | gesichert | `confirmed` | `active` |
| `V` | Verdacht | `provisional` or `differential` | `active` |
| `Z` | Zustand nach | `confirmed` | `resolved` |
| `A` | ausgeschlossen | `refuted` | not required |

`Z` means resolved or state-after for the specific diagnosis tuple. It is not a
generic long-term diagnosis marker. The `Dauerdiagnose` concept (permanent/long-term
diagnosis flag used in some PVS systems) is handled separately and must not be
inferred from `Z`.

## Implementation Contract

Downstream resolution logic must:

- Preserve source Conditions.
- Build the Claim diagnosis list from exact billing tuples.
- Keep different `Diagnosesicherheit`, laterality, and multiple-coding marker
  values as separate Claim diagnosis entries.
- Collapse only exact tuple duplicates when producing the Claim projection.
- Preserve `Seitenlokalisation` and
  `Mehrfachcodierungskennzeichen` on the source ICD coding and, when using
  `diagnosisCodeableConcept`, on the Claim diagnosis coding.

## Related IG Pages and Beads

- Account-centered billing case: `AccountPraxisSchein` anchors the Schein;
  `EncounterPraxis` models clinical contacts; quarterly diagnoses project onto
  `Claim.diagnosis` on the preliminary billing claim. See
  [Architecture Overview](architecture.html) and [AW-SST Crosswalk](aw-sst-crosswalk.html).
- `fpde-cj3`: AccountPraxisSchein and EncounterPraxis contact re-scope
- `fpde-mub`: this Claim.diagnosis contract and KBV-AWS diagnosis certainty mapping
- External bead `59tj`: downstream Account-centered billing-case coordination
