Profile: HvgMandantBeteiligung
Parent: Basic
Id: hvg-mandant-beteiligung
Title: "HVG Mandant Beteiligung"
Description: "Profil fuer die Beteiligung eines Mandanten an einem HVG-Selektivvertrag (§73b/§73c SGB V). Bildet das Join-Entity zwischen Mandant und Contract ab."
* code = BasicResourceTypeCS#hvg-mandant-beteiligung (exactly)
* code MS
* subject MS
* extension contains
    HvgMandantContractRefExt named hvgMandantContractRef 1..1 MS and
    HvgMandantStatusExt named hvgMandantStatus 0..1 and
    HvgMandantDatumBeginnExt named hvgMandantDatumBeginn 0..1 and
    HvgMandantDatumEndeExt named hvgMandantDatumEnde 0..1 and
    HvgMandantDatumFreischaltungExt named hvgMandantDatumFreischaltung 0..1
