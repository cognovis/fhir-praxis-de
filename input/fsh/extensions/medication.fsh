// ============================================================================
// Medication / Prescription Extensions
// ============================================================================

Extension: AutIdemExt
Id: aut-idem
Title: "Aut-idem"
Description: "Kennzeichen, ob der Arzt die Substitution durch ein wirkstoffgleiches Praeparat ausgeschlossen hat (aut-idem-Kreuz)"
Context: MedicationRequest
* value[x] only boolean

Extension: IsErezeptExt
Id: is-erezept
Title: "E-Rezept"
Description: "Kennzeichen, ob das Rezept als E-Rezept (elektronisches Rezept) ausgestellt wurde"
Context: MedicationRequest
* value[x] only boolean

Extension: IsDauermedikationExt
Id: is-dauermedikation
Title: "Dauermedikation"
Description: "Kennzeichen, ob das Medikament zur Dauermedikation des Patienten gehoert"
Context: MedicationStatement
* value[x] only boolean

Extension: AvpExt
Id: avp
Title: "Apothekenverkaufspreis"
Description: "Apothekenverkaufspreis (AVP) des verordneten Medikaments"
Context: MedicationRequest
* value[x] only Money

Extension: FestbetragExt
Id: festbetrag
Title: "Festbetrag"
Description: "GKV-Festbetrag fuer das verordnete Medikament"
Context: MedicationRequest
* value[x] only Money
