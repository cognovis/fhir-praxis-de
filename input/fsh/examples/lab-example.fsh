// Example 1: Observation with dual coding (LDT-Testkennung + LOINC)
// Illustrative example: LDT-Testkennung 12345678 maps to LOINC 2160-0 (Kreatinin)
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
* interpretation.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
* interpretation.coding[0].code = #H
* interpretation.coding[0].display = "High"

// Example 2: Observation with ONLY LDT-Testkennung (legacy lab system, no LOINC mapping)
Instance: ldt-obs-example-ldt-only
InstanceOf: Observation
Usage: #example
* status = #final
* code.coding[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen"
* code.coding[0].code = #12345678
* code.coding[0].display = "Kreatinin"
* subject = Reference(Patient/example)
* effectiveDateTime = "2025-07-15"
* valueQuantity.value = 1.1
* valueQuantity.unit = "mg/dL"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mg/dL

// Example 3: Observation with ONLY LOINC (modern lab system, no LDT code)
Instance: ldt-obs-example-loinc-only
InstanceOf: Observation
Usage: #example
* status = #final
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #1234-5
* code.coding[0].display = "Leucocytes [#/volume] in Blood"
* subject = Reference(Patient/example)
* effectiveDateTime = "2025-07-15"
* valueQuantity.value = 6.8
* valueQuantity.unit = "10*9/L"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #10*9/L

// Example 4: ServiceRequest with ldt-auftragsnummer identifier
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
* code.coding[0].display = "Creatinine [Mass/volume] in Serum or Plasma"
