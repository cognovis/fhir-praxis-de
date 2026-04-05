// Beispiele fuer medizinische Geraete und Laboranalyzatoren
// Basierend auf GDT 3.5 Geraetedaten (FK 8402 Geraetename, FK 8410 Test-Ident)

Instance: example-cobas-6000
InstanceOf: PraxisDevice
Title: "Roche Cobas 6000 — Laboranalyzer"
Description: "Vollautomatischer Laboranalyzer Roche Cobas 6000, Geraetekennung COBAS6000-LAB01 (GDT FK 8402)."
Usage: #example
* status = #active
* identifier[gdtId].system = "https://fhir.cognovis.de/praxis/NamingSystem/gdt-device-id"
* identifier[gdtId].value = "COBAS6000-LAB01"
* deviceName[0].name = "Cobas 6000"
* deviceName[0].type = #manufacturer-name
* manufacturer = "Roche Diagnostics GmbH"
* modelNumber = "Cobas 6000"
* version[0].value = "3.5.1"
* type = http://snomed.info/sct#706689003 "Analysegeraet fuer klinische Diagnostik"

Instance: example-schiller-at102
InstanceOf: PraxisDevice
Title: "Schiller AT-102 — EKG-Geraet"
Description: "EKG-Geraet Schiller AT-102 mit minimalen Pflichtfeldern."
Usage: #example
* status = #active
* identifier[gdtId].system = "https://fhir.cognovis.de/praxis/NamingSystem/gdt-device-id"
* identifier[gdtId].value = "AT102-PRAXIS01"
* deviceName[0].name = "AT-102"
* deviceName[0].type = #manufacturer-name
