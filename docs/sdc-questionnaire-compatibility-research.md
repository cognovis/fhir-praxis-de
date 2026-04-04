# Research: HL7 SDC Implementation Guide and Questionnaire Profile Compatibility

## Key Findings

### 1. SDC Architecture and Profile Hierarchy

**SDC Version**: 3.0.0 (STU 3) - based on FHIR R4
**Current Production**: 4.0.0 (supersedes 3.0.0)
**Official URL**: http://hl7.org/fhir/uv/sdc

SDC is a comprehensive IG defining **8 major capability areas**:
1. **Workflow** — system roles and interactions (questionnaire discovery, completion tracking)
2. **Search** — finding questionnaires in form repositories
3. **Advanced Rendering** — visual presentation (HTML, markdown, table layouts, formatting)
4. **Form Behavior** — dynamic form logic (adaptive logic, calculations, constraints)
5. **Automatic Population** — pre-filling forms with existing data
6. **Data Extraction** — converting QuestionnaireResponse → FHIR resources
7. **Modular Forms** — reusable question libraries and sub-forms
8. **Adaptive Forms** — dynamically generated forms via API

### 2. SDC Base Questionnaire Profile

**Profile Name**: sdc-questionnaire
**URL**: http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire
**Maturity**: Level 3 (Trial-use / STU)

**Purpose**: Foundation profile extending base FHIR Questionnaire with SDC extensions for common use cases

**Key Additions to Base Questionnaire**:
- Support for FHIRPath and CQL expressions
- Rendering extensions (HTML content, markdown rendering hints)
- Validation constraints (regex patterns, min/max values)
- Terminology bindings for answer options
- Links to external definitions
- Code system and value set relationships

### 3. SDC Questionnaire-Specific Profiles

SDC defines **3 specialized profiles** for different use patterns:

#### A. **sdc-questionnaire-render** (Advanced Rendering Profile)
- **Purpose**: Forms requiring rich visual presentation
- **Key Extensions**:
  - `item-control` — controls for answer rendering (checkboxes, dropdowns, autocomplete)
  - `displayCategory` — rendering hints for grouping/display
  - `hidden` — conditional visibility
  - Markdown/HTML text rendering
  - Image and custom content support
- **Use Case**: Clinical forms, assessment tools, user-friendly questionnaires

#### B. **sdc-questionnaire-populate** (Population Profile)
- **Purpose**: Pre-filling forms with existing clinical data
- **Key Extensions**:
  - `launchContext` — external data sources (Patient, Encounter, etc.)
  - `initialExpression` — FHIRPath to pre-populate answers
  - `candidateAnswers` — FHIRPath to populate choice lists dynamically
- **Use Case**: Intake forms, pre-visit summaries, follow-up questionnaires

#### C. **sdc-questionnaire-extract** (Extraction Profile)
- **Purpose**: Converting completed forms to FHIR resources
- **Key Extensions**:
  - `itemExtractionContext` — maps items to FHIR paths
  - `calculatedExpression` — post-processing answers
  - `structureMapUri` — complex transformation rules (FHIR StructureMap)
  - `observationExtract` — creates Observation resources
- **Use Case**: Lab order forms, clinical documentation capture, data standards alignment

### 4. Derivation from SDC vs. Base Questionnaire

**Question**: Can a custom profile derive from SDC's Questionnaire profile?

**Answer**: YES, absolutely valid and recommended.

**Pattern**:
```
Custom Profile (e.g., AnamneseQuestionnaire)
  ↓ derives from
sdc-questionnaire (or sdc-questionnaire-render/-populate/-extract)
  ↓ derives from
Base FHIR Questionnaire
```

**Advantages**:
- Inherits all SDC extensions automatically
- Can add further constraints/requirements
- Clear compliance chain (custom → SDC → FHIR base)
- Enables reuse of SDC-compliant tools and services

**How**: Use `baseDefinition` in StructureDefinition:
```json
{
  "url": "http://example.com/StructureDefinition/AnamneseQuestionnaire",
  "baseDefinition": "http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-render",
  "type": "Questionnaire",
  "derivation": "constraint"
}
```

### 5. CH ORF (Switzerland Order & Referral by Form) Pattern

