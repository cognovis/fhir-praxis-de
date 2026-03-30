Extension: RechnungsbetragExt
Id: rechnungsbetrag
Title: "Rechnungsbetrag"
Description: "Rechnungsbetrag"
Context: Account
* value[x] only Money

Extension: OpSollExt
Id: op-soll
Title: "OP Soll"
Description: "Sollbetrag der offenen Posten"
Context: Account
* value[x] only Money

Extension: OpHabenExt
Id: op-haben
Title: "OP Haben"
Description: "Habenbetrag der offenen Posten"
Context: Account
* value[x] only Money

Extension: MahnstufeExt
Id: mahnstufe
Title: "Mahnstufe"
Description: "Aktuelle Mahnstufe"
Context: Account
* value[x] only integer

Extension: MahnsperreExt
Id: mahnsperre
Title: "Mahnsperre"
Description: "Kennzeichen ob eine Mahnsperre vorliegt"
Context: Account
* value[x] only boolean

Extension: FaelligkeitsdatumExt
Id: faelligkeitsdatum
Title: "Faelligkeitsdatum"
Description: "Faelligkeitsdatum der Forderung"
Context: Account
* value[x] only date

Extension: LetzteMahnungExt
Id: letzte-mahnung
Title: "Letzte Mahnung"
Description: "Datum der letzten Mahnung"
Context: Account
* value[x] only date

Extension: MahngebuehrExt
Id: mahngebuehr
Title: "Mahngebuehr"
Description: "Mahngebuehr"
Context: Communication
* value[x] only Money

Extension: OpRefExt
Id: op-ref
Title: "OP-Referenz"
Description: "Referenz auf den zugehoerigen Account (Offener Posten)"
Context: Communication
* value[x] only Reference(Account)
