CodeSystem: RezeptTypCS
Id: rezept-typ
Title: "Rezepttyp"
Description: "Typ des Rezepts in der ambulanten Versorgung"
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/rezept-typ"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #gkv "GKV-Rezept" "Rezept fuer gesetzlich versicherte Patienten (Muster 16)"
* #privat "Privatrezept" "Rezept fuer privat versicherte Patienten"
* #btm "BTM-Rezept" "Betaeubungsmittelrezept nach BtMVV"
* #t-rezept "T-Rezept" "Thalidomid-Rezept (THALIX/Lenalidomid)"

CodeSystem: MedikationKategorieCS
Id: medikation-kategorie
Title: "Medikationskategorie"
Description: "Kategorie der Medikation hinsichtlich der Einnahmedauer"
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/medikation-kategorie"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #dauermedikation "Dauermedikation" "Medikament wird dauerhaft eingenommen"
* #bedarfsmedikation "Bedarfsmedikation" "Medikament wird nur bei Bedarf eingenommen"
