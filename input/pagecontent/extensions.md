# Extensions

This IG defines extensions grouped by clinical and administrative domain. All extensions use the canonical base URL `https://fhir.cognovis.de/praxis/StructureDefinition/`.

## Patient / Allgemein

Administrative extensions for patient management.

| Extension | Type | Description |
|-----------|------|-------------|
| `PatientSeitExt` | date | Datum seit wann der Patient in der Praxis in Behandlung ist (behandelt seit) |

## Encounter / Warteraum

Queue management extensions for patient flow in the practice.

| Extension | Type | Description |
|-----------|------|-------------|
| `ArrivalTimeExt` | dateTime | Zeitpunkt der Ankunft des Patienten im Warteraum |
| `EncounterCalledExt` | dateTime | Zeitpunkt des Aufrufs in das Behandlungszimmer |
| `EncounterCreatedAtExt` | dateTime | Erstellungszeitpunkt des Scheins im PVS |
| `ScheintypExt` | Coding | Scheinart (GKV, PKV, BG, IGeL, etc.) |
| `KrabllinkRefExt` | Reference | Referenz auf den zugehörigen Krabllink-Datensatz |

## Billing / Abrechnung GKV

Extensions for EBM billing, charge items, and catalog metadata.

| Extension | Type | Description |
|-----------|------|-------------|
| `BillingSystemExt` | uri | Abrechnungssystem (EBM, GOÄ, etc.) |
| `BillingCodeExt` | string | Abrechnungsziffer |
| `BillingCategoryExt` | Coding | Leistungskategorie |
| `BillingPointsExt` | decimal | Punktzahl der Leistung |
| `BillingEuroValueExt` | Money | Euro-Betrag der Leistung |
| `BillingRequirementsExt` | string | Abrechnungsvoraussetzungen (Legende) |
| `BillingExclusionsExt` | string | Abrechnungsausschlüsse |
| `BillingExclusionsContextExt` | string | Kontext der Abrechnungsausschlüsse |
| `SupplementToExt` | string | Zuschlagsziffer zu Hauptleistung |
| `AgeMinExt` | integer | Mindestalter für die Leistung |
| `AgeMaxExt` | integer | Höchstalter für die Leistung |
| `GenderExt` | code | Geschlechtsbeschränkung |
| `MaxPerCaseExt` | integer | Max. Häufigkeit je Behandlungsfall |
| `MaxPerQuarterExt` | integer | Max. Häufigkeit je Quartal |
| `CatalogIsActiveExt` | boolean | Katalog-Eintrag aktiv/inaktiv |
| `CatalogVersionLabelExt` | string | Katalog-Versionskennzeichen |
| `BillingPruefzeitExt` | integer | Prüfzeit in Minuten (KBV) |
| `BillingFachgruppenExt` | string | Zugelassene Fachgruppen |
| `BillingGenehmigungspflichtExt` | boolean | Genehmigungspflichtige Leistung |
| `BillingLeistungsinhaltExt` | string | Leistungsinhalt/Leistungsbeschreibung |
| `AbrechnungsquartalExt` | string | Abrechnungsquartal (z.B. "2026Q1") |
| `ScheinPositionExt` | Reference | Referenz auf die Scheinposition |
| `StatistikleistungExt` | boolean | Kennzeichnung als Statistikleistung |

## Private Billing / GOÄ

Extensions specific to GOÄ (private fee schedule) billing.

