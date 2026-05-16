// wb-befugnis-status.fsh
// Status codes for Weiterbildungsbefugnis
// Bead: fpde-e0o

CodeSystem: WbBefugnisStatusCS
Id: wb-befugnis-status
Title: "WB-Befugnis Status"
Description: "Statuswerte fuer Weiterbildungsbefugnisse"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #aktiv "Aktiv" "Weiterbildungsbefugnis ist aktiv und gueltig"
* #abgelaufen "Abgelaufen" "Weiterbildungsbefugnis ist abgelaufen"
* #entzogen "Entzogen" "Weiterbildungsbefugnis wurde entzogen"

ValueSet: WbBefugnisStatusVS
Id: wb-befugnis-status-vs
Title: "WB-Befugnis Status"
Description: "Statuswerte fuer Weiterbildungsbefugnisse"
* ^status = #active
* ^experimental = false
* include codes from system WbBefugnisStatusCS
