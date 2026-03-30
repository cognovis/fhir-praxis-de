// Krankenhauseinweisung extensions

Extension: KheKrankenhausExt
Id: khe-krankenhaus
Title: "Krankenhaus"
Description: "Name des Krankenhauses fuer die Einweisung."
Context: ServiceRequest
* value[x] only string

Extension: KheDiagnoseExt
Id: khe-diagnose
Title: "Einweisungsdiagnose"
Description: "Diagnosetext fuer die Krankenhauseinweisung."
Context: ServiceRequest
* value[x] only string

Extension: KheIcdExt
Id: khe-icd
Title: "Einweisungs-ICD"
Description: "ICD-Code fuer die Krankenhauseinweisung."
Context: ServiceRequest
* value[x] only CodeableConcept

Extension: KheBelegarztExt
Id: khe-belegarzt
Title: "Belegarzt"
Description: "Kennzeichnung einer belegaerztlichen Einweisung."
Context: ServiceRequest
* value[x] only boolean

Extension: KheNotfallExt
Id: khe-notfall
Title: "Notfall"
Description: "Kennzeichnung einer Notfalleinweisung."
Context: ServiceRequest
* value[x] only boolean

Extension: KheUnfallExt
Id: khe-unfall
Title: "Unfall"
Description: "Kennzeichnung einer unfallbedingten Einweisung."
Context: ServiceRequest
* value[x] only boolean

Extension: KheBvgExt
Id: khe-bvg
Title: "BVG"
Description: "Kennzeichnung einer Einweisung nach dem Bundesversorgungsgesetz (BVG)."
Context: ServiceRequest
* value[x] only boolean
