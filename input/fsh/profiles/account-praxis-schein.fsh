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

* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #closed
* identifier ^short = "ScheinNummer (source-PK, ADR-002) — only this slice is permitted"
* identifier contains scheinNummer 1..1 MS
* identifier[scheinNummer].system 1..1 MS
* identifier[scheinNummer].system = "https://fhir.cognovis.de/praxis/sid/scheinNummer"
* identifier[scheinNummer].value 1..1 MS

* type 1..1 MS
* type from https://fhir.cognovis.de/praxis/ValueSet/scheinart (required)

* servicePeriod 1..1 MS

* coverage MS
* coverage.coverage MS
* coverage.coverage only Reference(Coverage)

* status 1..1 MS
* status ^comment = "Use active for an open billing case and inactive for a closed billing case. Billing lifecycle states such as claimed or settled are represented on Claim and ClaimResponse, not Account.status."

* subject 1..1 MS
* subject only Reference(Patient)
