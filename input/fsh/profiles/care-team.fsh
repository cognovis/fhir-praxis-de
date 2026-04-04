Profile: CareTeamDE
Parent: CareTeam
Id: care-team-de
Title: "CareTeam DE"
Description: "Profil fuer Behandler-Teams in der deutschen ambulanten Versorgung (z.B. interdisziplinaere Versorgungsteams)."

// Slicing on participant by role
* participant MS
* participant ^slicing.discriminator.type = #pattern
* participant ^slicing.discriminator.path = "role"
* participant ^slicing.rules = #open
* participant contains
    behandler 0..*

// Behandler-slice: Rollenkodierung via BehandlerRolleVS
* participant[behandler].role from BehandlerRolleVS (required)
* participant[behandler].role MS
* participant[behandler].member MS
* participant[behandler].member only Reference(Practitioner or PractitionerRole or Organization)
* participant[behandler].period 0..1
* participant[behandler].period MS

// Must Support Felder
* status MS
* category MS
* name MS
* subject MS
* subject only Reference(Patient)
* period MS
* managingOrganization 0..*
* managingOrganization only Reference(Organization)
