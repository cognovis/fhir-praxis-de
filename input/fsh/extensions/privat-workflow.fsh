// Privatabrechnung Workflow Extensions

Extension: PrivatFreigabeStatusExt
Id: privat-freigabe-status
Title: "Privat-Freigabestatus"
Description: "Freigabestatus der Privatrechnung (z.B. entwurf, freigegeben, versendet)"
Context: Encounter, Claim
* value[x] only string

Extension: PrivatReviewedStatusExt
Id: privat-reviewed-status
Title: "Privat-Prüfstatus"
Description: "Kennzeichen, ob die Privatrechnung ärztlich geprüft wurde"
Context: Encounter, Claim
* value[x] only boolean

Extension: PrivatReviewedAtExt
Id: privat-reviewed-at
Title: "Privat-Prüfungszeitpunkt"
Description: "Zeitpunkt der ärztlichen Prüfung der Privatrechnung"
Context: Encounter, Claim
* value[x] only dateTime

Extension: ReviewedStatusExt
Id: reviewed-status
Title: "Prüfstatus"
Description: "Allgemeiner Prüfstatus einer Abrechnungsposition (z.B. geprüft, offen, beanstandet)"
Context: ChargeItem, Claim
* value[x] only string

Extension: ReviewedAtExt
Id: reviewed-at
Title: "Prüfungszeitpunkt"
Description: "Zeitpunkt der Prüfung einer Abrechnungsposition"
Context: ChargeItem, Claim
* value[x] only dateTime
