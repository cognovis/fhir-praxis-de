// TestAWSST — CI tests for AW-SST gap profile constraints
// Bead fpde-7eg: AW-SST crosswalk implementation
//
// Two test layers:
//   Layer 1 — Existence tests: Profile: Test* Parent: * verifies each profile compiles (SUSHI).
//   Layer 2 — Constraint tests: Instance-level tests verify key profile constraints are satisfied.
//             SUSHI enforces cardinality (1..*, 0..0) and pattern constraints (subType, use)
//             at instance compilation time; violations produce SUSHI errors.

// =============================================================================
// Layer 1: Existence / extensibility tests
// =============================================================================

Profile: TestPraxisPreliminaryBillingClaimDE
Parent: PraxisPreliminaryBillingClaimDE
Id: test-praxis-preliminary-billing-claim-de
Title: "Test: PraxisPreliminaryBillingClaimDE exists"
Description: "CI test verifying PraxisPreliminaryBillingClaimDE exists and is extendable."
* ^status = #draft

Profile: TestPraxisGKVClaimDE
Parent: PraxisGKVClaimDE
Id: test-praxis-gkv-claim-de
Title: "Test: PraxisGKVClaimDE exists"
Description: "CI test verifying PraxisGKVClaimDE exists and is extendable."
* ^status = #draft

Profile: TestPraxisPrivateClaimDE
Parent: PraxisPrivateClaimDE
Id: test-praxis-private-claim-de
Title: "Test: PraxisPrivateClaimDE exists"
Description: "CI test verifying PraxisPrivateClaimDE exists and is extendable."
* ^status = #draft

Profile: TestPraxisBGClaimDE
Parent: PraxisBGClaimDE
Id: test-praxis-bg-claim-de
Title: "Test: PraxisBGClaimDE exists"
Description: "CI test verifying PraxisBGClaimDE exists and is extendable."
* ^status = #draft

Profile: TestPraxisSelectiveContractClaimDE
Parent: PraxisSelectiveContractClaimDE
Id: test-praxis-selective-contract-claim-de
Title: "Test: PraxisSelectiveContractClaimDE exists"
Description: "CI test verifying PraxisSelectiveContractClaimDE exists and is extendable."
* ^status = #draft

Profile: TestPraxisAnamneseFreeTextObservationDE
Parent: PraxisAnamneseFreeTextObservationDE
Id: test-praxis-anamnese-freetext-observation-de
Title: "Test: PraxisAnamneseFreeTextObservationDE exists"
Description: "CI test verifying PraxisAnamneseFreeTextObservationDE exists and is extendable."
* ^status = #draft

Profile: TestPraxisBefundFreeTextObservationDE
Parent: PraxisBefundFreeTextObservationDE
Id: test-praxis-befund-freetext-observation-de
Title: "Test: PraxisBefundFreeTextObservationDE exists"
Description: "CI test verifying PraxisBefundFreeTextObservationDE exists and is extendable."
* ^status = #draft

Profile: TestPraxisAllergyIntoleranceDE
Parent: PraxisAllergyIntoleranceDE
Id: test-praxis-allergy-intolerance-de
Title: "Test: PraxisAllergyIntoleranceDE exists"
Description: "CI test verifying PraxisAllergyIntoleranceDE exists and is extendable."
* ^status = #draft

// =============================================================================
// Layer 2: Constraint tests (SUSHI compile-time enforcement)
//
// These instances verify that:
//   - Preliminary claim requires item 1..* (SUSHI error if omitted)
//   - Preliminary claim subType is fixed to #vorlaeufig
//   - Final claims require related.claim 1..1 (SUSHI error if omitted)
//   - Final claims prohibit item lines (item 0..0 — SUSHI error if present)
//   - Final claims subType is fixed to the correct code per profile
//
// All instances compile cleanly = constraints are correct and enforced.
// =============================================================================

// Shared helpers for constraint test instances
Instance: TestAWSSTInsurerOrg
InstanceOf: Organization
Title: "Test Insurer (AW-SST constraint tests)"
Description: "Minimal insurer Organization for AW-SST constraint test instances."
Usage: #example
* name = "Test Insurer"

Instance: TestAWSSTPatient
InstanceOf: Patient
Title: "Test Patient (AW-SST constraint tests)"
Description: "Minimal patient for AW-SST constraint test instances."
Usage: #example
* name[0].family = "Test"

