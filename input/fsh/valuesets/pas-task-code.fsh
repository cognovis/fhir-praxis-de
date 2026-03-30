CodeSystem: PASTaskCodeCS
Id: pas-task-code
Title: "PAS Task Code"
Description: "Codes fuer Genehmigungsworkflow-Tasks (Prior Authorization)"
* ^status = #draft
* ^caseSensitive = true
* #submit "Antrag einreichen" "Genehmigungsantrag an Kostentraeger senden"
* #inquire "Status abfragen" "Status des Genehmigungsantrags abfragen"
* #cancel "Antrag stornieren" "Genehmigungsantrag zurueckziehen"

ValueSet: PASTaskCodeVS
Id: pas-task-code
Title: "PAS Task Code"
Description: "Codes fuer Genehmigungsworkflow-Tasks"
* ^status = #draft
* include codes from system PASTaskCodeCS
