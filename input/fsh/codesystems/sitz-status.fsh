// sitz-status.fsh
// Status codes for KV-Sitz (practice seat/license)
// Bead: fpde-e0o

CodeSystem: SitzStatusCS
Id: sitz-status
Title: "Sitz Status"
Description: "Statuswerte fuer einen KV-Sitz (Niederlassungssitz)"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #aktiv "Aktiv" "Sitz ist aktiv besetzt"
* #vakant "Vakant" "Sitz ist vakant (unbesetzt)"
* #ruhend "Ruhend" "Sitz ruht voruebergehend"
* #verkauft "Verkauft" "Sitz wurde verkauft"

ValueSet: SitzStatusVS
Id: sitz-status-vs
Title: "Sitz Status"
Description: "Statuswerte fuer einen KV-Sitz"
* ^status = #active
* ^experimental = false
* include codes from system SitzStatusCS