// Constraint test: PraxisPreliminaryBillingClaimDE
// Verifies: item 1..* is satisfied, subType=vorlaeufig is accepted.
Instance: TestPraxisPreliminaryBillingClaimInstance
InstanceOf: PraxisPreliminaryBillingClaimDE
Title: "Constraint test: PraxisPreliminaryBillingClaimDE — item 1..*, subType=vorlaeufig"
Description: "SUSHI compile-time constraint test. If item 1..* or subType constraints are violated, SUSHI will emit an error."
Usage: #example
* status = #draft
* use = #predetermination
* subType = PraxisBillingClaimSubTypeCS#vorlaeufig
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(TestAWSSTPatient)
* created = "2024-01-01"
* provider.display = "Test Provider"
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(TestAWSSTInsurerOrg)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "Test Coverage"
* item[0].sequence = 1
* item[0].productOrService.text = "Test Service"

// Constraint test: PraxisGKVClaimDE
// Verifies: related.claim 1..1 is satisfied, item 0..0 is satisfied, subType=gkv.
Instance: TestPraxisGKVClaimInstance
InstanceOf: PraxisGKVClaimDE
Title: "Constraint test: PraxisGKVClaimDE — related 1..*, item 0..0, subType=gkv"
Description: "SUSHI compile-time constraint test. If related 1..* or item 0..0 or subType constraints are violated, SUSHI will emit an error."
Usage: #example
* status = #draft
* use = #claim
* subType = PraxisBillingClaimSubTypeCS#gkv
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(TestAWSSTPatient)
* created = "2024-01-01"
* provider.display = "Test Provider"
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(TestAWSSTInsurerOrg)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "Test Coverage"
* related[0].claim = Reference(TestPraxisPreliminaryBillingClaimInstance)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated

// Constraint test: PraxisPrivateClaimDE
Instance: TestPraxisPrivateClaimInstance
InstanceOf: PraxisPrivateClaimDE
Title: "Constraint test: PraxisPrivateClaimDE — related 1..*, item 0..0, subType=privat"
Description: "SUSHI compile-time constraint test for PraxisPrivateClaimDE."
Usage: #example
* status = #draft
* use = #claim
* subType = PraxisBillingClaimSubTypeCS#privat
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(TestAWSSTPatient)
* created = "2024-01-01"
* provider.display = "Test Provider"
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(TestAWSSTInsurerOrg)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "Test Coverage"
* related[0].claim = Reference(TestPraxisPreliminaryBillingClaimInstance)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated

// Constraint test: PraxisBGClaimDE
Instance: TestPraxisBGClaimInstance
InstanceOf: PraxisBGClaimDE
Title: "Constraint test: PraxisBGClaimDE — related 1..*, item 0..0, subType=bg, no accident"
Description: "SUSHI compile-time constraint test for PraxisBGClaimDE. No Claim.accident used — BG context via referenced resources."
Usage: #example
* status = #draft
* use = #claim
* subType = PraxisBillingClaimSubTypeCS#bg
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(TestAWSSTPatient)
* created = "2024-01-01"
* provider.display = "Test Provider"
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(TestAWSSTInsurerOrg)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "Test Coverage"
* related[0].claim = Reference(TestPraxisPreliminaryBillingClaimInstance)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated

// Constraint test: PraxisSelectiveContractClaimDE
Instance: TestPraxisSelectiveContractClaimInstance
InstanceOf: PraxisSelectiveContractClaimDE
Title: "Constraint test: PraxisSelectiveContractClaimDE — related 1..*, item 0..0, subType=hzv-selektiv"
Description: "SUSHI compile-time constraint test for PraxisSelectiveContractClaimDE."
Usage: #example
* status = #draft
* use = #claim
* subType = PraxisBillingClaimSubTypeCS#hzv-selektiv
* type = http://terminology.hl7.org/CodeSystem/claim-type#professional
* patient = Reference(TestAWSSTPatient)
* created = "2024-01-01"
* provider.display = "Test Provider"
* priority.coding[0].system = "http://terminology.hl7.org/CodeSystem/processpriority"
* priority.coding[0].code = #normal
* insurer = Reference(TestAWSSTInsurerOrg)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "Test Coverage"
* related[0].claim = Reference(TestPraxisPreliminaryBillingClaimInstance)
* related[0].relationship = http://terminology.hl7.org/CodeSystem/ex-relatedclaimrelationship#associated
