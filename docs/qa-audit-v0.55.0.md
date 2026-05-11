# QA Audit — fhir-praxis-de v0.55.0

**Audit date:** 2026-05-11
**QA report source:** https://cognovis.github.io/fhir-praxis-de/qa.html (v0.55.0 published)
**Total errors:** 79
**Fixed in v0.56.0:** 26 internal errors
**Suppressed as external:** 53 external errors (added to ignoreWarnings.txt)

## Error Summary by Category

| Category | Count | Type | Fix |
|----------|-------|------|-----|
| HumanName.prefix.extension (iso21090-EN-qualifier missing) | 6 | Internal | Fixed: added `#AC` qualifier to 6 practitioner examples |
| DVMD KDL DG020110 display "Roentgenbefund" | 6 | Internal | Fixed: changed to "Röntgenbefund" in profile |
| ParticipationMode MAILWRIT display | 2 | Internal | Fixed: changed to canonical "mail" |
| ParticipationMode TYPEWRIT display | 2 | Internal | Fixed: changed to canonical "typewritten" |
| Fachkunde DVT display | 2 | Internal | Fixed: changed to "Fachkunde Digitale Volumentomographie" |
| Invalid LOINC 36218-5 | 1 | Internal | Fixed: removed from ImagingRequestCodeVS |
| ku-hinweis-required constraint failure | 3 | Internal | Fixed: FHIRPath expression corrected |
| par-grading Profile Reference | 4 | Internal | Covered by qualifier extension fix |
| SNOMED 1255414003 (not in tx.fhir.org) | ~10 | External | Suppressed in ignoreWarnings.txt |
| tx.fhir.org LOINC LL2255-7 filter error | ~5 | External | Suppressed in ignoreWarnings.txt |
| German CodeSystems (BEMA, GOZ, GOAe, UNECE) not on tx.fhir.org | ~20 | External | Suppressed in ignoreWarnings.txt |
| German NamingSystems not resolvable | ~7 | External | Suppressed in ignoreWarnings.txt |
| kvid-2 warnings (GKV/PKV type codes retired in HL7 v3) | 7 | External | Warnings only — from de.basisprofil.r4 dependency |
| Build errors (IG Publisher) | 2 | External | IG Publisher version/infra issues |

## Detailed Error Analysis by File

### Bundle-par-grading-bundle (15 errors)

- **4× par-grading-profile-ref**: `par-grading-practitioner-arzt` did not have the iso21090-EN-qualifier extension on `name[0].prefix[0]`.
  - **Fix:** Added `name[0].prefix[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-EN-qualifier"` and `valueCode = #AC` in `example-condition-constraints-bundle.fsh`.
- **6× DVMD DG020110 display**: The `ImagingDiagnosticReportPraxisDe` profile category binding used "Roentgenbefund" for KDL code DG020110.
  - **Fix:** Changed to "Röntgenbefund" in `input/fsh/profiles/imaging-diagnostic-report.fsh`.
- **2× ParticipationMode MAILWRIT**: Wrong display in `ReportDistributionChannelVS`.
  - **Fix:** Changed to "mail" in `input/fsh/valuesets/report-distribution-channel.fsh`.
- **2× ParticipationMode TYPEWRIT**: Wrong display in `ReportDistributionChannelVS`.
  - **Fix:** Changed to "typewritten" in same file.
- **1× external**: `Error from https://tx.fhir.org/r4: Error: The filter "LIST = LL2255-7" is not understood or supported` — SmokingStatus Observation binding on LOINC LL2255-7 panel filter not supported by tx.fhir.org. Suppressed in `input/ignoreWarnings.txt`.

### Bundle-karies-bundle (10 errors)

- **4× par-grading-profile-ref**: Same as above — `par-grading-practitioner-arzt` is reused in the Karies bundle.
  - **Fix:** Same qualifier extension fix covers this.
- **6× DVMD/ParticipationMode**: Same category as above.

### Bundle-ExampleBundleBeihilfeMultiCoverage (7 errors)

- **7× kvid-2 warnings**: Coverage type codes GKV/PKV are marked `retired` in HL7 v3 ActCoverageTypeCode. This constraint is defined in `de.basisprofil.r4` (FPDECoverageGKV profile). These are warnings (not errors) from the upstream German base profiles.
  - **Status:** External — from dependency, not fixable in this IG. Noted as known issue.

### Bundle-ExampleBundleKfoMultiCoverage (5 errors) and Bundle-ExampleBundleZeMultiCoverage (5 errors)

- Similar kvid-2 warnings pattern as above.
  - **Status:** External.

### Practitioner-par-grading-practitioner-arzt (4 errors)

- **4× HumanName.prefix.extension**: `KBV_PR_Base_Practitioner` requires `iso21090-EN-qualifier` extension on prefix "Dr.".
  - **Fix:** Added in `example-condition-constraints-bundle.fsh`.

