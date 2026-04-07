// ============================================================================
// EBM/GOÄ Billing Catalog Extensions (on ChargeItemDefinition)
// ============================================================================

Extension: BillingSystemExt
Id: billing-system
Title: "Abrechnungssystem"
Description: "Kennung des Abrechnungssystems (z.B. EBM, GOÄ, BG)"
Context: ChargeItemDefinition
* value[x] only string

Extension: BillingCodeExt
Id: billing-code
Title: "Abrechnungsziffer"
Description: "Abrechnungsziffer im jeweiligen Gebührenkatalog"
Context: ChargeItemDefinition
* value[x] only string

Extension: BillingCategoryExt
Id: billing-category
Title: "Abrechnungskategorie"
Description: "Kategorie der Abrechnungsziffer im Gebührenkatalog"
Context: ChargeItemDefinition
* value[x] only string

Extension: BillingPointsExt
Id: billing-points
Title: "Punktzahl"
Description: "Punktwert der Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only decimal

Extension: BillingEuroValueExt
Id: billing-euro-value
Title: "Euro-Betrag"
Description: "Euro-Wert der Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only decimal

Extension: MultiplierMinExt
Id: multiplier-min
Title: "Mindestfaktor"
Description: "Minimaler Steigerungsfaktor für die Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only decimal

Extension: MultiplierDefaultExt
Id: multiplier-default
Title: "Standardfaktor"
Description: "Standard-Steigerungsfaktor für die Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only decimal

Extension: MultiplierMaxExt
Id: multiplier-max
Title: "Maximalfaktor"
Description: "Maximaler Steigerungsfaktor für die Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only decimal

Extension: BillingRequirementsExt
Id: billing-requirements
Title: "Abrechnungsvoraussetzungen"
Description: "Voraussetzungen für die Abrechnung der Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only string

Extension: BillingExclusionsExt
Id: billing-exclusions
Title: "Ausschlüsse"
Description: "Ausschlussregelungen zu anderen Leistungsziffern"
Context: ChargeItemDefinition
* value[x] only string

Extension: BillingExclusionsContextExt
Id: billing-exclusions-context
Title: "Ausschlüsse mit Bezugsraum"
Description: "Ausschlussregelungen mit Bezugsraum-Kontext, Format BF:01100,01101|AF:01955 (BF=Behandlungsfall, AF=Arztfall, SF=Sitzung, TG=Tag)"
Context: ChargeItemDefinition
* value[x] only string

Extension: SupplementToExt
Id: supplement-to
Title: "Zuschlag zu"
Description: "Referenz auf die Leistungsziffer, zu der diese Ziffer ein Zuschlag ist"
Context: ChargeItemDefinition
* value[x] only string

Extension: AgeMinExt
Id: age-min
Title: "Mindestalter"
Description: "Mindestalter des Patienten für die Abrechnung der Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only integer

Extension: AgeMaxExt
Id: age-max
Title: "Höchstalter"
Description: "Höchstalter des Patienten für die Abrechnung der Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only integer

Extension: GenderExt
Id: gender
Title: "Geschlechtseinschränkung"
Description: "Geschlechtsbezogene Einschränkung für die Abrechnung der Leistungsziffer"
Context: ChargeItemDefinition
* value[x] only code

Extension: MaxPerCaseExt
Id: max-per-case
Title: "Maximum pro Behandlungsfall"
Description: "Maximale Häufigkeit der Abrechnung pro Behandlungsfall"
Context: ChargeItemDefinition
* value[x] only integer

Extension: MaxPerQuarterExt
Id: max-per-quarter
Title: "Maximum pro Quartal"
Description: "Maximale Häufigkeit der Abrechnung pro Quartal"
Context: ChargeItemDefinition
* value[x] only integer

Extension: CatalogIsActiveExt
Id: catalog-is-active
Title: "Katalog aktiv"
Description: "Gibt an, ob die Leistungsziffer im aktuellen Katalog aktiv ist"
Context: ChargeItemDefinition
* value[x] only boolean

Extension: CatalogVersionLabelExt
Id: catalog-version-label
Title: "Katalogversion"
Description: "Bezeichnung der Katalogversion (z.B. EBM 2026Q1)"
Context: ChargeItemDefinition
* value[x] only string

Extension: BillingPruefzeitExt
Id: billing-pruefzeit
Title: "Prüfzeit"
Description: "KBV-Prüfzeit in Minuten für die Plausibilitätsprüfung"
Context: ChargeItemDefinition
* value[x] only integer

