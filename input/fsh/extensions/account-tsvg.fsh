// TSVG case-level qualifiers on Account (case carrier)

Extension: AccountTsvgVermittlungsartExt
Id: account-tsvg-vermittlungsart
Title: "TSVG Vermittlungs-/Kontaktart"
Description: "TSVG Vermittlungs-/Kontaktart (KVDT FK 4103) des Behandlungsfalls. Steuert die extrabudgetaere Verguetung. Quelle: Schein.Vermittlungsart."
Context: Account
* value[x] only code
* valueCode from https://fhir.cognovis.de/praxis/ValueSet/tsvg-vermittlungsart (required)

Extension: AccountTerminvermittlungsdatumExt
Id: account-terminvermittlungsdatum
Title: "Tag der Terminvermittlung"
Description: "Datum der Terminvermittlung (TSVG). Quelle: Schein.TagDerTerminvermittlung."
Context: Account
* value[x] only date