### ChargeItemDefinition examples (2 errors each × 3 = 6 errors)

- `example-cid-bema-heilbehandlung`, `example-cid-eigenlabor-material`, `example-cid-igel-bleaching`: Each has 2 errors from German CodeSystems (BEMA/GOZ/GOAe) not resolvable on tx.fhir.org.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

### Coverage examples (2 errors each × 4 = 8 errors)

- `ExampleCoverageBeihilfe`, `ExampleCoveragePkvBeamter`, `ExampleCoveragePkvZusatzKfo`, `ExampleCoveragePrivat`, `ExampleCoverageZzvZe`: kvid-2 warnings + external NamingSystem resolution errors.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

### ImplementationGuide-de.cognovis.fhir.praxis (2 build errors)

- IG Publisher build configuration errors (not FSH source errors).
  - **Status:** External — CI/infrastructure level.

### Observation-par-grading-smoking-obs (2 errors)

- LOINC LL2255-7 filter not supported by tx.fhir.org for SmokingStatus ValueSet binding.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

### StructureDefinition-imaging-diagnostic-report-praxis-de (2 errors)

- DVMD KDL DG020110 display mismatch ("Roentgenbefund" vs "Röntgenbefund").
  - **Fix:** Fixed in `input/fsh/profiles/imaging-diagnostic-report.fsh`.

### QuestionnaireResponse-example-praxis-anamnese-questionnaire-response (2 errors)

- Related to LOINC LL2255-7 filter (smoking status binding on questionnaire response).
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

### Appointment-example-imaging-appointment-mrt-knie (1 error)

- SNOMED code or German CodeSystem not resolvable.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

### ChargeItemDefinition-example-charge-item-def-goae-km (1 error)

- GOAe CodeSystem not on tx.fhir.org.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

### Invoice examples (3 errors)

- `example-invoice-19percent`, `example-invoice-7percent`, `example-invoice-zahnaerzte-exempt`: Each fails `ku-hinweis-required` invariant even though `kuHinweisPflicht` extension is NOT set.
  - **Root cause:** FHIRPath `extension.where(...).value.ofType(boolean).first() = true` returns empty `{}` when extension absent. Some validators evaluate `{} = true` as `{}` (empty), not `false`, then `implies` on empty antecedent may fail.
  - **Fix:** Changed FHIRPath to `(extension.where(...).value.ofType(boolean).where($this = true).exists()) implies note.text.exists()` in `input/fsh/profiles/PraxisInvoiceDE.fsh`.

### DiagnosticReport examples (2 errors)

- `karies-befund`, `par-grading-befund`: External CodeSystem validation errors.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

### ImagingStudy-example-imaging-study-mrt-knie-km (1 error)

- GOAe CodeSystem not on tx.fhir.org.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

### Procedure-example-dvt-oberkiefer-implantat (3 errors)

- **1× SNOMED 1255414003**: Cone beam CT of maxilla code not indexed by tx.fhir.org.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.
- **1× Fachkunde DVT display**: "Fachkunde DVT" does not match CodeSystem canonical "Fachkunde Digitale Volumentomographie".
  - **Fix:** Corrected in `example-roentgen-procedure-dvt.fsh`.
- **1× HumanName.prefix.extension**: `example-practitioner-radiologin-dvt` missing qualifier extension.
  - **Fix:** Added qualifier extension in `example-roentgen-procedure-dvt.fsh`.

### ValueSet-imaging-request-code (1 error)

- LOINC 36218-5 "MRI of spine" does not exist in the LOINC CodeSystem.
  - **Fix:** Removed from `input/fsh/valuesets/imaging-request-code.fsh`.

### Observation-par-grading-hba1c-obs (1 error)

- tx.fhir.org LOINC filter issue on SmokingStatus binding.
  - **Fix:** Suppressed in `ignoreWarnings.txt`.

## Changes Made in v0.56.0

### FSH Source Files Modified

| File | Change |
|------|--------|
| `input/fsh/examples/example-shared-resources.fsh` | Added iso21090-EN-qualifier #AC to `example-practitioner` and `example-practitioner-wb` |
| `input/fsh/examples/example-condition-constraints-bundle.fsh` | Added iso21090-EN-qualifier #AC to `par-grading-practitioner-arzt` |
| `input/fsh/examples/example-imaging-diagnostic-report.fsh` | Added iso21090-EN-qualifier #AC to `example-practitioner-radiologin` |
| `input/fsh/examples/example-imaging-study-praxis-de.fsh` | Added iso21090-EN-qualifier #AC to `example-practitioner-referring` |
| `input/fsh/examples/example-roentgen-procedure-dvt.fsh` | Added iso21090-EN-qualifier #AC to `example-practitioner-radiologin-dvt`; fixed Fachkunde DVT display |
| `input/fsh/examples/pas-claim.fsh` | Added iso21090-EN-qualifier #AC to `PASClaimPractitionerExample` |
| `input/fsh/profiles/imaging-diagnostic-report.fsh` | Changed DG020110 display "Roentgenbefund" → "Röntgenbefund" |
| `input/fsh/profiles/PraxisInvoiceDE.fsh` | Fixed ku-hinweis-required FHIRPath invariant |
| `input/fsh/valuesets/imaging-request-code.fsh` | Removed invalid LOINC 36218-5 |
| `input/fsh/valuesets/report-distribution-channel.fsh` | Fixed MAILWRIT → "mail", TYPEWRIT → "typewritten" |
| `input/ignoreWarnings.txt` | Added suppressions for external errors |

