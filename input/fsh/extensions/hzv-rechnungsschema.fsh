Extension: HzvRechnungsschemaExt
Id: hzv-rechnungsschema
Title: "HZV-Rechnungsschema"
Description: "(Retired) Was used on EncounterPraxisHZV to reference the HZV contract catalog. Retired: Account.coverage -> Coverage(HZV) carries the contract (see AccountPraxisSchein). Extension context changed to EpisodeOfCare only (retained for backward compat)."
Context: EpisodeOfCare
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status"
* ^extension[=].valueCode = #deprecated
* value[x] only Reference(Contract)
