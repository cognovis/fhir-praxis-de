// Test: Verifies all 4 PraxisDE wrapper profiles exist and are extendable
// This file will fail sushi compilation until PraxisConditionDE et al. are created.
Profile: TestPraxisConditionDE
Parent: PraxisConditionDE
Id: test-praxis-condition-de
Title: "Test: PraxisConditionDE extends KBV"
Description: "CI test verifying PraxisConditionDE wrapper profile exists."
* ^status = #draft

Profile: TestPraxisPatientDE
Parent: PraxisPatientDE
Id: test-praxis-patient-de
Title: "Test: PraxisPatientDE extends KBV"
Description: "CI test verifying PraxisPatientDE wrapper profile exists."
* ^status = #draft

Profile: TestPraxisPractitionerDE
Parent: PraxisPractitionerDE
Id: test-praxis-practitioner-de
Title: "Test: PraxisPractitionerDE extends KBV"
Description: "CI test verifying PraxisPractitionerDE wrapper profile exists."
* ^status = #draft

Profile: TestPraxisOrganizationDE
Parent: PraxisOrganizationDE
Id: test-praxis-organization-de
Title: "Test: PraxisOrganizationDE extends KBV"
Description: "CI test verifying PraxisOrganizationDE wrapper profile exists."
* ^status = #draft
