// Organization instances used by invoice tax examples.
// example-praxis: generic practice (no KU regulation).
// example-zahnarzt-praxis: dental practice with KleinunternehmerregelungExt.
// ASCII-safe: keine Umlaute in Kommentaren.

Instance: example-praxis
InstanceOf: PraxisOrganizationDE
Title: "Beispiel Organisation — Arztpraxis"
Description: "Muster-Arztpraxis ohne Kleinunternehmerregelung. Wird in Invoice-Beispielen (19%, KU) als Rechnungssteller verwendet."
Usage: #example

* name = "Musterpraxis Dr. Muster"
* type[0] = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"

// ---

Instance: example-zahnarzt-praxis
InstanceOf: PraxisOrganizationDE
Title: "Beispiel Organisation — Zahnarztpraxis (Kleinunternehmer)"
Description: "Muster-Zahnarztpraxis mit aktiver Kleinunternehmerregelung nach § 19 UStG ab 2025-01-01. Wird in Invoice-Beispielen (E §4Nr14a, 7%) als Rechnungssteller verwendet."
Usage: #example

* name = "Zahnarztpraxis Dr. Zahnarzt"
* type[0] = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* extension[kleinunternehmerregelung].extension[aktiv].valueBoolean = true
* extension[kleinunternehmerregelung].extension[gueltigAb].valueDate = "2025-01-01"
