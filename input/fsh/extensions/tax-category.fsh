// ext-tax-category — Steuerkategorie auf Invoice (Root)
// Basis: EN 16931 BT-151, ZUGFeRD / XRechnung Mapping in steuer-compliance.md
// Context: Invoice (root only — SUSHI v3 limitation; line-level tax tagging via priceComponent.code directly)
// ASCII-safe: keine Umlaute in Kommentaren.

Extension: TaxCategoryExt
Id: ext-tax-category
Title: "Steuerkategorie"
Description: "Steuerkategoriecode nach EN 16931 (ZUGFeRD/XRechnung BT-151). Gibt an, ob die Rechnung mit dem Normal- (S, 19%), ermaessigtem (AA, 7%) oder Nullsteuersatz (E, AE, Z) belegt ist. Binding: TaxCategoryDE ValueSet (required). Context: Invoice root only — SUSHI v3 unterstuetzt 'Invoice.lineItem.priceComponent' nicht als Context-Token; line-level Steuer-Tagging erfolgt direkt ueber priceComponent.code."
Context: Invoice
* value[x] only CodeableConcept
* value[x] from TaxCategoryDE (required)
