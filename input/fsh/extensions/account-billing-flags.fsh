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

Extension: AccountNachzueglerExt
Id: account-nachzuegler
Title: "Nachzuegler"
Description: "Kennzeichen, ob der Schein (Abrechnungsfall) als Nachzuegler in einer spaeteren KVDT-Lieferung als dem servicePeriod-Quartal eingereicht wird. Quelle: Schein.Nachzuegler"
Context: Account
* value[x] only boolean

Extension: AccountArztPatientenKontaktExt
Id: account-arzt-patienten-kontakt
Title: "Arzt-Patienten-Kontakte"
Description: "Anzahl der Arzt-Patienten-Kontakte (APK) im Abrechnungsfall (Schein). KVDT-relevant; aus der Quelle uebernommen, nicht aus Encounter-Zaehlung abgeleitet. Quelle: Schein.ArztPatientenKontakt"
Context: Account
* value[x] only unsignedInt

Extension: AccountEgkLesedatumExt
Id: account-egk-lesedatum
Title: "eGK Lesedatum"
Description: "Datum des letzten eGK-/VSDM-Einlesens im Quartal. Fehlt das Datum, wurde die Karte im Quartal nicht eingelesen (vgl. Ersatzverfahren). Quelle: Schein.Chipkartenlesedatum (Sentinel-Wert wird als fehlend abgebildet)"
Context: Account
* value[x] only date
