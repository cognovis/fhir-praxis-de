Test a ValueSet against the local Aidbox FHIR server.

## Input
$ARGUMENTS — Name of the ValueSet resource (e.g. "BillingTypeVS")

## Steps

1. Find the ValueSet JSON in `output/package/ValueSet-*.json` matching the name
2. Identify all CodeSystems referenced by this ValueSet
3. If a test file exists at `test/VS/$ARGUMENTS.http`, read it. Otherwise create one.
4. The test file should contain:
   - PUT all referenced CodeSystems first
   - PUT the ValueSet
   - Run `$expand` on the ValueSet
   - Run `$validate-code` on 2-3 representative codes (expect valid)
   - Run `$validate-code` on 1 invalid code (expect invalid)
   - DELETE all resources
5. Run the test: `httpyac send -a test/VS/$ARGUMENTS.http`
6. Report the results. Do NOT auto-fix errors — report them first.

## Variables
```
@fhirServer = http://localhost:8080
@auth = Basic basic:secret
```
