// ext-tax-exemption-reason — Umsatzsteuerbefreiungsgrund auf Invoice (Root)
// Referenz: UStBefreiungsgrundVS mit Codes nach §4 UStG und §19 UStG (KU-Regelung).
// Context: Invoice (root only — SUSHI v3 limitation; line-level tax tagging via priceComponent.code directly)
// ASCII-safe: keine Umlaute in Kommentaren.

Extension: TaxExemptionReasonExt
Id: ext-tax-exemption-reason
Title: "Umsatzsteuerbefreiungsgrund"
Description: "Gesetzlicher Befreiungsgrund von der Umsatzsteuer nach dem deutschen UStG. Anzuwenden wenn TaxCategory = E (befreit). Gibt den konkreten Paragraphen an (z.B. para4-nr14a fuer Heilbehandlungsleistungen von Aerzten). Binding: UStBefreiungsgrundVS (required). Context: Invoice root only — SUSHI v3 unterstuetzt 'Invoice.lineItem.priceComponent' nicht als Context-Token; line-level Steuer-Tagging erfolgt direkt ueber priceComponent.code."
Context: Invoice
* value[x] only CodeableConcept
* value[x] from UStBefreiungsgrundVS (required)
