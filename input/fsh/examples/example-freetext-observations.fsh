// AW-SST Freetext Observation Examples
// PraxisAnamneseFreeTextObservationDE and PraxisBefundFreeTextObservationDE

// Shared patient reference
Instance: FreetextObsPatientExample
InstanceOf: Patient
Title: "Example Patient (Freetext Observations)"
Description: "Example patient for freetext observation examples"
Usage: #example
* identifier[0].system = "http://fhir.de/NamingSystem/gkv/kvid-10"
* identifier[0].value = "B111222333"
* name[0].family = "Beispiel"
* name[0].given[0] = "Klaus"
* birthDate = "1952-11-08"
* gender = #male

// --- Anamnesis freetext observation ---
Instance: PraxisAnamneseFreeTextObservationExample
InstanceOf: PraxisAnamneseFreeTextObservationDE
Title: "Anamnesis Freetext Observation Example"
Description: "Beispiel einer freitextlichen Anamnesebeobachtung aus der Karteikarte. Patient berichtet ueber Schmerzen im linken Knie seit 3 Wochen nach sportlicher Belastung."
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = http://loinc.org#10164-2
* subject = Reference(FreetextObsPatientExample)
* effectiveDateTime = "2024-05-10T10:15:00+02:00"
* valueString = "Patient berichtet seit 3 Wochen ueber Schmerzen im linken Kniegelenk, vor allem bei Treppensteigen und nach laengerem Laufen. Keine Schwellung, kein Erguss tastbar. Schmerz VAS 4/10. Vorbehandlung: Ibuprofen 400 mg p.r.n. mit maessigem Erfolg. Kein Trauma."

// --- Clinical finding freetext observation ---
Instance: PraxisBefundFreeTextObservationExample
InstanceOf: PraxisBefundFreeTextObservationDE
Title: "Clinical Finding Freetext Observation Example"
Description: "Beispiel einer freitextlichen Befundbeobachtung aus der Karteikarte. Klinischer Untersuchungsbefund Kniegelenk links."
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#exam
* code = http://loinc.org#11506-3
* subject = Reference(FreetextObsPatientExample)
* effectiveDateTime = "2024-05-10T10:30:00+02:00"
* valueString = "Linkes Kniegelenk: kein Erguss, kein Haemarthros. Patella gut verschieblich, kein Ballottement. Meniskustests (McMurray, Apley) negativ. Bandstabilitaet seitengleich. Druckschmerz mediales Kompartiment VAS 3/10. Gangbild unauffaellig. ROM: Extension/Flexion 0-0-130."
