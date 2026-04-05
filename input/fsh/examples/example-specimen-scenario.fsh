// Specimen Beispielszenarien — Probenmaterial in der ambulanten Praxis

// Instanz 1: Venaeses Blut (EDTA)
Instance: example-specimen-blut-edta
InstanceOf: PraxisSpecimen
Title: "Specimen: Venaeses Blut (EDTA)"
Description: "EDTA-Blutprobe fuer Haematologie und klinische Chemie."
Usage: #example

* identifier[0].system = "https://labor-beispiel.de/proben-id"
* identifier[0].value = "BL-2026-00147"

* type.coding[snomed].system = "http://snomed.info/sct"
* type.coding[snomed].code = #122555007
* type.coding[snomed].display = "Venous blood specimen"
* type.coding[ldt].system = "https://fhir.cognovis.de/praxis/CodeSystem/ldt-materialbezeichnung"
* type.coding[ldt].code = #EDTA-Blut
* type.coding[ldt].display = "EDTA-Blut"

* subject = Reference(example-patient)

* collection.collectedDateTime = "2026-04-05T08:30:00+02:00"
* collection.method.coding[0].system = "http://snomed.info/sct"
* collection.method.coding[0].code = #28520004
* collection.method.coding[0].display = "Venipuncture"

* container[0].type.coding[0].system = "http://snomed.info/sct"
* container[0].type.coding[0].code = #702281005
* container[0].type.coding[0].display = "EDTA tube"


// Instanz 2: Urin Mittelstrahl
Instance: example-specimen-urin-msu
InstanceOf: PraxisSpecimen
Title: "Specimen: Urin Mittelstrahl"
Description: "Mittelstrahlurin (MSU) fuer Urinalyse und Urinkultur."
Usage: #example

* identifier[0].system = "https://labor-beispiel.de/proben-id"
* identifier[0].value = "UR-2026-00148"

* type.coding[snomed].system = "http://snomed.info/sct"
* type.coding[snomed].code = #122575003
* type.coding[snomed].display = "Urine specimen"

* subject = Reference(example-patient)

* collection.collectedDateTime = "2026-04-05T09:15:00+02:00"
* collection.method.coding[0].system = "http://snomed.info/sct"
* collection.method.coding[0].code = #38034000
* collection.method.coding[0].display = "Midstream clean-catch collection of urine"

* container[0].type.coding[0].system = "http://snomed.info/sct"
* container[0].type.coding[0].code = #706054001
* container[0].type.coding[0].display = "Urine container"


// Instanz 3: Rachenabstrich
Instance: example-specimen-rachenabstrich
InstanceOf: PraxisSpecimen
Title: "Specimen: Rachenabstrich (Mikrobiologie)"
Description: "Rachenabstrich fuer mikrobiologische Diagnostik (z.B. Streptokokken, SARS-CoV-2)."
Usage: #example

// Kein identifier — Labor hat noch keinen Proben-ID vergeben

* type.coding[snomed].system = "http://snomed.info/sct"
* type.coding[snomed].code = #258529004
* type.coding[snomed].display = "Throat swab"

* subject = Reference(example-patient)

* collection.collectedDateTime = "2026-04-05T10:00:00+02:00"
* collection.method.coding[0].system = "http://snomed.info/sct"
* collection.method.coding[0].code = #257261003
* collection.method.coding[0].display = "Swab"
* collection.bodySite.coding[0].system = "http://snomed.info/sct"
* collection.bodySite.coding[0].code = #54066008
* collection.bodySite.coding[0].display = "Pharyngeal structure"
