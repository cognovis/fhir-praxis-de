// praxis-practitioner-role-de.fsh
// PractitionerRole profile for Arzt-Standort-Zuordnung
// with WB-Befugnis, Genehmigungen, and Sitz-Zuordnung
// Bead: fpde-e0o

Profile: PraxisPractitionerRoleDE
Parent: PractitionerRole
Id: praxis-practitioner-role-de
Title: "Praxis PractitionerRole DE"
Description: "PractitionerRole fuer Arzt-Standort-Zuordnung mit WB-Befugnis, Genehmigungen und Sitz-Zuordnung. Basisschicht fuer spezialisierte Arzt-Standort-Profile."

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
