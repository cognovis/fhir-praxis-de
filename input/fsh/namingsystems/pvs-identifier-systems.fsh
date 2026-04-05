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

Instance: abrechnr
InstanceOf: NamingSystem
Usage: #definition
* name = "Abrechnr"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "KV-Abrechnungsnummer im Kurzformat (PVS-spezifische Kurzbezeichnung)"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/abrechnr"
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

Instance: bsnr
InstanceOf: NamingSystem
Usage: #definition
* name = "Bsnr"
* status = #draft
* kind = #identifier
* date = "2026-04-03"
* publisher = "cognovis GmbH"
* description = "Betriebsstaettennummer — lokaler Alias fuer http://fhir.de/sid/dkgev/bsnr. Enthaelt Verweis auf die nationale Definition."
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/bsnr"
* uniqueId[0].preferred = true
* uniqueId[1].type = #uri
* uniqueId[1].value = "http://fhir.de/sid/dkgev/bsnr"
* uniqueId[1].preferred = false

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
