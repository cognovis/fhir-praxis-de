// PraxisImmunization — Impfdokumentation in der ambulanten Praxis
// B2: Thin profile ohne KBV-MIO-Impfpass-Abhaengigkeit
// (B1 via packages.kbv.de nicht erreichbar — siehe Bead fpde-daz)

Profile: PraxisImmunization
Parent: Immunization
Id: praxis-immunization
Title: "Praxis Immunization"
Description: "Immunization-Profil fuer die ambulante Praxis (B2: thin profile ohne KBV-MIO-Impfpass-Abhaengigkeit). Dokumentiert Schutzimpfungen mit Impfstoff, Patient, Verabreichungsdatum und verabreichendem Arzt (LANR)."

// Status: Pflicht
* status 1..1 MS

// Impfstoff: Pflicht und Must-Support
* vaccineCode 1..1 MS

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
