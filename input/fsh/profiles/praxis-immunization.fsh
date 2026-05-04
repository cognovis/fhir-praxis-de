// PraxisImmunization — Impfdokumentation in der ambulanten Praxis
// Bindet KBV-MIO-Impfpass Impfstoff-Vokabular via cognovis-Vocab-Repackage
// kbv.mio.impfpass.vocab@1.1.0-cognovis.1 (Subset von kbv.mio.impfpass 1.1.0
// ohne dimdi-Referenzen → keine transitive Abhängigkeit auf de.basisprofil.r4@0.9.12).
// Die ValueSet-URLs sind unverändert von KBV: https://fhir.kbv.de/ValueSet/KBV_VS_MIO_Vaccination_Vaccine_List et al.
// Parent bleibt base Immunization (nicht KBV_PR_MIO_Vaccination_Record_Prime),
// da dessen obligatorische Extensions (Entry_Type, Attester) mit PVS-Daten
// inkompatibel waeren — fpde-daz B1-Entscheidung.

Profile: PraxisImmunization
Parent: Immunization
Id: praxis-immunization
Title: "Praxis Immunization"
Description: "Immunization-Profil fuer die ambulante Praxis. Bindet KBV-MIO-Impfpass Impfstoff-Vokabular (KBV_VS_MIO_Vaccination_Vaccine_List) als extensible Binding. Parent ist base Immunization (nicht KBV_PR_MIO_Vaccination_Record_Prime, da dessen obligatorische Extensions inkompatibel mit PVS-Kratkenblatt-Daten sind)."

// Status: Pflicht
* status 1..1 MS

// Impfstoff: Pflicht — KBV-MIO-Impfpass Vokabular (extensible)
* vaccineCode 1..1 MS
* vaccineCode from https://fhir.kbv.de/ValueSet/KBV_VS_MIO_Vaccination_Vaccine_List (extensible)

// Patient: Pflicht
* patient 1..1 MS
* patient only Reference(Patient)

// Verabreichungsdatum: Must-Support
* occurrence[x] MS

// Verabreichender Arzt: Must-Support
* performer MS
* performer.actor MS

// LANR-Identifier fuer verabreichenden Arzt (via Display-Referenz oder identifier.system)
// Note: A fixed-system constraint on performer.actor.identifier.system cannot be enforced at the
// profile level in FHIR R4 because Reference.identifier is a flat element (cardinality max=1)
// and slicing on it is not supported. LANR convention is documented here but cannot be
// structurally enforced — implementations MUST set identifier.system = KBV_NS_Base_ANR by convention.
* performer.actor.identifier MS
* performer.actor.identifier.system MS
* performer.actor.identifier.value MS
