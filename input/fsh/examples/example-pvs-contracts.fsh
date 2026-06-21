Instance: example-contract-regime-ebm
InstanceOf: PraxisContractDE
Title: "PVS Contract — EBM"
Description: "Typed Contract example for EBM billing regime resolution."
Usage: #example

* status = #active
* identifier[0].system = "https://fhir.cognovis.de/praxis/sid/pvs-contract-id"
* identifier[0].value = "PVS-REGIME-EBM"
* type = BillingTypeCS#ebm "EBM"

Instance: example-contract-regime-goae
InstanceOf: PraxisContractDE
Title: "PVS Contract — GOÄ"
Description: "Typed Contract example for GOÄ billing regime resolution."
Usage: #example

* status = #active
* identifier[0].system = "https://fhir.cognovis.de/praxis/sid/pvs-contract-id"
* identifier[0].value = "PVS-REGIME-GOAE"
* type = BillingTypeCS#goae "GOÄ"

Instance: example-contract-regime-uv-goae
InstanceOf: PraxisContractDE
Title: "PVS Contract — UV-GOÄ"
Description: "Typed Contract example for UV-GOÄ billing regime resolution."
Usage: #example

* status = #active
* identifier[0].system = "https://fhir.cognovis.de/praxis/sid/pvs-contract-id"
* identifier[0].value = "PVS-REGIME-UV-GOAE"
* type = BillingTypeCS#uv-goae "UV-GOÄ"

Instance: example-contract-regime-hzv
InstanceOf: PraxisContractDE
Title: "PVS Contract — HZV"
Description: "Typed Contract example for HZV billing regime resolution."
Usage: #example

* status = #active
* identifier[0].system = "https://fhir.cognovis.de/praxis/sid/pvs-contract-id"
* identifier[0].value = "PVS-REGIME-HZV"
* type = BillingTypeCS#hzv "HZV"

Instance: example-contract-regime-dmp
InstanceOf: PraxisContractDE
Title: "PVS Contract — DMP"
Description: "Typed Contract example for DMP billing regime resolution."
Usage: #example

* status = #active
* identifier[0].system = "https://fhir.cognovis.de/praxis/sid/pvs-contract-id"
* identifier[0].value = "PVS-REGIME-DMP"
* type = BillingTypeCS#dmp "DMP"
