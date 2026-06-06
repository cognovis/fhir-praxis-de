// HealthcareService scenario — general practice, radiology, psychosomatic basic care, shared location
// Bead: fpde-ir8

Instance: ExampleSharedPracticeLocation
InstanceOf: Location
Title: "Shared practice site — Gibitzenhof"
Description: "Physical practice location shared by general medicine and radiology service offerings at the same organization."
Usage: #example
* status = #active
* name = "Praxis Gibitzenhof — Hauptstandort"
* mode = #instance
* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode"
* type[0].coding[0].code = #PROFF
* type[0].coding[0].display = "Provider's Office"
* address.line[0] = "Gibitzenhofstrasse 12"
* address.city = "Nuernberg"
* address.postalCode = "90459"
* address.country = "DE"
* managingOrganization = Reference(ExamplePraxisOrganizationHs)

Instance: ExamplePraxisOrganizationHs
InstanceOf: PraxisOrganizationDE
Title: "Medizinisches Versorgungszentrum Gibitzenhof"
Description: "Multi-specialty ambulatory organization hosting general medicine and radiology offerings."
Usage: #example
* active = true
* name = "MVZ Gibitzenhof"
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_BSNR"
* identifier[0].value = "987654321"

Instance: ExampleHealthcareServiceGeneral
InstanceOf: PraxisHealthcareServiceDE
Title: "General practice service — Gibitzenhof"
Description: "Primary care / general medicine service offering at the shared Gibitzenhof site."
Usage: #example
* active = true
* identifier[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/service-offering-id"
* identifier[0].value = "hs-general-gibitzenhof"
* name = "Hausarztpraxis Gibitzenhof"
* providedBy = Reference(ExamplePraxisOrganizationHs)
* location[0] = Reference(ExampleSharedPracticeLocation)
* type[0].coding[0] = PraxisHealthcareServiceTypeCS#general-practice
* specialty[0].coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BAR2_WBO"
* specialty[0].coding[0].code = #010
* specialty[0].coding[0].display = "Allgemeinmedizin"

Instance: ExampleHealthcareServiceRadiology
InstanceOf: PraxisHealthcareServiceDE
Title: "Radiology service — Gibitzenhof"
Description: "Radiology and diagnostic imaging service offering co-located at Gibitzenhof."
Usage: #example
* active = true
* identifier[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/service-offering-id"
* identifier[0].value = "hs-radiology-gibitzenhof"
* name = "Radiologie Gibitzenhof"
* providedBy = Reference(ExamplePraxisOrganizationHs)
* location[0] = Reference(ExampleSharedPracticeLocation)
* type[0].coding[0] = PraxisHealthcareServiceTypeCS#radiology
* specialty[0].coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BAR2_WBO"
* specialty[0].coding[0].code = #050
* specialty[0].coding[0].display = "Radiologie"

Instance: ExampleHealthcareServicePsychosomatik
InstanceOf: PraxisHealthcareServiceDE
Title: "Psychosomatic basic care — standalone site"
Description: "Psychosomatische Grundversorgung service offering with KV Genehmigung evidence on the practitioner."
Usage: #example
* active = true
* identifier[0].system = "https://fhir.cognovis.de/praxis/NamingSystem/service-offering-id"
* identifier[0].value = "hs-psychosomatik-nord"
* name = "Psychosomatische Grundversorgung Nord"
* providedBy = Reference(ExamplePraxisOrganizationPsy)
* location[0] = Reference(ExamplePsychosomatikLocation)
* type[0].coding[0] = PraxisHealthcareServiceTypeCS#psychosomatic-basic-care
* specialty[0].coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BAR2_WBO"
* specialty[0].coding[0].code = #080
* specialty[0].coding[0].display = "Psychosomatische Medizin und Psychotherapie"

Instance: ExamplePraxisOrganizationPsy
InstanceOf: PraxisOrganizationDE
Title: "Praxis fuer Psychosomatische Grundversorgung Nord"
Description: "Single-specialty organization for psychosomatic basic care."
Usage: #example
* active = true
* name = "Praxis Psychosomatik Nord"
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_BSNR"
* identifier[0].value = "112233445"

Instance: ExamplePsychosomatikLocation
InstanceOf: Location
Title: "Psychosomatik practice site — Nord"
Description: "Standalone location for psychosomatic basic care offering."
Usage: #example
* status = #active
* name = "Praxis Psychosomatik Nord — Hauptstandort"
* mode = #instance
* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode"
* type[0].coding[0].code = #PROFF
* address.line[0] = "Nordring 8"
* address.city = "Erlangen"
* address.postalCode = "91054"
* address.country = "DE"
* managingOrganization = Reference(ExamplePraxisOrganizationPsy)

Instance: ExamplePractitionerPsychosomatik
InstanceOf: PraxisPractitionerDE
Title: "Dr. Anna Keller — Psychosomatische Medizin"
Description: "Facharzt with qualification and KV Genehmigung for psychosomatische Grundversorgung."
Usage: #example
* active = true
* name[0].family = "Keller"
* name[0].given[0] = "Anna"
* name[0].prefix[0] = "Dr."
* qualification[0].code.coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BAR2_WBO"
* qualification[0].code.coding[0].code = #080
* qualification[0].code.coding[0].display = "Psychosomatische Medizin und Psychotherapie"

Instance: ExampleGenehmigungPsychosomatik
InstanceOf: Basic
Title: "KV Genehmigung Psychosomatische Grundversorgung — Dr. Keller"
Description: "Authorization evidence linked to practitioner; maps to service offering via specialty alignment, not HealthcareService.type."
Usage: #example
* code = BasicResourceTypeCS#genehmigung
* subject = Reference(ExamplePractitionerPsychosomatik)
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/genehmigung-eintrag"
* extension[=].extension[+].url = "leistungsbereich"
* extension[=].extension[=].valueCode = #psychosomatik-grundversorgung
* extension[=].extension[+].url = "genehmigungsdatum"
* extension[=].extension[=].valueDate = "2024-01-15"
* extension[=].extension[+].url = "ablaufdatum"
* extension[=].extension[=].valueDate = "2031-01-14"
* extension[=].extension[+].url = "kvAktenzeichen"
* extension[=].extension[=].valueString = "KVB-2024-PSY-0042"
* extension[+].url = "https://fhir.cognovis.de/praxis/StructureDefinition/genehmigung-typ"
* extension[=].valueCode = #kopfbezogen

Instance: ExamplePractitionerRoleGeneral
InstanceOf: PraxisPractitionerRoleDE
Title: "Hausarzt role linked to general practice HealthcareService"
Description: "PractitionerRole at shared Gibitzenhof location linked to general practice service offering."
Usage: #example
* active = true
* practitioner = Reference(example-practitioner)
* organization = Reference(ExamplePraxisOrganizationHs)
* location[0] = Reference(ExampleSharedPracticeLocation)
* healthcareService[0] = Reference(ExampleHealthcareServiceGeneral)
* code[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
* code[0].coding[0].code = #doctor

Instance: ExamplePractitionerRoleRadiology
InstanceOf: PraxisPractitionerRoleDE
Title: "Radiologist role linked to radiology HealthcareService at shared location"
Description: "Co-located radiology role sharing Location with general practice offering."
Usage: #example
* active = true
* practitioner = Reference(ExamplePractitionerRadiology)
* organization = Reference(ExamplePraxisOrganizationHs)
* location[0] = Reference(ExampleSharedPracticeLocation)
* healthcareService[0] = Reference(ExampleHealthcareServiceRadiology)
* code[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
* code[0].coding[0].code = #doctor

Instance: ExamplePractitionerRadiology
InstanceOf: PraxisPractitionerDE
Title: "Dr. Andrea Fischer — Radiologie"
Description: "Radiologist with BAR2-WBO qualification at shared MVZ site."
Usage: #example
* active = true
* name[0].family = "Fischer"
* name[0].given[0] = "Andrea"
* name[0].prefix[0] = "Dr."
* qualification[0].code.coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BAR2_WBO"
* qualification[0].code.coding[0].code = #050
* qualification[0].code.coding[0].display = "Radiologie"

Instance: ExamplePractitionerRolePsychosomatik
InstanceOf: PraxisPractitionerRoleDE
Title: "Psychosomatik role with Genehmigung-backed service offering"
Description: "Links practitioner qualification, KV Genehmigung evidence, and psychosomatic HealthcareService."
Usage: #example
* active = true
* practitioner = Reference(ExamplePractitionerPsychosomatik)
* organization = Reference(ExamplePraxisOrganizationPsy)
* location[0] = Reference(ExamplePsychosomatikLocation)
* healthcareService[0] = Reference(ExampleHealthcareServicePsychosomatik)
* code[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
* code[0].coding[0].code = #doctor
