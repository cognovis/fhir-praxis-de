# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0] - 2026-03-30

### Features

- 22 new Extensions: GOÄ detail/Sachkosten (6), Private billing workflow (5), EBM on ChargeItem (5), HVG/Selektivvertrag (2), BGT2001 BG-Tarif (3), Price history (1)
- 2 new CodeSystem shells: Zuzahlungsstatus (eGK VSD), HVG-Vertragsart (Selektivverträge)
- BillingType CodeSystem extended with generic catalog types (bgt2001, hzv, facharztvertrag) — regional HZV contracts use the generic `hzv` type with region via Contract/jurisdiction
- GitHub Actions CI/CD workflow for IG Publisher build + GitHub Pages deployment
- LICENSE (CC-BY-4.0), README, VERSION, cliff.toml

### Architecture

- PVS-agnostic design: no PVS-specific knowledge in IG; all PVS mapping belongs in adapter code
- Generic billing catalog model: regional Selektivverträge (HZV Bayern, BW, etc.) use ChargeItemDefinition + billing-system discriminator instead of per-region CodeSystems
- CodeSystem shells use `^content = #not-present` for ETL-filled terminologies

## [0.1.0] - 2026-03-30

### Features

- Initial scaffold for de.cognovis.fhir.praxis IG
- 122 Extensions across 18 domains
- 9 CodeSystems (Scheinart, BillingType, CorrectionRule, DiagnoseSeite, TaskType, Genehmigung, WbRolle, AiProvenance)
- 7 ValueSets with bindings for all CodeSystems

