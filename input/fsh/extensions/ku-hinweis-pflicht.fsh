// ext-ku-hinweis-pflicht — Pflicht-Hinweis Kleinunternehmerregelung auf Invoice
// Wenn true: Invoice.note muss den Pflichthinweis nach §19 UStG enthalten.
// ASCII-safe: keine Umlaute in Kommentaren.

Extension: KuHinweisPflichtExt
Id: ext-ku-hinweis-pflicht
Title: "KU-Hinweis Pflicht"
Description: "Kennzeichen dass auf dieser Rechnung der gesetzliche Pflichthinweis zur Kleinunternehmerregelung nach §19 UStG enthalten sein muss ('Gemaess §19 UStG wird keine Umsatzsteuer berechnet'). Wenn true, erzwingt die Invariante ku-hinweis-required im PraxisInvoiceDE-Profil das Vorhandensein von Invoice.note."
Context: Invoice
* value[x] only boolean
