Instance: example-cid-pvs-ebm-hausbesuch
InstanceOf: PraxisChargeItemDefinitionDE
Title: "PVS ChargeItemDefinition — EBM Hausbesuch Punktwert"
Description: "PVS-importiertes ChargeItemDefinition-Beispiel fuer EBM 01410 mit Punktwert und informativem Steigerungsfaktor-Kontext. Die Regelausfuehrung bleibt ausserhalb der ChargeItemDefinition."
Usage: #example

* url = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/example-cid-pvs-ebm-hausbesuch"
* status = #active
* title = "EBM 01410 — Hausbesuch"
* description = "Katalogeintrag fuer den allgemeinmedizinischen Hausbesuch nach EBM mit Punktwert als standard R4 propertyGroup.priceComponent."
* code.coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM"
* code.coding[0].code = #01410
* code.coding[0].display = "Hausbesuch"
* propertyGroup[0].priceComponent[0].type = #base
* propertyGroup[0].priceComponent[0].code.text = "Punktwert EBM"
* propertyGroup[0].priceComponent[0].factor = 1.0
* propertyGroup[0].priceComponent[0].amount.value = 10.82
* propertyGroup[0].priceComponent[0].amount.currency = #EUR
* propertyGroup[0].priceComponent[1].type = #informational
* propertyGroup[0].priceComponent[1].code.text = "Max. Steigerungsfaktor"
* propertyGroup[0].priceComponent[1].factor = 3.5
