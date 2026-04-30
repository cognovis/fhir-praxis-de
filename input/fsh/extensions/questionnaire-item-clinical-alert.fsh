Extension: QuestItemClinicalAlertExt
Id: questionnaire-item-clinical-alert
Title: "Questionnaire Item Clinical Alert"
Description: "Marks a questionnaire item as clinically critical (e.g., allergy, anticoagulant, endocarditis risk). When true, the item requires heightened clinical attention — not merely a UI highlight. Vendor-neutral replacement for PVS-specific alert flags."
Context: Questionnaire#item, QuestionnaireResponse#item
* value[x] 1..1
* value[x] only boolean
