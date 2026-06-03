CodeSystem: CorrectionRuleCS
Id: kvb-richtigstellung
Title: "KVB Richtigstellungsgrund"
Description: "Codes für KV-Richtigstellungen im Honorarbescheid"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #ZF "Zufügung" "Runtime correction rule with credit direction"
* #HO "Honorarordnung" "Runtime correction rule with debit direction"
* #ER "Ersetzung/Umsetzung" "Runtime correction rule with neutral direction"
* #UV "Übergreifende Validierung" "Runtime correction rule with debit direction"
* #WU "Wechselseitige Unverträglichkeit" "Runtime correction rule with debit direction"
* #GHO "Gruppen-Honorarordnung" "Runtime correction rule with debit direction"
* #SFX "Sonderfall/Richtlinie" "Runtime correction rule with debit direction"
* #ZS "Zusammenhangsprüfung" "Runtime correction rule with debit direction"
* #MF "Meldefehler" "Runtime correction rule with debit direction"
* #HW "Höchstwert-Ersetzung" "Runtime correction rule with neutral direction"
* #AT "Automatische Technik" "Runtime correction rule with credit direction"
* #MZ "Manuelle Zufügung" "Runtime correction rule with credit direction"
* #MU "Manuelle Umsetzung" "Runtime correction rule with neutral direction"
* #MS "Mengensteuerung/Fachgebiet" "Runtime correction rule with debit direction"
* #ZHO "Zusatz-Honorarordnung" "Runtime correction rule with debit direction"
* #SKV "Kostenträger-Validierung" "Runtime correction rule with debit direction"
// Legacy documented KVB codes that are not currently observed in production runtime corpora.
* #PL "Plausibilitätsprüfung" "Documented KVB code; not currently observed in known runtime corpora"
* #WP "Wirtschaftlichkeitsprüfung" "Documented KVB code; not currently observed in known runtime corpora"
* #ST "Storno" "Documented KVB code; not currently observed in known runtime corpora"
* #KO "Korrektur" "Documented KVB code; not currently observed in known runtime corpora"
