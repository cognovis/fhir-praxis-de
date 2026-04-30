Extension: AbrechSatzartExt
Id: abrech-satzart
Title: "Abrechnung Satzart"
Description: "KV-Abrechnung Satzart fuer Claim-Positionen."
Context: Claim.item
* value[x] only string

Extension: AbrechFeldkennungExt
Id: abrech-feldkennung
Title: "Abrechnung Feldkennung"
Description: "KV-Abrechnung Feldkennung fuer Claim-Positionen."
Context: Claim.item
* value[x] only integer

Extension: HvVersichertenNrExt
Id: hv-versicherten-nr
Title: "HV Versichertennummer"
Description: "eGK Versichertennummer aus dem Hauptversicherungsverhaeltnis."
Context: Coverage
* value[x] only string
