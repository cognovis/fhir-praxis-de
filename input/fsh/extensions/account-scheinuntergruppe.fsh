// Scheinuntergruppe (KVDT FK 4239) — finer classification of the Schein, below Scheinart.
// Carried as a coded Account extension (not a second type.coding) because the live
// x.isynet domain spans TWO code systems: the canonical KBV Schluesseltabelle plus
// proprietary x.isynet values (e.g. 90 on PKV-Scheinart 5, 501/502 on HZV-Scheinart 50).
// Binding is therefore EXTENSIBLE to the KBV ValueSet: KBV codes carry canonical
// displays; proprietary codes are permitted with the cognovis system. The KBV ValueSet
// ships via the de.cognovis.terminology.kbv dependency (no local mirror).
// Note: proprietary Scheinuntergruppe values are NOT billing-load-bearing — HZV coding
// keys on Scheinart=50 + HVGVertrag, never on Scheinuntergruppe.

Extension: AccountScheinuntergruppeExt
Id: account-scheinuntergruppe
Title: "Scheinuntergruppe"
Description: "Scheinuntergruppe (KVDT FK 4239) des Abrechnungsfalls. KBV-konforme Codes (S_KBV_SCHEINART) ergänzt um x.isynet-proprietäre Werte. Quelle: Schein.Scheinuntergruppe."
Context: Account
* value[x] only CodeableConcept
* value[x] from https://fhir.kbv.de/ValueSet/KBV_VS_SFHIR_KBV_SCHEINART (extensible)
