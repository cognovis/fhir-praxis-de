// wb-befugnis-status.fsh
// Status codes for Weiterbildungsbefugnis
// Bead: fpde-e0o, fpde-1cn

CodeSystem: WbBefugnisStatusCS
Id: wb-befugnis-status
Title: "WB-Befugnis Status"
Description: "Statuswerte fuer Weiterbildungsbefugnisse"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* insert ZulassungStatusConcepts

ValueSet: WbBefugnisStatusVS
Id: wb-befugnis-status-vs
Title: "WB-Befugnis Status"
Description: "Statuswerte fuer Weiterbildungsbefugnisse"
* ^status = #active
* ^experimental = false
* include codes from system WbBefugnisStatusCS
