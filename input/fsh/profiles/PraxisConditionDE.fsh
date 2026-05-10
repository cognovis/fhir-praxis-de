// PraxisConditionDE — KBV Inheritance Middle Layer for Diagnoses
// 3-Layer-Chain: KBV_PR_Base_Condition_Diagnosis -> PraxisConditionDE -> DentalConditionDE etc.
// Bead: fpde-shp.6

Profile: PraxisConditionDE
Parent: KBV_PR_Base_Condition_Diagnosis
Id: praxis-condition-de
Title: "Praxis Condition DE"
Description: "Wrapper-Profil fuer Diagnosen in der deutschen Praxisverwaltung. Erweitert KBV_PR_Base_Condition_Diagnosis mit praxis-spezifischen Constraints: Diagnose-Stellung ist Arzt-/Zahnarzt-Vorbehalt (asserter targetProfile). Dient als Parent fuer Spezial-IG-Profile (z.B. DentalConditionDE in fhir-dental-de). Bead: fpde-shp.3 (asserter-Constraint) wird hier implementiert als Mittelschicht-Constraint."

// Asserter: Diagnose-Stellung ist Arzt-/Zahnarzt-Vorbehalt (ZHG § 1 Abs. 5, BAeO)
// KBV_PR_Base_Condition_Diagnosis hat asserter als open Reference -- we restrict to Practitioner
* asserter only Reference(KBV_PR_Base_Practitioner)
* asserter MS
* asserter ^short = "Diagnosesteller (Arzt/Zahnarzt-Vorbehalt -- nur qualifizierte Practitioner)"
* asserter ^definition = "Pflichtfeld bei aerztlicher Diagnose. Nur qualifizierte Practitioner gemaess KBV_PR_Base_Practitioner duerfen als Diagnosesteller fungieren (Arzt-/Zahnarzt-Vorbehalt: ZHG § 1 Abs. 5, BAeO). MFA/ZFA duerfen Befunde messen (recorder), aber nicht als asserter referenziert werden."

// AI Provenance Marker: applicable for AI-assisted diagnosis documentation
* extension contains AiProvenanceApplicableExt named aiProvenanceApplicable 0..1 MS
