// TaxCategoryDE ValueSet — EN 16931 / ZUGFeRD / XRechnung Steuerkategorien
// CodeSystem TaxCategoryCS is defined in codesystems/tax-category.fsh (Id: tax-category-de).
// ASCII-safe: keine Umlaute in Kommentaren.

ValueSet: TaxCategoryDE
Id: tax-category-de
Title: "Steuerkategorie DE"
Description: "Steuerkategoriecodes fuer deutsche Rechnungen nach EN 16931, ZUGFeRD und XRechnung. Enthaelt die in der ambulanten Praxis relevanten Steuerkategorien: S (19%), AA (7%), E (befreit) und AE (Reverse Charge)."
* ^status = #active
* ^experimental = false
* include codes from system TaxCategoryCS
