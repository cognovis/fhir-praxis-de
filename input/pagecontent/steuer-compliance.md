# Steuer-Compliance in der ambulanten Praxis

This page documents the tax-compliance architecture for German ambulatory practice management FHIR profiles — covering VAT (Umsatzsteuer) categorization, exemptions, and the Kleinunternehmerregelung.

---

## Trennungsprinzip

German ambulatory practices frequently provide **both** VAT-exempt and VAT-liable services in the same billing cycle:

| Service Type | VAT Status | Typical Example |
|---|---|---|
| Heilbehandlungsleistung (GKV/PKV) | Exempt (§ 4 Nr. 14a UStG) | Consultation, BEMA treatment |
| IGeL — medical purpose (Heilbehandlung) | Exempt (§ 4 Nr. 14a UStG) | Medical advice with therapeutic goal |
| IGeL — non-medical purpose | Taxable (19% standard) | Travel medicine certificate, cosmetic procedure |
| Reimbursements, technical services | Taxable or zero-rated | Lab pass-through (varies) |
| KU-regulated practice | Exempt (§ 19 UStG) | All services, blanket exemption |

**FHIR Implementation:** Each `Invoice` carries the invoice-level tax category and exemption reason via extensions:
- `ext-tax-category` — UNECE-5305 / EN 16931 category code (S / AA / E / AE / Z), see `TaxCategoryDE` ValueSet. **Context: `Invoice`, `ChargeItemDefinition.propertyGroup.priceComponent`**.
- `ext-tax-exemption-reason` — legal basis for exemption, see `UStBefreiungsgrundVS`. **Context: `Invoice`, `ChargeItemDefinition.propertyGroup.priceComponent`**.

Both extensions apply at the **Invoice root level** for final billing classification, and optionally on `ChargeItemDefinition.propertyGroup.priceComponent` as a non-binding default suggestion in the service catalog (see ChargeItemDefinition-Pattern section below).

For **per-line-item tax category** in mixed invoices, use the standard FHIR field `Invoice.lineItem.priceComponent.code` directly (bound to the `TaxCategoryDE` ValueSet) — no extension is needed. This produces legally compliant ZUGFeRD / XRechnung output where each line item carries its own EN 16931 category code.

---

## ChargeItemDefinition-Pattern

### Schichtenmodell: Katalog → Profil → Spezialisierung

The tax extension pattern spans three layers of the German FHIR terminology and profile ecosystem:

```
fhir-terminology-de                fhir-praxis-de              fhir-dental-de
(Katalog-Lieferant)               (Pattern-Layer)             (Spezialisierung)
        |                               |                             |
        |  TaxCategoryDE ValueSet       |  ext-tax-category           |  ZahnPraxisInvoiceDE
        |  (UNECE-5305 codes:           |  ext-tax-exemption-reason   |  ZahnChargeItemDef
        |   S, AA, E, AE, Z)           |  Context:                   |  -- inherits pattern
        |                              |   Invoice,                  |
        |                              |   ChargeItemDefinition      |
        |                              |   .propertyGroup            |
        |                              |   .priceComponent           |
        +------------------------------> -----------------------------> 
             provides codes                 defines context               uses profile
```

