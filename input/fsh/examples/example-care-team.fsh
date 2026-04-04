// Beispiel: Behandler-Team fuer Thomas Weber
// Interdisziplinaeres Versorgungsteam mit Hausarzt, MFA und Physiotherapeut

Instance: example-care-team
InstanceOf: CareTeamDE
Title: "Behandler-Team Weber"
Description: "Interdisziplinaeres Behandler-Team fuer den Privatpatienten Thomas Weber."
Usage: #example

* status = #active
* category[0].coding[0].system = "http://loinc.org"
* category[0].coding[0].code = #LA27975-4
* category[0].coding[0].display = "Encounter-focused care team"
* name = "Behandler-Team Weber"
* subject = Reference(example-patient)
* period.start = "2026-01-01"

// Behandler-Slice: Hausarzt
* participant[behandler][0].role[0].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][0].role[0].coding[0].code = #arzt
* participant[behandler][0].role[0].coding[0].display = "Arzt"
* participant[behandler][0].member = Reference(example-practitioner)
* participant[behandler][0].period.start = "2026-01-01"

// Behandler-Slice: MFA
* participant[behandler][1].role[0].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][1].role[0].coding[0].code = #mfa
* participant[behandler][1].role[0].coding[0].display = "MFA"
* participant[behandler][1].member.display = "Sabine Huber"
* participant[behandler][1].period.start = "2026-01-01"

// Behandler-Slice: Physiotherapeut
* participant[behandler][2].role[0].coding[0].system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][2].role[0].coding[0].code = #physiotherapeut
* participant[behandler][2].role[0].coding[0].display = "Physiotherapeut"
* participant[behandler][2].member.display = "Klaus Brenner"
* participant[behandler][2].period.start = "2026-02-01"

* managingOrganization[0] = Reference(example-organization)
