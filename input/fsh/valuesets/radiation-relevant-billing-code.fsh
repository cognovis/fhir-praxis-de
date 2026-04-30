// RadiationRelevantBillingCodeVS — DEPRECATED
//
// Superseded by:
//   https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes
//   from package: de.cognovis.terminology.imaging 2026.0.0
//
// Migration notes:
//   cpw.6 (radiation dose tracking):
//     BIND to https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes
//     (extensible binding — additional radiation billing systems such as DGUV may be used)
//   cpw.2 (imaging order / Radiologieanforderung):
//     REFERENCE https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes
//     to determine whether an ordered procedure triggers dose documentation
//   cpw.4 (imaging study / ImagingStudy-Profil):
//     REFERENCE https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes
//     when linking billing codes to completed imaging procedures requiring StrlSchG documentation
//
// The external VS covers the same scope:
//   EBM  Chapter 34    — Radiologische Leistungen (34xxx)
//   GOÄ  §§5000-5855   — Strahlendiagnostik und -therapie
//   BEMA Chapter 4     — Zahnaerztlich-radiologische Leistungen (OPG, DVT)
//   GOZ  §§5000-5099   — Zahnaerztliche Roentgenleistungen
//
// Do NOT use this local VS in new profiles. It is retained as a deprecated stub
// for backward compatibility only.

ValueSet: RadiationRelevantBillingCodeVS
Id: radiation-relevant-billing-code
Title: "Radiation Relevant Billing Code (Deprecated)"
Description: "DEPRECATED. Superseded by https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes from de.cognovis.terminology.imaging. cpw.6 (radiation dose tracking) SHOULD bind to the external VS directly. cpw.2 and cpw.4 SHOULD reference the external VS for radiation trigger detection. Billing codes that trigger radiation dose documentation requirements under the German Strahlenschutzgesetz (StrlSchG): EBM Chapter 34 (Radiologie), GOÄ §§5000-5855 (Strahlendiagnostik/therapie), BEMA Chapter 4 (dental radiology, OPG, DVT), and GOZ §§5000-5099 (private dental radiology)."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/radiation-relevant-billing-code"
* ^status = #retired
* ^experimental = false

// cpw.6 consumption note: bind to https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes
// cpw.2 consumption note: reference https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes
// cpw.4 consumption note: reference https://fhir.cognovis.de/imaging/ValueSet/radiation-relevant-billing-codes

// SCOPE: EBM Chapter 34 (Radiologie/Nuklearmedizin) only.
// Filter: codes starting with "34" per KBV EBM chapter numbering.
// Full system include used — no filter support declared by KBV_CS_SFHIR_EBM.
* include codes from system https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM

// SCOPE: GOÄ §§5000-5855 (radiological procedures) only.
// Range: 5000-5855 covers Strahlendiagnostik, Nuklearmedizin, MRT, Strahlentherapie.
// Full system include used — numeric range filters not supported in FSH.
* include codes from system https://fhir.de/CodeSystem/bak/goae

// SCOPE: BEMA Chapter 4 — Zahnaerztlich-radiologische Leistungen only.
// Covers: intraoral X-ray (Ä1), panoramic (OPG), cephalometric, DVT.
// Full system include used — chapter filter not declared by KBV_CS_SFHIR_BEMA.
* include codes from system https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BEMA

// SCOPE: GOZ §§5000-5099 — Roentgenaufnahmen, DVT (PKV private dental radiology) only.
// Full system include used — numeric range filters not supported in FSH.
* include codes from system https://fhir.de/CodeSystem/bzaek/goz
