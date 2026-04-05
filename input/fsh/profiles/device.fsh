Profile: PraxisDevice
Parent: Device
Id: praxis-device
Title: "Praxis Device"
Description: "Profil fuer medizinische Geraete und Laboranalyzatoren in der deutschen ambulanten Praxis. Basiert auf GDT 3.5 Geraetedaten (FK 8402 Geraetename, FK 8410 Test-Ident)."

// GDT Geraetekennung (FK 8402) als Identifier-Slice
* identifier MS
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains gdtId 0..1 MS

* identifier[gdtId].system = "https://fhir.cognovis.de/praxis/NamingSystem/gdt-device-id"
* identifier[gdtId].value MS

// Geraetename (FK 8402)
* deviceName MS
* deviceName.name MS
* deviceName.type MS

// Hersteller und Modell
* manufacturer MS
* modelNumber MS

// Softwareversion (falls vorhanden)
* version MS
* version.value MS

// Geraetetyp (SNOMED-CT bevorzugt)
* type MS

// Status
* status MS
