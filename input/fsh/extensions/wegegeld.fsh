CodeSystem: PraxisHausbesuchBesuchszonenCS
Id: praxis-hausbesuch-besuchszonen
Title: "Praxis Home Visit Zones"
Description: "Local home-visit zone codes mirroring KBV_VS_AW_Hausbesuch_Besuchszonen for Wegegeld."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/praxis-hausbesuch-besuchszonen"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #zone-a "Zone A" "Home visit zone A, 0-2 km."
* #zone-b "Zone B" "Home visit zone B, 2-5 km."
* #zone-c "Zone C" "Home visit zone C, more than 5 km."

ValueSet: PraxisHausbesuchBesuchszonenVS
Id: praxis-hausbesuch-besuchszonen
Title: "Praxis Home Visit Zones"
Description: "Local home-visit zone value set mirroring KBV_VS_AW_Hausbesuch_Besuchszonen for Wegegeld."
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/praxis-hausbesuch-besuchszonen"
* ^status = #active
* ^experimental = false
* include codes from system PraxisHausbesuchBesuchszonenCS

Extension: WegegeldHausbesuchExt
Id: wegegeld-hausbesuch
Title: "Wegegeld Hausbesuch"
Description: "Distance and zone for home visits (Wegegeld). Sourced from Patient.EntfernungZurPraxis (distance km) and Schein.Zonenkennzeichen/Patient.Zonenkennzeichen (per ADR-002). Editable by downstream systems with writeback."
Context: Encounter
* extension contains distance 0..1 MS and zone 0..1 MS
* extension[distance] ^short = "Home visit distance in kilometres"
* extension[distance] ^definition = "Distance to the patient home in km, sourced from Patient.EntfernungZurPraxis. Used for Wegegeld billing code determination per EBM chapter 40."
* extension[distance].url = "distance"
* extension[distance].value[x] only Quantity
* extension[distance].valueQuantity.unit = "km"
* extension[distance].valueQuantity.system = "http://unitsofmeasure.org"
* extension[distance].valueQuantity.code = #km
* extension[zone] ^short = "Home visit Besuchszone"
* extension[zone] ^definition = "Zone coding for Wegegeld, sourced from Schein.Zonenkennzeichen with Patient.Zonenkennzeichen as default per ADR-002. Editable by downstream systems with writeback to the configured source columns per ADR-002."
* extension[zone].url = "zone"
* extension[zone].value[x] only Coding
* extension[zone].valueCoding from PraxisHausbesuchBesuchszonenVS (required)
