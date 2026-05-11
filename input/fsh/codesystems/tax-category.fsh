// TaxCategoryCS — EN 16931 / ZUGFeRD / XRechnung Steuerkategoriecodes
// Moved from valuesets/tax-category-de.fsh (fpde-shp.7 refactor).
// ASCII-safe: keine Umlaute in Kommentaren.

CodeSystem: TaxCategoryCS
Id: tax-category-de
Title: "Steuerkategorie (EN 16931)"
Description: "Steuerkategoriecodes nach EN 16931 (europaeische Norm fuer elektronische Rechnungsstellung). Wird in ZUGFeRD und XRechnung als BT-151 'Steuerkategoriecode des Verkaeufers' verwendet. Kuerzel: S = Standard, AA = Ermaessigt, E = Befreit, AE = Umkehrung der Steuerschuldnerschaft (Reverse Charge), Z = Nullsatz."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
// Standard rate — ZUGFeRD: S (19% oder aktueller Regelsteuersatz)
* #S "Normaler Steuersatz" "Normaler Umsatzsteuersatz (derzeit 19%). ZUGFeRD/XRechnung: CategoryCode S, TaxPercent 19.00"
// Reduced rate — ZUGFeRD: AA (7% ermaessigt)
* #AA "Ermaessigter Steuersatz" "Ermaessigter Umsatzsteuersatz (derzeit 7%). ZUGFeRD/XRechnung: CategoryCode AA, TaxPercent 7.00"
// Exempt — ZUGFeRD: E (steuerbefreit nach §4 UStG oder §19 UStG)
* #E "Steuerfrei" "Steuerbefreit (z.B. Heilbehandlungen nach §4 Nr.14 UStG oder Kleinunternehmer §19 UStG). ZUGFeRD/XRechnung: CategoryCode E, TaxPercent 0.00"
// Reverse charge — ZUGFeRD: AE
* #AE "Umkehrung der Steuerschuldnerschaft" "Reverse Charge — Steuerschuldnerschaft geht auf den Leistungsempfaenger ueber (§13b UStG). ZUGFeRD/XRechnung: CategoryCode AE"
// Zero rated — ZUGFeRD: Z (Nullsatz, z.B. innergemeinschaftliche Lieferung)
* #Z "Nullsatz" "Nullsatz — steuerbar aber mit 0% belastet (z.B. innergemeinschaftliche Lieferungen). ZUGFeRD/XRechnung: CategoryCode Z, TaxPercent 0.00"
