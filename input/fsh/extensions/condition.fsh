// Condition / Diagnosis extensions

Extension: DauerdiagnoseExt
Id: dauerdiagnose
Title: "Dauerdiagnose"
Description: "Kennzeichnung einer Dauerdiagnose (chronische Diagnose). Diagnosen mit diesem Flag werden automatisch in Folgequartale uebernommen."
Context: Condition
* value[x] only boolean

Extension: DiagnoseSeiteExt
Id: diagnose-seite
Title: "Diagnoseseite"
Description: "Seitenangabe der Diagnose (links/rechts/beidseitig). Ergaenzt die KBV bodySite-Kodierung."
Context: Condition
* value[x] only CodeableConcept
* valueCodeableConcept from http://hl7.org/fhir/ValueSet/body-site-laterality (extensible)
