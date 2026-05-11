// ext-tax-category — Steuerkategorie auf Invoice und Invoice.lineItem.priceComponent
// Basis: EN 16931 BT-151, ZUGFeRD / XRechnung Mapping in steuer-compliance.md
// ASCII-safe: keine Umlaute in Kommentaren.

Extension: TaxCategoryExt
Id: ext-tax-category
Title: "Steuerkategorie"
Description: "Steuerkategoriecode nach EN 16931 (ZUGFeRD/XRechnung BT-151). Gibt an, ob der Rechnungsposten mit dem Normal- (S, 19%), ermaessigtem (AA, 7%) oder Nullsteuersatz (E, AE, Z) belegt ist. Binding: TaxCategoryDE ValueSet (required)."
Context: Invoice
* value[x] only CodeableConcept
* value[x] from TaxCategoryDE (required)
