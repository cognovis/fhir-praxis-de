// ConceptMap: CAVE Clinical Warning Type → SNOMED-CT

Instance: cave-clinical-warning-type-snomed
InstanceOf: ConceptMap
Usage: #definition
Title: "CAVE Clinical Warning Type → SNOMED-CT"
Description: "Mapping der CAVE-Warnhinweistyp-Kuerzel auf SNOMED-CT Konzepte"
* name = "CaveClinicalWarningTypeSnomedCM"
* url = "https://fhir.cognovis.de/praxis/ConceptMap/cave-clinical-warning-type-snomed"
* status = #draft
* experimental = true
* sourceCanonical = Canonical(CaveClinicalWarningTypeVS)
* targetCanonical = "http://snomed.info/sct?fhir_vs"
* group[0].source = Canonical(CaveClinicalWarningTypeCS)
* group[0].target = "http://snomed.info/sct"
* group[0].element[0].code = #K
* group[0].element[0].display = "Kontraindikation"
* group[0].element[0].target[0].code = #103306003
* group[0].element[0].target[0].display = "Contraindication to treatment (finding)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #A
* group[0].element[1].display = "Allergie"
* group[0].element[1].target[0].code = #420134006
* group[0].element[1].target[0].display = "Propensity to adverse reaction (finding)"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[2].code = #V
* group[0].element[2].display = "Vertraeglichkeit"
* group[0].element[2].target[0].code = #418775008
* group[0].element[2].target[0].display = "Finding of tolerance or intolerance to treatment (finding)"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[3].code = #E
* group[0].element[3].display = "Empfehlung"
* group[0].element[3].target[0].code = #737470001
* group[0].element[3].target[0].display = "Clinical decision support intervention (procedure)"
* group[0].element[3].target[0].equivalence = #relatedto
