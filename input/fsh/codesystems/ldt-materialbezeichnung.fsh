// LDT Materialbezeichnung CodeSystem (FK 8428)
// Minimale Definition der haeufigsten Probenmaterial-Bezeichnungen gemaess LDT3-Schluessel.
// Quelle: KBV LDT3 Spezifikation (Feldkennung 8428 — Materialbezeichnung)

CodeSystem: LdtMaterialbezeichnungCS
Id: ldt-materialbezeichnung
Title: "LDT Materialbezeichnung (FK 8428)"
Description: "Probenmaterial-Bezeichnungen gemaess LDT3-Schluessel (Feldkennung 8428). PVS-agnostische Auswahl haeufiger Materialien."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/ldt-materialbezeichnung"
* ^status = #active
* ^content = #fragment
* ^caseSensitive = true
* ^experimental = false

* #EDTA-Blut "EDTA-Blut" "Venaeses Blut in EDTA-Roehrchen (Haematologie, klinische Chemie)"
* #Serum "Serum" "Blutserum (klinische Chemie, Serologie)"
* #Urin-MSU "Urin-MSU" "Mittelstrahlurin (Urinalyse, Urinkultur)"
* #Abstrich "Abstrich" "Abstrich (Mikrobiologie)"
* #Liquor "Liquor" "Liquor cerebrospinalis"
* #Stuhl "Stuhl" "Stuhlprobe (Mikrobiologie, Parasitologie)"
* #Urin "Urin" "Urin (ungeklaert, Streifentest)"
