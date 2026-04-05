// FPDEPatient — Patient-Profil der deutschen Praxisverwaltung
// AK1: Geburtsname (use=maiden) wird unterstuetzt — name.use akzeptiert #maiden
// AK2: Ortsteil/Stadtteil via iso21090-ADXP-precinct Extension auf address.extension

Profile: FPDEPatient
Parent: Patient
Id: fpde-patient
Title: "FPDE Patient"
Description: "Patient-Profil der deutschen Praxisverwaltung. Unterstützt Geburtsname (use=maiden), Ortsteil/Stadtteil und Stammdaten."
* address.extension contains
    http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-precinct named stadtteil 0..1 MS
