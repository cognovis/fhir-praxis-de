// Referral / Ueberweisung extensions

Extension: UeFachrichtungExt
Id: ue-fachrichtung
Title: "Ueberweisungs-Fachrichtung"
Description: "Fachrichtung, an die ueberwiesen wird."
Context: ServiceRequest
* value[x] only CodeableConcept

Extension: UeUnfallExt
Id: ue-unfall
Title: "Ueberweisung Unfall"
Description: "Kennzeichnung einer unfallbedingten Ueberweisung."
Context: ServiceRequest
* value[x] only boolean

// MVZ Internal Referral Optimization

Extension: ReferralSugTypeExt
Id: referral-sug-type
Title: "Referral Suggested Type"
Description: "Vorgeschlagener Fachrichtungstyp fuer die interne MVZ-Ueberweisung."
Context: ServiceRequest
* value[x] only string

Extension: ReferralCrossArztgruppeExt
Id: referral-cross-arztgruppe
Title: "Referral Cross-Arztgruppe"
Description: "Kennzeichnung einer arztgruppenueberschreitenden Ueberweisung im MVZ."
Context: ServiceRequest
* value[x] only boolean

Extension: ReferralOptimizationStatusExt
Id: referral-optimization-status
Title: "Referral Optimization Status"
Description: "Status der Ueberweisungsoptimierung."
Context: ServiceRequest
* value[x] only string

Extension: ReferralOptimizationDeltaExt
Id: referral-optimization-delta
Title: "Referral Optimization Delta"
Description: "Optimierungsdelta in EUR."
Context: ServiceRequest
* value[x] only decimal
