// ============================================================================
// TSVG case-level qualifiers (on the billing Claim, case carrier)
// FK 4103 Vermittlungs-/Kontaktart + Tag der Terminvermittlung.
// Vermittlungscode is intentionally NOT modeled (dead field in practice).
// ============================================================================

Extension: ClaimTsvgVermittlungsartExt
Id: claim-tsvg-vermittlungsart
Title: "TSVG Vermittlungs-/Kontaktart"
Description: "TSVG Vermittlungs-/Kontaktart (KVDT FK 4103) des Behandlungsfalls. Steuert die extrabudgetäre Vergütung. Quelle: Schein.Vermittlungsart."
Context: Claim
* value[x] only code
* valueCode from https://fhir.cognovis.de/praxis/ValueSet/tsvg-vermittlungsart (required)

Extension: ClaimTerminvermittlungsdatumExt
Id: claim-terminvermittlungsdatum
Title: "Tag der Terminvermittlung"
Description: "Datum der Terminvermittlung (TSVG). Quelle: Schein.TagDerTerminvermittlung."
Context: Claim
* value[x] only date
