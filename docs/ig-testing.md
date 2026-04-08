# IG Testing mit Aidbox

Dieses Dokument beschreibt, wie der FHIR IG `de.cognovis.fhir.praxis` in Aidbox installiert und
getestet wird. Alle Tests sind als [httpyac](https://httpyac.github.io/)-Dateien im Verzeichnis
`test/` gespeichert.

## Voraussetzungen

- Aidbox läuft auf `http://localhost:8080`
- Aidbox Basic-Auth: `basic:secret`
- httpyac CLI installiert: `npm install -g httpyac` oder via `npx httpyac`

> **Warnung:** Die Basic-Auth-Credentials (`basic:secret`) gelten nur für die lokale Entwicklungsumgebung.
> Für Staging/Produktion eigene Credentials verwenden.

## IG als Package in Aidbox installieren

### Option A: Via Aidbox Package-Manager (empfohlen)

Aidbox unterstützt das Laden von FHIR-Packages direkt über die Admin-Konsole oder API.

1. Öffne die Aidbox Admin-Konsole: `http://localhost:8080/ui/console`
2. Navigiere zu **Packages** → **Install Package**
3. Gib `de.cognovis.fhir.praxis` und die gewünschte Version ein
4. Aidbox lädt das Package von der konfigurierten Registry

### Option B: Einzelne StructureDefinitions hochladen (Fallback)

Falls der Package-Manager nicht verfügbar ist, können einzelne Definitionen via FHIR REST API
hochgeladen werden. Das Paket enthält alle Definitionen im Verzeichnis `fsh-generated/resources/`.

```bash
# Beispiel: Alle StructureDefinitions hochladen
for f in fsh-generated/resources/StructureDefinition-*.json; do
  curl -s -X PUT \
    -H "Authorization: Basic basic:secret" \
    -H "Content-Type: application/fhir+json" \
    --data-binary "@$f" \
    "http://localhost:8080/fhir/StructureDefinition/$(jq -r .id "$f")"
done

# CodeSystems hochladen
for f in fsh-generated/resources/CodeSystem-*.json; do
  curl -s -X PUT \
    -H "Authorization: Basic basic:secret" \
    -H "Content-Type: application/fhir+json" \
    --data-binary "@$f" \
    "http://localhost:8080/fhir/CodeSystem/$(jq -r .id "$f")"
done

# ValueSets hochladen
for f in fsh-generated/resources/ValueSet-*.json; do
  curl -s -X PUT \
    -H "Authorization: Basic basic:secret" \
    -H "Content-Type: application/fhir+json" \
    --data-binary "@$f" \
    "http://localhost:8080/fhir/ValueSet/$(jq -r .id "$f")"
done
```

## Tests ausführen

### Alle Tests auf einmal

```bash
# Alle Profile-Tests
npx httpyac send "test/Profile/*.http" --all

# Alle ValueSet-Tests
npx httpyac send "test/VS/*.http" --all

# Alle CodeSystem-Tests
npx httpyac send "test/CS/*.http" --all

# Komplett-Run
npx httpyac send "test/**/*.http" --all
```

### Einzelne Dateien

```bash
# Nur Condition-Tests
npx httpyac send test/Profile/condition.http --all

# Nur Scheinart ValueSet-Tests
npx httpyac send test/VS/scheinart.http --all
```

### Mit Ausgabe (verbose)

```bash
npx httpyac send test/Profile/lab-observation.http --all --output response
```

## Test-Struktur

```
test/
├── CS/          # CodeSystem Concept-API-Tests
│   ├── scheinart.http
│   ├── dokument-kategorie.http
│   └── ...
├── VS/          # ValueSet $expand und $validate-code Tests
│   ├── scheinart.http
│   ├── scheinuntergruppe.http
│   └── ...
└── Profile/     # Profil-Validierungstests (POST $validate)
    ├── condition.http
    ├── lab-observation.http
    ├── procedure.http
    └── ...
```

### CS-Tests (CodeSystem)

Verwenden die Aidbox Concept-API (`GET /Concept?system=...&code=...`) anstelle von `$lookup`,
da `$lookup` in Aidbox nicht implementiert ist.

- **Gültige Codes** → Antwort enthält einen Concept-Eintrag
- **Ungültige Codes** → Leeres Bundle (`entry` fehlt oder `total=0`)

### VS-Tests (ValueSet)

- `$expand` → alle Codes im ValueSet ausgeliefert
- `$validate-code` mit gültigem Code → `result=true` in Parameters
- `$validate-code` mit ungültigem Code → `result=false`

### Profil-Tests (Profile)

Alle Tests verwenden `POST /fhir/{Resource}/$validate?profile=<url>` mit einem JSON-Body.

- **Happy-Path-Tests** → `?? status == 200` (OperationOutcome ohne Fehler)
- **Negativ-Tests** → `?? status == 200` und `?? body.issue[0].severity == "error"`

> **Hinweis:** `$validate` gibt immer HTTP 200 zurück; der Fehler steckt im OperationOutcome-Body.

## Negativ-Tests

Jedes Kernprofil hat mindestens einen Negativ-Test, der prüft, ob das Profil ungültige Ressourcen
korrekt ablehnt. Folgende Negativ-Tests sind vorhanden:

<!-- Snapshot Stand: April 2026 -->

| Profil | Test-Name (`@name`) | Datei | Erwarteter Fehler |
|--------|---------------------|-------|-------------------|
| PraxisCondition | `validate-condition-wrong-system` | condition.http | ICD-10-GM-Slice nicht erfüllt (SNOMED statt ICD-10-GM) |
| PraxisLabObservation | `validate-lab-obs-missing-category` | lab-observation.http | `category 1..*` verletzt |
| PraxisLabObservation | `validate-lab-obs-no-coding` | lab-observation.http | Invariant `praxis-lab-obs-code` verletzt |
| ProcedureAmbulantDE | `validate-procedure-missing-code` | procedure.http | `code 1..1` verletzt |
| ProcedureAmbulantDE | `validate-procedure-ops-missing-version` | procedure.http | OPS `version 1..1` verletzt |
| PraxisDevice | `validate-device-missing-status` | device.http | `status 1..1` verletzt (FHIR R4 Base) |
| FPDEPatient | `validate-patient-invalid-birthdate` | patient-demografie.http | FHIR `date`-Typ ungültig |
| PraxisSpecimen | `validate-specimen-missing-type` | specimen.http | `type 1..1` verletzt |
| CareTeamDE | `validate-care-team-missing-status` | care-team.http | `status 1..1` verletzt |
| InsurancePlanDE | `validate-insurance-plan-missing-status` | insurance-plan.http | `status 1..1` verletzt |

## Bekannte Aidbox-Besonderheiten

- `$lookup` ist nicht implementiert → stattdessen `GET /Concept?system=...&code=...`
- Coverage.identifier Patterns können zu Aidbox-spezifischen Warnungen führen (Quirk)
- Strikte Validierung muss in Aidbox global aktiviert sein (siehe `AIDBOX_FHIR_STRICT=true`)
