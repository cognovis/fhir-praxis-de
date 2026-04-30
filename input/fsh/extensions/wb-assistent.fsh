Extension: WbRolleExt
Id: wb-rolle
Title: "WB/SA-Rolle"
Description: "Rolle des Assistenten: WB-Assistent oder Sicherstellungsassistent"
Context: PractitionerRole
* value[x] only code
* valueCode from WbRolleVS (required)

Extension: WbSupervisorRoleExt
Id: wb-supervisor-role
Title: "WB-Supervisor-Rolle"
Description: "Referenz auf die PractitionerRole des supervising Arztes, unter dem der WB-Assistent abrechnet."
Context: PractitionerRole
* value[x] only Reference(PractitionerRole)
