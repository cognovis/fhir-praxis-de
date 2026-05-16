// PraxisOrganizationDE — KBV Inheritance Middle Layer for Organizations/Practices
// 3-Layer-Chain: KBV_PR_Base_Organization -> PraxisOrganizationDE -> DentalOrganizationDE etc.
// Bead: fpde-shp.6

Profile: PraxisOrganizationDE
Parent: KBV_PR_Base_Organization
Id: praxis-organization-de
Title: "Praxis Organization DE"
Description: "Wrapper-Profil fuer Praxis-Organisationen in der deutschen Praxisverwaltung. Erweitert KBV_PR_Base_Organization mit der Kleinunternehmerregelung § 19 UStG (KleinunternehmerregelungExt). Dient als Parent fuer Spezial-IG-Profile."

// Extensions: Kleinunternehmerregelung § 19 UStG (from fpde-47a), AI Provenance Marker, and Sitz extensions (from fpde-e0o)
* extension contains
    KleinunternehmerregelungExt named kleinunternehmerregelung 0..1 MS and
    AiProvenanceApplicableExt named aiProvenanceApplicable 0..1 MS and
    SitzUmfangExt named sitzUmfang 0..1 MS and
    SitzStatusExt named sitzStatus 0..1 MS and
    VakanzSeitExt named vakanzSeit 0..1 MS and
    VakanzFristExt named vakanzFrist 0..1 MS
* extension[kleinunternehmerregelung] ^short = "Kleinunternehmerregelung § 19 UStG aktiv"
* extension[kleinunternehmerregelung] ^definition = "Wenn aktiv: Praxis faellt unter § 19 UStG-Schwellen (seit 2025: 25.000 EUR Vorjahr / 100.000 EUR laufendes Jahr). Keine USt-Ausweis auf Rechnungen -- Pflichthinweis 'gemaess § 19 UStG wird keine Umsatzsteuer berechnet'. Implementiert fpde-47a (Kleinunternehmerregelung als Praxis-Eigenschaft)."
* extension[aiProvenanceApplicable] ^short = "KI-Provenance anwendbar (EU AI Act)"
* extension[aiProvenanceApplicable] ^definition = "Wenn gesetzt: KI-Provenance via Provenance-Ressource mit AiGeneratedExt, AiProviderExt etc. ist fuer diesen Eintrag dokumentiert."
* extension[sitzUmfang] ^short = "Umfang des KV-Sitzes (0.0-1.0, z.B. 0.5 fuer halben Sitz)"
* extension[sitzStatus] ^short = "Status des KV-Sitzes (aktiv, vakant, ruhend, verkauft)"
* extension[vakanzSeit] ^short = "Datum, ab dem der Sitz vakant ist"
* extension[vakanzFrist] ^short = "Frist fuer Neubesetzung des vakanten Sitzes"
