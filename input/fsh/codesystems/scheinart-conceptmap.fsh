Instance: scheinart-to-kvdt
InstanceOf: ConceptMap
Title: "ScheinartCS → KVDT Scheinuntergruppe"
Description: "Mappt PVS-interne Scheinart-Codes (ScheinartCS) auf KVDT-offizielle Scheinuntergruppe-Codes (KBV_CS_SFHIR_KBV_SCHEINART). Nur GKV-relevante Codes (gkv, ue, not) haben eine Entsprechung; pkv, bg, igel sind nicht in der KBV Schlüsseltabelle."
Usage: #definition
* url = "https://fhir.cognovis.de/praxis/ConceptMap/scheinart-to-kvdt"
* status = #active
* experimental = false
* sourceCanonical = "https://fhir.cognovis.de/praxis/ValueSet/scheinart"
* targetCanonical = "https://fhir.cognovis.de/praxis/ValueSet/kvdt-scheinuntergruppe"
* group[0].source = "https://fhir.cognovis.de/praxis/CodeSystem/scheinart"
* group[0].target = "https://fhir.cognovis.de/praxis/CodeSystem/kvdt-scheinuntergruppe"
* group[0].element[0].code = #gkv
* group[0].element[0].display = "GKV"
* group[0].element[0].target[0].code = #00
* group[0].element[0].target[0].display = "Behandlungsausweis"
* group[0].element[0].target[0].equivalence = #wider
* group[0].element[0].target[0].comment = "#gkv umfasst alle GKV-Scheine; #00 ist nur der Primär-/Hausarztschein — daher wider (gkv ist breiter)"
* group[0].element[1].code = #ue
* group[0].element[1].display = "Ueberweisung"
* group[0].element[1].target[0].code = #21
* group[0].element[1].target[0].display = "Überweisungsschein zur Mitbehandlung"
* group[0].element[1].target[0].equivalence = #relatedto
* group[0].element[1].target[0].comment = "Allgemeine Überweisung auf häufigsten KVDT-Überweisungstyp gemappt"
* group[0].element[2].code = #not
* group[0].element[2].display = "Notfall"
* group[0].element[2].target[0].code = #41
* group[0].element[2].target[0].display = "Notfallschein"
* group[0].element[2].target[0].equivalence = #relatedto
* group[0].element[3].code = #pkv
* group[0].element[3].display = "PKV"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "PKV nicht in KBV Schlüsseltabelle (nur GKV-Fälle)"
* group[0].element[4].code = #bg
* group[0].element[4].display = "BG"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "BG nicht in KBV Schlüsseltabelle"
* group[0].element[5].code = #igel
* group[0].element[5].display = "IGeL"
* group[0].element[5].target[0].equivalence = #unmatched
* group[0].element[5].target[0].comment = "IGeL nicht in KBV Schlüsseltabelle"

