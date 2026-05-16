// arzt-status.fsh
// Status codes for Arzt-Sitz-Zuordnung
// Bead: fpde-e0o

CodeSystem: ArztStatusCS
Id: arzt-status
Title: "Arzt Status"
Description: "Statuswerte fuer die Arzt-Sitz-Zuordnung in der ambulanten Versorgung"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #facharzt "Facharzt" "Niedergelassener Facharzt mit eigenem Sitz"
* #wba "WBA" "Weiterbildungsassistent"
* #sicherstellung "Sicherstellung" "Sicherstellungsassistent"
* #vertreter "Vertreter" "Vertreter (Urlaubsvertretung, Krankheitsvertretung)"

ValueSet: ArztStatusVS
Id: arzt-status-vs
Title: "Arzt Status"
Description: "Statuswerte fuer die Arzt-Sitz-Zuordnung"
* ^status = #active
* ^experimental = false
* include codes from system ArztStatusCS
