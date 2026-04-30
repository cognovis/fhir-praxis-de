// EncounterPraxisHZV — HZV-Abrechnungsschein-Profil der deutschen Praxisverwaltung
// Spezialisiert EncounterPraxis fuer die hausarztzentrierte Versorgung (§73b SGB V).
// Fixiert KBV-Scheinart auf #50 (HZV-Hausarztschein).

Profile: EncounterPraxisHZV
Parent: EncounterPraxis
Id: encounter-praxis-hzv
Title: "Encounter Praxis HZV"
Description: "Abrechnungsschein fuer die hausarztzentrierte Versorgung (HZV, §73b SGB V). Spezialisiert EncounterPraxis: fixiert Scheinart auf KBV-Code #50 (HZV) und erlaubt die Angabe des HZV-Rechnungsschemas per Extension."

// Scheinart KBV: HZV = #50 (Hausarztschein HZV)
* type[kbv-scheinart].coding.code = #50

// HZV-Rechnungsschema-Extension (optional): identifiziert den Vertragskatalog der Krankenkasse
* extension contains HzvRechnungsschemaExt named hzv-rechnungsschema 0..1 MS
* extension[hzv-rechnungsschema] ^short = "HZV-Rechnungsschema (Vertragskatalog)"
* extension[hzv-rechnungsschema] ^definition = "Identifiziert das konkrete HZV-Rechnungsschema (Vertragskatalog) der Krankenkasse, nach dem dieser Schein abgerechnet wird."
