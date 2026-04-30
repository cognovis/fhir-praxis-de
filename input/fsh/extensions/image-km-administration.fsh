// image-km-administration Extension — Kontrastmittel-Gabe fuer ImagingStudy
// Erfasst ob Kontrastmittel verabreicht wurde, welches Mittel (ATC), Dosis,
// Applikationsweg und GOAe-Abrechnungsziffer.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

Extension: ImageKmAdministrationExt
Id: image-km-administration
Title: "Image KM Administration"
Description: "Kontrastmittel-Gabe bei bildgebenden Untersuchungen. Dokumentiert ob KM verabreicht wurde, welches Mittel (ATC-Klassifikation), Dosis, Applikationsweg und ggf. GOAe-Abrechnungsziffer fuer die KM-Gabe."
* ^url = "https://fhir.cognovis.de/praxis/StructureDefinition/image-km-administration"
* ^status = #active
* ^experimental = false
* ^context[+].type = #element
* ^context[=].expression = "ImagingStudy"

* extension contains
    administered 1..1 MS and
    agent-atc 0..1 and
    agent-name 0..1 MS and
    dose-ml 0..1 and
    route 0..1 and
    goae-reference 0..1

// administered: Wurde Kontrastmittel verabreicht?
* extension[administered].value[x] only boolean
* extension[administered] ^short = "Kontrastmittel verabreicht (ja/nein)"
* extension[administered] ^definition = "Gibt an ob ein Kontrastmittel verabreicht wurde. Pflichtfeld."

// agent-atc: ATC-Klassifikation des Kontrastmittels
* extension[agent-atc].value[x] only CodeableConcept
* extension[agent-atc].valueCodeableConcept from https://fhir.cognovis.de/imaging/ValueSet/contrast-agent-atc (preferred)
* extension[agent-atc] ^short = "Kontrastmittel ATC-Klassifikation"
* extension[agent-atc] ^definition = "ATC-Klassifikation des verabreichten Kontrastmittels (z.B. V08CA fuer gadoliniumhaltige MRT-Kontrastmittel)."

// agent-name: Freitextname des Kontrastmittels
* extension[agent-name].value[x] only string
* extension[agent-name] ^short = "Kontrastmittel Freitext-Name"
* extension[agent-name] ^definition = "Freitextangabe des Handelsnamens oder Wirkstoffnamens des Kontrastmittels."

// dose-ml: Verabreichte Dosis in ml
* extension[dose-ml].value[x] only Quantity
* extension[dose-ml].valueQuantity.system = "http://unitsofmeasure.org"
* extension[dose-ml].valueQuantity.code = #mL
* extension[dose-ml] ^short = "Kontrastmittel-Dosis in ml"
* extension[dose-ml] ^definition = "Verabreichte Menge des Kontrastmittels in Milliliter."

// route: Applikationsweg
* extension[route].value[x] only CodeableConcept
* extension[route].valueCodeableConcept from http://hl7.org/fhir/ValueSet/route-codes (preferred)
* extension[route] ^short = "Applikationsweg"
* extension[route] ^definition = "Art der Verabreichung des Kontrastmittels (z.B. intravenoese Gabe)."

// goae-reference: GOAe-Abrechnungsziffer fuer die KM-Gabe
* extension[goae-reference].value[x] only Reference(ChargeItemDefinition)
* extension[goae-reference] ^short = "GOAe-Abrechnungsziffer fuer KM-Gabe"
* extension[goae-reference] ^definition = "Referenz auf die GOAe ChargeItemDefinition fuer die Abrechnung der Kontrastmittel-Gabe."
