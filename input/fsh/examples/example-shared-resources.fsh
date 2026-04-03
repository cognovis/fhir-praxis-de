// Gemeinsame Basis-Ressourcen fuer alle Beispielszenarien
// Basierend auf realen Seed-Daten aus der Mira-Praxisverwaltung

Instance: example-patient
InstanceOf: Patient
Title: "Thomas Weber — Privatpatient"
Description: "Privatpatient mit Diabetes mellitus Typ 2, Hypercholesterinaemie und Hypertonie."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Weber"
* name[0].given[0] = "Thomas"
* gender = #male
* birthDate = "1975-06-15"

Instance: example-practitioner
InstanceOf: Practitioner
Title: "Dr. Markus Schoell — Hausarzt"
Description: "Niedergelassener Hausarzt, Facharzt fuer Allgemeinmedizin."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Schoell"
* name[0].given[0] = "Markus"
* name[0].prefix[0] = "Dr."

Instance: example-practitioner-wb
InstanceOf: Practitioner
Title: "Dr. Jonas Mueller — WB-Assistent"
Description: "Weiterbildungsassistent in der Hausarztpraxis."
Usage: #example
* active = true
* name[0].use = #official
* name[0].family = "Mueller"
* name[0].given[0] = "Jonas"
* name[0].prefix[0] = "Dr."

Instance: example-organization
InstanceOf: Organization
Title: "Hausarztpraxis Gibitzenhof"
Description: "Hausarztpraxis mit zwei Aerzten und einem WB-Assistenten."
Usage: #example
* active = true
* name = "Hausarztpraxis Dr. Schoell — Gibitzenhof"

Instance: example-observation
InstanceOf: Observation
Title: "HbA1c-Befund Weber"
Description: "HbA1c-Laborwert fuer Patient Weber."
Usage: #example
* status = #final
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #4548-4
* code.coding[0].display = "Hämoglobin A1c/Hämoglobin.gesamt in Blut"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-01-15"
* performer[0] = Reference(example-practitioner)
* valueQuantity.value = 7.2
* valueQuantity.unit = "%"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #%

Instance: example-ai-device
InstanceOf: Device
Title: "Mira AI — Abrechnungsoptimierung"
Description: "KI-System fuer automatisierte Abrechnungsoptimierung und Plausibilitaetspruefung."
Usage: #example
* type.text = "AI Decision Support System"
* manufacturer = "Cognovis GmbH"
* deviceName[0].name = "Mira AI"
* deviceName[0].type = #user-friendly-name

Instance: example-documentreference
InstanceOf: DocumentReference
Title: "Krankenhausbrief Weber"
Description: "Entlassbrief vom Klinikum Nuernberg."
Usage: #example
* status = #current
* type.coding[0].system = "http://loinc.org"
* type.coding[0].code = #18842-5
* type.coding[0].display = "Discharge summary"
* subject = Reference(example-patient)
* content[0].attachment.contentType = #application/pdf
* content[0].attachment.url = "https://example.org/entlassbrief-weber.pdf"
