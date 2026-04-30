// radiation-dose Extension — Strahlendosis-Parameter fuer RoentgenProcedurePraxisDe
// Dokumentiert Dosis-Flaechenprodukt (DAP), effektive Dosis und Roentgenroehren-Parameter.
// DICOM DCM semantic alignment (kein Dependency auf CI-build IG).
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: RadiationDoseExt
Id: radiation-dose
Title: "Radiation Dose"
Description: "Strahlendosis-Parameter fuer Roentgen-Prozeduren. Erfasst Dosis-Flaechenprodukt (DAP in microGy*m2), effektive Dosis (microSv), Roehrenspannung (kVp in kV), Roehrenstrom (mA) und Belichtungszeit (s). DICOM DCM semantic alignment."
* ^url = "https://fhir.cognovis.de/praxis/StructureDefinition/radiation-dose"
* ^status = #active
* ^experimental = false
* ^context[+].type = #element
* ^context[=].expression = "Procedure"

* extension contains
    dap 0..1 MS and
    effectiveDose 0..1 MS and
    kvp 0..1 MS and
    tubeCurrent 0..1 MS and
    exposureTime 0..1 MS

// dap: Dosis-Flaechenprodukt in microGy*m2
* extension[dap].value[x] only Quantity
* extension[dap].valueQuantity.system = "http://unitsofmeasure.org"
* extension[dap].valueQuantity.code = #uGy.m2
* extension[dap] ^short = "Dosis-Flaechenprodukt (DAP) in microGy*m2"
* extension[dap] ^definition = "Dosis-Flaechenprodukt (Dose Area Product, DAP) in Mikrogray mal Quadratmeter (microGy*m2). DICOM Tag 0018,115E."

// effectiveDose: Effektive Dosis in microSv
* extension[effectiveDose].value[x] only Quantity
* extension[effectiveDose].valueQuantity.system = "http://unitsofmeasure.org"
* extension[effectiveDose].valueQuantity.code = #uSv
* extension[effectiveDose] ^short = "Effektive Dosis in microSv"
* extension[effectiveDose] ^definition = "Effektive Dosis in Mikrosievert (microSv). Abgeleitete Groesse aus Dosislaengprodukt und Koerperstelle."

// kvp: Roehrenspannung in kV
* extension[kvp].value[x] only Quantity
* extension[kvp].valueQuantity.system = "http://unitsofmeasure.org"
* extension[kvp].valueQuantity.code = #kV
* extension[kvp] ^short = "Roehrenspannung (kVp) in kV"
* extension[kvp] ^definition = "Spitzenroehrenspannung (Peak kV) der Roentgenroehre in Kilovolt. DICOM Tag 0018,0060."

// tubeCurrent: Roehrenstrom in mA
* extension[tubeCurrent].value[x] only Quantity
* extension[tubeCurrent].valueQuantity.system = "http://unitsofmeasure.org"
* extension[tubeCurrent].valueQuantity.code = #mA
* extension[tubeCurrent] ^short = "Roehrenstrom in mA"
* extension[tubeCurrent] ^definition = "Roehrenstrom der Roentgenroehre in Milliampere (mA). DICOM Tag 0018,1151."

// exposureTime: Belichtungszeit in Sekunden
* extension[exposureTime].value[x] only Quantity
* extension[exposureTime].valueQuantity.system = "http://unitsofmeasure.org"
* extension[exposureTime].valueQuantity.code = #s
* extension[exposureTime] ^short = "Belichtungszeit in Sekunden"
* extension[exposureTime] ^definition = "Belichtungszeit der Roentgenaufnahme in Sekunden. DICOM Tag 0018,1150."
