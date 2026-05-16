// zanr.fsh
// ZANR NamingSystem: Zahnarzt-Nummer fuer dentale Abrechnungsidentifikatoren
// Sub-NamingSystem for dental tenant extension (dental prep)
// Bead: fpde-e0o

Instance: zanr-identifier
InstanceOf: NamingSystem
Usage: #definition
* name = "ZANR"
* status = #active
* kind = #identifier
* date = "2026-05-16"
* publisher = "cognovis GmbH"
* description = "Zahnarzt-Nummer (ZANR) fuer zahnaerztliche Abrechnungsidentifikatoren. Sub-NamingSystem fuer dental-Tenants."
* uniqueId[+].type = #uri
* uniqueId[=].value = "https://fhir.cognovis.de/praxis/NamingSystem/zanr"
* uniqueId[=].preferred = true
