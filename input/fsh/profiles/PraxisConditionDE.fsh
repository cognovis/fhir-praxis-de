// PraxisConditionDE — KBV Inheritance Middle Layer for Diagnoses
// 3-Layer-Chain: KBV_PR_Base_Condition_Diagnosis -> PraxisConditionDE -> DentalConditionDE etc.
// Bead: fpde-shp.3 (origin) / fpde-shp.6 (asserter targetProfile) / fpde-shp.8 (evidence.detail + documentation)

Profile: PraxisConditionDE
Parent: KBV_PR_Base_Condition_Diagnosis
Id: praxis-condition-de
Title: "Praxis Condition DE"
Description: "Wrapper-Profil fuer Diagnosen in der deutschen Praxisverwaltung. Erweitert KBV_PR_Base_Condition_Diagnosis mit praxis-spezifischen Constraints: Diagnose-Stellung ist Arzt-/Zahnarzt-Vorbehalt (asserter targetProfile), evidence.detail-Verlinkung auf klinische Beobachtungen und Bildgebung. Dient als Parent fuer Spezial-IG-Profile (z.B. DentalConditionDE in fhir-dental-de)."

// =============================================================================
// ASSERTER CONSTRAINT — Design Rationale (Bead fpde-shp.6 / fpde-shp.8)
// =============================================================================
//
// Goal: Enforce that only a qualified physician (Arzt/Zahnarzt) may be the asserter
// of a diagnosis, as required by German law (ZHG § 1 Abs. 5, BAeO § 1 Abs. 5).
// MFA/ZFA may record measurements (recorder) but MUST NOT be listed as asserter.
//
// Design decision: targetProfile restriction (chosen) vs. alternatives:
//
// OPTION A — targetProfile restriction (chosen here):
//   * asserter only Reference(KBV_PR_Base_Practitioner)
//   Pros: declarative, enforced by FHIR validators via targetProfile checking,
//         machine-readable, works with $validate and profile-based tooling.
//   Cons: does NOT enforce LANR presence within the Practitioner — a Practitioner
//         without LANR (e.g. ZFA/MFA) still technically conforms to KBV_PR_Base_Practitioner
//         if no mandatory LANR slice is defined. See note on StructureDefinition-Slicing below.
//
// OPTION B — StructureDefinition-Slicing on asserter.identifier:
//   Slice asserter to require identifier with system = KBV_NS_Base_ANR.
//   Pros: structurally enforces LANR presence at the reference identifier level.
//   Cons: FHIR R4 does not support slicing on Reference.identifier in all validators;
//         requires resolved reference for full validation — not always available;
//         adds significant complexity for marginal gain since KBV_PR_Base_Practitioner
//         already covers the structural contract.
//
// OPTION C — FHIRPath Invariant:
//   Invariant: asserter.reference.resolve().identifier.where(system='...ANR').exists()
//   Pros: can enforce LANR at validation time when reference is resolvable.
//   Cons: resolve() is optional in FHIR R4 validators; not portable across tooling;
//         breaks offline / partial-document validation; overly fragile.
//
// CONCLUSION: targetProfile restriction (Option A) provides the best balance of
// validator support, tooling compatibility, and declarative clarity.
// The LANR expectation is documented here and enforced by convention / downstream
// profiles (e.g. DentalConditionDE from fhir-dental-de may add stricter slicing).
// =============================================================================

// Asserter: Diagnose-Stellung ist Arzt-/Zahnarzt-Vorbehalt (ZHG § 1 Abs. 5, BAeO)
// KBV_PR_Base_Condition_Diagnosis hat asserter als open Reference -- we restrict to Practitioner
* asserter only Reference(KBV_PR_Base_Practitioner)
* asserter MS
* asserter ^short = "Diagnosesteller (Arzt/Zahnarzt-Vorbehalt -- nur qualifizierte Practitioner)"
* asserter ^definition = "Wenn angegeben, MUSS ein qualifizierter Practitioner gemaess KBV_PR_Base_Practitioner referenziert werden (Arzt-/Zahnarzt-Vorbehalt: ZHG § 1 Abs. 5, BAeO). MFA/ZFA duerfen Befunde messen (recorder), aber NICHT als asserter referenziert werden."

// =============================================================================
// EVIDENCE.DETAIL LINKING PATTERN (Bead fpde-shp.8)
// =============================================================================
//
// Condition.evidence.detail links the diagnosis to supporting clinical evidence.
// In FHIR R4, evidence.detail is Reference(Any) — we restrict to the three most
// common evidence types in ambulatory practice:
//
//   - Observation:      lab values (HbA1c, SmokingStatus) or clinical findings
//   - ImagingStudy:     DICOM studies (X-ray, CT, MRT) referenced from a PACS
//   - DiagnosticReport: structured findings report (lab, radiology, pathology)
//
// Linking pattern:
//   evidence[0].detail[0] = Reference(Observation/hba1c-result)   "HbA1c"
//   evidence[0].detail[1] = Reference(ImagingStudy/dvt-knie)      "DVT Knie"
//   evidence[0].detail[2] = Reference(DiagnosticReport/befund)    "PAR-Befund"
//
// Multiple detail entries per evidence element are supported (array).
// Use display text on the Reference for human-readable context (see examples).
// =============================================================================

* evidence MS
* evidence.detail MS
* evidence.detail only Reference(Observation or ImagingStudy or DiagnosticReport)
* evidence.detail ^short = "Klinische Belege (Observation, ImagingStudy, DiagnosticReport)"
* evidence.detail ^definition = "Verweise auf klinische Belege, die die Diagnose stuetzen: Laborwerte (Observation), Bildgebung (ImagingStudy) oder strukturierte Befundberichte (DiagnosticReport). Mehrere Belege pro evidence-Element moeglich."

// AI Provenance Marker: applicable for AI-assisted diagnosis documentation
* extension contains AiProvenanceApplicableExt named aiProvenanceApplicable 0..1 MS
* extension[aiProvenanceApplicable] ^short = "KI-Provenance anwendbar (EU AI Act)"
* extension[aiProvenanceApplicable] ^definition = "Wenn gesetzt: KI-Provenance via Provenance-Ressource mit AiGeneratedExt, AiProviderExt etc. ist fuer diesen Eintrag dokumentiert."