Instance: kvdt-to-scheinart
InstanceOf: ConceptMap
Title: "KVDT Scheinuntergruppe → ScheinartCS"
Description: "Reverse-Mapping: KVDT-offizielle Scheinuntergruppe-Codes (KBV_CS_SFHIR_KBV_SCHEINART) auf PVS-interne Scheinart-Codes (ScheinartCS). Für KVDT-Import: Adapter nutzt diese Map um empfangene KVDT-Codes in interne Scheinart-Codes zu übersetzen."
Usage: #definition
* url = "https://fhir.cognovis.de/praxis/ConceptMap/kvdt-to-scheinart"
* status = #active
* experimental = false
* sourceCanonical = "https://fhir.cognovis.de/praxis/ValueSet/kvdt-scheinuntergruppe"
* targetCanonical = "https://fhir.cognovis.de/praxis/ValueSet/scheinart"
* group[0].source = "https://fhir.cognovis.de/praxis/CodeSystem/kvdt-scheinuntergruppe"
* group[0].target = "https://fhir.cognovis.de/praxis/CodeSystem/scheinart"
// Primärfall → gkv
* group[0].element[0].code = #00
* group[0].element[0].display = "Behandlungsausweis"
* group[0].element[0].target[0].code = #gkv
* group[0].element[0].target[0].display = "GKV"
* group[0].element[0].target[0].equivalence = #wider
// 01xx Kurativ-Arzt → gkv
* group[0].element[1].code = #0101
* group[0].element[1].display = "Überweisungsschein"
* group[0].element[1].target[0].code = #gkv
* group[0].element[1].target[0].display = "GKV"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[2].code = #0102
* group[0].element[2].display = "Überweisungsschein Vertretung"
* group[0].element[2].target[0].code = #gkv
* group[0].element[2].target[0].display = "GKV"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[3].code = #0104
* group[0].element[3].display = "Überweisungsschein Notfall"
* group[0].element[3].target[0].code = #gkv
* group[0].element[3].target[0].display = "GKV"
* group[0].element[3].target[0].equivalence = #wider
// 10 Notfall-/Vertretungsfall → not
* group[0].element[4].code = #10
* group[0].element[4].display = "Behandlungsschein ambulante Notfallbehandlung"
* group[0].element[4].target[0].code = #not
* group[0].element[4].target[0].display = "Notfall"
* group[0].element[4].target[0].equivalence = #relatedto
// 20er Überweisungen → ue
* group[0].element[5].code = #20
* group[0].element[5].display = "Überweisungsschein"
* group[0].element[5].target[0].code = #ue
* group[0].element[5].target[0].display = "Ueberweisung"
* group[0].element[5].target[0].equivalence = #relatedto
* group[0].element[6].code = #21
* group[0].element[6].display = "Überweisungsschein zur Mitbehandlung"
* group[0].element[6].target[0].code = #ue
* group[0].element[6].target[0].display = "Ueberweisung"
* group[0].element[6].target[0].equivalence = #relatedto
* group[0].element[7].code = #22
* group[0].element[7].display = "Überweisungsschein zur Konsiliaruntersuchung"
* group[0].element[7].target[0].code = #ue
* group[0].element[7].target[0].display = "Ueberweisung"
* group[0].element[7].target[0].equivalence = #relatedto
* group[0].element[8].code = #23
* group[0].element[8].display = "Überweisungsschein zur Auftragsleistung"
* group[0].element[8].target[0].code = #ue
* group[0].element[8].target[0].display = "Ueberweisung"
* group[0].element[8].target[0].equivalence = #relatedto
* group[0].element[9].code = #24
* group[0].element[9].display = "Überweisungsschein zur Weiterbehandlung"
* group[0].element[9].target[0].code = #ue
* group[0].element[9].target[0].display = "Ueberweisung"
* group[0].element[9].target[0].equivalence = #relatedto
* group[0].element[10].code = #25
* group[0].element[10].display = "Überweisungsschein zur Mitbehandlung bei Schwangerschaft"
* group[0].element[10].target[0].code = #ue
* group[0].element[10].target[0].display = "Ueberweisung"
* group[0].element[10].target[0].equivalence = #relatedto
* group[0].element[11].code = #26
* group[0].element[11].display = "Überweisungsschein zur Mitbehandlung Psychiatrie"
* group[0].element[11].target[0].code = #ue
* group[0].element[11].target[0].display = "Ueberweisung"
* group[0].element[11].target[0].equivalence = #relatedto
* group[0].element[12].code = #27
* group[0].element[12].display = "Überweisungsschein Labor"
* group[0].element[12].target[0].code = #ue
* group[0].element[12].target[0].display = "Ueberweisung"
* group[0].element[12].target[0].equivalence = #relatedto
* group[0].element[13].code = #28
* group[0].element[13].display = "Überweisungsschein Pathologie"
* group[0].element[13].target[0].code = #ue
* group[0].element[13].target[0].display = "Ueberweisung"
* group[0].element[13].target[0].equivalence = #relatedto
// 30er Belegärztlich → gkv (kein eigener Typ in ScheinartCS)
* group[0].element[14].code = #31
* group[0].element[14].display = "Überweisungsschein zur belegärztlichen Behandlung"
* group[0].element[14].target[0].code = #gkv
* group[0].element[14].target[0].display = "GKV"
* group[0].element[14].target[0].equivalence = #relatedto
* group[0].element[14].target[0].comment = "Kein eigener belegärztlicher Typ in ScheinartCS"
* group[0].element[15].code = #32
* group[0].element[15].display = "Belegärztliche Notaufnahme"
* group[0].element[15].target[0].code = #not
* group[0].element[15].target[0].display = "Notfall"
* group[0].element[15].target[0].equivalence = #relatedto
// 40er Notfälle → not
* group[0].element[16].code = #41
* group[0].element[16].display = "Notfallschein"
* group[0].element[16].target[0].code = #not
* group[0].element[16].target[0].display = "Notfall"
* group[0].element[16].target[0].equivalence = #relatedto
* group[0].element[17].code = #42
* group[0].element[17].display = "Notfallschein Unfall"
* group[0].element[17].target[0].code = #not
* group[0].element[17].target[0].display = "Notfall"
* group[0].element[17].target[0].equivalence = #relatedto
* group[0].element[18].code = #43
* group[0].element[18].display = "Notfallschein Arbeitsunfall"
* group[0].element[18].target[0].code = #bg
* group[0].element[18].target[0].display = "BG"
* group[0].element[18].target[0].equivalence = #relatedto
* group[0].element[18].target[0].comment = "Arbeitsunfall fällt unter BG-Schein"
* group[0].element[19].code = #44
* group[0].element[19].display = "Notfallschein Bereitschaftsdienst"
* group[0].element[19].target[0].code = #not
* group[0].element[19].target[0].display = "Notfall"
* group[0].element[19].target[0].equivalence = #relatedto
* group[0].element[20].code = #45
* group[0].element[20].display = "Notfallschein KV-Notfallpraxis"
* group[0].element[20].target[0].code = #not
* group[0].element[20].target[0].display = "Notfall"
* group[0].element[20].target[0].equivalence = #relatedto
* group[0].element[21].code = #46
* group[0].element[21].display = "Notfallschein Krankenhausnotaufnahme"
* group[0].element[21].target[0].code = #not
* group[0].element[21].target[0].display = "Notfall"
* group[0].element[21].target[0].equivalence = #relatedto
