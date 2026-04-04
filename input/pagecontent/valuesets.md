# Value Sets

This IG defines ValueSets that group codes for use in extension bindings. Each ValueSet includes all codes from its corresponding custom CodeSystem.

## Custom ValueSets

### BillingTypeVS — Abrechnungsart

Alle zulässigen Abrechnungsarten in der ambulanten Versorgung.

- **Includes:** All codes from [BillingTypeCS](CodeSystem-billing-type.html)
- **Binding:** Used by `BillingSystemExt`, `BillingCategoryExt`
- **Usage:** Identifies whether a charge item is billed under EBM, GOÄ, BG, IGeL, etc.

### BehandlerRolleVS — Behandler-Rolle

Rollen der Mitglieder in einem Behandler-Team in der deutschen ambulanten Versorgung.

- **Includes:** All codes from [BehandlerRolleCS](CodeSystem-behandler-rolle.html)
- **Binding:** Used by `CareTeamDE.participant[behandler].role` (required)
- **Usage:** Identifies the clinical role of each team participant (Zahnarzt, Arzt, ZFA, MFA, WB-Assistent, Physiotherapeut)

### ScheinartVS — Scheinart

Abrechnungsschein-Typen in der ambulanten Versorgung.

- **Includes:** All codes from [ScheinartCS](CodeSystem-scheinart.html)
- **Binding:** Used by `ScheintypExt` on Encounter
- **Usage:** Classifies encounters by billing type (GKV, PKV, BG, Überweisung, Notfall, IGeL)

### DiagnoseSeiteVS — Diagnoseseite

Seitenangabe für Diagnosen (Lateralität).

- **Includes:** All codes from [DiagnoseSeiteCS](CodeSystem-diagnose-seite.html)
- **Binding:** Used by `DiagnoseSeiteExt` on Condition
- **Usage:** Supplements ICD-10-GM coding with laterality (Links, Rechts, Beidseitig)

### GenehmigungenLeistungsbereichVS — Genehmigung Leistungsbereich

KV-regulierte Leistungsbereiche mit Genehmigungspflicht.

- **Includes:** All codes from [GenehmigungenLeistungsbereichCS](CodeSystem-genehmigung-leistungsbereich.html)
- **Binding:** Used by `GenehmigungenExt.leistungsbereich`
- **Usage:** Identifies which medical service area requires a KV approval (e.g. Chirotherapie, Sonographie, Psychotherapie)

### GenehmigungenTypVS — Genehmigungstyp

Typ der KV-Genehmigung: kopfbezogen vs. betriebsstättenbezogen.

- **Includes:** All codes from [GenehmigungenTypCS](CodeSystem-genehmigung-typ.html)
- **Binding:** Used by `GenehmigungenExt.typ` and `GenehmigungenTypExt`
- **Usage:** Distinguishes whether an approval is bound to the individual physician (kopfbezogen) or to the practice site (betriebsstättenbezogen)

### WbRolleVS — WB/SA-Rolle

Rollen für Weiterbildungs- und Sicherstellungsassistenten.

- **Includes:** All codes from [WbRolleCS](CodeSystem-wb-rolle.html)
- **Binding:** Used by `WbRolleExt` on PractitionerRole
- **Usage:** Identifies whether a physician is a training resident (WB-Assistent) or a locum for ensuring care provision (Sicherstellungsassistent)

### AiProvenanceVS — AI Provenance

Codes für KI-Herkunftskennzeichnung gemäß EU AI Act Art. 50.

- **Includes:** All codes from [AiProvenanceCS](CodeSystem-ai-provenance.html)
- **Binding:** Used by `AiGeneratedExt` on Provenance
- **Usage:** Tracks the level of AI involvement in content generation (KI-generiert, KI-unterstützt, menschlich geprüft, menschlich freigegeben)

### AppointmentModeVS — Terminmodus

Terminmodus für ambulante Konsultationen.

- **Includes:** All codes from [AppointmentModeCS](CodeSystem-appointment-mode.html)
- **Binding:** Used by `AppointmentModeExt` on Appointment (required)
- **Usage:** Identifies the mode of consultation: in-person, video, phone, or home visit

## External ValueSets

The IG does not define custom ValueSets for external code systems. Extensions referencing KBV Schlüsseltabellen (e.g. `KBV_CS_SFHIR_BAR2_FACHGRUPPENZUORDNUNG` for `RlvFachgruppeExt`) bind directly to the external CodeSystem from `kbv.all.st-combined`.