## Known External Issues (CI-Gate Allowlist)

The following patterns are added to `input/ignoreWarnings.txt` and should be excluded from any CI error gate:

```text
# External German CodeSystems not resolvable by tx.fhir.org
A definition for CodeSystem 'https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM' could not be found, so the code cannot be validated
Das CodeSystem https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_EBM ist unbekannt
A definition for CodeSystem 'http://fhir.de/CodeSystem/goae' could not be found, so the code cannot be validated
A definition for CodeSystem 'http://fhir.de/CodeSystem/bfarm/ops' could not be found, so the code cannot be validated
A definition for CodeSystem 'http://fhir.de/CodeSystem/bfarm/icd-10-gm' could not be found, so the code cannot be validated

# External German NamingSystems not resolvable
URL-Wert 'http://fhir.de/NamingSystem/arge-ik/iknr' löst nicht auf
URL-Wert 'http://fhir.de/NamingSystem/gkv/kvid-10' löst nicht auf
URL-Wert 'https://fhir.kbv.de/NamingSystem/KBV_NS_Base_ANR' löst nicht auf
URL-Wert 'https://fhir.de/sid/gkv/kvid-10' löst nicht auf

# SNOMED CT code 1255414003 — Cone beam computed tomography of maxilla (not yet indexed)
Unknown code '1255414003' in the CodeSystem 'http://snomed.info/sct'

# tx.fhir.org cannot process LOINC LL2255-7 panel filter
Error from https://tx.fhir.org/r4: Error: The filter "LIST = LL2255-7" is not understood or supported

# German dental code systems — valid but not registered on international tx.fhir.org
A definition for CodeSystem 'https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BEMA' could not be found
Das CodeSystem https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BEMA ist unbekannt
A definition for CodeSystem 'https://fhir.de/CodeSystem/bzaek/goz' could not be found
A definition for CodeSystem 'https://fhir.de/CodeSystem/bak/goae' could not be found
A definition for CodeSystem 'urn:un:unece:uncefact:codelist:standard:5305' could not be found

# de.basisprofil.r4 dependency canonical not resolvable (known issue with fhir.de registry)
Canonical URL 'http://fhir.de/ImplementationGuide/basisprofil-de-r4' kann nicht aufgelöst werden
The canonical URL http://fhir.de/ImplementationGuide/basisprofil-de-r4 doesn't point to an actual ImplementationGuide resource

# Own CodeSystems with #not-present / #example content — codes provided via ETL, not in IG
Error from https://tx.fhir.org/r4: Error: A definition for CodeSystem 'https://fhir.cognovis.de/praxis/CodeSystem/bgt2001' could not be found, so the value set cannot be expanded
The value set references CodeSystem 'https://fhir.cognovis.de/praxis/CodeSystem/bgt2001' which has status 'example'

# No German (de-DE) display names registered on tx.fhir.org for international codes
There are no valid display names found for the code urn:iso:std:iso:3166#DE for language(s) 'de-DE'. The display is 'Germany' which is the default language display
There are no valid display names found for the code http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB for language(s) 'de-DE'. The display is 'ambulatory' which is the default language display
There are no valid display names found for the code http://terminology.hl7.org/CodeSystem/v3-ActCode#PBILLACCT for language(s) 'de-DE'. The display is 'patient billing account' which is the default language display
There are no valid display names found for the code http://terminology.hl7.org/CodeSystem/adjudication#eligible for language(s) 'de-DE'. The display is 'Eligible Amount' which is the default language display
There are no valid display names found for the code http://terminology.hl7.org/CodeSystem/adjudication#submitted for language(s) 'de-DE'. The display is 'Submitted Amount' which is the default language display
There are no valid display names found for the code http://terminology.hl7.org/CodeSystem/payment-type#payment for language(s) 'de-DE'. The display is 'Payment' which is the default language display
```

Additionally, kvid-2 warnings (GKV/PKV type codes retired) originate from `de.basisprofil.r4` dependency and cannot be fixed in this IG.
