// PAS Task Input/Output Type CodeSystem
// Discriminator-Codes fuer Task.input und Task.output Slicing

CodeSystem: PASTaskInputTypeCS
Id: pas-task-input-type
Title: "PAS Task Input Type"
Description: "Codes zur Unterscheidung der Eingabe- und Ausgabetypen in PAS-Workflow-Tasks."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #claim-reference "Claim Reference" "Referenz auf den zugehoerigen Genehmigungsantrag (Claim)"
* #response-reference "ClaimResponse Reference" "Referenz auf den Genehmigungsbescheid (ClaimResponse)"
