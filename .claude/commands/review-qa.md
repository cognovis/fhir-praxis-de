Review the IG Publisher QA report and create a fix plan.

## Steps

1. Check if the IG has been built: look for `output/qa.html`
2. If not built locally, fetch from GitHub Pages: https://cognovis.github.io/fhir-praxis-de/qa.html
3. Parse the QA report and categorize issues:
   - **Errors** (must fix) — list each with file and description
   - **Warnings** (should fix) — group by category, count per type
   - **Info** (nice to have) — summarize
4. For each error, identify the source FSH file in `input/fsh/` that needs fixing
5. Present a prioritized fix plan: errors first, then high-impact warnings
6. Do NOT auto-fix — present the plan and wait for approval

## Output Format
```
## QA Report Summary
- Errors: X
- Warnings: Y
- Info: Z

## Errors (must fix)
1. [file.fsh:line] — description — suggested fix
2. ...

## Top Warnings (by category)
- Category A (N occurrences) — suggested approach
- ...
```
