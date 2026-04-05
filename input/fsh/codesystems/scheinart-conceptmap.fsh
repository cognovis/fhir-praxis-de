Instance: scheinart-to-kvdt
InstanceOf: ConceptMap
Title: "ScheinartCS → KVDT Scheinuntergruppe"
Description: "Mappt PVS-interne Scheinart-Codes (ScheinartCS) auf KVDT-offizielle Scheinuntergruppe-Codes (KBV_CS_SFHIR_KBV_SCHEINART). Nur GKV-relevante Codes (gkv, ue, not) haben eine Entsprechung; pkv, bg, igel sind nicht in der KBV Schlüsseltabelle."
Usage: #definition
* url = "https://fhir.cognovis.de/praxis/ConceptMap/scheinart-to-kvdt"
* status = #active
* experimental = false
* sourceCanonical = "https://fhir.cognovis.de/praxis/ValueSet/scheinart"
* targetCanonical = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* group[0].source = "https://fhir.cognovis.de/praxis/CodeSystem/scheinart"
* group[0].target = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* group[0].element[0].code = #gkv
* group[0].element[0].display = "GKV"
* group[0].element[0].target[0].code = #00
* group[0].element[0].target[0].display = "Behandlungsausweis"
* group[0].element[0].target[0].equivalence = #relatedto
* group[0].element[0].target[0].comment = "Beide decken GKV Primärschein ab"
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
