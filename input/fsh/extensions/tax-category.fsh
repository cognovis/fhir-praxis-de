// ext-tax-category — Steuerkategorie auf Invoice und ChargeItemDefinition.propertyGroup.priceComponent
// Basis: EN 16931 BT-151, ZUGFeRD / XRechnung Mapping in steuer-compliance.md
// Codes nach UNECE Recommendation N20 (urn:un:unece:uncefact:codelist:standard:5305)
// ASCII-safe: keine Umlaute in Kommentaren.

Extension: TaxCategoryExt
Id: ext-tax-category
Title: "Steuerkategorie"
Description: "Steuerkategoriecode nach EN 16931 und UNECE-5305 (ZUGFeRD/XRechnung BT-151). Gibt an, ob die Leistung mit dem Normal- (S, 19%), ermaessigtem (AA, 7%) oder Nullsteuersatz (E, AE, Z) belegt ist. Binding: TaxCategoryDE ValueSet (required). Anwendbar auf Invoice (finale Klassifikation) und ChargeItemDefinition.propertyGroup.priceComponent (Vorbelegung im Leistungskatalog, unverbindlich)."
Context: Invoice | ChargeItemDefinition.propertyGroup.priceComponent
* value[x] only CodeableConcept
* value[x] from TaxCategoryDE (required)
