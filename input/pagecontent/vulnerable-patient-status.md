# Vulnerable Patient Status

## Patient Master Data Modifiers

The `VulnerablePatientStatusDE` extension captures patient master-data modifiers that influence how the practice records and interprets a patient as vulnerable for administrative and downstream billing workflows:

- `pflegegradStatus` records the Pflegegrad classification under SGB XI.
- `eingliederungshilfeStatus` records whether Eingliederungshilfe applies and, where applicable, the associated disability category.
- `kooperationsvertragStatus` records the local Kooperationsvertrag state under § 119b SGB V.
- `kooperationsvertragFacility` optionally points to the Organization that is part of the contractual setup.

The extension is intentionally limited to master data. It does not encode dental billing rules, clinical eligibility logic, or any downstream procedure-specific trigger interpretation.

## Temporal Validity

`validFrom` and `validUntil` define the period in which the recorded master data is valid in the practice record.

- `validFrom` marks the first date on which the modifier is effective.
- `validUntil` marks the last date on which the modifier remains effective.

If a modifier changes over time, downstream systems should treat the extension as time-bounded master data rather than as a permanent patient attribute.

## Dental BEMA Trigger Delegation

Dental BEMA trigger interpretation (positions 107a, 174a/b, 171a/b, 172a/b, 173a/b, 154/155, and age-driven 165) is delegated to the fhir-dental-de implementation guide (bead fdde-xht). Downstream dental systems should consume the VulnerablePatientStatusDE extension and apply their own billing rules.

This IG only publishes the patient master-data modifiers and the terminology required to exchange them.

## SNOMED/ICF Cross-Maps

The local terminology includes cross-map metadata where it is available:

- Pflegegrad codes carry a SNOMED CT family reference for the care-dependency domain.
- Eingliederungshilfe categories carry ICF domain references for the relevant body-function groups.

These cross-maps are informational and support terminology alignment. They do not replace the local patient master-data codes.
