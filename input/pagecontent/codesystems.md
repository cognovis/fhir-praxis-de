# Code Systems

This IG defines custom CodeSystems for concepts specific to German ambulatory practice management that are not covered by existing KBV or HL7 Germany terminologies.

## Custom CodeSystems

### BillingTypeCS — Abrechnungsart

Codes für Abrechnungsarten und Abrechnungskataloge in der ambulanten Versorgung. Dient als Diskriminator für ChargeItemDefinition-Kataloge. Regionale Selektivverträge nutzen den generischen Typ (z.B. `hzv`) — die KV-Region wird über `Contract.identifier` bzw. `ChargeItemDefinition.jurisdiction` abgebildet.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `ebm` | EBM | Einheitlicher Bewertungsmaßstab (GKV) |
| `goae` | GOÄ | Gebührenordnung für Ärzte (PKV) |
| `bema` | BEMA | Bewertungsmaßstab für zahnärztliche Leistungen (GKV) |
| `goz` | GOZ | Gebührenordnung für Zahnärzte (PKV) |
| `bgt2001` | BGT2001 | Berufsgenossenschaftliche Gebühren-Tarifpositionen (DGUV) |
| `hzv` | HZV | Hausarztzentrierte Versorgung (§73b SGB V) |
| `facharztvertrag` | Facharztvertrag | Facharztvertrag / Besondere Versorgung (§73c/§140a SGB V) |
| `igel` | IGeL | Individuelle Gesundheitsleistung |
| `bg` | BG | Berufsgenossenschaft (sonstige BG-Abrechnung) |

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

### ZuzahlungsstatusCS — Zuzahlungsstatus

GKV-Zuzahlungsstatus gemäß eGK-Versichertenstammdaten (VSD). Inhalte werden per ETL aus den offiziellen eGK-VSD-Spezifikationen befüllt (`^content = #not-present`).

### HvgVertragsartCS — HVG-Vertragsart

Arten von Selektivverträgen nach §73b/§73c SGB V (Hausarztverträge, Facharztverträge, Besondere Versorgung). Inhalte werden per ETL befüllt (`^content = #not-present`).

### KvFachgruppeCS — KV-Fachgruppe

KV-Fachgruppencodes für Honorarverteilung und Qualitätssicherung.

| Code | Display |
|------|---------|
| `allgemeinmedizin` | Allgemeinmedizin |
| `innere-medizin` | Innere Medizin |
| `paediatrie` | Pädiatrie |
| `gynaekologie` | Gynäkologie |
| `chirurgie` | Chirurgie |
| `orthopaedie` | Orthopädie |
| `urologie` | Urologie |
| `augenheilkunde` | Augenheilkunde |
| `hno` | HNO |
| `neurologie` | Neurologie |
| `psychiatrie` | Psychiatrie |
| `radiologie` | Radiologie |
| `dermatologie` | Dermatologie |
| `anaesthesiologie` | Anästhesiologie |

### KrablLinkKategorieCS — KrablLink-Dokumentkategorie

Dokumentkategorien für KrablLink-Dokumente (arztbrief, befund, labor, etc.).

| Code | Display | Beschreibung |
|------|---------|--------------|
| `arztbrief` | Arztbrief | Ärztlicher Brief |
| `befund` | Befund | Medizinischer Befund |
| `labor` | Labor | Laborbefund |
| `bild` | Bild | Bildgebende Diagnostik (z.B. Röntgen, CT, MRT) |
| `einwilligung` | Einwilligung | Einwilligungsdokument |
| `verordnung` | Verordnung | Ärztliche Verordnung |
| `ueberweisung` | Überweisung | Überweisungsdokument |
| `sonstiges` | Sonstiges | Sonstiges Dokument |

### KrablLinkContentCS — KrablLink-Content-Typ

Content-Typen für KrablLink-Dokumente.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `pdf` | PDF | PDF-Dokument |
| `hl7-cda` | HL7 CDA | HL7 Clinical Document Architecture |
| `plaintext` | Plaintext | Einfacher Text |
| `dicom` | DICOM | DICOM-Bilddaten |
| `jpeg` | JPEG | JPEG-Bilddatei |
| `png` | PNG | PNG-Bilddatei |
| `hl7-fhir` | HL7 FHIR | HL7 FHIR-Ressource |

### LkzCS — Löschkennzeichen

Lifecycle-Status-Codes für Soft-Delete und Archivierung.

| Code | Display | Beschreibung |
|------|---------|--------------|
| `aktiv` | Aktiv | Eintrag ist aktiv |
| `geloescht` | Gelöscht | Eintrag wurde gelöscht (Soft-Delete) |
| `gesperrt` | Gesperrt | Eintrag ist gesperrt |
| `archiviert` | Archiviert | Eintrag ist archiviert |

### AppointmentModeCS — Terminmodus

Terminmodus für ambulante Konsultationen (R4-Erweiterung für FHIR R5 virtualService).

| Code | Display | Beschreibung |
|------|---------|--------------|
| `in-person` | Praxisbesuch | Patient erscheint persönlich in der Praxis |
| `video` | Videosprechstunde | Termin findet per Videokonferenz statt |
| `phone` | Telefontermin | Termin findet telefonisch statt |
| `home-visit` | Hausbesuch | Arzt besucht den Patienten zu Hause |

## External CodeSystems

This IG also references the following external CodeSystems from the KBV Schlüsseltabellen (`kbv.all.st-combined`):

| CodeSystem | Package | Usage |
|------------|---------|-------|
| **KBV_CS_SFHIR_KBV_SCHEINART** | kbv.all.st-combined | Offizielle Scheinart-Codes der KBV (ergänzend zu ScheinartCS) |
| **KBV_CS_SFHIR_EBM_RLV** | kbv.all.st-combined | EBM-Ziffern mit RLV-Relevanz |
| **KBV_CS_SFHIR_BAR2_FACHGRUPPENZUORDNUNG** | kbv.all.st-combined | Fachgruppen-Codes für KV-Benchmark und RLV |
