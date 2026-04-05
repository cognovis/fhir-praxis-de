# KBV Schlüsseltabelle S_KBV_SCHEINART Verification

## Official Source Data

**Table Name:** S_KBV_SCHEINART  
**OID:** 1.2.276.0.76.5.235  
**FHIR Canonical URL:** https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART  
**Current Version:** 1.02 (valid since 01.10.2008)  
**Source:** https://applications.kbv.de/S_KBV_SCHEINART_V1.02.xhtml

## OFFICIAL CODES (from KBV applications.kbv.de)

| Code | Display (Official KBV) |
|------|---------------------------|
| 00   | ambulante Behandlung |
| 0101 | ambulante Behandlung |
| 0102 | Überweisung |
| 0103 | Belegärztliche Behandlung |
| 0104 | Notfall/Vertretung |
| 20   | Selbstausstellung |
| 21   | Auftragsleistungen |
| 23   | Konsiliaruntersuchung |
| 24   | Mit-/Weiterbehandlung |
| 26   | Stationäre Mitbehandlung, Vergütung nach ambulanten Grundsätzen |
| 27   | Überweisungs-/Abrechnungsschein für Laboratoriumsuntersuchungen als Auftragsleistung |
| 28   | Anforderungschein für Laboratoriumsuntersuchungen bei Laborgemeinschaften |
| 30   | Belegärztliche Behandlung |
| 31   | Belegärztliche Mitbehandlung |
| 32   | Urlaubs-/Krankheitsvertretung bei belegärztlicher Behandlung |
| 41   | Ärztlicher Notfalldienst |
| 42   | Urlaubs-/Krankheitsvertretung |
| 43   | Notfall |
| 44   | Notfalldienst mit Taxi |
| 45   | Notarzt-/Rettungswagen |
| 46   | Zentraler Notfalldienst |

## KVDT-SPECIFIC VARIANT: S_VDX_SCHEINUNTERGRUPPE

**Table Name:** S_VDX_SCHEINUNTERGRUPPE  
**OID:** 1.2.276.0.76.3.1.1.5.1.19  
**FHIR Canonical URL:** (not yet mapped to FHIR)  
**Current Version:** 1.01 (valid since 01.10.2008)  
**Source:** https://applications.kbv.de/S_VDX_SCHEINUNTERGRUPPE_V1.01.xhtml  
**Description:** KVDT-specific subset used in KVDT electronic data interchange

### KVDT SUBSET CODES

| Code | Display (with KVDT defaults) |
|------|------------------------------|
| 00   | Ambulante Behandlung (Defaultwert) |
| 20   | Selbstausstellung |
| 21   | Auftragsleistungen (Defaultwert bei Einsendepraxen) |
| 23   | Konsiliaruntersuchung |
| 24   | Mit-/Weiterbehandlung (Defaultwert; außer bei Einsendepraxen) |
| 26   | Stationäre Mitbehandlung, Vergütung nach ambulanten Grundsätzen |
| 27   | Überweisungs-/Abrechnungsschein für Laboratoriumsuntersuchungen als Auftragsleistung |
| 28   | Anforderungschein für Laboratoriumsuntersuchungen bei Laborgemeinschaften |
| 30   | Belegärztliche Behandlung (Defaultwert) |
| 31   | Belegärztliche Mitbehandlung |
| 32   | Urlaubs- bzw. Krankheitsvertretung bei belegärztlicher Behandlung |
| 41   | Ärztlicher Notfalldienst (Defaultwert) |
| 42   | Urlaubs-/bzw. Krankheitsvertretung |
| 43   | Notfall |
| 44   | Notfalldienst mit Taxi |
| 45   | Notarzt-/Rettungswagen (Rettungsdienst) |
| 46   | Zentraler Notfalldienst |

## KEY FINDINGS

### 1. Two Different Tables
- **S_KBV_SCHEINART (OID 1.2.276.0.76.5.235):** Official KBV scheme types including split codes (01xx series)
- **S_VDX_SCHEINUNTERGRUPPE (OID 1.2.276.0.76.3.1.1.5.1.19):** KVDT-specific subset for KVDT data exchange

### 2. Code 00 vs Code 01xx
- **Code 00:** "ambulante Behandlung" (general ambulatory treatment)
- **Code 0101:** "ambulante Behandlung" (same display, but distinct code)
- **Codes 0102-0104:** Specific variants (Überweisung, Belegärztlich, Notfall/Vertretung)

### 3. Your Codebase vs Official Data

**Issue:** Your `scheinuntergruppe.fsh` uses **different codes and displays** than the official S_KBV_SCHEINART:

| Your Code | Your Display | Official Code | Official Display |
|-----------|--------------|---------------|------------------|
| 00 | Behandlungsausweis | 00 | ambulante Behandlung |
| 01 | Überweisungsschein | 0102 | Überweisung |
| 10 | Behandlungsschein ambulante Notfallbehandlung | 0104 | Notfall/Vertretung |
| 21 | Überweisungsschein zur Mitbehandlung | 21 | Auftragsleistungen |
| 22 | Überweisungsschein zur Konsiliaruntersuchung | 23 | Konsiliaruntersuchung |
| 23 | Überweisungsschein zur Auftragsleistung | (missing in 1.02) | - |
| 24 | Überweisungsschein zur Weiterbehandlung | 24 | Mit-/Weiterbehandlung |
| 25 | Überweisungsschein zur Mitbehandlung bei Schwangerschaft | (missing in 1.02) | - |
| 27 | Überweisungsschein Labor | 27 | Überweisungs-/Abrechnungsschein... |
| 28 | Überweisungsschein Pathologie | 28 | Anforderungschein für... |
| 31 | Überweisungsschein zur belegärztlichen Behandlung | 30 | Belegärztliche Behandlung |
| 32 | Belegärztliche Notaufnahme | 32 | Urlaubs-/Krankheitsvertretung... |
| 41 | Notfallschein | 41 | Ärztlicher Notfalldienst |

### 4. Available Formats
- **XML:** https://applications.kbv.de/xml/S_KBV_SCHEINART_V1.02.xml
- **PDF:** https://applications.kbv.de/pdf/S_KBV_SCHEINART_V1.02.pdf
- **FHIR R4 ZIP:** https://applications.kbv.de/fhir4/KBV_CS_SFHIR_KBV_SCHEINART_V1.02.zip
- **FHIR STU3 ZIP:** https://applications.kbv.de/fhir3/74_CS_SFHIR_KBV_SCHEINART_V1.02.zip

## Conclusion

**Code 00:** "ambulante Behandlung" (NOT "Behandlungsausweis")  
**Code 01:** Does NOT exist in KBV 1.02 — the code is split into 0101, 0102, 0103, 0104  
**Code 10:** Does NOT exist in KBV 1.02 — closest is 0104  

Your codes appear to be based on an **older KBV version** or a **KV-specific variant**. Verify against the actual KBV FHIR R4 package to ensure compliance.