| Extension | Type | Description |
|-----------|------|-------------|
| `FaktorExt` | decimal | Steigerungsfaktor (allgemein) |
| `GoaeFaktorExt` | decimal | GOÄ-Steigerungsfaktor (1,0 - 3,5) |
| `GoaePunkteExt` | integer | GOÄ-Punktzahl |
| `MultiplierMinExt` | decimal | Minimaler Steigerungsfaktor (1,0) |
| `MultiplierDefaultExt` | decimal | Schwellenwert (z.B. 2,3) |
| `MultiplierMaxExt` | decimal | Höchstsatz (z.B. 3,5) |
| `LeistungsdatumExt` | date | Datum der Leistungserbringung |
| `RabStatusExt` | code | Status der rechnerischen Abrechnung |
| `RabRefExt` | Reference | Referenz auf den RAB-Vorgang |
| `RechFormArtExt` | code | Rechnungsformart |
| `ManualOverrideExt` | boolean | Manuell überschriebener Wert |
| `BgAktenzeichenExt` | string | BG-Aktenzeichen |
| `BgUnfalltagExt` | date | BG-Unfalltag |

## GOÄ Detail / Sachkosten

Extensions for detailed GOÄ billing: ultrasound organs, time-of-day surcharges, material costs, and analog billing.

| Extension | Type | Description |
|-----------|------|-------------|
| `GoaeOrganExt` | string | Ultraschall-Organ (GOÄ Kapitel C V) |
| `GoaeUhrzeitExt` | time | Behandlungsuhrzeit (für Unzeitzuschläge GOÄ E/F) |
| `GoaeSachkostenBezeichnungExt` | string | Sachkosten-Bezeichnung (GOÄ §10) |
| `GoaeMaterialkostenExt` | Money | Materialkosten-Betrag (GOÄ §10) |
| `SachkostenPriceExt` | Money | Sachkostenpauschale für GOÄ 0xxx-Ziffern |
| `AnalogReferenceExt` | string | Analogziffer-Referenz (GOÄ §6 Abs. 2) |

## Private Billing Workflow

Extensions tracking review and release status of private invoices.

| Extension | Type | Description |
|-----------|------|-------------|
| `PrivatFreigabeStatusExt` | string | Freigabestatus (Entwurf, Freigegeben, Versendet) |
| `PrivatReviewedStatusExt` | boolean | Ärztlich geprüft |
| `PrivatReviewedAtExt` | dateTime | Zeitpunkt der ärztlichen Prüfung |
| `ReviewedStatusExt` | string | Allgemeiner Prüfstatus einer Abrechnungsposition |
| `ReviewedAtExt` | dateTime | Zeitpunkt der Prüfung |

## EBM auf ChargeItem-Ebene

EBM detail extensions on individual ChargeItems (complementing the catalog-level extensions on ChargeItemDefinition). The concrete billed values may differ from catalog values due to surcharges or deductions.

| Extension | Type | Description |
|-----------|------|-------------|
| `EbmKapitelExt` | string | EBM-Kapitel der abgerechneten Leistung |
| `EbmPunkteExt` | decimal | Konkret abgerechnete EBM-Punktzahl |
| `EbmPruefzeitExt` | integer | Prüfzeit in Minuten |
| `EbmRlvRelevanzExt` | boolean | RLV-Relevanz der Leistung |
| `EbmEuroBetragExt` | Money | Euro-Betrag nach Orientierungspunktwert |

## RLV / Budget

Extensions for physician capitation budget management (Regelleistungsvolumen).

| Extension | Type | Description |
|-----------|------|-------------|
| `RlvKvRegionExt` | string | KV-Region (z.B. KVB, KVNO) |
| `RlvFachgruppeExt` | Coding | Fachgruppe gemäß KBV-Fachgruppenverzeichnis |
| `RlvFallwertExt` | Money | RLV-Fallwert in Euro |
| `RlvQzvFallwertExt` | Money | QZV-Fallwert in Euro |
| `RlvZugewiesenExt` | Money | Zugewiesenes RLV-Budget |
| `RlvQzvZugewiesenExt` | Money | Zugewiesenes QZV-Budget |
| `RlvEntbudgetiertExt` | boolean | Entbudgetierung (z.B. Hausärzte) |
| `RlvKategorieExt` | code | RLV-Kategorie |

## Honorarbescheid / Remittance

Extensions for KV quarterly payment statements.

