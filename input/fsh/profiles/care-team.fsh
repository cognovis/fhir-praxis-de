Profile: CareTeamDE
Parent: CareTeam
Id: care-team-de
Title: "CareTeam DE"
Description: "Profil fuer Behandler-Teams in der deutschen ambulanten Versorgung (z.B. interdisziplinaere Versorgungsteams)."

// RED: intentionally referencing a non-existent ValueSet to trigger an error
* participant ^slicing.discriminator.type = #pattern
* participant ^slicing.discriminator.path = "role"
* participant ^slicing.rules = #open
* participant contains
    behandler 0..*

* participant[behandler].role from NonExistentValueSetThatDoesNotExist (required)
* participant[behandler].role MS
* participant[behandler].member MS
* participant[behandler].period 0..1

* status MS
* category MS
* name MS
* subject MS
* subject only Reference(Patient)
* period MS
* managingOrganization 0..*
* managingOrganization only Reference(Organization)
