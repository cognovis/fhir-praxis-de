// Ueberweisungs-Quelldaten (BSNR/LANR des Ueberweisers) auf dem Account (Schein).
// Auf einem Ueberweisungsschein (Scheinart Ueberweisung) traegt das Quellsystem die
// ueberweisende Betriebsstaette (BSNR) und den ueberweisenden Arzt (LANR). Dies ist das
// Account-seitige Pendant zur ServiceRequest-basierten Ueberweisung auf der anfordernden
// Seite; die Werte werden als Rohstrings aus dem PVS uebernommen.

Extension: AccountUeberweisungVonBsnrExt
Id: account-ueberweisung-von-bsnr
Title: "Ueberweiser BSNR"
Description: "Betriebsstaettennummer (BSNR) der ueberweisenden Praxis auf einem Ueberweisungsschein (Scheinart Ueberweisung). Rohwert aus dem Quellsystem. Quelle: Schein.ÜberweisungVon"
Context: Account
* value[x] only string

Extension: AccountUeberweisungVonLanrExt
Id: account-ueberweisung-von-lanr
Title: "Ueberweiser LANR"
Description: "Lebenslange Arztnummer (LANR) des ueberweisenden Arztes auf einem Ueberweisungsschein (Scheinart Ueberweisung). Rohwert aus dem Quellsystem. Quelle: Schein.ÜberweisungVonLANR"
Context: Account
* value[x] only string
