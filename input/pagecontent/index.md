# German Practice Management FHIR Profiles

FHIR R4 profiles and extensions for German ambulatory practice management (Vertragsarzt/MVZ). This Implementation Guide defines a comprehensive, PVS-agnostic extension layer for the day-to-day data needs of German medical practices — from billing and budget management to AI provenance tracking under the EU AI Act.

**Any German practice management system** (x.isynet, Medistar, Charly, TurboMed, etc.) can map its internal data model to these profiles. The IG deliberately avoids PVS-specific structures and instead models the shared regulatory and clinical domain.

## Scope

| Domain | Description |
|--------|-------------|
| **Billing (EBM/GOÄ/BGT)** | EBM-Ziffern, GOÄ-Faktoren inkl. Sachkosten/Analogziffern, BGT2001, Scheinarten, Abrechnungsquartal |
| **Selektivverträge (HZV)** | Generisches Katalogmodell für HZV/Facharztverträge aller KV-Regionen über ChargeItemDefinition |
| **Budget Management (RLV/QZV)** | Regelleistungsvolumen, qualifikationsgebundene Zusatzvolumina, Entbudgetierung |
| **Remittance (Honorarbescheid)** | KV-Honorarbescheide, Richtigstellungen, Auszahlungsbeträge |
| **Private Billing Workflow** | Freigabe-/Review-Status für Privatrechnungen |
| **Queue Management (Warteraum)** | Ankunftszeiten, Aufrufzeiten, R5-Encounter.subjectStatus-Backport |
| **AI Provenance (EU AI Act)** | KI-Herkunftskennzeichnung gemäß Art. 50, Modellversion, menschliche Prüfung |
| **Administrative Workflows** | Aufgaben, Genehmigungen, Überweisungen, Einweisungen, Einwilligungen, AU-Bescheinigungen |

## Extension Categories

- **Encounter / Warteraum** — Queue management with arrival and call timestamps
- **Billing / Abrechnung** — EBM and GOÄ billing, charge items, catalog metadata, Scheinpositionen
- **GOÄ Detail / Sachkosten** — Ultrasound organs, material costs, analog billing (GOÄ §6/§10)
- **EBM auf ChargeItem** — Concrete billed EBM values (Kapitel, Punkte, Prüfzeit, RLV-Relevanz)
- **Private Billing Workflow** — Review and release status for private invoices
- **HVG / Selektivverträge** — Selective contract extensions (§73b/§73c SGB V)
- **BGT2001 / BG-Tarif** — Occupational accident tariff details (supplements dguv.basis)
- **Price History** — Historical pricing on ChargeItemDefinition catalog entries
- **RLV / Budget** — Contract-based physician capitation budget (Regelleistungsvolumen)
- **Honorarbescheid / Remittance** — KV payment reconciliation and correction codes
- **AI Provenance** — EU AI Act Art. 50 compliance: AI-generated content flagging, human review tracking
- **Genehmigungen / KV Approvals** — Leistungsbereichs-Genehmigungen (kopfbezogen/betriebsstättenbezogen)
- **Administrative** — Consent management, referrals, hospital admissions, accounts receivable, AU/Arbeitsunfähigkeit

## Built On

This IG builds on established German FHIR base profiles:

- [de.basisprofil.r4](https://simplifier.net/basisprofil-de-r4) (1.5.0) — German base profiles
- [kbv.basis](https://simplifier.net/for) (1.8.0) — KBV Basisprofile
- [kbv.ita.for](https://simplifier.net/for) (1.3.1) — Formularübergreifende Festlegungen
- [kbv.ita.aws](https://simplifier.net/for) (1.2.0) — Archivierungs-/Wechselschnittstelle
- [kbv.all.st-combined](https://simplifier.net/for) (1.32.0) — KBV Schlüsseltabellen
- [DGUV.Basis](https://simplifier.net/dguv-basis) (1.4.0) — BG/Arbeitsunfall

## Publisher

**cognovis GmbH** — [cognovis.de](https://www.cognovis.de)

## License

This Implementation Guide is published under **CC-BY-4.0**.

## Status

**Draft / CI-Build** — This IG is under active development. Breaking changes may occur between versions.

## International Interoperability

These profiles are designed with international FHIR concepts in mind. Where possible, they use standard R4 resources and documented mappings to international equivalents. See the [International Interoperability](international-interoperability.html) page for detailed mapping tables.

## Dependencies

{% include dependency-table.xhtml %}

## Cross-Version Analysis

{% include cross-version-analysis.xhtml %}

## Global Profiles

{% include globals-table.xhtml %}

## IP Statements

{% include ip-statements.xhtml %}
