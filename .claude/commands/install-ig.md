Install this IG package into the local Aidbox FHIR server.

## Steps

1. Check that Aidbox is running: `curl -s http://localhost:8080/health`
2. Build the IG if not already built: check that `output/package.tgz` exists
3. Install the package via the FHIR API:

```
POST http://localhost:8080/fhir/$fhir-package-install
Authorization: Basic basic:secret
Content-Type: application/json

{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "package",
      "valueString": "file:///var/config/package.tgz"
    }
  ]
}
```

4. If file:// doesn't work (Aidbox may not have access), use an alternative:
   - Copy the tgz into the Aidbox container: `docker compose cp output/package.tgz aidbox:/tmp/package.tgz`
   - Then install with `file:///tmp/package.tgz`

5. Report the installed canonical count and any errors.

## Alternative: Install from GitHub Release
```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "package",
      "valueString": "de.cognovis.fhir.praxis@0.4.0"
    },
    {
      "name": "registry",
      "valueUrl": "https://fs.get-ig.org/pkgs"
    }
  ]
}
```
Note: Our packages are NOT on public registries yet. Use file:// or direct URL to GitHub Release asset.
