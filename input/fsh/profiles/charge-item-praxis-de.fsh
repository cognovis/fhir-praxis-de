// ChargeItemPraxisDe — ChargeItem-Profil fuer die deutsche ambulante Praxis
// FHIRPath-Invariante: strahlenrelevante Abrechnungscodes muessen auf RoentgenProcedurePraxisDe verweisen.
// Linkage-Pattern: ChargeItem.service -> RoentgenProcedurePraxisDe (nicht basedOn).
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Invariant: radiation-service-required
Description: "ChargeItem mit Strahlenschutz-relevantem Abrechnungscode muss ChargeItem.service auf eine RoentgenProcedurePraxisDe referenzieren"
Expression: "code.coding.where(memberOf('https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes')).empty() or service.where(resolve() is Procedure).exists()"
Severity: #error

Profile: ChargeItemPraxisDe
Parent: ChargeItem
Id: charge-item-praxis-de
Title: "ChargeItem (Praxis DE)"
Description: "ChargeItem-Profil fuer die deutsche ambulante Praxis. Stellt sicher, dass strahlenrelevante Abrechnungscodes (GOAe/EBM Bildgebung) per ChargeItem.service auf eine RoentgenProcedurePraxisDe-Prozedur verweisen (Strahlenschutz-Compliance gemaess SS85 StrlSchG). FHIRPath-Invariante: radiation-service-required."

* obeys radiation-service-required

// status: Pflichtfeld (von FHIR R4 required)
* status MS
* status ^short = "Status des ChargeItems"

// code: Abrechnungscode (EBM/GOAe/weitere)
* code MS
* code ^short = "Abrechnungscode (EBM, GOAe, etc.)"
* code ^definition = "Abrechnungsziffer des ChargeItems. Wenn der Code in RadiationRelevantBillingCodeVS enthalten ist, ist service (Referenz auf RoentgenProcedurePraxisDe) Pflicht (Invariante radiation-service-required)."

// subject: Patient-Referenz
* subject MS
* subject only Reference(Patient or Group)
* subject ^short = "Patient (Pflichtfeld)"

// service: Referenz auf durchgefuehrte Prozedur (Strahlenschutz-Compliance)
* service MS
* service ^short = "Referenz auf RoentgenProcedurePraxisDe (Pflicht fuer strahlenrelevante Codes)"
* service ^definition = "Referenz auf die durchgefuehrte Roentgen-Prozedur (RoentgenProcedurePraxisDe). Pflichtfeld wenn code einen strahlenrelevanten Abrechnungscode enthaelt (Invariante radiation-service-required)."
