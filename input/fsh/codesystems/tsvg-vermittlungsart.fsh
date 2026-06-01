// TSVG Vermittlungs-/Kontaktart (KVDT FK 4103). Local mirror of the KBV key table as
// surfaced by the source-system Schein dropdown (code 5 is intentionally not assigned).
// The official KBV OID should be confirmed and added here (or this table sourced from
// de.cognovis.terminology.kbv) on next sync.
CodeSystem: TsvgVermittlungsartCS
Id: tsvg-vermittlungsart
Title: "TSVG Vermittlungs-/Kontaktart"
Description: "TSVG Vermittlungs-/Kontaktart (KVDT FK 4103). Kennzeichnet den Vermittlungs- bzw. Kontaktanlass eines Behandlungsfalls für die extrabudgetäre Vergütung (TSS-/HA-Vermittlung, offene Sprechstunde)."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/tsvg-vermittlungsart"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #1 "TSS-Terminfall"
* #2 "TSS-Akutfall"
* #3 "HA-Vermittlungsfall"
* #4 "Offene Sprechstunde"
* #6 "TSS-Routine-Termin"