**IG**: CH ORF (build.fhir.org/ig/HL7/ch-orf)
**Status**: In development (Swiss national IG)
**Approach**: Excellent example of SDC-derived profile

**CH ORF Pattern**:
- Derives from **sdc-questionnaire-populate** and **sdc-questionnaire-extract**
- Defines Swiss-specific constraints for:
  - Medical referrals (e.g., to specialists)
  - Laboratory orders
  - Diagnostic requests
  - Insurance/billing data capture

**Key Design Decisions**:
- Mandatory SDC population support (pre-fills patient, insurance, ordering provider)
- Structured extraction to Swiss-specific FHIR profiles (ServiceRequest, DiagnosticRequest)
- Terminology bindings to Swiss CodeSystems (OID-based)
- Multi-language support (DE, FR, IT)

**Lessons for AnamneseQuestionnaire**:
1. Separate population and extraction concerns into dedicated profiles
2. Use SDC launchContext for standard clinical data (Patient, Encounter, Practitioner)
3. Leverage SDC FHIRPath for dynamic behavior
4. Keep rendering separate from logic (render profile can layer on top)

### 6. Must-Support Elements in SDC Profiles

**SDC Base Questionnaire** requires support for:
- `item.type` — question type (text, choice, group, etc.)
- `item.required` — mandatory fields
- `item.code` — terminology binding to standard questionnaires (LOINC)
- `item.answerOption` — fixed or reference value sets
- Extensions for validation, rendering, and behavior

**SDC Questionnaire-Render** additionally requires:
- `item-control` extension (rendering hints)
- `displayCategory` (visual grouping)
- Answer option display strings

**SDC Questionnaire-Populate** additionally requires:
- `launchContext` (data sources)
- `initialExpression` (FHIRPath for pre-fill)

**SDC Questionnaire-Extract** additionally requires:
- `itemExtractionContext` (mapping to FHIR)
- `structureMapUri` or item code mapping

### 7. Making a Custom Profile SDC-Compatible

**Minimum Steps**:

1. **Choose Base Profile**:
   - If rendering is important → derive from `sdc-questionnaire-render`
   - If population needed → include `sdc-questionnaire-populate`
   - If extraction needed → include `sdc-questionnaire-extract`
   - Use `sdc-questionnaire` if only adding validation

2. **Add Extensions**:
   - Rendering: use `item-control`, `displayCategory`, `hidden` (from SDC)
   - Population: use `launchContext`, `initialExpression` (from SDC)
   - Extraction: use `structureMapUri`, `itemExtractionContext` (from SDC)
   - Validation: use `regex`, `minLength`, `maxLength` (from base FHIR)

3. **Define Terminology**:
   - Bind `item.code` to standard questionnaire codes (LOINC recommended)
   - Use `valueSet` for answer options
   - Include proper `display` elements for rendering

4. **Example: German Anamnesis Profile**
```json
{
  "resourceType": "StructureDefinition",
  "url": "http://example.de/StructureDefinition/AnamneseQuestionnaire",
  "baseDefinition": "http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-render",
  "type": "Questionnaire",
  "name": "AnamneseQuestionnaire",
  "elements": [
    {
      "id": "Questionnaire.url",
      "mustSupport": true
    },
    {
      "id": "Questionnaire.item",
      "mustSupport": true,
      "slicing": {
        "discriminator": {"type": "value", "path": "code"},
        "rules": "open"
      }
    }
  ],
  "extension": [
    {
      "url": "http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-itemControl",
      "valueCodeableConcept": {...}
    }
  ]
}
```

### 8. Extraction Methods in SDC

SDC supports **3 extraction patterns**:

#### Pattern A: Observation-Based
- Each question → creates an Observation resource
- Uses `structureMapUri` to map item → observation code
- Best for: Lab values, vital signs, standardized assessments
- Example: Each pain scale item becomes an Observation with LOINC code

#### Pattern B: Definition-Based
- Directly maps items to FHIR resource elements
- Uses `item.definition` pointing to ElementDefinition
- Best for: Structured EHR data, patient demographics
- Example: Name item directly fills Patient.name

#### Pattern C: Structure Map
- Complex transformations using FHIR StructureMap language
- Handles multi-step logic, conditional creation, bundling
- Best for: Multi-resource extraction, referrals, orders
- Example: Referral form → creates Encounter + ServiceRequest + Practitioner

