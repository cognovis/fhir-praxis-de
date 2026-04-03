# FHIR IG QA Report Analysis
## Summary
- Total Errors: 11
- Total Warnings: 202
- Total Info: 203
- Broken Links: 0

---

## CRITICAL ERRORS (must fix before publishing)

### 1. RESOURCE_ID_MISMATCH & RESOURCE_CANONICAL_MISMATCH
**Resource:** ConceptMap-CaveClinicalWarningTypeSnomedCM
**Issue:** Resource id/url mismatch: CaveClinicalWarningTypeSnomedCM vs https://fhir.cognovis.de/praxis/ConceptMap/cave-clinical-warning-type-snomed
**Severity:** ERROR
**Fix:** Update the resource ID or canonical URL to match
**File:** input/fsh/ConceptMap/CaveClinicalWarningTypeSnomedCM.fsh (or similar)

### 2. CONCEPTMAP_VS_NOT_A_VS
**Resource:** ConceptMap-CaveClinicalWarningTypeSnomedCM
**Issue:** Reference must be to a ValueSet, but found a CodeSystem instead. Target canonical is 'http://snomed.info/sct' which is a CodeSystem, not a ValueSet
**Severity:** ERROR
**Fix:** ConceptMap.target must reference a ValueSet. Wrap SNOMED CT in a ValueSet or revise the mapping target
**File:** input/fsh/ConceptMap/CaveClinicalWarningTypeSnomedCM.fsh

### 3. TYPE_SPECIFIC_CHECKS_DT_URL_RESOLVE (Multiple StructureDefinitions)
**Resources:** 
- StructureDefinition-pas-claim-de
- (Others with pattern CodeableConcept.coding.system = 'http://terminology.hl7.org/CodeSystem/task-input-type')
**Issue:** URL 'http://terminology.hl7.org/CodeSystem/task-input-type' cannot be resolved
**Severity:** ERROR
**Fix:** Verify the CodeSystem URL exists and is accessible. Consider using HTTPS or checking HL7 terminology server
**Files:** input/fsh/StructureDefinition/pas-claim-de.fsh and related files

### 4. TYPE_SPECIFIC_CHECKS_DT_CANONICAL_TYPE
**Resource:** ConceptMap-CaveClinicalWarningTypeSnomedCM
**Issue:** Canonical URL 'http://snomed.info/sct' verweist auf eine Ressource, die den falschen Typ hat. Gefunden CodeSystem, erwartet eines von [ValueSet]
**Severity:** ERROR
**Fix:** Use a ValueSet instead of CodeSystem as ConceptMap target
**Related to:** CONCEPTMAP_VS_NOT_A_VS (same root cause)

### 5. IG_DEPENDENCY_INVALID_URL
**Resource:** ImplementationGuide (de.cognovis.fhir.praxis)
**Issue:** The canonical URL http://fhir.org/packages/de.basisprofil.r4/ImplementationGuide/de.basisprofil.r4 doesn't point to an actual ImplementationGuide resource
**Severity:** ERROR
**Fix:** Verify the dependency URL or update it to a valid IG reference
**File:** input/fsh/ig-data/ImplementationGuide.json or fsh file

### 6. UNKNOWN_CODESYSTEM / TYPE_SPECIFIC_CHECKS_DT_CANONICAL_RESOLVE
**Issue:** Referenced CodeSystem URL cannot be resolved on terminology server
**Severity:** ERROR
**Fix:** Verify all CodeSystem URLs are correct and accessible on tx.fhir.org
**Affected:** Check all references to CodeSystems in patterns

---

## MAJOR ISSUES (strong recommendation to fix)

### 7. CODESYSTEM_SHAREABLE_MISSING
**Affected Resources:** 16 CodeSystems (all missing 'experimental' element)
- CodeSystem-ai-provenance
- CodeSystem-billing-type
- CodeSystem-cave-clinical-warning-type
- CodeSystem-cave-typ
- CodeSystem-diagnose-seite
- CodeSystem-einwilligung-kategorie
- CodeSystem-genehmigung-leistungsbereich
- CodeSystem-genehmigung-typ
- CodeSystem-hvg-vertragsart
- CodeSystem-hzv-participation
- CodeSystem-kvb-richtigstellung
- CodeSystem-pas-task-code
- CodeSystem-scheinart
- CodeSystem-task-type
- CodeSystem-wb-rolle
- CodeSystem-zuzahlungsstatus

