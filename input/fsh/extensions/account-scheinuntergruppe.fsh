// Scheinuntergruppe (KVDT FK 4239) is carried as a coded Account extension, not a
// second type.coding, because the live source domain spans two code systems.
// Canonical KBV values remain allowed via the extensible binding, and cognovis
// semantic values use https://fhir.cognovis.de/praxis/CodeSystem/schein-untergruppe.
// Scheinuntergruppe values are not billing-load-bearing.

Extension: AccountScheinuntergruppeExt
Id: account-scheinuntergruppe
Title: "Scheinuntergruppe"
Description: "Scheinuntergruppe (KVDT FK 4239) of the billing case. KBV-conformant codes remain allowed through the extensible binding, and cognovis semantic codes use https://fhir.cognovis.de/praxis/CodeSystem/schein-untergruppe. Source: Schein.Scheinuntergruppe."
Context: Account
* value[x] only CodeableConcept
* value[x] from https://fhir.cognovis.de/praxis/ValueSet/schein-untergruppe (extensible)
