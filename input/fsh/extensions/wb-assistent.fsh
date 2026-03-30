Extension: WbRolleExt
Id: wb-rolle
Title: "WB/SA-Rolle"
Description: "Rolle des Assistenten: WB-Assistent oder Sicherstellungsassistent"
Context: Basic
* value[x] only code
* valueCode from WbRolleVS (required)

Extension: WbAbrechnenderArztExt
Id: wb-abrechnender-arzt
Title: "Abrechnender Arzt"
Description: "Referenz auf den Arzt, unter dessen Nummer der Assistent abrechnet. Mehrfach verwendbar (ein Assistent kann unter mehreren Aerzten abrechnen)."
Context: Basic
* value[x] only Reference(Practitioner)
