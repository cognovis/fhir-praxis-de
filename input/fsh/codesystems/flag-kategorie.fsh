CodeSystem: FlagKategorieCS
Id: flag-kategorie
Title: "Flag-Kategorie"
Description: "Kategorien fuer patientenbezogene Flags (Hinweise, CAVE, Risiken) in der ambulanten Praxis"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #hinweis "Hinweis" "Allgemeiner Hinweis"
* #cave "CAVE" "Warnhinweis zu Arzneimitteln oder Allergien"
* #risiko "Risiko" "Risikohinweis (z.B. Sturzgefahr)"
* #op "OP" "Operationshinweis"
* #info "Info" "Informationshinweis"
* #dicom "DICOM-Sicherheitshinweis" "Hinweis auf implantierten Schrittmacher oder MRT-Kontraindikation"
