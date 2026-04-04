# de.cognovis.fhir.praxis — Ambulante FHIR-Profile fuer Deutschland

**FHIR R4 Implementation Guide fuer die Praxisverwaltung (PVS)**

---

## Was ist das?

Ein produktives, offen lizenziertes (CC-BY-4.0) FHIR R4 Implementation Guide fuer die
ambulante Versorgung in Deutschland. Entwickelt aus der Praxis — nicht aus der Theorie.

Das IG bildet die komplette Wertschoepfungskette einer Arztpraxis ab:
von der Terminbuchung ueber Abrechnung bis zur Honorarbescheid-Verarbeitung.

| | |
|---|---|
| **Package** | `de.cognovis.fhir.praxis` v0.18.0 (STU1) |
| **Canonical** | https://fhir.cognovis.de/praxis |
| **Published IG** | https://cognovis.github.io/fhir-praxis-de/ |
| **Basis** | FHIR R4, de.basisprofil.r4 v1.6.0 |
| **Lizenz** | CC-BY-4.0 |
| **Publisher** | cognovis GmbH, Hamburg |

---

## Umfang

| Artefakt-Typ | Anzahl | Beispiele |
|-------------|--------|-----------|
| Profile | 6 | InsurancePlan (GKV/PKV), CareTeam, Questionnaire/Anamnese, PAS Claim/Response/Task |
| Extensions | 161 | EBM/GOAe-Abrechnung, RLV/QZV-Budget, HZV-Teilnahme, AI Provenance, Terminmodus |
| CodeSystems | 27 | Scheinart, KV-Fachgruppe, Behandler-Rolle, CAVE-Warntyp, Abrechnungsart |
| ValueSets | 18 | Alle CS mit passenden VS |
| NamingSystems | 7 | BSNR, Abrechnungsnummer, PVS-ID |
| Examples | 12 | Klinische Szenarien mit Abrechnung |
| Tests | 40 | httpyac-Tests gegen Aidbox |

---

## Abgedeckte Domaenen

- **Abrechnung**: EBM (GKV), GOAe (PKV), BGT2001 (BG), IGeL
- **Budget**: RLV/QZV-Zuweisung, KV-Benchmark-Daten, Entbudgetierung
- **Selektivvertraege**: HZV (Paragraph 73b), Facharztvertraege (Paragraph 73c)
- **Honorarbescheid**: Quartalsabrechnung, Richtigstellungen, Einzelfallpruefung
- **Privatrechnung**: GOAe-Workflow (Entwurf -> Freigabe -> Versand), Mahnwesen
- **Terminverwaltung**: Modus (Praxis/Video/Telefon/Hausbesuch), Wartezimmer-Queue
- **Klinische Dokumentation**: CAVE-Warnungen, Dauerdiagnosen, Seitenlokalisation
- **Einwilligungen**: DSGVO-konforme Consent-Verwaltung mit Widerruf
- **AI Provenance**: EU AI Act Art. 50 — Kennzeichnung KI-generierter Inhalte
- **Genehmigungen**: KV-Genehmigungsverfahren (Psychotherapie, Akupunktur etc.)

---

## Angebot an die Community: Upstream-Kandidaten

Diese Artefakte sind **nicht cognovis-spezifisch** — jedes PVS in Deutschland braucht sie.
Wir bieten sie zur Uebernahme in nationale Profile an:

### Fuer de.basisprofil.r4

| CodeSystem / Extension | Beschreibung | Warum national? |
|----------------------|--------------|-----------------|
| **Scheinart** | GKV, PKV, BG, Ueberweisung, Notfall, IGeL | Jede Praxis unterscheidet Abrechnungstypen identisch |
| **Appointment-Mode** | Praxis, Video, Telefon, Hausbesuch | Telemedizin-Pflicht seit DiGA/Videosprechstunde |
| **Behandler-Rolle** | Arzt, ZFA, MFA, Physiotherapeut, WB-Assistent | Universelle Team-Rollen in jeder Praxis |
| **Diagnose-Seite** | Links, Rechts, Beidseitig | Klinischer Standard fuer Seitenlokalisation |
| **CAVE-Warntyp** | K, A, V, E (PVS-uebergreifend standardisiert) | Patientensicherheit, alle PVS nutzen dieselben Codes |

### Fuer KBV

| CodeSystem / Extension | Beschreibung | Warum KBV? |
|----------------------|--------------|------------|
| **KV-Fachgruppe** | Offizielle KBV-Fachgruppencodes | Honorarverteilung, Budgetierung |
| **HZV-Teilnahmestatus** | Eingeschrieben, abgemeldet, gesperrt | Paragraph 73b SGB V, gesetzlich geregelt |
| **HVG-Vertragsart** | Selektivvertragstypen | Paragraph 73b/73c SGB V |
| **Genehmigung-Leistungsbereich** | Psychotherapie, Akupunktur, Sono etc. | KV-regulierte Genehmigungspflicht |
| **Zuzahlungsstatus** | eGK-VSD-basierter Zuzahlungsstatus | National einheitlich ueber eGK |

### Fuer HL7 DE / EU-weit

| Extension-Set | Beschreibung | Warum uebergreifend? |
|--------------|--------------|---------------------|
| **AI Provenance** (8 Extensions) | ai-generated, ai-provider, ai-model, ai-timestamp, ai-purpose, human-reviewed, human-reviewer, human-review-timestamp | EU AI Act Art. 50 macht KI-Kennzeichnung ab 2026 zur Pflicht fuer alle Gesundheitssysteme |

---

## Warum sollte das standardisiert werden?

1. **Vermeidung von Inselloesungen**: Aktuell definiert jedes PVS eigene FHIR-Mappings.
   Gemeinsame CodeSystems ermoeglichen Datenaustausch zwischen Praxen.

2. **Interoperabilitaet**: Patienten wechseln Praxen. Wenn Scheinart, Diagnoseseite und
   CAVE-Codes ueberall gleich kodiert sind, funktioniert der Datentransfer.

3. **Regulatorische Effizienz**: HZV-Status, Genehmigungsbereiche und KV-Fachgruppen sind
   gesetzlich definiert — sie sollten einmal zentral profiliert werden, nicht 50x.

4. **EU AI Act Compliance**: Ab 2026 muessen alle Gesundheitssysteme KI-Inhalte kennzeichnen.
   Ein gemeinsames Extension-Set spart jedem Hersteller Entwicklungszeit.

---

## Naechste Schritte

- **Interoperabilitaetsforum**: Vorstellung der Upstream-Kandidaten im naechsten Quartalstreffen
- **Ballotierung**: Formaler Vorschlag der CodeSystems fuer de.basisprofil.r4
- **Kooperation**: Suche nach PVS-Herstellern die gemeinsame ambulante Profile nutzen wollen

---

## Kontakt

**cognovis GmbH**
Malte Sussdorff — malte.sussdorff@cognovis.de
https://cognovis.github.io/fhir-praxis-de/
