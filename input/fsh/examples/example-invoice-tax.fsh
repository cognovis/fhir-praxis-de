// Invoice-Beispiele fuer verschiedene Steuerszenarien in der ambulanten Praxis
// 1. Zahnarzt-Rechnung steuerbefreit nach §4 Nr. 14a UStG (Kategorie E)
// 2. Rechnung mit normalem Steuersatz 19% (Kategorie S)
// 3. Rechnung mit ermaessigtem Steuersatz 7% (Kategorie AA) — zahntechnische Leistung
// 4. Kleinunternehmer-Rechnung mit Pflichthinweis (§19 UStG, Kategorie E)
// ASCII-safe: keine Umlaute in Kommentaren.

// --- Beispiel 1: Zahnarzt — steuerbefreit §4 Nr. 14a UStG ---

Instance: example-invoice-zahnaerzte-exempt
InstanceOf: PraxisInvoiceDE
Title: "Beispiel Invoice — Zahnarzt §4 Nr. 14a UStG (steuerbefreit)"
Description: "Zahnarztrechnung fuer eine Heilbehandlungsleistung, steuerbefreit nach §4 Nr. 14a UStG. Steuerkategorie E (befreit), Befreiungsgrund para4-nr14a."
Usage: #example

* extension[taxCategory].valueCodeableConcept = TaxCategoryCS#E "Steuerfrei"
* extension[taxExemptionReason].valueCodeableConcept = UStBefreiungsgrundCS#para4-nr14a "§ 4 Nr. 14a UStG"
* status = #issued
* subject = Reference(Patient/example-patient)
* date = "2026-05-11"
* issuer = Reference(Organization/example-zahnarzt-praxis)
* totalGross.value = 120.00
* totalGross.currency = #EUR
* lineItem[0].chargeItemCodeableConcept = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#OTH "Other"
* lineItem[0].chargeItemCodeableConcept.text = "Zahnaerztliche Behandlung BEMA §4 Nr.14a"
* lineItem[0].priceComponent[0].type = #base
* lineItem[0].priceComponent[0].amount.value = 120.00
* lineItem[0].priceComponent[0].amount.currency = #EUR

// --- Beispiel 2: Rechnung 19% (Kategorie S) ---

Instance: example-invoice-19percent
InstanceOf: PraxisInvoiceDE
Title: "Beispiel Invoice — IGeL 19% Umsatzsteuer (Kategorie S)"
Description: "IGeL-Rechnung (z.B. Reisemedizinische Beratung ohne GKV-Indikation) mit normalem Umsatzsteuersatz 19% (Steuerkategorie S). Nicht steuerbefreit da keine Heilbehandlung im umsatzsteuerlichen Sinne."
Usage: #example

* extension[taxCategory].valueCodeableConcept = TaxCategoryCS#S "Normaler Steuersatz"
* status = #issued
* subject = Reference(Patient/example-patient)
* date = "2026-05-11"
* issuer = Reference(Organization/example-praxis)
* totalNet.value = 100.84
* totalNet.currency = #EUR
* totalGross.value = 120.00
* totalGross.currency = #EUR
* lineItem[0].chargeItemCodeableConcept = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#OTH "Other"
* lineItem[0].chargeItemCodeableConcept.text = "Reisemedizinische Beratung (IGeL)"
* lineItem[0].priceComponent[0].type = #base
* lineItem[0].priceComponent[0].amount.value = 100.84
* lineItem[0].priceComponent[0].amount.currency = #EUR
* lineItem[0].priceComponent[1].type = #tax
* lineItem[0].priceComponent[1].factor = 0.19
* lineItem[0].priceComponent[1].amount.value = 19.16
* lineItem[0].priceComponent[1].amount.currency = #EUR

// --- Beispiel 3: Rechnung 7% ermaessigter Steuersatz (Kategorie AA) ---
// Zahntechnische Laborleistungen koennen dem ermaessigten Steuersatz unterliegen.

Instance: example-invoice-7percent
InstanceOf: PraxisInvoiceDE
Title: "Beispiel Invoice — 7% ermaessigter Steuersatz (Kategorie AA)"
Description: "Rechnung fuer eine zahntechnische Laborleistung mit ermaessigtem Umsatzsteuersatz 7% (Steuerkategorie AA). ZUGFeRD/XRechnung: CategoryCode AA, TaxPercent 7.00."
Usage: #example

* extension[taxCategory].valueCodeableConcept = TaxCategoryCS#AA "Ermaessigter Steuersatz"
* status = #issued
* subject = Reference(Patient/example-patient)
* date = "2026-05-11"
* issuer = Reference(Organization/example-zahnarzt-praxis)
* totalNet.value = 93.46
* totalNet.currency = #EUR
* totalGross.value = 100.00
* totalGross.currency = #EUR
* lineItem[0].chargeItemCodeableConcept = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#OTH "Other"
* lineItem[0].chargeItemCodeableConcept.text = "Zahntechnische Laborleistung (7% USt)"
* lineItem[0].priceComponent[0].type = #base
* lineItem[0].priceComponent[0].amount.value = 93.46
* lineItem[0].priceComponent[0].amount.currency = #EUR
* lineItem[0].priceComponent[1].type = #tax
* lineItem[0].priceComponent[1].factor = 0.07
* lineItem[0].priceComponent[1].amount.value = 6.54
* lineItem[0].priceComponent[1].amount.currency = #EUR

// --- Beispiel 4: Kleinunternehmer-Rechnung (§19 UStG) ---

Instance: example-invoice-kleinunternehmer
InstanceOf: PraxisInvoiceDE
Title: "Beispiel Invoice — Kleinunternehmerregelung §19 UStG"
Description: "Rechnung einer Praxis unter der Kleinunternehmerregelung nach §19 UStG. ku-hinweis-pflicht = true erzwingt den gesetzlichen Pflichthinweis in Invoice.note. Steuerkategorie E, Befreiungsgrund kleinunternehmer-para19."
Usage: #example

* extension[kuHinweisPflicht].valueBoolean = true
* extension[taxCategory].valueCodeableConcept = TaxCategoryCS#E "Steuerfrei"
* extension[taxExemptionReason].valueCodeableConcept = UStBefreiungsgrundCS#kleinunternehmer-para19 "Kleinunternehmerregelung § 19 UStG"
* status = #issued
* subject = Reference(Patient/example-patient)
* date = "2026-05-11"
* issuer = Reference(Organization/example-zahnarzt-praxis)
* totalGross.value = 80.00
* totalGross.currency = #EUR
// Pflichthinweis nach §19 UStG in note (erzwungen durch ku-hinweis-required Invariante)
* note[0].text = "Gemaess § 19 UStG wird keine Umsatzsteuer berechnet."
* lineItem[0].chargeItemCodeableConcept = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#OTH "Other"
* lineItem[0].chargeItemCodeableConcept.text = "Aerztliche Leistung (Kleinunternehmer)"
* lineItem[0].priceComponent[0].type = #base
* lineItem[0].priceComponent[0].amount.value = 80.00
* lineItem[0].priceComponent[0].amount.currency = #EUR
