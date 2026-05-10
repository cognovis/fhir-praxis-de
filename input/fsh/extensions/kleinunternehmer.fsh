// Kleinunternehmerregelung § 19 UStG — Extension on Organization
// Bead: fpde-shp.6. ChargeItem-Logik und Invoice-Constraint folgen in fpde-47a.

Extension: KleinunternehmerregelungExt
Id: kleinunternehmerregelung
Title: "Kleinunternehmerregelung § 19 UStG"
Description: "Kennzeichnung ob die Praxis unter die Kleinunternehmerregelung nach § 19 UStG faellt. Seit 2025: Schwellen 25.000 EUR Vorjahresumsatz / 100.000 EUR laufendes Jahr. Bei aktiver Regelung: Keine USt-Ausweis, Pflicht-Hinweis auf Rechnungen ('gemaess § 19 UStG wird keine Umsatzsteuer berechnet'). ChargeItem-Logik und Invoice-Constraint folgen in fpde-47a."
Context: Organization
* extension contains
    aktiv 1..1 and
    gueltigAb 0..1
* extension[aktiv].value[x] only boolean
* extension[aktiv] ^short = "Kleinunternehmerregelung aktiv (ja/nein)"
* extension[gueltigAb].value[x] only date
* extension[gueltigAb] ^short = "Gueltig ab (Stichtag des Wechsels)"
* extension[gueltigAb] ^definition = "Datum ab dem die KU-Regelung greift (oder endet). Relevant bei jaehrlichem Wechsel."
