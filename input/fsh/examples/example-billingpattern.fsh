Instance: example-billingpattern-hausbesuch
InstanceOf: PraxisBillingPattern
Title: "Beispiel BillingPattern Hausbesuch EBM"
Description: "Beispiel-Ziffernkette fuer einen allgemeinmedizinischen Hausbesuch mit ICD-Fokus und zwei Stoppfeldern (Diagnosetext und ICD-Ziffer)."
Usage: #example

* status = #active
* type = http://terminology.hl7.org/CodeSystem/plan-definition-type#order-set
* title = "Hausbesuch — Allgemeinmedizin (EBM)"
* description = "Standardisierte Ziffernkette fuer den allgemeinmedizinischen Hausbesuch gemaess EBM."

// Source-system billing pattern identifier
* identifier[billingPatternId].system = "https://fhir.cognovis.de/praxis/sid/billing-pattern-id"
* identifier[billingPatternId].value = "HB-AM-001"

// useContext: Practitioner-Slice (Fachgruppe Allgemeinmedizin)
* useContext[practitioner].code = http://terminology.hl7.org/CodeSystem/usage-context-type#user
* useContext[practitioner].valueCodeableConcept.coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/kv-fachgruppe"
* useContext[practitioner].valueCodeableConcept.coding[0].code = #allgemeinmedizin
* useContext[practitioner].valueCodeableConcept.coding[0].display = "Allgemeinmedizin"

// useContext: ICD-Focus-Slice (Hausbesuch bei Hypertonie)
* useContext[icdFocus].code = http://terminology.hl7.org/CodeSystem/usage-context-type#focus
* useContext[icdFocus].valueCodeableConcept.coding[0].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* useContext[icdFocus].valueCodeableConcept.coding[0].code = #I10
* useContext[icdFocus].valueCodeableConcept.coding[0].display = "Essentielle (primaere) Hypertonie"

// Stopfield 1: Text — Befundbeschreibung
* extension[stopfield][0].extension[label].valueString = "Befundbeschreibung"
* extension[stopfield][0].extension[type].valueCode = #text
* extension[stopfield][0].extension[required].valueBoolean = false

// Stopfield 2: ICD — Hauptdiagnose
* extension[stopfield][1].extension[label].valueString = "Hauptdiagnose"
* extension[stopfield][1].extension[type].valueCode = #icd
* extension[stopfield][1].extension[required].valueBoolean = true

// Action: Hausbesuch EBM 01410
* action[0].title = "Hausbesuch (EBM 01410)"
* action[0].definitionCanonical = "https://fhir.cognovis.de/praxis/ActivityDefinition/ebm-01410"

// Action: Wegepauschale EBM 01416
* action[1].title = "Wegepauschale (EBM 01416)"
* action[1].definitionCanonical = "https://fhir.cognovis.de/praxis/ActivityDefinition/ebm-01416"
