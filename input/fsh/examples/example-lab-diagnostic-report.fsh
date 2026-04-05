// STUB — example references PraxisLabDiagnosticReport (TDD red phase)

Instance: example-lab-dr-blutbild
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: Blutbild CBC (Einzelbefund)"
Description: "STUB"
Usage: #example
* status = #final
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #58410-2
* subject = Reference(example-patient)
