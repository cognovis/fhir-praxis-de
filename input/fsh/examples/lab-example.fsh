// Lab Observation Examples — PraxisLabObservation Profil
// Drei Beispiele: quantitativ (HbA1c), qualitativ (Urin-Streifentest), LDT-only (Custom)

// Example 1: HbA1c quantitativ — LOINC + LDT, interpretation H, mit Referenzbereich
Instance: lab-obs-example-hba1c
InstanceOf: PraxisLabObservation
Title: "Lab Observation: HbA1c (quantitativ)"
Description: "HbA1c-Messung mit LOINC- und LDT-Codierung, Quantitativ in %, Referenzbereich, Interpretation H (High). Probe: EDTA-Blut."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].code = #4548-4
* code.coding[loinc].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* code.coding[ldt].system = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen"
* code.coding[ldt].code = #03034000
* code.coding[ldt].display = "HbA1c"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-05T08:30:00+02:00"
* valueQuantity.value = 6.1
* valueQuantity.unit = "%"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #%
* referenceRange.low.value = 4.0
* referenceRange.low.unit = "%"
* referenceRange.low.system = "http://unitsofmeasure.org"
* referenceRange.low.code = #%
* referenceRange.high.value = 6.0
* referenceRange.high.unit = "%"
* referenceRange.high.system = "http://unitsofmeasure.org"
* referenceRange.high.code = #%
* interpretation.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
* interpretation.coding[0].code = #H
* interpretation.coding[0].display = "High"
* specimen = Reference(example-specimen-blut-edta)

// Example 2: Urin-Streifentest Leukozyten — qualitativ (valueString), LOINC + LDT, interpretation N
Instance: lab-obs-example-leukozyten-urin
InstanceOf: PraxisLabObservation
Title: "Lab Observation: Leukozyten im Urin (Streifentest)"
Description: "Qualitativer Nachweis von Leukozyten im Urin per Streifentest. Ergebnis als Freitext 'negativ', Interpretation N (Normal). Probe: Mittelstrahlurin."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].code = #5799-2
* code.coding[loinc].display = "Leukocytes [Presence] in Urine by Test strip"
* code.coding[ldt].system = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen"
* code.coding[ldt].code = #03059000
* code.coding[ldt].display = "Leukozyten (Urin)"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-05T09:15:00+02:00"
* valueString = "negativ"
* interpretation.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
* interpretation.coding[0].code = #N
* interpretation.coding[0].display = "Normal"
* specimen = Reference(example-specimen-urin-msu)

// Example 3: Praxisspezifischer Schnelltest — LDT-only, valueQuantity mg/dL, interpretation N
Instance: lab-obs-example-ldt-only-custom
InstanceOf: PraxisLabObservation
Title: "Lab Observation: Praxisspezifischer Schnelltest (LDT-only)"
Description: "Praxisspezifischer Schnelltest ohne LOINC-Mapping. Nur LDT-Testkennung vorhanden. Ergebnis quantitativ in mg/dL, Interpretation N (Normal). Keine Probe referenziert."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[ldt].system = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen"
* code.coding[ldt].code = #03302000
* code.coding[ldt].display = "Praxisspezifischer Schnelltest XY"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-05T10:00:00+02:00"
* valueQuantity.value = 42.0
* valueQuantity.unit = "mg/dL"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mg/dL
* referenceRange.low.value = 10.0
* referenceRange.low.unit = "mg/dL"
* referenceRange.low.system = "http://unitsofmeasure.org"
* referenceRange.low.code = #mg/dL
* referenceRange.high.value = 50.0
* referenceRange.high.unit = "mg/dL"
* referenceRange.high.system = "http://unitsofmeasure.org"
* referenceRange.high.code = #mg/dL
* interpretation.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
* interpretation.coding[0].code = #N
* interpretation.coding[0].display = "Normal"

// ServiceRequest example kept for reference (LDT Auftragsnummer)
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
