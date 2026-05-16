// ermaechtigung-status.fsh
// Status codes for aerztliche Ermaechtigung
// Bead: fpde-e0o

CodeSystem: ErmaechtigungStatusCS
Id: ermaechtigung-status
Title: "Ermaechtigung Status"
Description: "Statuswerte fuer aerztliche Ermaechtigungen"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #aktiv "Aktiv" "Ermaechtigung ist aktiv und gueltig"
* #abgelaufen "Abgelaufen" "Ermaechtigung ist abgelaufen"
* #entzogen "Entzogen" "Ermaechtigung wurde entzogen"

ValueSet: ErmaechtigungStatusVS
Id: ermaechtigung-status-vs
Title: "Ermaechtigung Status"
Description: "Statuswerte fuer aerztliche Ermaechtigungen"
* ^status = #active
* ^experimental = false
* include codes from system ErmaechtigungStatusCS
