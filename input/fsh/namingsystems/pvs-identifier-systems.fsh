Instance: pvs-id
InstanceOf: NamingSystem
Usage: #definition
* name = "PvsId"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "Generischer PVS-interner Identifier fuer Rueckweg-Sync zwischen FHIR-Adapter und dem PVS"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/pvs-id"
* uniqueId[0].preferred = true

Instance: abrechnungsnummer
InstanceOf: NamingSystem
Usage: #definition
* name = "Abrechnungsnummer"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "KV-Abrechnungsnummer des Arztes (vollstaendiges Format)"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/abrechnungsnummer"
* uniqueId[0].preferred = true

Instance: pvs-patient-nummer
InstanceOf: NamingSystem
Usage: #definition
* name = "PvsPatientNummer"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "PVS-interne Patientennummer"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/pvs-patient-nummer"
* uniqueId[0].preferred = true

Instance: zahlung
InstanceOf: NamingSystem
Usage: #definition
* name = "ZahlungsId"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "Zahlungs-ID aus dem PVS"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/zahlung"
* uniqueId[0].preferred = true

Instance: abrechnungsnummer-kurz
InstanceOf: NamingSystem
Usage: #definition
* name = "AbrechnungsnummerKurz"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "KV-Abrechnungsnummer im Kurzformat, falls ein Quellsystem nur eine gekuerzte Darstellung fuehrt"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/abrechnungsnummer-kurz"
* uniqueId[0].preferred = true

Instance: hvg-vertrag
InstanceOf: NamingSystem
Usage: #definition
* name = "HvgVertrag"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "HVG Vertragstyp-Identifier (identifiziert den Vertragstyp)"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/hvg-vertrag"
* uniqueId[0].preferred = true

Instance: hvg-vertrags-id
InstanceOf: NamingSystem
Usage: #definition
* name = "HvgVertragsId"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "Eindeutige ID eines konkreten HVG-Vertrags (Instanz-Identifier)"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/hvg-vertrags-id"
* uniqueId[0].preferred = true

Instance: scheindiagnosen
InstanceOf: NamingSystem
Usage: #definition
* name = "Scheindiagnosen"
* status = #draft
* kind = #identifier
* date = "2026-04-05"
* publisher = "cognovis GmbH"
* description = "Identifier-System fuer Scheindiagnosen (Condition.identifier)"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/scheindiagnosen"
* uniqueId[0].preferred = true

Instance: insurance-plan-id
InstanceOf: NamingSystem
Usage: #definition
* name = "InsurancePlanId"
* status = #draft
* kind = #identifier
* date = "2026-04-05"
* publisher = "cognovis GmbH"
* description = "PVS-interner Identifier fuer InsurancePlan-Ressourcen (Kassentarife, PKV-Tarife)"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/sid/insurance-plan-id"
* uniqueId[0].preferred = true

Instance: hvg-kennung
InstanceOf: NamingSystem
Usage: #definition
* name = "HvgKennung"
* status = #draft
* kind = #identifier
* date = "2026-04-26"
* publisher = "cognovis GmbH"
* description = "HVG-Kennung (2-char Kurzkennung des Selektivvertrags, z.B. 'BY' fuer Bayern). Modelliert als Contract.identifier, nicht als Extension."
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/hvg-kennung"
* uniqueId[0].preferred = true

Instance: schein-nummer
InstanceOf: NamingSystem
Usage: #definition
* name = "ScheinNummer"
* status = #draft
* kind = #identifier
* date = "2026-04-25"
* publisher = "cognovis GmbH"
* description = "PVS-interne Scheinnummer (Encounter.identifier). Eindeutiger Identifier eines Abrechnungsscheins im PVS."
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* uniqueId[0].preferred = true