Extension: BillingRlvRelevanzExt
Id: billing-rlv-relevanz
Title: "RLV-Relevanz"
Description: "Kennzeichen, ob die Leistung RLV-relevant ist (Regelleistungsvolumen)"
Context: ChargeItemDefinition
* value[x] only boolean

Extension: BillingFachgruppenExt
Id: billing-fachgruppen
Title: "Fachgruppen"
Description: "Kommaseparierte KBV-Fachgruppencodes, die diese Leistung abrechnen dürfen"
Context: ChargeItemDefinition
* value[x] only string

Extension: BillingGenehmigungspflichtExt
Id: billing-genehmigungspflicht
Title: "Genehmigungspflicht"
Description: "Gibt an, ob die Leistung eine Genehmigung der KV vor Erbringung erfordert"
Context: ChargeItemDefinition
* value[x] only boolean

Extension: BillingLeistungsinhaltExt
Id: billing-leistungsinhalt
Title: "Leistungsinhalt"
Description: "Obligater und fakultativer Leistungsinhalt der Gebührenordnungsposition"
Context: ChargeItemDefinition
* value[x] only string

// ============================================================================
// ChargeItem Billing Extensions (on ChargeItem)
// ============================================================================

Extension: AbrechnungsquartalExt
Id: abrechnungsquartal
Title: "Abrechnungsquartal"
Description: "GKV-Abrechnungsquartal im Format JJJJQX (z.B. 2026Q1)"
Context: ChargeItem, Encounter
* value[x] only string

Extension: ScheinPositionExt
Id: schein-position
Title: "Scheinposition"
Description: "Position der Leistung auf dem Abrechnungsschein"
Context: ChargeItem
* value[x] only integer

Extension: StatistikleistungExt
Id: statistikleistung
Title: "Statistikleistung"
Description: "Kennzeichen, ob es sich um eine reine Statistikleistung handelt (nicht honorarrelevant)"
Context: ChargeItem
* value[x] only boolean

// ============================================================================
// Private Billing GOÄ Extensions (on Claim, ChargeItem)
// ============================================================================

Extension: GoaeFaktorExt
Id: goae-faktor
Title: "GOÄ-Faktor"
Description: "GOÄ-Steigerungsfaktor (1,0 bis 3,5 bzw. darüber mit Begründung)"
Context: Claim, ChargeItem
* value[x] only decimal

Extension: GoaePunkteExt
Id: goae-punkte
Title: "GOÄ-Punkte"
Description: "Punktzahl der GOÄ-Leistungsziffer"
Context: Claim, ChargeItem
* value[x] only decimal

Extension: RabStatusExt
Id: rab-status
Title: "RAB-Status"
Description: "Status im Rechnungsausgangsbuch (z.B. offen, gesendet, bezahlt)"
Context: Claim
* value[x] only string

Extension: RabRefExt
Id: rab-ref
Title: "RAB-Referenz"
Description: "Referenznummer im Rechnungsausgangsbuch"
Context: Claim
* value[x] only string

Extension: RechFormArtExt
Id: rech-form-art
Title: "Rechnungsformular-Art"
Description: "Art des Rechnungsformulars (z.B. Privatliquidation, BG-Rechnung)"
Context: Claim, ChargeItem
* value[x] only string

Extension: ManualOverrideExt
Id: manual-override
Title: "Manuelle Überschreibung"
Description: "Kennzeichen, ob die Abrechnungsposition manuell überschrieben wurde"
Context: Claim, ChargeItem
* value[x] only boolean

Extension: BgAktenzeichenExt
Id: bg-aktenzeichen
Title: "BG-Aktenzeichen"
Description: "Aktenzeichen der Berufsgenossenschaft für den Unfallversicherungsfall"
Context: Claim
* value[x] only string

Extension: BgUnfalltagExt
Id: bg-unfalltag
Title: "BG-Unfalltag"
Description: "Datum des Arbeitsunfalls für die BG-Abrechnung"
Context: Claim
* value[x] only date

// ============================================================================
// Price History Extension (on ChargeItemDefinition)
// ============================================================================

Extension: PriceHistoryExt
Id: price-history
Title: "Preishistorie"
Description: "Historischer Preis-/Punktwert einer Leistungsziffer mit Gültigkeitszeitraum"
Context: ChargeItemDefinition
* extension contains
    validFrom 1..1 and
    validTo 0..1 and
    points 0..1 and
    euroValue 0..1
* extension[validFrom].value[x] only date
* extension[validTo].value[x] only date
* extension[points].value[x] only decimal
* extension[euroValue].value[x] only Money