| Extension | Type | Description |
|-----------|------|-------------|
| `HonorarbescheidQuartalExt` | string | Abrechnungsquartal des Honorarbescheids |
| `HonorarbescheidBsnrExt` | string | Betriebsstättennummer |
| `HonorarbescheidPatientNameExt` | string | Patientenname (aus Honorarbescheid) |
| `HonorarbescheidPatientBirthDateExt` | date | Geburtsdatum (aus Honorarbescheid) |
| `HonorarbescheidPatientRefExt` | Reference | Referenz auf den Patienten |
| `HonorarbescheidCorrectionSignExt` | code | Richtigstellungskennzeichen |

## KV Benchmark

Extensions for KV benchmark/comparison data (Fachgruppen-Durchschnittswerte).

| Extension | Type | Description |
|-----------|------|-------------|
| `KvBenchmarkKvRegionExt` | string | KV-Region |
| `KvBenchmarkFachgruppeExt` | string | Fachgruppenbezeichnung |
| `KvBenchmarkFachgruppeCodeExt` | Coding | Fachgruppen-Code (KBV BAR2) |
| `KvBenchmarkGueltigJahrExt` | integer | Gültigkeitsjahr |
| `KvBenchmarkRlvFallwertAk1Ext` | Money | RLV-Fallwert AK1 (Durchschnitt) |
| `KvBenchmarkRlvFallwertAk2Ext` | Money | RLV-Fallwert AK2 |
| `KvBenchmarkRlvFallwertAk3Ext` | Money | RLV-Fallwert AK3 |
| `KvBenchmarkDurchschnittFallzahlExt` | integer | Durchschnittliche Fallzahl der Fachgruppe |
| `KvBenchmarkAuszahlungsquoteExt` | decimal | Auszahlungsquote in Prozent |
| `KvBenchmarkHonorarJeFallExt` | Money | Durchschnittliches Honorar je Fall |
| `KvBenchmarkQzvBereicheExt` | string | QZV-Bereiche der Fachgruppe |

## Zeitbudget

Extensions for KBV time budget management (Prüfzeit).

| Extension | Type | Description |
|-----------|------|-------------|
| `ZeitbudgetMaxMinutenExt` | integer | Maximale Prüfzeit in Minuten pro Quartal |
| `ZeitbudgetAbrechnungskreiseExt` | string | Zugehörige Abrechnungskreise |

## HVG / Selektivverträge

Extensions for selective contracts (§73b/§73c SGB V). Base contract data maps to the FHIR Contract resource; only genuinely additional fields are modeled as extensions.

| Extension | Type | Description |
|-----------|------|-------------|
| `HvgFacharztvertragExt` | boolean | Facharztvertrag-Kennzeichen (§73c SGB V) |
| `HvgKennungExt` | string | Eindeutige Vertragskennung beim Kostenträger |

## BGT2001 / BG-Tarif

Extensions for occupational accident tariff positions (supplements dguv.basis dependency).

| Extension | Type | Description |
|-----------|------|-------------|
| `BgtPunkteExt` | decimal | BGT-Punktzahl |
| `BgtKatalogGruppeExt` | string | Obergruppe im BGT2001-Katalog |
| `BgtKatalogUntergruppeExt` | string | Untergruppe im BGT2001-Katalog |

## Price History

Complex extension for historical pricing on ChargeItemDefinition catalog entries.

| Extension | Type | Description |
|-----------|------|-------------|
| `PriceHistoryExt` | complex | Container mit Gültigkeitszeitraum und historischen Werten |
| `PriceHistoryExt.validFrom` | date | Gültig ab |
| `PriceHistoryExt.validTo` | date | Gültig bis |
| `PriceHistoryExt.points` | decimal | Historischer Punktwert |
| `PriceHistoryExt.euroValue` | Money | Historischer Euro-Betrag |

## Condition / Diagnose

Extensions for German-specific diagnosis metadata.

