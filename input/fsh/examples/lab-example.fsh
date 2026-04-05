// Example 1: Observation with dual coding (LDT-Testkennung + LOINC)
Instance: ldt-obs-example-dual-coding
InstanceOf: Observation
Usage: #example
* status = #final
* code.coding[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen"
* code.coding[0].code = #12345678
* code.coding[0].display = "Kreatinin"
* code.coding[1].system = "http://loinc.org"
* code.coding[1].code = #2160-0
* code.coding[1].display = "Creatinine [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/example)
* effectiveDateTime = "2025-07-15"
* valueQuantity.value = 1.1
* valueQuantity.unit = "mg/dL"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mg/dL

// Example 2: ServiceRequest with ldt-auftragsnummer identifier
Instance: ldt-servicerequest-example
InstanceOf: ServiceRequest
Usage: #example
* status = #completed
* intent = #order
* identifier[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-auftragsnummer"
* identifier[0].value = "LAB-2025-00123"
* subject = Reference(Patient/example)
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #2160-0
* code.coding[0].display = "Creatinine panel"