**fhir-terminology-de** acts as the authoritative catalog supplier for the `TaxCategoryDE` ValueSet. The codes (S, AA, E, AE, Z) are sourced from the UNECE Recommendation N20 standard (`urn:un:unece:uncefact:codelist:standard:5305`). See [fhir-terminology-de](https://cognovis.github.io/fhir-terminology-de/) for the full catalog.

**fhir-praxis-de** defines the extension pattern (this IG) — where the extensions can be applied (`Context`) and how they are bound (`TaxCategoryDE`, `UStBefreiungsgrundVS`).

**fhir-dental-de** and other specialty IGs inherit the pattern and apply it to their specific service definitions.

### ChargeItemDefinition as Catalog with Tax Pre-Population

A `ChargeItemDefinition` can carry a **non-binding tax category suggestion** on its `propertyGroup.priceComponent`. This serves as a pre-population hint for the PVS (practice management software) when generating an `Invoice`:

```
ChargeItemDefinition (catalog entry)
  └── propertyGroup[0]
        └── priceComponent[0]
              ├── type = #base
              ├── amount = 13.50 EUR
              └── extension[ext-tax-category]
                    └── valueCodeableConcept = UNECE-5305#E  ← pre-population hint (optional, 0..1)
              └── extension[ext-tax-exemption-reason]
                    └── valueCodeableConcept = UStBefreiungsgrundCS#para4-nr14a  ← hint (if E)

Invoice (actual billing document)
  └── extension[ext-tax-category]  ← FINAL classification (set by PVS/Steuerberater)
        └── valueCodeableConcept = UNECE-5305#E
  └── extension[ext-tax-exemption-reason]
        └── valueCodeableConcept = UStBefreiungsgrundCS#para4-nr14a
```

### Design Decisions and Disclaimers

**Default is optional (0..1):** The `ext-tax-category` extension on `ChargeItemDefinition.propertyGroup.priceComponent` is entirely optional. Not every catalog entry carries a tax suggestion — in particular:

- **Context-dependent codes (e.g. BEMA/GOZ codes):** A BEMA code may be exempt (§4 Nr. 14a UStG) when billed by a licensed dentist, but taxable when the same service is performed by a non-licensed entity. The ChargeItemDefinition does **not** carry a default in these ambiguous cases.
- **Mixed-use services:** Services that can be both therapeutic (exempt) and cosmetic (taxable) carry no default.

**Final classification is the PVS/Steuerberater responsibility:** The tax category on `ChargeItemDefinition.propertyGroup.priceComponent` is an **informational pre-population hint**, not a legal declaration. The PVS must apply context-specific rules (type of practice entity, patient relationship, service purpose) and the final `Invoice` must reflect the actual legal classification as validated by the practice's tax advisor.

**Cross-reference:** The `TaxCategoryDE` ValueSet codes are defined in UNECE Recommendation N20 and mapped to EN 16931 / ZUGFeRD / XRechnung standards. The German FHIR terminology ecosystem provides these codes via `fhir-terminology-de`.

### Example Instances

This IG provides three `ChargeItemDefinition` demo instances showing the tax extension pattern:

| Instance | Service Type | Tax Category | Reason |
|---|---|---|---|
| `example-cid-bema-heilbehandlung` | BEMA 01 — GKV dental treatment | E (exempt) | §4 Nr. 14a UStG |
| `example-cid-igel-bleaching` | IGeL bleaching — cosmetic | S (19%) | Taxable cosmetic service |
| `example-cid-eigenlabor-material` | Own-lab dental material | AA (7%) | §12 Abs. 2 Nr. 2 UStG |

---

## Kleinunternehmerregelung (§ 19 UStG)

The *Kleinunternehmerregelung* exempts practices below revenue thresholds from charging VAT. Since 2025 the thresholds are:

- **25,000 EUR** prior-year revenue (Vorjahresumsatz)
- **100,000 EUR** current-year revenue (laufendes Jahr, new hard limit since 2025 reform)

### Organization Flag

The `KleinunternehmerregelungExt` on `Organization` (profile `PraxisOrganizationDE`) marks whether the practice is currently operating under § 19 UStG:

```
Organization
  └── extension[kleinunternehmerregelung]
        ├── extension[aktiv] = true
        └── extension[gueltigAb] = "2025-01-01"
```

### Invoice Constraint

The `PraxisInvoiceDE` profile enforces via FHIRPath invariant `ku-hinweis-required` that invoices flagged with `ext-ku-hinweis-pflicht = true` **must** contain `Invoice.note` with the statutory notice:

> *„Gemäß § 19 UStG wird keine Umsatzsteuer berechnet."*

FHIRPath expression:
```
extension.where(url='https://fhir.cognovis.de/praxis/StructureDefinition/ext-ku-hinweis-pflicht')
  .value.ofType(boolean).first() = true
implies note.text.exists()
```

**Note:** FHIRPath in FHIR R4 cannot traverse external references (Invoice → Organization). The `ext-ku-hinweis-pflicht` boolean extension on `Invoice` therefore acts as a signal set by the invoicing system when it detects the issuing organization is a Kleinunternehmer — the validator then verifies the note is present.

### Tax Category for KU Invoices

KU invoices use:
- `ext-tax-category` = `E` (exempt)
- `ext-tax-exemption-reason` = `kleinunternehmer-para19`

---

## Abfärbetheorie

The *Abfärbetheorie* (§ 15 Abs. 3 EStG) is relevant for practices operating as partnerships (*Personengesellschaften*): a single commercial activity can "infect" the entire partnership income, converting all income from freelance (*freiberuflich*) to commercial (*gewerblich*) with trade tax (*Gewerbesteuer*) consequences.

**Scope in this IG:** The profiles in this IG operate at the **invoice / billing level** and do not model income-tax classification. The Abfärbetheorie is documented here as context for implementers building practice management systems that need to:

1. Track whether a practice entity is a *Freiberufler* (§ 18 EStG) or *Gewerbetreibender* (§ 15 EStG)
2. Flag invoices that originate from potentially commercial activities (e.g. sale of products, laboratory mark-ups)

The `BillingTypeCS` codes (`igel`, `bg`, `hzv`) can serve as a starting point for classifying activities — implementers must apply appropriate legal review for their specific entity structure.

---

## ZUGFeRD / XRechnung Mapping

The `TaxCategoryDE` ValueSet uses UNECE-5305 codes (`urn:un:unece:uncefact:codelist:standard:5305`) which correspond directly to the EN 16931 / ZUGFeRD / XRechnung `BT-151` (Seller tax category code). The local `TaxCategoryCS` was removed in v0.54.0 — the UNECE URN is now the authoritative system:

| UNECE-5305 Code | EN 16931 BT-151 | TaxPercent (typical) | ZUGFeRD Profile | Description |
|---|---|---|---|---|
| `S` | S | 19.00 | MINIMUM / EN16931 / EXTENDED | Standard rate (Regelsteuersatz) |
| `AA` | AA | 7.00 | EN16931 / EXTENDED | Reduced rate (ermäßigter Satz) |
| `E` | E | 0.00 | MINIMUM / EN16931 / EXTENDED | Exempt (§ 4 UStG / § 19 UStG) |
| `AE` | AE | 0.00 | EN16931 / EXTENDED | Reverse Charge (§ 13b UStG) |
| `Z` | Z | 0.00 | EN16931 / EXTENDED | Zero-rated (Nullsatz) |

**FHIR system URI:** `urn:un:unece:uncefact:codelist:standard:5305`  
**ZUGFeRD XML path:** `ram:ApplicableTradeTax/ram:CategoryCode`  
**XRechnung XML path:** `cac:TaxCategory/cbc:ID`

**Migration note:** Systems that previously used the local `TaxCategoryCS` (`https://fhir.cognovis.de/praxis/CodeSystem/tax-category-de`) must migrate to the UNECE URN. The code values (S, AA, E, AE, Z) remain unchanged.

For ZUGFeRD MINIMUM profile (used in B2G, XRechnung): only codes `S` and `E` are valid — include `AE` and `Z` only in EN16931 or EXTENDED profiles.

---

## Out of Scope: Vorsteueraufteilung

**Vorsteueraufteilung** (input VAT apportionment, § 15 Abs. 4 UStG) — the pro-rata allocation of input VAT between deductible (for taxable services) and non-deductible (for exempt services) — is **out of scope** for this Implementation Guide.

Reasons:
- Vorsteueraufteilung requires knowledge of the overall revenue split across a fiscal year, which is an accounting-system concern, not a per-transaction FHIR billing concern.
- The calculation method (Umsatzschlüssel, Flächenschlüssel, etc.) varies by practice type and must be agreed with the practice's tax advisor.
- FHIR resources (Invoice, ChargeItem) capture the **gross/net amounts per service** — the aggregation and apportionment logic belongs in the downstream accounting system (e.g. DATEV).

Implementers requiring Vorsteueraufteilung should use the `Invoice.totalNet` / `Invoice.totalGross` values and the `ext-tax-category` codes to feed their accounting system's apportionment logic.

---

## Disclaimer

> **This documentation is for technical implementers of FHIR-based practice management systems. It does not constitute legal or tax advice.**
>
> Tax law (UStG, EStG, StrlSchG) is subject to change. The thresholds, rates, and exemption rules described here reflect the legal situation as of the IG publication date. Always verify the current legal requirements with a qualified tax advisor (*Steuerberater*) before implementing billing workflows.
>
> The FHIR profiles in this IG provide the **data model** for capturing tax-relevant information — compliance with German tax law remains the responsibility of the practice management software and its operators.
