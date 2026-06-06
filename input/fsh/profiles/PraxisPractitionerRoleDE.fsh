// praxis-practitioner-role-de.fsh
// PractitionerRole profile for Arzt-Standort-Zuordnung
// with WB-Befugnis, Genehmigungen, and Sitz-Zuordnung
// Bead: fpde-e0o

Profile: PraxisPractitionerRoleDE
Parent: KBV_PR_Base_PractitionerRole
Id: praxis-practitioner-role-de
Title: "Praxis PractitionerRole DE"
Description: "PractitionerRole fuer Arzt-Standort-Zuordnung mit WB-Befugnis, Genehmigungen und Sitz-Zuordnung. Basisschicht fuer spezialisierte Arzt-Standort-Profile."

* code from PraxisFunktionsrolleVS (extensible)
* code ^short = "Practice function on PractitionerRole.code"
* code ^definition = "Practice function for this practitioner in this organizational scope. Use PractitionerRole.code for function (what the practitioner does in this role), not for qualification or location. Qualification/profession goes on Practitioner.qualification.code. Location routing goes on PractitionerRole.location (not authorization). Organization-scoped authorization is via PractitionerRole.organization and Organization.partOf descendants."

// WB-Befugnis: Weiterbildungsbefugnis des Arztes an diesem Standort
* extension contains
    WbBefugnisExt named wbBefugnis 0..* MS and
    SitzAnteilExt named sitzAnteil 0..1 MS and
    StundenProWocheExt named stundenProWoche 0..1 MS and
    ArztSitzStatusExt named arztSitzStatus 0..1 MS
* extension[wbBefugnis] ^short = "Weiterbildungsbefugnis an diesem Standort"
* extension[wbBefugnis] ^definition = "Weiterbildungsbefugnis gemaess WBO: Fachgruppe, maximale Weiterbildungsdauer und Gueltigkeitszeitraum."
* extension[sitzAnteil] ^short = "Anteil am KV-Sitz"
* extension[sitzAnteil] ^definition = "Anteil des Arztes am KV-Sitz als Dezimalzahl (0.0-1.0)."
* extension[stundenProWoche] ^short = "Vertraglich vereinbarte Arbeitsstunden pro Woche"
* extension[arztSitzStatus] ^short = "Arzt-Status in der Sitz-Zuordnung (Facharzt, WBA, Sicherstellung, Vertreter)"

// Service offering link (fpde-ir8)
* healthcareService 0..* MS
* healthcareService only Reference(PraxisHealthcareServiceDE)
* healthcareService ^short = "Healthcare service offerings at this role"
* healthcareService ^definition = "Ambulatory service offerings this practitioner role operates under at the referenced organization and location. Links PractitionerRole to PraxisHealthcareServiceDE for service-offering publication and downstream configuration."
* location 0..* MS
* location ^short = "Practice locations for this role"
* location ^definition = "Physical routing context for this practitioner role. Align with HealthcareService.location when the role serves a specific service offering at a site."
