Instance: example-organization-with-bank-account
InstanceOf: Organization
Title: "Zahnarztpraxis Dr. Mustermann (mit Bankverbindung)"
Description: "Beispiel einer Organisation mit Bankverbindungsangabe (BankAccountExt)."
Usage: #example
* active = true
* name = "Zahnarztpraxis Dr. Mustermann"
* extension[bank-account].extension[iban].valueString = "DE89370400440532013000"
* extension[bank-account].extension[bic].valueString = "COBADEFFXXX"
* extension[bank-account].extension[bankname].valueString = "Commerzbank AG"
* extension[bank-account].extension[kontoinhaber].valueString = "Zahnarztpraxis Dr. Mustermann"
