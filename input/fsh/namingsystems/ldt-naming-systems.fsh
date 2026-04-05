Instance: ldt-testkennungen
InstanceOf: NamingSystem
Usage: #definition
* name = "LdtTestkennungen"
* status = #draft
* kind = #codesystem
* date = "2026-04-05"
* publisher = "cognovis GmbH"
* description = "LDT-Testkennungen (Labor-Ergebnis-Codes) gemaess LDT-Standard. OID 1.2.276.0.76.4.78 ist die offizielle OID fuer LDT-Testkennungen in Deutschland."
* uniqueId[0].type = #oid
* uniqueId[0].value = "1.2.276.0.76.4.78"
* uniqueId[0].preferred = false
* uniqueId[1].type = #uri
* uniqueId[1].value = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen"
* uniqueId[1].preferred = true

Instance: ldt-auftragsnummer
InstanceOf: NamingSystem
Usage: #definition
* name = "LdtAuftragsnummer"
* status = #draft
* kind = #identifier
* date = "2026-04-05"
* publisher = "cognovis GmbH"
* description = "Laborauftragsnummer gemaess LDT-Standard fuer ServiceRequest.identifier"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-auftragsnummer"
* uniqueId[0].preferred = true
