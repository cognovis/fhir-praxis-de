// PraxisInvoiceDE — Invoice-Profil fuer die deutsche ambulante Praxis
// Steuer-Compliance: Steuerkategorie (EN 16931), KU-Hinweis-Pflicht (§19 UStG).
// FHIRPath-Invariante: ku-hinweis-required erzwingt Invoice.note bei KU-Rechnungen.
// ASCII-safe: keine Umlaute in Kommentaren.

Invariant: ku-hinweis-required
Description: "Bei Rechnungen mit Kleinunternehmerregelung (ku-hinweis-pflicht = true) muss Invoice.note.text vorhanden sein. Der konkrete Inhalt des Pflichthinweises ('gemaess § 19 UStG wird keine Umsatzsteuer berechnet') liegt in der Verantwortung des implementierenden Systems."
Expression: "extension.where(url='https://fhir.cognovis.de/praxis/StructureDefinition/ext-ku-hinweis-pflicht').value.ofType(boolean).first() = true implies note.text.exists()"
Severity: #error

Profile: PraxisInvoiceDE
Parent: Invoice
Id: praxis-invoice-de
Title: "Invoice (Praxis DE)"
Description: "Invoice-Profil fuer die deutsche ambulante Praxis. Stellt Steuer-Compliance sicher: Steuerkategorie nach EN 16931 (ZUGFeRD/XRechnung BT-151), Umsatzsteuerbefreiungsgrund nach UStG, und Pflichthinweis bei Kleinunternehmerregelung (§19 UStG). FHIRPath-Invariante: ku-hinweis-required."

* obeys ku-hinweis-required

// KU-Hinweis Pflicht Extension (Invoice-Ebene)
* extension contains KuHinweisPflichtExt named kuHinweisPflicht 0..1 MS
* extension[kuHinweisPflicht] ^short = "Pflicht-Hinweis Kleinunternehmerregelung (§19 UStG) erforderlich"
* extension[kuHinweisPflicht] ^definition = "Wenn true: Rechnung muss den gesetzlichen Hinweis 'Gemaess §19 UStG wird keine Umsatzsteuer berechnet' in Invoice.note enthalten."

// Steuerkategorie Extension (Invoice-Ebene)
* extension contains TaxCategoryExt named taxCategory 0..1 MS
* extension[taxCategory] ^short = "Steuerkategorie der Rechnung (EN 16931: S/AA/E/AE/Z)"

// Umsatzsteuerbefreiungsgrund Extension (Invoice-Ebene)
* extension contains TaxExemptionReasonExt named taxExemptionReason 0..1 MS
* extension[taxExemptionReason] ^short = "Umsatzsteuerbefreiungsgrund nach UStG (z.B. §4 Nr. 14a, §19)"

// status: Pflichtfeld
* status MS
* status ^short = "Status der Rechnung"

// subject: Pflichtfeld — Patient-Referenz
* subject MS
* subject ^short = "Patient (Pflichtfeld)"

// note: Freitext-Hinweis (Pflicht wenn KU-Hinweis-Extension = true)
* note MS
* note ^short = "Rechnungshinweise (u.a. Pflichthinweis §19 UStG bei KU-Regelung)"
