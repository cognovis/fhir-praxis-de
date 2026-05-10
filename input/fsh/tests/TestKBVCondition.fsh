// CI test: verifies kbv.basis snapshot generation allows KBV inheritance
// This profile extends KBV_PR_Base_Condition_Diagnosis — only works if
// the generate-kbv-basis-snapshots action has run first.
// Ticket: fpde-shp.5
Profile: TestKBVConditionDE
Parent: KBV_PR_Base_Condition_Diagnosis
Id: test-kbv-condition-de
Title: "Test: KBV Base Condition (fpde-shp.5 CI verification)"
Description: "Temporary test profile verifying KBV_PR_Base_Condition_Diagnosis snapshot availability. Remove when KBV ships snapshots natively."
* ^status = #draft
// No additional constraints -- pure inheritance test
