CodeSystem: BillingBezugsraumCS
Id: billing-bezugsraum
Title: "Abrechnungsbezugsraum"
Description: "Zeitlicher Bezugsraum für Ausschlussregelungen im EBM (Behandlungsfall, Arztfall, Sitzung, Tag)"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #BF "Behandlungsfall" "Ausschluss gilt innerhalb desselben Behandlungsfalls (Quartal)"
* #AF "Arztfall" "Ausschluss gilt innerhalb desselben Arztfalls"
* #SF "Sitzung" "Ausschluss gilt für dieselbe Sitzung (Arztkontakt)"
* #TG "Tag" "Ausschluss gilt für denselben Behandlungstag"
