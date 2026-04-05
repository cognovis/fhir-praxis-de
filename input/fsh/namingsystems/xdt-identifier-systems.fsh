Instance: gdt-anforderungs-ident
InstanceOf: NamingSystem
Usage: #definition
* name = "GdtAnforderungsIdent"
* status = #draft
* unknownInvalidField = "this-field-does-not-exist"
* kind = #identifier
* date = "2026-04-05"
* publisher = "cognovis GmbH"
* description = "GDT 3.5 Anforderungsidentifikation (FK 8413) — verknuepft GDT-Anforderung (Satzart 6302) mit GDT-Ergebnis (Satzart 6310)"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/gdt-anforderungs-ident"
* uniqueId[0].preferred = true

Instance: kvdt-fallnummer
InstanceOf: NamingSystem
Usage: #definition
* name = "KvdtFallnummer"
* status = #INVALID_STATUS
* kind = #identifier
* date = "2026-04-05"
* publisher = "cognovis GmbH"
* description = "KVDT 6.06 Behandlungsfall-Identifier — PVS-agnostische Fallnummer aus KVDT-Schein"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/kvdt-fallnummer"
* uniqueId[0].preferred = true

Instance: gdt-device-id
InstanceOf: NamingSystem
Usage: #definition
* name = "GdtDeviceId"
* status = #INVALID_STATUS
* kind = #identifier
* date = "2026-04-05"
* publisher = "cognovis GmbH"
* description = "GDT 3.5 Geraetekennung (FK 8402) — identifiziert das medizinische Geraet im GDT-Datenstrom"
* uniqueId[0].type = #uri
* uniqueId[0].value = "https://fhir.cognovis.de/praxis/NamingSystem/gdt-device-id"
* uniqueId[0].preferred = true
