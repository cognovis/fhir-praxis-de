// Encounter extensions for waiting room, queue management, and billing

Extension: EncounterCalledExt
Id: encounter-called
Title: "Patient aufgerufen"
Description: "Zeitpunkt, zu dem der Patient aus dem Wartezimmer aufgerufen wurde."
Context: Encounter
* value[x] only dateTime

Extension: ArrivalTimeExt
Id: arrival-time
Title: "Ankunftszeit"
Description: "Zeitpunkt der Ankunft des Patienten in der Praxis."
Context: Encounter
* value[x] only dateTime

Extension: EncounterCreatedAtExt
Id: encounter-created-at
Title: "Encounter Erstellungszeitpunkt"
Description: "Zeitpunkt der Erstellung des Encounters im PVS."
Context: Encounter
* value[x] only dateTime

Extension: KrabllinkRefExt
Id: krabllink-ref
Title: "KRABL-Link Referenz"
Description: "Referenz auf ein verlinktes Dokument (DocumentReference)."
Context: ChargeItem, Encounter
* value[x] only Reference(DocumentReference)
