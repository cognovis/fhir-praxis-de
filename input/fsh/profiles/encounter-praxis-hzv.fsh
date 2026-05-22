// EncounterPraxisHZV — HZV-Abrechnungsschein-Profil der deutschen Praxisverwaltung
// Spezialisiert EncounterPraxis fuer die hausarztzentrierte Versorgung (§73b SGB V).
// Fixiert die lokale Praxis-Scheinart auf hzv. KBV_CS_SFHIR_KBV_SCHEINART hat
// keinen offiziellen HZV-Code.

Profile: EncounterPraxisHZV
Parent: EncounterPraxis
Id: encounter-praxis-hzv
Title: "Encounter Praxis HZV"
Description: "Abrechnungsschein fuer die hausarztzentrierte Versorgung (HZV, §73b SGB V). Spezialisiert EncounterPraxis: fixiert die lokale Praxis-Scheinart auf hzv und erlaubt die Angabe des HZV-Rechnungsschemas per Extension."

// HZV ist nicht Teil der offiziellen KBV_SFHIR_KBV_SCHEINART-Terminologie.
* type[praxis-scheinart].coding.code = #hzv

// HZV-Rechnungsschema-Extension (optional): identifiziert den Vertragskatalog der Krankenkasse
* extension contains HzvRechnungsschemaExt named hzv-rechnungsschema 0..1 MS
* extension[hzv-rechnungsschema] ^short = "HZV-Rechnungsschema (Vertragskatalog)"
* extension[hzv-rechnungsschema] ^definition = "Identifiziert das konkrete HZV-Rechnungsschema (Vertragskatalog) der Krankenkasse, nach dem dieser Schein abgerechnet wird."
