// praxis-plan-topic — Discovery axis CodeSystem for PlanDefinition.topic
// Differentiates plan variants (Chain vs. Job vs. DMP-Template etc.) within PraxisBillingPattern.
// Implements ADR-001 Decision 3: type differentiation via topic CodeSystem instead of separate profiles.

CodeSystem: PraxisPlanTopicCS
Id: praxis-plan-topic
Title: "Praxis Plan Topic"
Description: "Discovery axis for PlanDefinition.topic within PraxisBillingPattern resources. Distinguishes plan variants — chains, jobs, complex templates, DMP/HZV/HKP/specialist templates — without requiring separate FHIR profiles. Implements ADR-001 Decision 3. Extensible without profile version bump."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-plan-topic"
// Ziffernkette / chain: A implies B (automated co-billing trigger)
* #chain "Ziffernkette" "Automatische Mitnahmekette — A impliziert B (z.B. Wegepauschale bei Hausbesuch)"
// Job: structured workflow template with Doku + Ziffern + Diagnosen sections
* #job "Job" "Behandlungsbaustein bestehend aus Dokumentation, Leistungsziffern und Diagnosen-Sektionen"
// Komplex: multi-code complex (linked items not necessarily sequential)
* #komplex "Komplex" "Leistungskomplex — mehrere zusammengehoerige Ziffern ohne feste Reihenfolge"
// DMP template: disease management programme workflow plan
* #dmp "DMP-Template" "Disease-Management-Programm-Vorlage (§137f SGB V)"
// HZV template: hausarzt-programme workflow plan
* #hzv "HZV-Template" "Hausarztzentrierte Versorgung Planvorlage (§73b SGB V)"
// HKP template: Heil- und Kostenplan workflow
* #hkp "HKP-Template" "Heil- und Kostenplan-Vorlage (§87 Abs. 1a SGB V)"
// PAR template: parodontology treatment sequence
* #par "PAR-Template" "Parodontitis-Behandlungs-Sequenz (S3-Leitlinie/BEMA)"
// KFO template: Kieferorthopaedie treatment plan
* #kfo "KFO-Template" "Kieferorthopaedie-Behandlungsplan-Vorlage"
// ZE template: Zahnersatz treatment plan
* #ze "ZE-Template" "Zahnersatz-Behandlungsplan-Vorlage (§56 SGB V)"

// Companion ValueSet — all topic codes (extensible)
ValueSet: PraxisPlanTopicVS
Id: praxis-plan-topic
Title: "Praxis Plan Topic"
Description: "All codes from the praxis-plan-topic CodeSystem. Bind to PlanDefinition.topic (extensible) to classify plan templates within PraxisBillingPattern."
* ^status = #active
* ^experimental = false
* include codes from system PraxisPlanTopicCS
