// ext-tax-exemption-reason — Umsatzsteuerbefreiungsgrund auf Invoice und ChargeItemDefinition.propertyGroup.priceComponent
// Referenz: UStBefreiungsgrundVS mit Codes nach §4 UStG und §19 UStG (KU-Regelung).
// ASCII-safe: keine Umlaute in Kommentaren.

Extension: TaxExemptionReasonExt
Id: ext-tax-exemption-reason
Title: "Umsatzsteuerbefreiungsgrund"
Description: "Gesetzlicher Befreiungsgrund von der Umsatzsteuer nach dem deutschen UStG. Anzuwenden wenn TaxCategory = E (befreit). Gibt den konkreten Paragraphen an (z.B. para4-nr14a fuer Heilbehandlungsleistungen von Aerzten). Binding: UStBefreiungsgrundVS (required). Anwendbar auf Invoice (finale Klassifikation) und ChargeItemDefinition.propertyGroup.priceComponent (Vorbelegung im Leistungskatalog, unverbindlich)."
Context: Invoice | ChargeItemDefinition.propertyGroup.priceComponent
* value[x] only CodeableConcept
* value[x] from UStBefreiungsgrundVS (required)
