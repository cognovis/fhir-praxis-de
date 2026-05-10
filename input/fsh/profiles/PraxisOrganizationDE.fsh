// PraxisOrganizationDE — KBV Inheritance Middle Layer for Organizations/Practices
// 3-Layer-Chain: KBV_PR_Base_Organization -> PraxisOrganizationDE -> DentalOrganizationDE etc.
// Bead: fpde-shp.6

Profile: PraxisOrganizationDE
Parent: KBV_PR_Base_Organization
Id: praxis-organization-de
Title: "Praxis Organization DE"
Description: "Wrapper-Profil fuer Praxis-Organisationen in der deutschen Praxisverwaltung. Erweitert KBV_PR_Base_Organization mit der Kleinunternehmerregelung § 19 UStG (KleinunternehmerregelungExt). Dient als Parent fuer Spezial-IG-Profile."

// Kleinunternehmerregelung § 19 UStG (from fpde-47a)
* extension contains KleinunternehmerregelungExt named kleinunternehmerregelung 0..1 MS
* extension[kleinunternehmerregelung] ^short = "Kleinunternehmerregelung § 19 UStG aktiv"
* extension[kleinunternehmerregelung] ^definition = "Wenn aktiv: Praxis faellt unter § 19 UStG-Schwellen (seit 2025: 25.000 EUR Vorjahr / 100.000 EUR laufendes Jahr). Keine USt-Ausweis auf Rechnungen -- Pflichthinweis 'gemaess § 19 UStG wird keine Umsatzsteuer berechnet'. Implementiert fpde-47a (Kleinunternehmerregelung als Praxis-Eigenschaft)."

// AI Provenance Marker
* extension contains AiProvenanceApplicableExt named aiProvenanceApplicable 0..1 MS
