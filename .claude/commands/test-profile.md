Test a StructureDefinition (Profile) against the local Aidbox FHIR server.

## Input
$ARGUMENTS — Name of the Profile (e.g. "AbrechnungsquartalExt")

## Steps

1. Find the StructureDefinition JSON in `output/package/StructureDefinition-*.json` matching the name
2. Identify ALL dependencies: Extensions, CodeSystems, ValueSets referenced by the profile
3. If a test file exists at `test/Profile/$ARGUMENTS.http`, read it. Otherwise create one.
4. The test file should contain:
   - PUT all dependency resources (CodeSystems, ValueSets, Extensions) first
   - PUT the StructureDefinition
   - POST a **valid** example resource to `{{fhirServer}}/fhir/{{ResourceType}}/$validate`
   - POST an **invalid** example resource (missing required fields or wrong codes) to `$validate` — expect validation errors
   - DELETE all resources in reverse order
5. Run the test: `httpyac send -a test/Profile/$ARGUMENTS.http`
6. Report the results. Do NOT auto-fix errors — report them first.

## Variables
```
@fhirServer = http://localhost:8080
@auth = Basic basic:secret
```

## Notes
- Use `$validate` (not PUT) for test resources — we don't want to persist test data
- For Extensions: test them embedded in a parent resource, not standalone
