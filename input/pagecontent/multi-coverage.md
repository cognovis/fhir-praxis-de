# Multi-Coverage Linking Pattern

## Übersicht

In der deutschen ambulanten Praxis treten regelmäßig Szenarien auf, in denen ein Patient durch mehrere Kostenträger versichert ist. Typische Beispiele:

- **GKV + ZZV (Zahnzusatzversicherung):** Der GKV-Anteil bei Zahnersatz wird durch eine private Zahnzusatzversicherung ergänzt.
- **GKV + PKV-Zusatz (KFO):** Kieferorthopädische Leistungen mit GKV-Grundversorgung und privatem Zusatzanteil.
- **PKV + Beihilfe:** Beamte sind typischerweise privat krankenversichert (PKV) und erhalten zusätzlich staatliche Beihilfe.

## Coverage.order — Einschränkung durch de.basisprofil.r4

Das FHIR R4 Basisfeld `Coverage.order` (Typ: `positiveInt`) wird in den deutschen Basisprofilen (`de.basisprofil.r4`) auf `max=0` eingeschränkt — es ist in `coverage-de-gkv` und `coverage-de-basis` **nicht verwendbar**.

Für das Multi-Coverage-Linking stehen stattdessen folgende Standardmechanismen zur Verfügung:

| Feld | Verfügbarkeit | Verwendungszweck |
|------|---------------|-----------------|
| `Coverage.order` | **Nicht verfügbar** (max=0 in de.basisprofil.r4) | — |
| `Coverage.subrogation` | Verfügbar (FHIR R4 Basis 0..1, in de.basisprofil.r4 nicht eingeschränkt) | Koordinierte Leistungserbringung (Beihilfe) |
| `Account.coverage.priority` | Verfügbar (FHIR R4 Account) | Abrechnungsreihenfolge im Account |

## Coverage.subrogation — Koordinierte Leistungserbringung

Das Feld `Coverage.subrogation` (FHIR R4 Typ: `boolean`, Kardinalität: 0..1) signalisiert,
dass der Kostenträger Informationen für die Kostenrückforderung von einem anderen Zahler bereitstellt.

**Semantik in FHIR R4:** "Subrogation" bezeichnet das Recht eines Versicherers, Kosten von einem Dritten
zurückzufordern — z. B. bei Unfällen (Berufsgenossenschaft vs. privater Haftpflicht).

**Beihilfe-PKV-Szenario:** Beihilfe und PKV sind **parallele Zahler**, nicht ein Rückforderungsverhältnis.
Beihilfe erstattet typischerweise 50% der Kosten, die PKV die verbleibenden 50% — unabhängig voneinander.
Ein direktes Regressrecht der Beihilfe gegenüber der PKV besteht nicht.

In diesem IG wird `subrogation=true` auf der Beihilfe-Coverage als **pragmatisches Marker-Flag** gesetzt,
um das koordinierte Leistungsverhältnis (coordinated benefit) zwischen staatlicher Beihilfe und
privater Krankenversicherung zu signalisieren. Dies weicht vom strengen FHIR-R4-Subrogations-Semantic ab
und ist eine projektspezifische Konvention.

**Empfehlung:** `subrogation = true` auf der Beihilfe-Coverage setzen, um das koordinierte Leistungsverhältnis
zu markieren, mit Verständnis des semantischen Unterschieds zur FHIR-R4-Definition.

## Account.coverage.priority — Abrechnungsreihenfolge

Das `Account`-Backbone-Element `Account.coverage.priority` (Typ: `positiveInt`, Kardinalität: 0..1) ist der empfohlene Mechanismus zur Steuerung der Abrechnungsreihenfolge bei Multi-Coverage-Szenarien:

| Wert | Bedeutung |
|------|-----------|
| `1`  | Primärer Kostenträger (zuerst abrechnen) |
| `2`  | Sekundärer Kostenträger |
| `3`  | Tertiärer Kostenträger |

```
Account.coverage[0].coverage  → Reference(GKV-Coverage)
Account.coverage[0].priority  → 1  // primary billing
Account.coverage[1].coverage  → Reference(ZZV-Coverage)
Account.coverage[1].priority  → 2  // secondary billing
```

Der Account verknüpft mehrere Coverages mit expliziter Priorität, ohne auf das in de.basisprofil.r4 gesperrte `Coverage.order`-Feld angewiesen zu sein.

