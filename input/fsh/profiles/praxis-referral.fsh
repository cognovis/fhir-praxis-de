// PraxisReferralDE — Überweisung (referral) into the practice.
// Captures the "Überweisung von BSNR/LANR" chain on the Schein: the referring
// physician (LANR) and Betriebsstätte (BSNR) are carried on ServiceRequest.requester.
// The receiving billing case (AccountPraxisSchein) links here via Encounter.basedOn.
// Homes the referral.fsh extensions (previously unbound).

Profile: PraxisReferralDE
Parent: ServiceRequest
Id: praxis-referral-de
Title: "Praxis Referral DE"
Description: "Überweisung in die Praxis. Trägt die überweisende Seite (Überweisung von BSNR/LANR) auf requester sowie Überweisungs-Kennzeichen. Der Abrechnungsfall (AccountPraxisSchein) verweist via Encounter.basedOn auf diese ServiceRequest."

* extension contains
    UeUnfallExt named unfall 0..1 MS and
    ReferralSugTypeExt named suggestedType 0..1 MS and
    ReferralCrossArztgruppeExt named crossArztgruppe 0..1 MS and
    ReferralOptimizationStatusExt named optimizationStatus 0..1 MS and
    ReferralOptimizationDeltaExt named optimizationDelta 0..1 MS
* extension[unfall] ^short = "Unfallbedingte Überweisung"
* extension[suggestedType] ^short = "Vorgeschlagener Fachrichtungstyp (MVZ-intern)"
* extension[crossArztgruppe] ^short = "Arztgruppenübergreifende Überweisung (MVZ-intern)"
* extension[optimizationStatus] ^short = "Status der Überweisungsoptimierung (MVZ-intern)"
* extension[optimizationDelta] ^short = "Optimierungsdelta in EUR (MVZ-intern)"

* status 1..1 MS
* intent = #order
* intent MS
* intent ^short = "order — eine Überweisung ist eine Auftragsleistung"

* subject 1..1 MS
* subject only Reference(Patient)
* subject ^short = "Überwiesener Patient"

* requester MS
* requester only Reference(PractitionerRole or Practitioner or Organization)
* requester ^short = "Überweisende Seite: Arzt (LANR) bzw. Betriebsstätte (BSNR). LANR liegt am referenzierten Practitioner/PractitionerRole, BSNR an der Organization."

* performerType MS
* performerType ^short = "Ziel-Fachrichtung der Überweisung"

* authoredOn MS
* authoredOn ^short = "Ausstellungsdatum der Überweisung"

* occurrence[x] MS
* occurrence[x] ^short = "Gültigkeitszeitraum/-datum der Überweisung"

* reasonCode MS
* reasonCode ^short = "Überweisungsgrund/Auftrag"
