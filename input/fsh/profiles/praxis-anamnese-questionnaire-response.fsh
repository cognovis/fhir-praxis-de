// PraxisAnamneseQuestionnaireResponse — Ausgefuellter Anamnesebogen
// Antworten auf AnamneseQuestionnaire-Templates aus der Praxis

Profile: PraxisAnamneseQuestionnaireResponse
Parent: QuestionnaireResponse
Id: praxis-anamnese-questionnaire-response
Title: "Praxis Anamnese QuestionnaireResponse"
Description: "QuestionnaireResponse-Profil fuer ausgefuellte ambulante Anamneseboegen. Gebunden an AnamneseQuestionnaire-Templates. Erfasst Patientenantworten mit verlinktem Fragebogen, Patientenreferenz und Bearbeitungszeitpunkt."

// Fragebogen-Canonical: Pflicht (Referenz auf AnamneseQuestionnaire)
* questionnaire 1..1 MS

// Status: Pflicht
* status 1..1 MS

// Patient: Pflicht
* subject 1..1 MS
* subject only Reference(Patient)

// Bearbeitungszeitpunkt: Must-Support
* authored MS

// Antworten: Mindestens ein Item
* item 1..* MS
* item.linkId 1..1 MS
* item.answer MS
