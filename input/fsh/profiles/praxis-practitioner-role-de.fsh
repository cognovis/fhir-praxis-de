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
* extension contains WbBefugnisExt named wbBefugnis 0..* MS
* extension[wbBefugnis] ^short = "Weiterbildungsbefugnis an diesem Standort"
* extension[wbBefugnis] ^definition = "Weiterbildungsbefugnis gemaess WBO: Fachgruppe, maximale Weiterbildungsdauer und Gueltigkeitszeitraum."
