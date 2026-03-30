Extension: AuTypExt
Id: au-typ
Title: "AU-Typ"
Description: "Typ der Arbeitsunfaehigkeitsbescheinigung"
Context: ServiceRequest
* value[x] only string

Extension: AuVonDatumExt
Id: au-von-datum
Title: "AU von Datum"
Description: "Beginn der Arbeitsunfaehigkeit"
Context: ServiceRequest
* value[x] only date

Extension: AuBisDatumExt
Id: au-bis-datum
Title: "AU bis Datum"
Description: "Ende der Arbeitsunfaehigkeit"
Context: ServiceRequest
* value[x] only date

Extension: AuEnddatumExt
Id: au-enddatum
Title: "AU-Enddatum auf Schein"
Description: "Enddatum der Arbeitsunfaehigkeit auf dem Schein"
Context: Encounter
* value[x] only date

Extension: AuArbeitsunfallExt
Id: au-arbeitsunfall
Title: "Arbeitsunfall"
Description: "Kennzeichen ob ein Arbeitsunfall vorliegt"
Context: ServiceRequest
* value[x] only boolean
