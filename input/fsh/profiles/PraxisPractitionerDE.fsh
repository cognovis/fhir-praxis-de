// PraxisPractitionerDE — KBV Inheritance Middle Layer for Practitioners
// 3-Layer-Chain: KBV_PR_Base_Practitioner -> PraxisPractitionerDE -> DentalPractitionerDE etc.
// Bead: fpde-shp.6

Profile: PraxisPractitionerDE
Parent: KBV_PR_Base_Practitioner
Id: praxis-practitioner-de
Title: "Praxis Practitioner DE"
Description: "Wrapper-Profil fuer Behandler in der deutschen Praxisverwaltung. Erweitert KBV_PR_Base_Practitioner und markiert die Telematik-ID als Must Support (gematik TI-Anforderung). Dient als Parent fuer Spezial-IG-Profile."

// Telematik-ID: KBV has it as optional -- we mark it as Must Support
// KBV slice identifier:Telematik-ID already defined, we only add MS
* identifier[Telematik-ID] MS
* identifier[Telematik-ID] ^short = "Telematik-ID (gematik TI -- Must Support)"
* identifier[Telematik-ID] ^definition = "Telematik-Identifikator gemaess gematik. Must Support in praxis-de: Jeder in der TI registrierte Behandler SOLL eine Telematik-ID fuehren."

// AI Provenance Marker
* extension contains AiProvenanceApplicableExt named aiProvenanceApplicable 0..1 MS