**Issue:** Shareable CodeSystem Profile requires the 'experimental' element to be present
**Severity:** ERROR (per FHIR base rules, though called "SHOULD")
**Fix:** Add "* experimental = false" (or true) to each CodeSystem definition in FSH
**Pattern:** Look for all CodeSystem definitions in input/fsh/CodeSystem/

### 8. CONCEPTMAP_SHAREABLE_EXTRA_MISSING
**Resource:** ConceptMap-CaveClinicalWarningTypeSnomedCM
**Issue:** ShareableConceptMap profile recommends the 'name' element is filled
**Severity:** ERROR
**Fix:** Add a 'name' property to the ConceptMap
**File:** input/fsh/ConceptMap/CaveClinicalWarningTypeSnomedCM.fsh

### 9. MSG_DEPENDS_ON_DEPRECATED
**Resource:** StructureDefinition-pas-claim-de
**Issue:** Extension http://hl7.org/fhir/StructureDefinition/elementdefinition-maxValueSet|5.2.0 is deprecated
**Severity:** ERROR
**Fix:** Remove or replace the deprecated extension, or add it to suppressed messages if unavoidable
**File:** input/fsh/StructureDefinition/pas-claim-de.fsh

---

## WARNINGS (202 total - mostly informational)

### Pattern 1: NO_VALID_DISPLAY_FOUND_NONE_FOR_LANG_OK (Multiple CodeSystems & StructureDefinitions)
**Issue:** No valid display names found for code 'urn:iso:std:iso:3166#DE' for language 'de-DE'. Display is 'Germany' (default language display)
**Severity:** WARNING (informational only, usually safe to ignore)
**Affected Resources:** Most CodeSystems with jurisdiction="Germany"
**Fix:** Optional - can add German display name or suppress this message
**Note:** This is typically a non-blocking warning

### Pattern 2: CONCEPTMAP_GROUP_TARGET_SERVER_SIDE
**Resource:** ConceptMap-CaveClinicalWarningTypeSnomedCM
**Issue:** Target Code System http://snomed.info/sct is only supported on the terminology server
**Severity:** WARNING
**Fix:** This is expected for SNOMED CT mappings; can be suppressed if intentional
**Note:** Performance-related, codes are not validated locally

### Pattern 3: SD_PATH_SLICING_DEPRECATED
**Issue:** SlicingDiscriminator path-based discriminators are deprecated
**Severity:** WARNING
**Fix:** Use type-based or value-based discriminators instead
**Affected:** Check StructureDefinitions for path-based slicing

---

## RECOMMENDATIONS FOR FIXING

**Priority 1 (Blocking):**
1. Fix ConceptMap target issue (CONCEPTMAP_VS_NOT_A_VS, TYPE_SPECIFIC_CHECKS_DT_CANONICAL_TYPE)
2. Add 'experimental' to all 16 CodeSystems (CODESYSTEM_SHAREABLE_MISSING)
3. Fix resource ID/URL mismatches (RESOURCE_CANONICAL_MISMATCH, RESOURCE_ID_MISMATCH)
4. Verify/fix CodeSystem URL references (TYPE_SPECIFIC_CHECKS_DT_URL_RESOLVE)
5. Fix IG dependency URL (IG_DEPENDENCY_INVALID_URL)

**Priority 2 (Strong Recommendation):**
1. Add 'name' to ConceptMap (CONCEPTMAP_SHAREABLE_EXTRA_MISSING)
2. Remove deprecated extension (MSG_DEPENDS_ON_DEPRECATED)

**Priority 3 (Optional/Suppressible):**
1. Language display warnings (NO_VALID_DISPLAY_FOUND_NONE_FOR_LANG_OK) - can suppress
2. SNOMED CT server-side warnings (CONCEPTMAP_GROUP_TARGET_SERVER_SIDE) - can suppress
3. Deprecated slicing discriminators (SD_PATH_SLICING_DEPRECATED) - refactor if feasible

