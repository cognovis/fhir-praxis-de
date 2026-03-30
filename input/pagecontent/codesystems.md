# Code Systems

This IG defines custom CodeSystems for concepts specific to German ambulatory practice management that are not covered by existing KBV or HL7 Germany terminologies.

## Custom CodeSystems

### BillingTypeCS — Abrechnungsart

Codes für Abrechnungsarten in der ambulanten Versorgung.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `goae` | GOÄ | Gebührenordnung für Ärzte |
| `ebm` | EBM | Einheitlicher Bewertungsmaßstab |
| `bema` | BEMA | Bewertungsmaßstab für zahnärztliche Leistungen |
| `goz` | GOZ | Gebührenordnung für Zahnärzte |
| `bg` | BG | Berufsgenossenschaft |
| `igel` | IGeL | Individuelle Gesundheitsleistung |

### CorrectionRuleCS — KVB Richtigstellungsgründe

Codes für KV-Richtigstellungen im Honorarbescheid.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `UV` | UV | Überschreitung Volumen |
| `HO` | HO | Honoraroptimierung |
| `GHO` | GHO | Gruppenhonorar-Optimierung |
| `PL` | PL | Plausibilitätsprüfung |
| `WP` | WP | Wirtschaftlichkeitsprüfung |
| `ST` | ST | Storno |
| `KO` | KO | Korrektur |

### ScheinartCS — Scheintypen

Abrechnungsschein-Typen in der ambulanten Versorgung.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `gkv` | GKV | Gesetzliche Krankenversicherung |
| `pkv` | PKV | Private Krankenversicherung |
| `bg` | BG | Berufsgenossenschaft |
| `ue` | Überweisung | Überweisungsschein |
| `not` | Notfall | Notfallschein |
| `igel` | IGeL | Individuelle Gesundheitsleistung |

### DiagnoseSeiteCS — Seitenangabe

Seitenangabe für Diagnosen (Lateralität).

| Code | Display |
|------|---------|
| `L` | Links |
| `R` | Rechts |
| `B` | Beidseitig |

### TaskTypeCS — Praxis-Aufgabentypen

Typen für Praxis-Aufgaben in der Aufgabenverwaltung.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `callback` | Rückruf | Patient bittet um Rückruf |
| `urgent` | Dringend | Dringende Aufgabe |
| `lab` | Labor | Labor-Ergebnis bearbeiten |
| `recipe` | Rezept | Rezeptanforderung |
| `referral` | Überweisung | Überweisungsanforderung |

### GenehmigungenLeistungsbereichCS — KV-regulierte Leistungsbereiche

Leistungsbereiche, die einer KV-Genehmigung bedürfen.

| Code | Display |
|------|---------|
| `chirotherapie` | Chirotherapie |
| `psychosomatik` | Psychosomatik |
| `psychotherapie` | Psychotherapie |
| `akupunktur` | Akupunktur |
| `schmerztherapie` | Schmerztherapie |
| `sonographie` | Sonographie |
| `sono-abdomen` | Sono Abdomen |
| `langzeit-ekg` | Langzeit-EKG |
| `langzeit-blutdruck` | Langzeit-Blutdruck |
| `radiologie` | Radiologie |
| `allergologie` | Allergologie |
| `dmp` | DMP |
| `hks` | HKS (Herzschrittmacher-Kontrolle) |

### GenehmigungenTypCS — Genehmigungstyp

Typ der KV-Genehmigung: an den Arzt oder an die Betriebsstätte gebunden.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `kopfbezogen` | Kopfbezogen | An den einzelnen Arzt gebunden |
| `betriebsstaette` | Betriebsstätte | An die Betriebsstätte gebunden |

### WbRolleCS — WB/SA-Rollen

Rollen für Weiterbildungs- und Sicherstellungsassistenten.

| Code | Display |
|------|---------|
| `wb-assistent` | WB-Assistent (Weiterbildungsassistent) |
| `sicherstellungsassistent` | Sicherstellungsassistent |

### AiProvenanceCS — KI-Herkunftskennzeichnung

Codes für KI-Herkunftskennzeichnung gemäß EU AI Act Art. 50.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `ai-generated` | KI-generiert | Inhalt wurde durch ein KI-System erzeugt |
| `ai-assisted` | KI-unterstützt | Inhalt wurde mit KI-Unterstützung erstellt |
| `human-reviewed` | Menschlich geprüft | KI-Inhalt wurde durch einen Menschen geprüft |
| `human-approved` | Menschlich freigegeben | KI-Inhalt wurde durch einen Menschen freigegeben |

## External CodeSystems

This IG also references the following external CodeSystems from the KBV Schlüsseltabellen (`kbv.all.st-combined`):

| CodeSystem | Package | Usage |
|------------|---------|-------|
| **KBV_CS_SFHIR_KBV_SCHEINART** | kbv.all.st-combined | Offizielle Scheinart-Codes der KBV (ergänzend zu ScheinartCS) |
| **KBV_CS_SFHIR_EBM_RLV** | kbv.all.st-combined | EBM-Ziffern mit RLV-Relevanz |
| **KBV_CS_SFHIR_BAR2_FACHGRUPPENZUORDNUNG** | kbv.all.st-combined | Fachgruppen-Codes für KV-Benchmark und RLV |