| Extension | Type | Description |
|-----------|------|-------------|
| `DauerdiagnoseExt` | boolean | Kennzeichnung als Dauerdiagnose |
| `DiagnoseSeiteExt` | Coding | Seitenangabe (Links, Rechts, Beidseitig) |

## AI Provenance

Extensions for EU AI Act Art. 50 compliance — tracking AI-generated content.

| Extension | Type | Description |
|-----------|------|-------------|
| `AiGeneratedExt` | Coding | Art der KI-Beteiligung (generiert, unterstützt) |
| `AiProviderExt` | string | KI-Anbieter/Hersteller |
| `AiModelExt` | string | KI-Modellversion |
| `AiTimestampExt` | dateTime | Zeitpunkt der KI-Generierung |
| `AiPurposeExt` | string | Zweck des KI-Einsatzes |
| `HumanReviewedExt` | boolean | Durch einen Menschen geprüft |
| `HumanReviewerExt` | Reference | Prüfende Person |
| `HumanReviewTimestampExt` | dateTime | Zeitpunkt der menschlichen Prüfung |

## Genehmigung / KV Approvals

Complex extension for KV-regulated service approvals (Leistungsbereichs-Genehmigungen).

| Extension | Type | Description |
|-----------|------|-------------|
| `GenehmigungenExt` | complex | Container für Genehmigungsinformationen |
| `GenehmigungenExt.leistungsbereich` | Coding | Genehmigter Leistungsbereich (z.B. Chirotherapie, Sonographie) |
| `GenehmigungenExt.typ` | Coding | Genehmigungstyp: kopfbezogen oder betriebsstättenbezogen |
| `GenehmigungenExt.gueltigAb` | date | Gültig ab |
| `GenehmigungenExt.gueltigBis` | date | Gültig bis |
| `GenehmigungenTypExt` | Coding | Standalone-Genehmigungstyp (kopfbezogen/betriebsstätte) |

## Cross-Abrechnungskreis / MVZ

Extensions for multi-physician practices (MVZ) where billing crosses between physicians.

| Extension | Type | Description |
|-----------|------|-------------|
| `CrossAkIsPrimaryExt` | boolean | Primärer Abrechnungskreis |
| `CrossAkBilledUnderExt` | Reference | Abgerechnet unter anderem Abrechnungskreis |

## WB / Sicherstellungsassistent

Extensions for training physicians and locum doctors.

| Extension | Type | Description |
|-----------|------|-------------|
| `WbRolleExt` | Coding | Rolle: WB-Assistent oder Sicherstellungsassistent |
| `WbAbrechnenderArztExt` | Reference | Abrechnender Arzt (Supervisor) |

## Insurance / Kasse

Extensions for health insurance fund metadata.

| Extension | Type | Description |
|-----------|------|-------------|
| `KassennameExt` | string | Name der Krankenkasse |
| `KassennummerExt` | string | IK-Nummer der Krankenkasse |

## Accounts Receivable / Offene Posten

Extensions for managing open invoices and dunning.

| Extension | Type | Description |
|-----------|------|-------------|
| `RechnungsbetragExt` | Money | Rechnungsbetrag |
| `OpSollExt` | Money | Soll-Betrag (offener Posten) |
| `OpHabenExt` | Money | Haben-Betrag (Zahlungseingänge) |
| `MahnstufeExt` | integer | Aktuelle Mahnstufe (0-3) |
| `MahnsperreExt` | boolean | Mahnsperre gesetzt |
| `FaelligkeitsdatumExt` | date | Fälligkeitsdatum der Rechnung |
| `LetzteMahnungExt` | date | Datum der letzten Mahnung |
| `MahngebuehrExt` | Money | Mahngebühr |
| `OpRefExt` | Reference | Referenz auf den offenen Posten |

## Payment / Zahlung

Extensions for payment tracking.

| Extension | Type | Description |
|-----------|------|-------------|
| `ZahlungsartExt` | code | Zahlungsart (bar, Überweisung, EC, etc.) |
| `PaymentPatientRefExt` | Reference | Referenz auf den zahlenden Patienten |

