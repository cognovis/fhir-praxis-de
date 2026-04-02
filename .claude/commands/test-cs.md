Test a CodeSystem against the local Aidbox FHIR server.

## Input
$ARGUMENTS — Name of the CodeSystem resource (e.g. "BillingType")

## Steps

1. Find the CodeSystem JSON in `output/package/CodeSystem-*.json` matching the name
2. If a test file exists at `test/CS/$ARGUMENTS.http`, read it. Otherwise create one.
3. The test file should contain:
   - PUT the CodeSystem to `{{fhirServer}}/fhir/CodeSystem/{{id}}`
   - Run `$lookup` on 2-3 representative codes
   - DELETE the CodeSystem
4. Run the test: `httpyac send -a test/CS/$ARGUMENTS.http`
5. Report the results. Do NOT auto-fix errors — report them first.

## Variables
```
@fhirServer = http://localhost:8080
@auth = Basic basic:secret
```

## Prerequisites
- `docker compose up -d` must be running
- IG must be built: `sushi .` then IG Publisher
