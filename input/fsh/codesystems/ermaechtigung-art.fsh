// ermaechtigung-art.fsh
// Art der aerztlichen Ermaechtigung
// Bead: fpde-e0o

CodeSystem: ErmaechtingungArtCS
Id: ermaechtigung-art
Title: "Ermaechtigung Art"
Description: "Arten der aerztlichen Ermaechtigung gemaess § 116 SGB V und verwandter Vorschriften"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #krankenhausambulanz "Krankenhausambulanz" "Ermaechtigung fuer Krankenhausambulanz gemaess § 116 SGB V"
* #mvz-uebergang "MVZ-Uebergang" "Uebergangsmassnahme fuer Medizinisches Versorgungszentrum"
* #bedarfsplanung "Bedarfsplanung" "Ermaechtigung im Rahmen der Bedarfsplanung"
* #sonderbedarfszulassung "Sonderbedarfszulassung" "Sonderbedarfszulassung gemaess § 101 Abs. 1 Nr. 3 SGB V"
* #notfallversorgung "Notfallversorgung" "Ermaechtigung fuer Notfallversorgung"

ValueSet: ErmaechtingungArtVS
Id: ermaechtigung-art-vs
Title: "Ermaechtigung Art"
Description: "Arten der aerztlichen Ermaechtigung"
* ^status = #active
* ^experimental = false
* include codes from system ErmaechtingungArtCS
