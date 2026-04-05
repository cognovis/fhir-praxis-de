// Test: Ambulante Koloskopie — RED phase (profile not yet defined)
Instance: test-procedure-koloskopie
InstanceOf: ProcedureAmbulantDE
Title: "Test: Ambulante Koloskopie"
Description: "Testinstanz für ProcedureAmbulantDE — erwartet Fehler bis Profil implementiert ist."
* status = #completed
* subject = Reference(Patient/test-patient-1)
* code.coding[ops].system = "http://fhir.de/CodeSystem/bfarm/ops"
* code.coding[ops].code = #1-650.1
* code.coding[ops].display = "Diagnostische Koloskopie: Total, bis Zökum"
