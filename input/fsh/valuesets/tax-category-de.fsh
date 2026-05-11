// TaxCategoryDE ValueSet — UNECE Recommendation N20 Steuerkategorien (EN 16931 / ZUGFeRD / XRechnung)
// Migrated from local TaxCategoryCS to external UNECE-5305 URN (fpde-shp.9).
// System: urn:un:unece:uncefact:codelist:standard:5305
// ASCII-safe: keine Umlaute in Kommentaren.

Alias: $UNECE5305 = urn:un:unece:uncefact:codelist:standard:5305

ValueSet: TaxCategoryDE
Id: tax-category-de
Title: "Steuerkategorie DE"
Description: "Steuerkategoriecodes fuer deutsche Rechnungen nach EN 16931, ZUGFeRD und XRechnung. Basiert auf UNECE Recommendation N20 Tax Category Codes (urn:un:unece:uncefact:codelist:standard:5305). Enthaelt alle in der ambulanten Praxis relevanten Steuerkategorien: S (19% Regelsteuersatz), AA (7% ermaessigt), E (steuerbefreit), AE (Reverse Charge), Z (Nullsatz)."
* ^status = #active
* ^experimental = false
// Standard rate — ZUGFeRD BT-151: S (19% oder aktueller Regelsteuersatz)
* $UNECE5305#S "Normaler Steuersatz"
// Reduced rate — ZUGFeRD BT-151: AA (7% ermaessigt, z.B. zahntechnische Leistungen)
* $UNECE5305#AA "Ermaessigter Steuersatz"
// Exempt — ZUGFeRD BT-151: E (steuerbefreit nach §4 UStG oder §19 UStG)
* $UNECE5305#E "Steuerfrei"
// Reverse charge — ZUGFeRD BT-151: AE (§13b UStG)
* $UNECE5305#AE "Umkehrung der Steuerschuldnerschaft"
// Zero rated — ZUGFeRD BT-151: Z (Nullsatz, z.B. innergemeinschaftliche Lieferung)
* $UNECE5305#Z "Nullsatz"
