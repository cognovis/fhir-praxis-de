Invariant: account-praxis-schein-status
Description: "AccountPraxisSchein.status is limited to active (open case) and inactive (closed case)."
Expression: "status = 'active' or status = 'inactive'"
Severity: #error

Profile: AccountPraxisSchein
Parent: Account
Id: account-praxis-schein
Title: "Account Praxis Schein"
Description: "Billing case (Schein) for ambulatory practice. Account.identifier = ScheinNummer (source-PK, ADR-002). Account.type = Scheinart. Account.servicePeriod = billing quarter (or longer for PKV). Account.coverage -> applicable Coverage. Account.status = active (open) | inactive (closed)."

* obeys account-praxis-schein-status

* extension contains
    AccountAbrechnungssperreExt named abrechnungssperre 0..1 MS and
    AccountErsatzverfahrenExt named ersatzverfahren 0..1 MS and
    AccountNachzueglerExt named nachzuegler 0..1 MS and
    AccountArztPatientenKontaktExt named arztPatientenKontakt 0..1 MS and
    AccountEgkLesedatumExt named egkLesedatum 0..1 MS
* extension[abrechnungssperre] ^short = "Abrechnungssperre flag (Schein.Abrechnungssperre); identisch zu 'Nicht abrechnen'"
* extension[ersatzverfahren] ^short = "Ersatzverfahren flag (Schein.Ersatzverfahren)"
* extension[nachzuegler] ^short = "Nachzuegler flag (Schein.Nachzuegler)"
* extension[arztPatientenKontakt] ^short = "Arzt-Patienten-Kontakte count (Schein.ArztPatientenKontakt)"
* extension[egkLesedatum] ^short = "eGK/VSDM read date (Schein.Chipkartenlesedatum); absent = card not read"

* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^short = "ScheinNummer (source-PK, ADR-002) with additional identifier slices allowed"
* identifier contains scheinNummer 0..1 MS
* identifier[scheinNummer].system 1..1 MS
* identifier[scheinNummer].system = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* identifier[scheinNummer].value 1..1 MS

* type 1..1 MS
* type from https://fhir.cognovis.de/praxis/ValueSet/scheinart (required)
// Scheinuntergruppe (KVDT FK 4239, KBV S_KBV_SCHEINART) rides as a second coding on
// the same CodeableConcept — same axis as Scheinart, just finer. Reuses the local
// kvdt-scheinuntergruppe mirror; Scheinart stays the primary required coding.
* type.coding ^slicing.discriminator.type = #value
* type.coding ^slicing.discriminator.path = "system"
* type.coding ^slicing.rules = #open
* type.coding contains scheinuntergruppe 0..1 MS
* type.coding[scheinuntergruppe] from https://fhir.cognovis.de/praxis/ValueSet/kvdt-scheinuntergruppe (required)
* type.coding[scheinuntergruppe].system = "https://fhir.cognovis.de/praxis/CodeSystem/kvdt-scheinuntergruppe"
* type.coding[scheinuntergruppe] ^short = "Scheinuntergruppe (KVDT FK 4239)"

* servicePeriod 1..1 MS

* coverage MS
* coverage.coverage MS
* coverage.coverage only Reference(Coverage)

* status 1..1 MS
* status ^comment = "Use active for an open billing case and inactive for a closed billing case. Billing lifecycle states such as claimed or settled are represented on Claim and ClaimResponse, not Account.status."

* subject 1..1 MS
* subject only Reference(Patient)
