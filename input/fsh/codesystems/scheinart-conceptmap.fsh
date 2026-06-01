// ScheinartCS <-> KBV Scheinuntergruppe ConceptMaps.
// Rebound to the canonical KBV Schluesseltabelle KBV_CS_SFHIR_KBV_SCHEINART (V1.02,
// shipped via de.cognovis.terminology.kbv) — the divergent local kvdt-scheinuntergruppe
// CS has been retired. Codes 10/22/25 (local-only, zero live rows) were dropped; 0103
// and 30 (in KBV, absent locally) were added. Target equivalences are KBV-semantics
// based approximations (#relatedto); the following shifted meaning versus the retired
// local CS and should be verified against the KVDT adapter:
//   20  local "Allgemeine Ueberweisung"    -> KBV "Selbstausstellung"        (now gkv)
//   21  local "zur Mitbehandlung"          -> KBV "Auftragsleistungen"
//   26  local "Mitbehandlung Psychiatrie"  -> KBV "Stationaere Mitbehandlung"
//   43  local "Notfallschein Arbeitsunfall"-> KBV "Notfall"                  (was bg, now not)

Instance: scheinart-to-kvdt
InstanceOf: ConceptMap
Title: "ScheinartCS → KVDT Scheinuntergruppe"
Description: "Mappt PVS-interne Scheinart-Codes (ScheinartCS) auf KVDT-offizielle Scheinuntergruppe-Codes (KBV_CS_SFHIR_KBV_SCHEINART). Nur GKV-relevante Codes (gkv, ue, not) haben eine Entsprechung; pkv, bg, igel sind nicht in der KBV Schlüsseltabelle."
Usage: #definition
* name = "ScheinartToKvdtCM"
* url = "https://fhir.cognovis.de/praxis/ConceptMap/scheinart-to-kvdt"
* status = #active
* experimental = false
* sourceCanonical = "https://fhir.cognovis.de/praxis/ValueSet/scheinart"
* targetCanonical = "https://fhir.kbv.de/ValueSet/KBV_VS_SFHIR_KBV_SCHEINART"
* group[0].source = "https://fhir.cognovis.de/praxis/CodeSystem/scheinart"
* group[0].target = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* group[0].element[0].code = #gkv
* group[0].element[0].display = "GKV"
* group[0].element[0].target[0].code = #00
* group[0].element[0].target[0].display = "ambulante Behandlung"
* group[0].element[0].target[0].equivalence = #wider
* group[0].element[0].target[0].comment = "#gkv umfasst alle GKV-Scheine; #00 ist nur der Primärfall — daher wider"
* group[0].element[1].code = #ue
* group[0].element[1].display = "Ueberweisung"
* group[0].element[1].target[0].code = #0102
* group[0].element[1].target[0].display = "Überweisung"
* group[0].element[1].target[0].equivalence = #relatedto
* group[0].element[1].target[0].comment = "Allgemeine Überweisung auf den generischen KBV-Überweisungscode gemappt"
* group[0].element[2].code = #not
* group[0].element[2].display = "Notfall"
* group[0].element[2].target[0].code = #41
* group[0].element[2].target[0].display = "Ärztlicher Notfalldienst"
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
* name = "KvdtToScheinartCM"
* url = "https://fhir.cognovis.de/praxis/ConceptMap/kvdt-to-scheinart"
* status = #active
* experimental = false
* sourceCanonical = "https://fhir.kbv.de/ValueSet/KBV_VS_SFHIR_KBV_SCHEINART"
* targetCanonical = "https://fhir.cognovis.de/praxis/ValueSet/scheinart"
* group[0].source = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* group[0].target = "https://fhir.cognovis.de/praxis/CodeSystem/scheinart"
// Primärfall → gkv
* group[0].element[0].code = #00
* group[0].element[0].display = "ambulante Behandlung"
* group[0].element[0].target[0].code = #gkv
* group[0].element[0].target[0].display = "GKV"
* group[0].element[0].target[0].equivalence = #wider
* group[0].element[1].code = #0101
* group[0].element[1].display = "ambulante Behandlung"
* group[0].element[1].target[0].code = #gkv
* group[0].element[1].target[0].display = "GKV"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[2].code = #0102
* group[0].element[2].display = "Überweisung"
* group[0].element[2].target[0].code = #ue
* group[0].element[2].target[0].display = "Ueberweisung"
* group[0].element[2].target[0].equivalence = #relatedto
* group[0].element[3].code = #0103
* group[0].element[3].display = "Belegärztliche Behandlung"
* group[0].element[3].target[0].code = #gkv
* group[0].element[3].target[0].display = "GKV"
* group[0].element[3].target[0].equivalence = #relatedto
* group[0].element[3].target[0].comment = "Kein eigener belegärztlicher Typ in ScheinartCS"
* group[0].element[4].code = #0104
* group[0].element[4].display = "Notfall/Vertretung"
* group[0].element[4].target[0].code = #not
* group[0].element[4].target[0].display = "Notfall"
* group[0].element[4].target[0].equivalence = #relatedto
// 20er Auftrags-/Überweisungsscheine → ue (20 = Selbstausstellung → gkv)
* group[0].element[5].code = #20
* group[0].element[5].display = "Selbstausstellung"
* group[0].element[5].target[0].code = #gkv
* group[0].element[5].target[0].display = "GKV"
* group[0].element[5].target[0].equivalence = #relatedto
* group[0].element[5].target[0].comment = "Selbstausstellung — keine empfangene Überweisung"
* group[0].element[6].code = #21
* group[0].element[6].display = "Auftragsleistungen"
* group[0].element[6].target[0].code = #ue
* group[0].element[6].target[0].display = "Ueberweisung"
* group[0].element[6].target[0].equivalence = #relatedto
* group[0].element[7].code = #23
* group[0].element[7].display = "Konsiliaruntersuchung"
* group[0].element[7].target[0].code = #ue
* group[0].element[7].target[0].display = "Ueberweisung"
* group[0].element[7].target[0].equivalence = #relatedto
* group[0].element[8].code = #24
* group[0].element[8].display = "Mit-/Weiterbehandlung"
* group[0].element[8].target[0].code = #ue
* group[0].element[8].target[0].display = "Ueberweisung"
* group[0].element[8].target[0].equivalence = #relatedto
* group[0].element[9].code = #26
* group[0].element[9].display = "Stationäre Mitbehandlung, Vergütung nach ambulanten Grundsätzen"
* group[0].element[9].target[0].code = #ue
* group[0].element[9].target[0].display = "Ueberweisung"
* group[0].element[9].target[0].equivalence = #relatedto
* group[0].element[10].code = #27
* group[0].element[10].display = "Überweisungs-/Abrechnungsschein für Laboratoriumsuntersuchungen als Auftragsleistung"
* group[0].element[10].target[0].code = #ue
* group[0].element[10].target[0].display = "Ueberweisung"
* group[0].element[10].target[0].equivalence = #relatedto
* group[0].element[11].code = #28
* group[0].element[11].display = "Anforderungschein für Laboratoriumsuntersuchungen bei Laborgemeinschaften"
* group[0].element[11].target[0].code = #ue
* group[0].element[11].target[0].display = "Ueberweisung"
* group[0].element[11].target[0].equivalence = #relatedto
// 30er Belegärztlich → gkv (kein eigener Typ in ScheinartCS)
* group[0].element[12].code = #30
* group[0].element[12].display = "Belegärztliche Behandlung"
* group[0].element[12].target[0].code = #gkv
* group[0].element[12].target[0].display = "GKV"
* group[0].element[12].target[0].equivalence = #relatedto
* group[0].element[12].target[0].comment = "Kein eigener belegärztlicher Typ in ScheinartCS"
* group[0].element[13].code = #31
* group[0].element[13].display = "Belegärztliche Mitbehandlung"
* group[0].element[13].target[0].code = #gkv
* group[0].element[13].target[0].display = "GKV"
* group[0].element[13].target[0].equivalence = #relatedto
* group[0].element[13].target[0].comment = "Kein eigener belegärztlicher Typ in ScheinartCS"
* group[0].element[14].code = #32
* group[0].element[14].display = "Urlaubs-/Krankheitsvertretung bei belegärztlicher Behandlung"
* group[0].element[14].target[0].code = #gkv
* group[0].element[14].target[0].display = "GKV"
* group[0].element[14].target[0].equivalence = #relatedto
* group[0].element[14].target[0].comment = "Belegärztliche Vertretung; kein eigener Typ in ScheinartCS"
// 40er Notfälle/Vertretung → not (42 Urlaubs-/Krankheitsvertretung → gkv)
* group[0].element[15].code = #41
* group[0].element[15].display = "Ärztlicher Notfalldienst"
* group[0].element[15].target[0].code = #not
* group[0].element[15].target[0].display = "Notfall"
* group[0].element[15].target[0].equivalence = #relatedto
* group[0].element[16].code = #42
* group[0].element[16].display = "Urlaubs-/Krankheitsvertretung"
* group[0].element[16].target[0].code = #gkv
* group[0].element[16].target[0].display = "GKV"
* group[0].element[16].target[0].equivalence = #relatedto
* group[0].element[16].target[0].comment = "Vertretungsfall, regulär GKV abgerechnet"
* group[0].element[17].code = #43
* group[0].element[17].display = "Notfall"
* group[0].element[17].target[0].code = #not
* group[0].element[17].target[0].display = "Notfall"
* group[0].element[17].target[0].equivalence = #equivalent
* group[0].element[18].code = #44
* group[0].element[18].display = "Notfalldienst mit Taxi"
* group[0].element[18].target[0].code = #not
* group[0].element[18].target[0].display = "Notfall"
* group[0].element[18].target[0].equivalence = #relatedto
* group[0].element[19].code = #45
* group[0].element[19].display = "Notarzt-/Rettungswagen"
* group[0].element[19].target[0].code = #not
* group[0].element[19].target[0].display = "Notfall"
* group[0].element[19].target[0].equivalence = #relatedto
* group[0].element[20].code = #46
* group[0].element[20].display = "Zentraler Notfalldienst"
* group[0].element[20].target[0].code = #not
* group[0].element[20].target[0].display = "Notfall"
* group[0].element[20].target[0].equivalence = #relatedto
