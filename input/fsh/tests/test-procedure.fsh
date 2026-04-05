// Test: Ambulante Koloskopie
Instance: test-procedure-koloskopie
InstanceOf: ProcedureAmbulantDE
Title: "Test: Ambulante Koloskopie"
Description: "Testinstanz für ProcedureAmbulantDE — validiert OPS-Kodierung mit Koloskopie."
* status = #completed
* subject = Reference(example-patient)
* code.coding[ops].system = "http://fhir.de/CodeSystem/bfarm/ops"
* code.coding[ops].version = "2024"
* code.coding[ops].code = #1-650.1
* code.coding[ops].display = "Diagnostische Koloskopie: Total, bis Zökum"
