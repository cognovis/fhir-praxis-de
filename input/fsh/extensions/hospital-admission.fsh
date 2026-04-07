// Krankenhauseinweisung extensions

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