## Referral / Überweisung

Extensions for referral management and optimization.

| Extension | Type | Description |
|-----------|------|-------------|
| `UeFachrichtungExt` | Coding | Ziel-Fachrichtung der Überweisung |
| `UeUnfallExt` | boolean | Überweisungskennzeichen: Unfall |
| `ReferralSugTypeExt` | code | Überweisungstyp (Auftragsleistung, Konsiliarauftrag, etc.) |
| `ReferralCrossArztgruppeExt` | Coding | Fachgruppenübergreifende Überweisung |
| `ReferralOptimizationStatusExt` | code | Optimierungsstatus (z.B. Budget-Impact) |
| `ReferralOptimizationDeltaExt` | Money | Budget-Delta der Überweisungsoptimierung |

## Organization / Betriebsstätte

Extensions for practice-level administrative data on Organization resources.

| Extension | Type | Description |
|-----------|------|-------------|
| `BankAccountExt` | Complex | Bankverbindung der Praxis (wiederholbar — mehrere Konten möglich) |
| `BankAccountExt.iban` | string (1..1) | IBAN (Pflichtfeld) |
| `BankAccountExt.bic` | string (0..1) | BIC / SWIFT-Code |
| `BankAccountExt.bankname` | string (0..1) | Name des Kreditinstituts |
| `BankAccountExt.kontoinhaber` | string (0..1) | Kontoinhaber |

## Hospital Admission / Krankenhauseinweisung

Extensions for hospital admission forms (Einweisungsschein).

| Extension | Type | Description |
|-----------|------|-------------|
| `KheKrankenhausExt` | string | Name des Krankenhauses |
| `KheDiagnoseExt` | string | Einweisungsdiagnose (Freitext) |
| `KheIcdExt` | Coding | Einweisungsdiagnose (ICD-10-GM) |
| `KheBelegarztExt` | boolean | Belegärztliche Behandlung |
| `KheNotfallExt` | boolean | Notfalleinweisung |
| `KheUnfallExt` | boolean | Unfallbedingte Einweisung |
| `KheBvgExt` | boolean | BVG-Einweisung (Bundesversorgungsgesetz) |

## Consent / Einwilligung

Extensions for patient consent management in the practice.

| Extension | Type | Description |
|-----------|------|-------------|
| `EinwilligungKuerzelExt` | string | Kürzel/Code der Einwilligung |
| `EinwilligungZielgruppeExt` | code | Zielgruppe (Patient, Betreuer, etc.) |
| `EinwilligungWiderrufMoeglichExt` | boolean | Widerruf möglich |
| `EinwilligungGueltigkeitsdauerExt` | Duration | Gültigkeitsdauer der Einwilligung |
| `EinwilligungAuswahlExt` | code | Auswahl des Patienten (Ja/Nein) |
| `EinwilligungScheinNummerExt` | string | Zugehörige Scheinnummer |
| `EinwilligungTextExt` | string | Einwilligungstext |

## AU / Arbeitsunfähigkeit

Extensions for certificates of incapacity for work (AU-Bescheinigung).

| Extension | Type | Description |
|-----------|------|-------------|
| `AuTypExt` | code | AU-Typ (Erstbescheinigung, Folgebescheinigung) |
| `AuVonDatumExt` | date | AU-Beginn (Feststellungsdatum) |
| `AuBisDatumExt` | date | Voraussichtlich arbeitsunfähig bis |
| `AuEnddatumExt` | date | Tatsächliches Ende der AU |
| `AuArbeitsunfallExt` | boolean | Arbeitsunfall (BG-relevant) |

## Appointment / Termin

Extensions for appointment scheduling and mode of consultation.

| Extension | Type | Description |
|-----------|------|-------------|
| `AppointmentModeExt` | code | Terminmodus (Praxisbesuch, Videosprechstunde, Telefontermin, Hausbesuch) |
