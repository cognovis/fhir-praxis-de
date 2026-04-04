// Beispiel: Behandlungsteam Zahnarztpraxis Dr. Mueller
// Zahnarztpraxis-Team mit Zahnarzt, ZFA und WB-Assistent (Q1 2024)

Instance: example-care-team
InstanceOf: CareTeamDE
Title: "Behandlungsteam Zahnarztpraxis Dr. Mueller"
Description: "Behandlungsteam der Zahnarztpraxis Dr. Mueller fuer Q1 2024."
Usage: #example

* status = #active
* category.coding.system = "http://loinc.org"
* category.coding.code = #LA27975-4
* category.coding.display = "Encounter-focused care team"
* name = "Behandlungsteam Zahnarztpraxis Dr. Mueller"
* subject = Reference(example-patient)
* period.start = "2024-01-01"
* period.end = "2024-03-31"

// Behandler-Slice: Dr. Mueller (Zahnarzt)
* participant[behandler][0].role.coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][0].role.coding.code = #zahnarzt
* participant[behandler][0].role.coding.display = "Zahnarzt"
* participant[behandler][0].member = Reference(example-practitioner)
* participant[behandler][0].period.start = "2024-01-01"
* participant[behandler][0].period.end = "2024-03-31"

// Behandler-Slice: Frau Schmidt (ZFA)
* participant[behandler][1].role.coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][1].role.coding.code = #zfa
* participant[behandler][1].role.coding.display = "ZFA"
* participant[behandler][1].member.display = "Frau Schmidt"
* participant[behandler][1].period.start = "2024-01-01"
* participant[behandler][1].period.end = "2024-03-31"

// Behandler-Slice: Herr Weber (WB-Assistent)
* participant[behandler][2].role.coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][2].role.coding.code = #wb-assistent
* participant[behandler][2].role.coding.display = "WB-Assistent"
* participant[behandler][2].member.display = "Herr Weber"
* participant[behandler][2].period.start = "2024-01-01"
* participant[behandler][2].period.end = "2024-03-31"

* managingOrganization[0] = Reference(example-organization)


// Beispiel: Kleines 2-Personen-Team (Arzt + MFA)

Instance: example-care-team-small
InstanceOf: CareTeamDE
Title: "Kleines Behandler-Team"
Description: "Kleines Behandler-Team mit einem Arzt und einer MFA."
Usage: #example

* status = #active
* category.coding.system = "http://loinc.org"
* category.coding.code = #LA27975-4
* category.coding.display = "Encounter-focused care team"
* name = "Kleines Behandler-Team"
* subject = Reference(example-patient)
* period.start = "2024-01-01"

// Behandler-Slice: Arzt
* participant[behandler][0].role.coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][0].role.coding.code = #arzt
* participant[behandler][0].role.coding.display = "Arzt"
* participant[behandler][0].member = Reference(example-practitioner)

// Behandler-Slice: MFA
* participant[behandler][1].role.coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][1].role.coding.code = #mfa
* participant[behandler][1].role.coding.display = "MFA"
* participant[behandler][1].member.display = "Sabine Huber"


// Beispiel: Inaktives Team mit abgeschlossenem Zeitraum

Instance: example-care-team-inactive
InstanceOf: CareTeamDE
Title: "Inaktives Behandler-Team 2023"
Description: "Abgeschlossenes Behandler-Team aus dem Jahr 2023."
Usage: #example

* status = #inactive
* category.coding.system = "http://loinc.org"
* category.coding.code = #LA27975-4
* category.coding.display = "Encounter-focused care team"
* name = "Behandler-Team 2023"
* subject = Reference(example-patient)
* period.start = "2023-01-01"
* period.end = "2023-12-31"

// Behandler-Slice: Arzt
* participant[behandler][0].role.coding.system = "https://fhir.cognovis.de/praxis/CodeSystem/behandler-rolle"
* participant[behandler][0].role.coding.code = #arzt
* participant[behandler][0].role.coding.display = "Arzt"
* participant[behandler][0].member = Reference(example-practitioner)
* participant[behandler][0].period.start = "2023-01-01"
* participant[behandler][0].period.end = "2023-12-31"
