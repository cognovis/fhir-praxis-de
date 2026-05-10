// PraxisPatientDE — KBV Inheritance Middle Layer for Patients
// 3-Layer-Chain: KBV_PR_Base_Patient -> PraxisPatientDE -> DentalPatientDE etc.
// Bead: fpde-shp.6

Profile: PraxisPatientDE
Parent: KBV_PR_Base_Patient
Id: praxis-patient-de
Title: "Praxis Patient DE"
Description: "Wrapper-Profil fuer Patienten in der deutschen Praxisverwaltung. Erweitert KBV_PR_Base_Patient fuer die 3-Layer-Chain (KBV -> praxis-de -> Spezial-IG). AI-Provenance-Tracking fuer KI-unterstuetzte Patientendokumentation anwendbar."

// AI Provenance Marker: applicable for AI-assisted patient data entry
* extension contains AiProvenanceApplicableExt named aiProvenanceApplicable 0..1 MS
* extension[aiProvenanceApplicable] ^short = "KI-Provenance anwendbar (EU AI Act)"
* extension[aiProvenanceApplicable] ^definition = "Wenn gesetzt: KI-Provenance via Provenance-Ressource mit AiGeneratedExt, AiProviderExt etc. ist fuer diese Patientendaten dokumentiert."
