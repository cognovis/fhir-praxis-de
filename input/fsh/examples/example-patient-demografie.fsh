// Demografie-Beispiele: Geburtsname, Ortsteil, Adresszusaetze
// AK1: Geburtsname mit use=maiden und humanname-own-name Extension (de.basisprofil.r4)
// AK2: Ortsteil/Stadtteil mit iso21090-ADXP-precinct Extension auf Address.extension

Instance: example-patient-geburtsname
InstanceOf: FPDEPatient
Title: "Anna Mueller geb. Schmidt — Patient mit Geburtsnamen"
Description: "Patientenprofil mit offiziellem Namen und Geburtsnamen (use=maiden), demonstriert humanname-own-name Extension aus de.basisprofil.r4."
Usage: #example
* name[0].use = #official
* name[0].family = "Mueller"
* name[0].given[0] = "Anna"
* name[1].use = #maiden
* name[1].family = "Schmidt"
* name[1].family.extension[0].url = "http://hl7.org/fhir/StructureDefinition/humanname-own-name"
* name[1].family.extension[0].valueString = "Schmidt"
* birthDate = "1985-04-22"

Instance: example-patient-ohne-geburtsname
InstanceOf: FPDEPatient
Title: "Thomas Bauer — Patient ohne Geburtsnamen"
Description: "Patientenprofil ohne Geburtsnamen (Validierung muss weiterhin erfolgreich sein)."
Usage: #example
* name[0].use = #official
* name[0].family = "Bauer"
* name[0].given[0] = "Thomas"
* birthDate = "1970-11-05"

Instance: example-patient-ortsteil
InstanceOf: FPDEPatient
Title: "Maria Gonzalez — Patient mit Ortsteil/Stadtteil in Adresse"
Description: "Patientenprofil mit Stadtteil-Extension (iso21090-ADXP-precinct) auf Address.extension, wie in AddressDeBasis vorgesehen."
Usage: #example
* name[0].use = #official
* name[0].family = "Gonzalez"
* name[0].given[0] = "Maria"
* birthDate = "1992-08-14"
* address[0].line[0] = "Oranienstrasse 42"
* address[0].city = "Berlin"
* address[0].postalCode = "10999"
* address[0].country = "DE"
* address[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-precinct"
* address[0].extension[0].valueString = "Kreuzberg"
