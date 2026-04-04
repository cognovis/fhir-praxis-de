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

Instance: example-organization-minimal-bank-account
InstanceOf: Organization
Title: "Praxis mit minimaler Bankverbindung (IBAN + BIC)"
Description: "Organization mit nur IBAN und BIC, ohne Bankname und Kontoinhaber."
Usage: #example
* active = true
* name = "Zahnarztpraxis Minimal"
* extension[bank-account].extension[iban].valueString = "DE12500105170648489890"
* extension[bank-account].extension[bic].valueString = "INGDDEFFXXX"

Instance: example-organization-multi-bank-account
InstanceOf: Organization
Title: "Praxis mit zwei Bankverbindungen"
Description: "Organization mit zwei Bankverbindungen (Gehaelter und Betriebskonto)."
Usage: #example
* active = true
* name = "MVZ Mustermann GmbH"
* extension[bank-account][0].extension[iban].valueString = "DE89370400440532013000"
* extension[bank-account][0].extension[bic].valueString = "COBADEFFXXX"
* extension[bank-account][0].extension[bankname].valueString = "Commerzbank AG"
* extension[bank-account][0].extension[kontoinhaber].valueString = "MVZ Mustermann GmbH"
* extension[bank-account][1].extension[iban].valueString = "DE75512108001245126199"
* extension[bank-account][1].extension[bic].valueString = "SSKMDEMM"
* extension[bank-account][1].extension[bankname].valueString = "Stadtsparkasse Muenchen"
* extension[bank-account][1].extension[kontoinhaber].valueString = "MVZ Mustermann GmbH — Betriebskonto"
