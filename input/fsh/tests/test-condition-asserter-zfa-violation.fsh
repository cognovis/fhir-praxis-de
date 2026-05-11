// NEGATIVE TEST: asserter ZFA-Verstoss gegen PraxisConditionDE
// Bead: fpde-shp.8 (AC 2)
//
// This file contains instances that intentionally violate the asserter constraint
// defined in PraxisConditionDE:
//   * asserter only Reference(KBV_PR_Base_Practitioner)
//
// A ZFA (Zahnmedizinische Fachangestellte / dental nurse) MUST NOT be the asserter
// of a diagnosis. Only a qualified physician conforming to KBV_PR_Base_Practitioner
// (which requires at minimum an LANR identifier) is permitted.
//
// NEGATIVE TEST: This instance intentionally violates the asserter constraint
// (KBV_PR_Base_Practitioner required). The referenced Practitioner has no LANR
// identifier and therefore does NOT conform to KBV_PR_Base_Practitioner.
// Expected: validator error on asserter reference when validated against
// PraxisConditionDE with targetProfile enforcement.
//
// HOW TO TEST: POST to Aidbox $validate:
//   POST http://localhost:8080/fhir/Bundle/$validate
//   Body: Bundle with type=transaction containing test-zfa-practitioner-no-lanr + test-condition-asserter-zfa
//   Expected: OperationOutcome with issue[0].severity = "error" referencing asserter profileConstraint
//   The KBV_PR_Base_Practitioner profile requires identifier[LANR] — a Practitioner without LANR
//   does NOT conform, so the asserter targetProfile constraint in PraxisConditionDE fails.

// Supporting ZFA Practitioner — no LANR, plain base Practitioner
// This does NOT conform to KBV_PR_Base_Practitioner (no LANR / no qualifying identifier)
Instance: test-zfa-practitioner-no-lanr
InstanceOf: Practitioner
Title: "ZFA ohne LANR (Negativ-Test)"
Description: "ZFA (Zahnmedizinische Fachangestellte) ohne LANR-Identifier. Darf NICHT als asserter in PraxisConditionDE verwendet werden. Dieser Practitioner ist kein KBV_PR_Base_Practitioner-konformer Behandler."
Usage: #inline
* active = true
* name[0].use = #official
* name[0].family = "Braun"
* name[0].given[0] = "Maria"
// No LANR identifier — this Practitioner is a ZFA, not a licensed physician

// Condition with ZFA as asserter — VIOLATES asserter constraint
// NEGATIVE TEST: asserter MUST be Reference(KBV_PR_Base_Practitioner).
// A plain base Practitioner without LANR does NOT satisfy this constraint.
// A validator enforcing targetProfile on asserter MUST flag this as an error.
Instance: test-condition-asserter-zfa
InstanceOf: PraxisConditionDE
Title: "Condition ZFA-Asserter Verstoss (Negativ-Test)"
Description: "NEGATIV-TEST: Diese Condition-Instanz verletzt absichtlich den asserter-Constraint (KBV_PR_Base_Practitioner erforderlich). Die referenzierte ZFA (test-zfa-practitioner-no-lanr) hat keinen LANR-Identifier und entspricht daher NICHT KBV_PR_Base_Practitioner. Erwartetes Validator-Ergebnis: Fehler auf asserter-Referenz."
Usage: #inline
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* code.coding[ICD-10-GM].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding[ICD-10-GM].version = "2024"
* code.coding[ICD-10-GM].code = #K05.3
* code.coding[ICD-10-GM].display = "Chronische Parodontitis"
* subject = Reference(example-patient)
// asserter points to a non-KBV_PR_Base_Practitioner (ZFA, no LANR) — CONSTRAINT VIOLATION
* asserter = Reference(test-zfa-practitioner-no-lanr) "Maria Braun (ZFA)"

// Self-contained test Bundle aggregating ZFA Practitioner + violating Condition
// Usage: #inline — NOT #example, so it is excluded from the IG Publisher QA report
// (we want the validator to flag this as an error, not pollute the QA report with it)
Instance: test-bundle-asserter-zfa
InstanceOf: Bundle
Title: "TEST BUNDLE (NEGATIVE): ZFA als Asserter — erwartet Validator-Fehler"
Usage: #inline
* type = #collection
* entry[0].fullUrl = "urn:uuid:test-zfa-practitioner-no-lanr"
* entry[0].resource = test-zfa-practitioner-no-lanr
* entry[1].fullUrl = "urn:uuid:test-condition-asserter-zfa"
* entry[1].resource = test-condition-asserter-zfa
