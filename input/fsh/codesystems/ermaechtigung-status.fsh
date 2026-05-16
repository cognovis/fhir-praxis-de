// ermaechtigung-status.fsh
// Status codes for aerztliche Ermaechtigung
// Bead: fpde-e0o, fpde-1cn

CodeSystem: ErmaechtigungStatusCS
Id: ermaechtigung-status
Title: "Ermaechtigung Status"
Description: "Statuswerte fuer aerztliche Ermaechtigungen"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* insert ZulassungStatusConcepts

ValueSet: ErmaechtigungStatusVS
Id: ermaechtigung-status-vs
Title: "Ermaechtigung Status"
Description: "Statuswerte fuer aerztliche Ermaechtigungen"
* ^status = #active
* ^experimental = false
* include codes from system ErmaechtigungStatusCS
