// Procedure-Profil für ambulante Eingriffe (allgemein, nicht-dental)

Profile: ProcedureAmbulantDE
Parent: Procedure
Id: procedure-ambulant-de
Title: "Procedure Ambulant DE"
Description: "Ambulanter Eingriff in der deutschen Praxisverwaltung. Eingriffskodierung per OPS (Operationen- und Prozedurenschlüssel). Verwendet das CodingOPS-Profil aus de.basisprofil.r4, das die Seitenlokalisation als Extension auf der OPS-Coding einschließt."
* status MS
* code MS
* code.coding ^slicing.discriminator.type = #pattern
* code.coding ^slicing.discriminator.path = "system"
* code.coding ^slicing.rules = #open
* code.coding contains ops 0..1 MS
* code.coding[ops] only http://fhir.de/StructureDefinition/CodingOPS
* code.coding[ops].system 1..1
* code.coding[ops].code 1..1
* subject MS
* subject only Reference(Patient)
* performed[x] MS
* bodySite MS
* bodySite ^short = "Detaillierte Körperstelle (ergänzend zur Seitenlokalisation in code.coding[ops])"
