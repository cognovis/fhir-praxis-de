# E-Mail-Entwurf: Simone Heckmann (TC FHIR Chair)

**An:** Simone.Heckmann@dmi.de
**CC:** az@gefyra.de, M.Przysucha@hs-osnabrueck.de
**Betreff:** Ambulante FHIR-Profile fuer Praxisverwaltung — Vorstellung auf DMEA / Interoperabilitaetsforum

---

Sehr geehrte Frau Heckmann,

mein Name ist Malte Sussdorff, ich bin Geschaeftsfuehrer der cognovis GmbH in Hamburg.
Wir entwickeln FHIR-basierte Integrationen fuer die ambulante Praxisverwaltung und haben
dabei ein umfangreiches FHIR R4 Implementation Guide erstellt, das wir gerne der
Community vorstellen moechten.

## Was wir gemacht haben

Unser IG **de.cognovis.fhir.praxis** (https://cognovis.github.io/fhir-praxis-de/)
bildet die komplette Wertschoepfungskette einer Arztpraxis in FHIR ab:

- **161 Extensions** fuer EBM/GOAe-Abrechnung, RLV/QZV-Budget, HZV-Selektivvertraege,
  Honorarbescheid-Verarbeitung, Terminverwaltung und Privatrechnung
- **27 CodeSystems** fuer Scheinarten, KV-Fachgruppen, Behandler-Rollen, CAVE-Warntypen
  und weitere national einheitliche Klassifikationen
- **6 Profile** fuer InsurancePlan (GKV/PKV), CareTeam, Questionnaire/Anamnese und
  Prior Authorization (PAS)
- **40 automatisierte Tests** gegen eine Aidbox-FHIR-Instanz
- Basierend auf **de.basisprofil.r4 v1.6.0**

Das IG entstand aus praktischer Notwendigkeit: Wir bauen FHIR-Adapter fuer PVS-Systeme
(aktuell Solutio/Dampsoft) und einen KI-gestuetzten Abrechnungsassistenten, der beim
Odontathon 2026 den Preis fuer das beste Business-Konzept gewonnen hat. Fuer beides
brauchen wir ein standardisiertes Datenmodell — und das existierte bisher nicht.

## Was wir anbieten moechten

Bei der Entwicklung haben wir festgestellt, dass ca. 15 unserer Artefakte **nicht
cognovis-spezifisch** sind, sondern von jedem PVS in Deutschland identisch benoetigt
werden. Diese moechten wir gerne zur Diskussion stellen:

**Fuer de.basisprofil.r4:**
- Scheinart-CodeSystem (GKV/PKV/BG/Ueberweisung/Notfall/IGeL)
- Appointment-Mode (Praxis/Video/Telefon/Hausbesuch)
- Behandler-Rolle (Arzt/ZFA/MFA/Physiotherapeut/WB-Assistent)
- Diagnose-Seite (Links/Rechts/Beidseitig)
- CAVE-Warntyp (PVS-uebergreifend standardisierte Einbuchstaben-Codes)

**Fuer die KBV-Abstimmung:**
- KV-Fachgruppen, HZV-Teilnahmestatus, HVG-Vertragsarten, Genehmigungsbereiche

**EU-weit relevant:**
- AI Provenance Extensions (8 Stueck) fuer EU AI Act Art. 50 Compliance

## Meine Bitte

1. Waere es moeglich, diese Artefakte im naechsten **Interoperabilitaetsforum** kurz
   vorzustellen? Ich wuerde einen 15-20min Slot vorbereiten.

2. Ich bin auf der **DMEA** (21.-23. April) in Berlin — gibt es dort eine Moeglichkeit
   fuer ein persoenliches Gespraech mit Ihnen oder Mitgliedern des TC FHIR?

3. Kennen Sie andere PVS-Hersteller oder Initiativen, die an ambulanten FHIR-Profilen
   arbeiten? Wir suchen Verbundete fuer eine gemeinsame Standardisierung.

Das vollstaendige IG mit QA-Report ist unter dem oben genannten Link einsehbar.
Einen One-Pager mit den Upstream-Kandidaten bringe ich gerne zur DMEA mit.

Herzliche Gruesse
Malte Sussdorff

cognovis GmbH
malte.sussdorff@cognovis.de
https://www.cognovis.de
