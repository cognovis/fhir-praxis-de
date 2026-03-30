Extension: CrossAkIsPrimaryExt
Id: cross-ak-is-primary
Title: "Primaerer Abrechnungskreis"
Description: "Kennzeichen ob dies der primaere Abrechnungskreis ist"
Context: PractitionerRole
* value[x] only boolean

Extension: CrossAkBilledUnderExt
Id: cross-ak-billed-under
Title: "Abgerechnet unter Organisation"
Description: "Organisation unter der die Grundpauschale abgerechnet wurde"
Context: Encounter
* value[x] only Reference(Organization)
