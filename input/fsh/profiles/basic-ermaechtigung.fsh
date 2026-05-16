// basic-ermaechtigung.fsh
// Profile for aerztliche Ermaechtigung as Basic resource
// Bead: fpde-e0o

Profile: BasicErmaechtingungDE
Parent: Basic
Id: basic-ermaechtigung-de
Title: "Basic Ermaechtigung DE"
Description: "Aerztliche Ermaechtigung gemaess § 116 SGB V modelliert als Basic-Ressource. Enthaelt Art, Einrichtung, Leistungsbereich, Gueltigkeitszeitraum und Status."

// code: identifies this Basic resource as an Ermaechtigung
* code = BasicResourceTypeCS#ermaechtigung
* code MS

// subject: the practitioner who holds the Ermaechtigung
* subject 1..1 MS
* subject only Reference(Practitioner)
* subject ^short = "Arzt mit Ermaechtigung"

// Ermaechtigung data via extension
* extension contains ErmaechtingungExt named ermaechtigung 1..1 MS
* extension[ermaechtigung] ^short = "Ermaechtigung Daten"
* extension[ermaechtigung] ^definition = "Aerztliche Ermaechtigung mit Art, Einrichtung, Leistungsbereich, Gueltigkeitszeitraum und Status."