## Entscheidung: Keine neue Extension notwendig

Die Standardfelder `Coverage.subrogation` und `Account.coverage.priority` decken alle drei deutschen Multi-Coverage-Szenarien vollständig ab. Eine projektspezifische Linking-Extension ist nicht erforderlich:

| Szenario | Primär | Sekundär | Mechanismus |
|----------|--------|----------|-------------|
| ZE GKV + ZZV | GKV | ZZV/PKV | `Account.coverage.priority` |
| KFO GKV + PKV-Zusatz | GKV | PKV-Zusatz | `Account.coverage.priority` |
| Beihilfe + PKV | PKV | Beihilfe | `Account.coverage.priority` + `subrogation=true` |

**Hinweis:** Das FHIR R4 Basisfeld `Coverage.order` ist in den deutschen Profilen (de.basisprofil.r4) auf `max=0` eingeschränkt und kann nicht verwendet werden. Dies ist eine bewusste Designentscheidung der deutschen FHIR-Community, die den Account als Bindeglied für die Kostenträger-Priorisierung vorsieht.

## Beihilfe-Kodierung

Für Beihilfe-Coverage gibt es **keinen dedizierten Code** im deutschen CodeSystem `versicherungsart-de-basis`. Der Code `#SKT` (Sonstige Kostenträger) wird verwendet:

```fsh
* type.coding[0].system = "http://fhir.de/CodeSystem/versicherungsart-de-basis"
* type.coding[0].code = #SKT
* type.coding[0].display = "Sonstige Kostentraeger (Beihilfe)"
* subrogation = true
```

**Wichtig:** Für Beihilfe-Coverage MUSS `InstanceOf: http://fhir.de/StructureDefinition/coverage-de-basis` verwendet werden (NICHT `FPDECoveragePrivat`), da die Invariante `fpde-coverage-privat-type` nur `PKV` und `SEL` erlaubt.

## Beispielszenarien

Die folgenden drei Beispiel-Bundles illustrieren das Pattern:

### Bundle 1: Zahnersatz (ZE) — GKV + ZZV

Patient Weber ist GKV-versichert. Seine Zahnzusatzversicherung (DKV ZZV Premium) übernimmt den privaten Anteil bei Zahnersatz.

- `ExampleCoverageGkvZe`: GKV TK (primary)
- `ExampleCoverageZzvZe`: ZZV/PKV DKV (secondary)
- `ExampleAccountZe`: Account mit `coverage.priority` 1 (GKV) + 2 (ZZV)
- Bundle: `ExampleBundleZeMultiCoverage`

### Bundle 2: Kieferorthopädie (KFO) — GKV + PKV-Zusatz

Patientin Mueller ist GKV-versichert. Eine PKV-Zusatzversicherung übernimmt den über den GKV-Festzuschuss hinausgehenden KFO-Anteil.

- `ExampleCoverageGkvKfo`: GKV AOK (primary)
- `ExampleCoveragePkvZusatzKfo`: PKV-Zusatz ERGO (secondary)
- `ExampleAccountKfo`: Account mit `coverage.priority` 1 (GKV) + 2 (PKV-Zusatz)
- Bundle: `ExampleBundleKfoMultiCoverage`

### Bundle 3: Beamter — PKV + Beihilfe

Beamter Schneider ist privat krankenversichert. Die Beihilfestelle des Landes erstattet den beihilfefähigen Anteil (paralleler Zahler; `subrogation=true` als Marker für das koordinierte Leistungsverhältnis).

- `ExampleCoveragePkvBeamter`: PKV Allianz (primary)
- `ExampleCoverageBeihilfe`: Beihilfe SKT, `subrogation=true` (secondary)
- `ExampleAccountBeihilfe`: Account mit `coverage.priority` 1 (PKV) + 2 (Beihilfe)
- Bundle: `ExampleBundleBeihilfeMultiCoverage`

## Referenzen

- [FHIR R4 Coverage Resource](https://hl7.org/fhir/R4/coverage.html)
- [FHIR R4 Account Resource](https://hl7.org/fhir/R4/account.html)
- [de.basisprofil.r4 Coverage-GKV](http://fhir.de/StructureDefinition/coverage-de-gkv)
- [de.basisprofil.r4 Coverage-Basis](http://fhir.de/StructureDefinition/coverage-de-basis)
