// HZV-Einschreibung Extensions (§73b SGB V)

Extension: HzvParticipationExt
Id: hzv-participation
Title: "HZV-Teilnahmestatus"
Description: "Einschreibestatus des Patienten in die hausarztzentrierte Versorgung (HZV, §73b SGB V). PVS-uebergreifend definiert."
Context: Flag, EpisodeOfCare
* value[x] only CodeableConcept
* valueCodeableConcept from HzvParticipationVS (required)

Extension: HzvEinschreibedatumExt
Id: hzv-einschreibedatum
Title: "HZV Einschreibedatum"
Description: "Datum der Einschreibung des Patienten in die hausarztzentrierte Versorgung (§73b SGB V)"
Context: Flag, EpisodeOfCare
* value[x] only date

Extension: HzvAbmeldedatumExt
Id: hzv-abmeldedatum
Title: "HZV Abmeldedatum"
Description: "Datum der Abmeldung des Patienten aus der hausaerztlichen Versorgung (§73b SGB V)"
Context: Flag, EpisodeOfCare
* value[x] only date
