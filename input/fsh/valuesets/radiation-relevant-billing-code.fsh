// RadiationRelevantBillingCodeVS — Billing codes triggering radiation dose documentation
// Used by cpw.6 (radiation dose tracking) to identify encounters requiring
// radiation exposure documentation under German Strahlenschutzgesetz (StrlSchG).
//
// Intended scope (full system includes used — no FHIR filter support declared by source CSes):
//   EBM  Chapter 34    — Radiologische Leistungen (diagnostic radiology, codes 34xxx)
//   GOÄ  §§5000-5855   — Strahlendiagnostik und -therapie (private billing)
//   BEMA Chapter 4     — Zahnaerztlich-radiologische Leistungen (dental X-ray, OPG, DVT)
//   GOZ  §§5000-5099   — Zahnaerztliche Roentgenleistungen (private dental radiology)
//
// Binding: extensible — additional radiation billing systems (e.g. DGUV) may be used.
// Note: These systems do not declare FHIR filter support; full system includes are used.
// IMPORTANT: When expanded, these includes return the full referenced code systems.
// Implementers MUST apply scope filters in application logic using the ranges above.

ValueSet: RadiationRelevantBillingCodeVS
Id: radiation-relevant-billing-code
Title: "Radiation Relevant Billing Code"
Description: "Billing codes that trigger radiation dose documentation requirements under the German Strahlenschutzgesetz (StrlSchG). Intended scope: EBM Chapter 34 (codes starting with 34 — radiologische Leistungen), GOÄ §§5000-5855 (Strahlendiagnostik/therapie), BEMA Chapter 4 (dental radiology, OPG, DVT), and GOZ §§5000-5099 (private dental radiology). Full system includes are used because the referenced code systems do not declare FHIR filter support. Used by radiation dose tracking workflows (cpw.6)."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/radiation-relevant-billing-code"
* ^status = #active
* ^experimental = false

// SCOPE: EBM Chapter 34 (Radiologie/Nuklearmedizin) only.
// Filter: codes starting with "34" per KBV EBM chapter numbering.
// TODO: replace with chapter filter once KBV CS declares filter support.
// Full system include used — no filter support declared by KBV_CS_SFHIR_EBM.
* include codes from system https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM

// SCOPE: GOÄ §§5000-5855 (radiological procedures) only.
// Range: 5000-5855 covers Strahlendiagnostik, Nuklearmedizin, MRT, Strahlentherapie
// (PKV private billing for radiation procedures).
// Full system include used — numeric range filters not supported in FSH.
* include codes from system https://fhir.de/CodeSystem/bak/goae

// SCOPE: BEMA Chapter 4 — Zahnaerztlich-radiologische Leistungen only.
// Covers: intraoral X-ray (Ä1), panoramic (OPG), cephalometric, DVT
// (GKV dental radiology — KZBV SFHIR system).
// Full system include used — chapter filter not declared by KBV_CS_SFHIR_BEMA.
* include codes from system https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BEMA

// SCOPE: GOZ §§5000-5099 — Roentgenaufnahmen, DVT (PKV private dental radiology) only.
// Full system include used — numeric range filters not supported in FSH.
* include codes from system https://fhir.de/CodeSystem/bzaek/goz
