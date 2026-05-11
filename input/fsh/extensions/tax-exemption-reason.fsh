// ext-tax-exemption-reason — Umsatzsteuerbefreiungsgrund auf Invoice und Invoice.lineItem.priceComponent
// Referenz: UStBefreiungsgrundVS mit Codes nach §4 UStG und §19 UStG (KU-Regelung).
// ASCII-safe: keine Umlaute in Kommentaren.

Extension: TaxExemptionReasonExt
Id: ext-tax-exemption-reason
Title: "Umsatzsteuerbefreiungsgrund"
Description: "Gesetzlicher Befreiungsgrund von der Umsatzsteuer nach dem deutschen UStG. Anzuwenden wenn TaxCategory = E (befreit). Gibt den konkreten Paragraphen an (z.B. §4 Nr. 14a UStG fuer Heilbehandlungsleistungen von Aerzten). Binding: UStBefreiungsgrundVS (required)."
Context: Invoice
* value[x] only CodeableConcept
* value[x] from UStBefreiungsgrundVS (required)
