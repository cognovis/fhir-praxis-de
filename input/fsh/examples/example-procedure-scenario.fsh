// Beispielszenarien für ProcedureAmbulantDE

// Szenario 1: Ambulante Koloskopie (OPS 1-650.1)
Instance: example-procedure-koloskopie
InstanceOf: ProcedureAmbulantDE
Title: "Beispiel: Ambulante Koloskopie"
Description: "Diagnostische Koloskopie (OPS 1-650.1) als ambulanter Eingriff."
* status = #completed
* subject = Reference(Patient/example-patient-gkv)
* performedDateTime = "2024-03-15"
* code.coding[ops].system = "http://fhir.de/CodeSystem/bfarm/ops"
* code.coding[ops].version = "2024"
* code.coding[ops].code = #1-650.1
* code.coding[ops].display = "Diagnostische Koloskopie: Total, bis Zökum"

// Szenario 2: Wundversorgung links (mit Seitenlokalisation)
Instance: example-procedure-wundversorgung-links
InstanceOf: ProcedureAmbulantDE
Title: "Beispiel: Wundversorgung links"
Description: "Wundversorgung (OPS 5-916.00) mit Seitenlokalisation links."
* status = #completed
* subject = Reference(Patient/example-patient-gkv)
* performedDateTime = "2024-03-20"
* code.coding[ops].system = "http://fhir.de/CodeSystem/bfarm/ops"
* code.coding[ops].version = "2024"
* code.coding[ops].code = #5-916.00
* code.coding[ops].display = "Wundversorgung: Sekundäre Wundversorgung: Ohne weitere Maßnahmen"
* code.coding[ops].extension[+].url = "http://fhir.de/StructureDefinition/seitenlokalisation"
* code.coding[ops].extension[=].valueCoding.system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_ICD_SEITENLOKALISATION"
* code.coding[ops].extension[=].valueCoding.code = #L
* code.coding[ops].extension[=].valueCoding.display = "Links"
