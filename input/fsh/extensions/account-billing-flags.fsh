// ============================================================================
// Account billing-case flags (on AccountPraxisSchein / Account)
// ============================================================================

Extension: AccountAbrechnungssperreExt
Id: account-abrechnungssperre
Title: "Abrechnungssperre"
Description: "Kennzeichen, ob der Schein (Abrechnungsfall) fuer die Abrechnung gesperrt ist. Quelle: Schein.Abrechnungssperre"
Context: Account
* value[x] only boolean

Extension: AccountErsatzverfahrenExt
Id: account-ersatzverfahren
Title: "Ersatzverfahren"
Description: "Kennzeichen, ob fuer den Schein (Abrechnungsfall) das Ersatzverfahren (manuelle Erfassung ohne eGK) angewendet wurde. Quelle: Schein.Ersatzverfahren"
Context: Account
* value[x] only boolean
