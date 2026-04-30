Extension: BankAccountExt
Id: bank-account
Title: "Bankverbindung"
Description: "Bankverbindung einer Organisation (IBAN, BIC, Bankname, Kontoinhaber). Kann mehrfach angegeben werden."
Context: Organization
* extension contains
    iban 1..1 and
    bic 0..1 and
    bankname 0..1 and
    kontoinhaber 0..1
* extension[iban].value[x] only string
* extension[iban] ^short = "IBAN der Bankverbindung"
* extension[bic].value[x] only string
* extension[bic] ^short = "BIC/SWIFT-Code der Bank"
* extension[bankname].value[x] only string
* extension[bankname] ^short = "Name der Bank"
* extension[kontoinhaber].value[x] only string
* extension[kontoinhaber] ^short = "Name des Kontoinhabers"
