// PraxisCommunication — Kommunikationseintraege in der ambulanten Praxis
// Notizen, Telefonprotokolle, Kurzmitteilungen, Warnhinweise

Profile: PraxisCommunication
Parent: Communication
Id: praxis-communication
Title: "Praxis Communication"
Description: "Communication-Profil fuer die ambulante Praxis. Bildet Kommunikationseintraege (Notizen, Telefonprotokolle, interne Mitteilungen) im Krankenblatt ab."

// Status: Pflicht
* status 1..1 MS

// Kategorie: Slice fuer praxis-spezifische Kommunikationskategorie
* category MS
* category ^slicing.discriminator.type = #value
* category ^slicing.discriminator.path = "coding.system"
* category ^slicing.rules = #open
* category contains praxis-kategorie 0..1 MS
* category[praxis-kategorie].coding 1..1 MS
* category[praxis-kategorie].coding.system 1..1 MS
* category[praxis-kategorie].coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-communication-category"
* category[praxis-kategorie].coding.code 1..1 MS
* category[praxis-kategorie] from PraxisCommunicationCategoryVS (required)

// Patient: Must-Support
* subject MS
* subject only Reference(Patient)

// Sendedatum: Must-Support
* sent MS

// Inhalt: Must-Support
* payload MS
* payload.content[x] MS
* payload.contentString MS
