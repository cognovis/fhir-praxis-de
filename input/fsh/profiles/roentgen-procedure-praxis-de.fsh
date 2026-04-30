// RoentgenProcedurePraxisDe — Roentgen-Prozedur-Profil fuer die deutsche ambulante Praxis
// Erbt von IPS Procedure-uv-ips (hl7.fhir.uv.ips#1.1.0).
// Abdeckung: SS83-SS85 StrlSchG, Roeentgenbuch-Anforderungen gemaess SS117-SS119 StrlSchV.
// Pflichtfelder: Anwender (MTR), Aufnahmedatum, rechtfertigende Indikation.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Alias: $ips-procedure = http://hl7.org/fhir/uv/ips/StructureDefinition/Procedure-uv-ips
Alias: $sct = http://snomed.info/sct
Alias: $radiation-dose-ext = https://fhir.cognovis.de/praxis/StructureDefinition/radiation-dose
Alias: $ri-attest-ext = https://fhir.cognovis.de/praxis/StructureDefinition/rechtfertigende-indikation-attest
Alias: $anwender-fachkunde-ext = https://fhir.cognovis.de/praxis/StructureDefinition/anwender-fachkunde
Alias: $radiology-role-cs = https://fhir.cognovis.de/praxis/CodeSystem/radiology-role
Alias: $imaging-procedure-vs = https://fhir.cognovis.de/imaging/ValueSet/imaging-procedure
Alias: $ri-vs = https://fhir.cognovis.de/imaging/ValueSet/rechtfertigende-indikation

Profile: RoentgenProcedurePraxisDe
Parent: $ips-procedure
Id: roentgen-procedure-praxis-de
Title: "Roentgen Procedure (Praxis DE)"
Description: "Roentgen-Prozedur-Profil fuer die deutsche ambulante Praxis. Erbt von IPS Procedure-uv-ips. Dokumentiert Strahlenanwendungen gemaess SS83-SS85 StrlSchG (Roeentgenbuch-Pflicht): Anwender mit Fachkunde (SS14 StrlSchV), rechtfertigende Indikation (ICD-10-GM mit Attestierungsmetadaten), Strahlendosis-Extension und ChargeItem-Verknuepfung fuer strahlenrelevante Abrechnungscodes."

// Extensions auf Procedure-Ebene
* extension contains
    $radiation-dose-ext named radiationDose 0..1 MS

// category: Diagnostische Prozedur (SNOMED 103693007)
* category 1..1 MS
* category = $sct#103693007 "Diagnostic procedure"
* category ^short = "Kategorie: Diagnostische Prozedur (SNOMED 103693007)"
* category ^definition = "Roentgen-Prozedur ist immer eine diagnostische Prozedur gemaess SNOMED CT 103693007."

// code: Bildgebungsverfahren aus ImagingProcedureVS
* code MS
* code from $imaging-procedure-vs (extensible)
* code ^short = "Bildgebungsverfahren-Code (ImagingProcedureVS, extensible)"
* code ^definition = "Code des Bildgebungsverfahrens. Extensible Binding auf ImagingProcedureVS aus de.cognovis.terminology.imaging."

// subject: Patient (1..1) — override IPS narrowing to allow any Patient (not just Patient-uv-ips)
// Cannot use "only Reference(Patient)" in FSH because SUSHI does not allow widening a parent type constraint.
// Use caret syntax to set targetProfile directly in the generated JSON.
* subject 1..1 MS
* subject ^type[0].targetProfile[0] = "http://hl7.org/fhir/StructureDefinition/Patient"
* subject ^short = "Patient (Pflichtfeld)"

// performed[x]: Aufnahmedatum (Pflichtfeld gemaess SS85 StrlSchV)
// IPS uses performed[x] — constrain to dateTime only; cardinality on choice element before type narrowing
* performed[x] 1..1 MS
* performed[x] only dateTime
* performed[x] ^short = "Aufnahmedatum (Pflicht gemaess SS85 StrlSchV)"
* performed[x] ^definition = "Datum und Uhrzeit der Roentgenaufnahme. Pflichtfeld fuer die Aufzeichnung gemaess SS85 StrlSchV."

// performer: Anwender-Slicing (MTR und Strahlenschutzverantwortlicher)
* performer MS
* performer ^slicing.discriminator.type = #value
* performer ^slicing.discriminator.path = "function.coding.code"
* performer ^slicing.rules = #open
* performer ^slicing.description = "Slicing nach Rolle: Anwender (MTR) und Strahlenschutzverantwortlicher"
* performer contains
    anwender 1..* MS and
    strahlenschutzverantwortlicher 0..1 MS

// performer[anwender]: Durchfuehrende Person (MTR gemaess SS14 StrlSchV)
* performer[anwender].function 1..1 MS
* performer[anwender].function.coding 1..* MS
* performer[anwender].function.coding.system = $radiology-role-cs
* performer[anwender].function.coding.code = #MTR
* performer[anwender] ^short = "Anwender (MTR, durchfuehrende Person gemaess SS14 StrlSchV)"
* performer[anwender] ^definition = "Medizinisch-Technische Radiologieassistentin/Assistent (MTR) — durchfuehrende Person fuer die Strahlenanwendung gemaess SS14 StrlSchV."
* performer[anwender].extension contains
    $anwender-fachkunde-ext named fachkunde 0..1 MS

// performer[strahlenschutzverantwortlicher]: Strahlenschutzverantwortlicher
* performer[strahlenschutzverantwortlicher].function 1..1 MS
* performer[strahlenschutzverantwortlicher].function.coding 1..* MS
* performer[strahlenschutzverantwortlicher].function.coding.system = $radiology-role-cs
* performer[strahlenschutzverantwortlicher].function.coding.code = #SupervisingRadiologist
* performer[strahlenschutzverantwortlicher] ^short = "Strahlenschutzverantwortlicher (Facharzt, Supervision)"
* performer[strahlenschutzverantwortlicher] ^definition = "Strahlenschutzverantwortlicher Arzt (Facharzt fuer Radiologie oder anderer bevollmaechtigter Arzt). Supervision und abschliessende Verantwortung."

// reasonCode: Rechtfertigende Indikation (1..* Pflicht gemaess SS83 StrlSchG)
* reasonCode 1..* MS
* reasonCode ^slicing.discriminator.type = #value
* reasonCode ^slicing.discriminator.path = "coding.system"
* reasonCode ^slicing.rules = #open
* reasonCode ^slicing.description = "Slicing: rechtfertigende-indikation (ICD-10-GM) und ggf. weitere Indikationscodes"
* reasonCode contains
    rechtfertigende-indikation 1..* MS

// reasonCode[rechtfertigende-indikation]: ICD-10-GM Slice (required binding)
* reasonCode[rechtfertigende-indikation] MS
* reasonCode[rechtfertigende-indikation] from $ri-vs (required)
* reasonCode[rechtfertigende-indikation].coding 1..* MS
* reasonCode[rechtfertigende-indikation].coding.system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* reasonCode[rechtfertigende-indikation] ^short = "Rechtfertigende Indikation (ICD-10-GM, required)"
* reasonCode[rechtfertigende-indikation] ^definition = "Rechtfertigende Indikation fuer die Strahlenanwendung gemaess SS83 StrlSchG. Required Binding auf RechtfertigendeIndikationVS (ICD-10-GM). Attestierungsmetadaten als Extension."
* reasonCode[rechtfertigende-indikation].extension contains
    $ri-attest-ext named attest 0..1
