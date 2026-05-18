// AW-SST AllergyIntolerance Example
// PraxisAllergyIntoleranceDE — clinical allergy recording

// Shared patient reference
Instance: AllergyPatientExample
InstanceOf: Patient
Title: "Example Patient (Allergy)"
Description: "Example patient for allergy intolerance example"
Usage: #example
* identifier[0].system = "http://fhir.de/NamingSystem/gkv/kvid-10"
* identifier[0].value = "C444555666"
* name[0].family = "Testperson"
* name[0].given[0] = "Anna"
* birthDate = "1980-03-25"
* gender = #female

Instance: AllergyRecorderExample
InstanceOf: Practitioner
Title: "Example Practitioner (Allergy Recorder)"
Description: "Example practitioner who recorded the allergy"
Usage: #example
* identifier[0].system = "https://fhir.kbv.de/NamingSystem/KBV_NS_Base_ANR"
* identifier[0].value = "987654321"
* name[0].family = "Weber"
* name[0].given[0] = "Petra"
* name[0].prefix[0] = "Dr. med."

// --- Allergy: Penicillin ---
Instance: PraxisAllergyIntolerancePenicillinExample
InstanceOf: PraxisAllergyIntoleranceDE
Title: "Allergy Intolerance Example (Penicillin)"
Description: "Beispiel einer klinischen Allergie: Penicillin-Allergie mit Urtikaria. Separat von PraxisFlag (CAVE/Workflow-Warnungen)."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-verification#confirmed
* type = #allergy
* category[0] = #medication
* criticality = #high
* code = http://snomed.info/sct#372687004
* code.text = "Penicillin"
* patient = Reference(AllergyPatientExample)
* onsetDateTime = "2018-06-01"
* recordedDate = "2018-06-15"
* recorder = Reference(AllergyRecorderExample)
* reaction[0].substance = http://snomed.info/sct#372687004
* reaction[0].substance.text = "Penicillin"
* reaction[0].manifestation[0] = http://snomed.info/sct#126485001
* reaction[0].manifestation[0].text = "Urtikaria"
* reaction[0].severity = #moderate
* reaction[0].description = "Generalisierte Urtikaria nach oraler Einnahme von Amoxicillin 500 mg. Aufgetreten ca. 30 Minuten nach Einnahme."

// --- Intolerance: Lactose ---
Instance: PraxisAllergyIntoleranceLactoseExample
InstanceOf: PraxisAllergyIntoleranceDE
Title: "Allergy Intolerance Example (Lactose)"
Description: "Beispiel einer Nahrungsmittelunvertraeglichkeit: Laktoseintoleranz."
Usage: #example
* clinicalStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-verification#confirmed
* type = #intolerance
* category[0] = #food
* criticality = #low
* code = http://snomed.info/sct#47703008
* code.text = "Lactose"
* patient = Reference(AllergyPatientExample)
* onsetDateTime = "2015-01-01"
* recordedDate = "2020-02-10"
* recorder = Reference(AllergyRecorderExample)
* reaction[0].manifestation[0] = http://snomed.info/sct#21522001
* reaction[0].manifestation[0].text = "Bauchschmerzen, Blähungen"
* reaction[0].severity = #mild