---

## Details

### What SDC Adds on Top of Base FHIR Questionnaire

Base FHIR Questionnaire provides:
- Basic question/answer structure
- Simple value sets and coding
- Groups and nesting
- Required/optional flags

SDC Adds:
- **Rendering Control**: HTML/markdown, layout hints, accessibility
- **Dynamic Behavior**: FHIRPath/CQL conditions, calculations, cascading logic
- **Data Integration**: Pre-population from EHR, post-extraction to FHIR
- **Terminology**: Proper LOINC/SNOMED binding, standardization
- **Accessibility**: Proper nesting, item-control for screen readers
- **Workflow Integration**: Questionnaire discovery, response tracking

### SDC Extensions (Partial List)

**Core Rendering**:
- `displayCategory` — visual grouping
- `item-control` — widget types (dropdown, checkbox, radio, etc.)
- `hidden` — conditional visibility
- `text-using-markdown` — markdown rendering hint
- `entryFormat` — input format/mask

**Behavior**:
- `initialExpression` — FHIRPath to set initial value
- `calculatedExpression` — computed answer
- `enableWhen` — conditional question visibility
- `answerExpression` — populate answers from FHIRPath

**Population**:
- `launchContext` — named data sources available during form filling
- `launchContextResource` — defines structure of launch context

**Extraction**:
- `itemExtractionContext` — maps item to FHIR path
- `structureMapUri` — reference to StructureMap for transformation

### Incompatibilities / Constraints

**When deriving from SDC profiles, be aware**:

1. **Must-support obligations**: If you inherit `sdc-questionnaire-render`, you MUST support rendering extensions
2. **FHIR versions**: SDC 3.0.0 uses R4 only (not R5)
3. **Extension URLs**: Must use exact HL7 extension URLs (no local variation)
4. **FHIRPath complexity**: Extraction tools may not support all advanced FHIRPath
5. **StructureMap tooling**: Not all systems support FHIR StructureMap extraction

### Recommendation for AnamneseQuestionnaire

**Suggested Architecture**:

1. **Base Profile**: Derive from `sdc-questionnaire-render` (patient-facing form)
2. **Add Rendering**:
   - Use `displayCategory` for sections (medical history, medications, allergies)
   - Use `item-control: autocomplete` for diagnoses, medications
   - Use `hidden` with FHIRPath to show/hide based on patient age, gender

3. **Add Population** (as optional extension):
   - Include `launchContext` support for Patient, Encounter
   - Pre-fill known allergies, medications from EHR

4. **Add Extraction** (as separate extraction profile or included):
   - Map answers → AllergyIntolerance, MedicationStatement, Condition resources
   - Use StructureMap for complex transformations

5. **Constraints**:
   - Require `item.code` binding to German medical codes (SNOMED CT-DE, proprietary)
   - Require `valueSet` for medication answers (point to German medication list)
   - Set minimum `url` and `title` must-support

---

## Sources

- **SDC v3.0.0 Index**: http://hl7.org/fhir/uv/sdc/STU3/index.html — Overview, 8 major capability areas, scope
- **SDC Questionnaire Profile**: http://hl7.org/fhir/uv/sdc/STU3/StructureDefinition-sdc-questionnaire.html — Base profile, extensions, must-support elements
- **SDC Questionnaire-Render**: http://hl7.org/fhir/uv/sdc/STU3/StructureDefinition-sdc-questionnaire-render.html — Rendering extensions, visual control
- **SDC Questionnaire-Populate**: http://hl7.org/fhir/uv/sdc/STU3/StructureDefinition-sdc-questionnaire-populate.html — Pre-population, launchContext, initialExpression
- **SDC Questionnaire-Extract**: http://hl7.org/fhir/uv/sdc/STU3/StructureDefinition-sdc-questionnaire-extract.html — Extraction mapping, StructureMap, resource creation
- **SDC Data Extraction**: http://hl7.org/fhir/uv/sdc/STU3/extraction.html — Extraction patterns, patterns (observation-based, definition-based, structure-map)
- **CH ORF (Switzerland)**: http://build.fhir.org/ig/HL7/ch-orf/ — Real-world example of SDC-derived referral form IG

