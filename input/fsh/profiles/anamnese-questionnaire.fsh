Invariant: anamnese-top-level-item
Description: "Jedes top-level item muss entweder type = group sein oder einen nicht-leeren Fragetext haben."
Expression: "item.all(type = 'group' or (text.exists() and text.length() > 0))"
Severity: #warning

Profile: AnamneseQuestionnaire
Parent: Questionnaire
Id: anamnese-questionnaire
Title: "Anamnese-Questionnaire"
Description: "Profil fuer ambulante Anamneseboegen (Erstanamnese, Schmerzanamnese, Praevention) als FHIR Questionnaire-Templates. Praxisrelevante item.type-Werte: group, display, boolean, decimal, integer, date, dateTime, time, string, text, url, choice, open-choice, attachment, reference, quantity. Fuer publizierte Templates wird status = #active empfohlen."

* obeys anamnese-top-level-item

// Extension fuer Fachkategorie
* extension contains QuestionnaireKategorieExt named kategorie 0..1 MS
* item.extension contains QuestItemClinicalAlertExt named clinicalAlert 0..1 MS

// Must-Support elements
* status MS
* title 1..1 MS
* date MS
* publisher MS
* subjectType 1..* MS
* subjectType = #Patient

// useContext slice fuer Bogentyp
// 1..* required: classifying the Bogentyp is the core purpose of this slice in an AnamneseQuestionnaire
* useContext ^slicing.discriminator.type = #pattern
* useContext ^slicing.discriminator.path = "code"
* useContext ^slicing.rules = #open
* useContext contains bogentyp 1..*
* useContext[bogentyp].code = http://terminology.hl7.org/CodeSystem/usage-context-type#workflow
* useContext[bogentyp].value[x] only CodeableConcept
* useContext[bogentyp].valueCodeableConcept from AnamneseBogentypVS (extensible)

// Items
* item 1..* MS
* item.linkId 1..1 MS
* item.text MS
* item.type 1..1 MS
* item.required MS
* item.item MS
