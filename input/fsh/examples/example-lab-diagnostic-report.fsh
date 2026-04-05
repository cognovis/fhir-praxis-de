// Lab DiagnosticReport Beispiele — PraxisLabDiagnosticReport Profil
// Sechs Szenarien: Einzelbefund CBC, Mikrobiologie, Pathologie, Teilbefund (preliminary),
// Kumulativbefund HbA1c (Q1/Januar), Kumulativbefund HbA1c (Q2/April)
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss).

// --- Hilfsobservation: Leukozyten im Blut (CBC) ---
// Wird von Beispiel 1 (CBC-Befund) referenziert — semantisch korrekte CBC-Ergebnisgroesse
Instance: lab-obs-example-leukozyten-blut
InstanceOf: PraxisLabObservation
Title: "Lab Observation: Leukozyten im Blut (CBC)"
Description: "Leukozytenzahl im peripheren Blut als Teil des Differentialblutbilds. LOINC 6690-2."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].code = #6690-2
* code.coding[loinc].display = "Leukocytes [#/volume] in Blood by Automated count"
* code.coding[ldt].system = "https://fhir.cognovis.de/praxis/NamingSystem/ldt-testkennungen"
* code.coding[ldt].code = #03001000
* code.coding[ldt].display = "Leukozyten"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-01T08:30:00+02:00"
* valueQuantity.value = 7.2
* valueQuantity.unit = "10*3/uL"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #10*3/uL
* referenceRange.low.value = 4.0
* referenceRange.low.unit = "10*3/uL"
* referenceRange.low.system = "http://unitsofmeasure.org"
* referenceRange.low.code = #10*3/uL
* referenceRange.high.value = 10.0
* referenceRange.high.unit = "10*3/uL"
* referenceRange.high.system = "http://unitsofmeasure.org"
* referenceRange.high.code = #10*3/uL
* interpretation.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
* interpretation.coding[0].code = #N
* interpretation.coding[0].display = "Normal"
* specimen = Reference(example-specimen-blut-edta)

// --- Beispiel 1: Einzelbefund Blutbild (CBC) ---
// Standard-Labor, Status final, Probe EDTA-Blut
Instance: example-lab-dr-blutbild
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: Blutbild CBC (Einzelbefund)"
Description: "Standard-Laborbefund mit CBC-Panel (Blutbild), Status final. Kategorie LAB. Probe EDTA-Blut, Ergebnis-Verweis auf Leukozyten-Observation (Teil des Blutbilds)."
Usage: #example
* status = #final
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #58410-2
* code.coding[0].display = "CBC panel - Blood by Automated count"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-01"
* issued = "2026-04-01T14:00:00+02:00"
* result[0] = Reference(lab-obs-example-leukozyten-blut)
* specimen[0] = Reference(example-specimen-blut-edta)
* resultsInterpreter[0] = Reference(example-practitioner)

// --- Hilfsobservation: E. coli Keimnachweis (Urinkultur) ---
Instance: lab-obs-example-ecoli-keim
InstanceOf: PraxisLabObservation
Title: "Lab Observation: E. coli Keimnachweis (Urinkultur)"
Description: "Mikrobiologie-Observation fuer E. coli-Nachweis in Urinkultur. LOINC-Mapping."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].code = #6463-4
* code.coding[loinc].display = "Bacteria identified in Urine by Culture"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-02"
* valueCodeableConcept.coding[0].system = "http://snomed.info/sct"
* valueCodeableConcept.coding[0].code = #112283007
* valueCodeableConcept.coding[0].display = "Escherichia coli"

// --- Hilfsobservation: Antibiogramm Ciprofloxacin (Urinkultur) ---
Instance: lab-obs-example-antibiogramm-cipro
InstanceOf: PraxisLabObservation
Title: "Lab Observation: Antibiogramm Ciprofloxacin"
Description: "Antibiogramm-Observation fuer Ciprofloxacin-Empfindlichkeit. LOINC 18907-0."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].code = #18907-0
* code.coding[loinc].display = "Ciprofloxacin [Susceptibility]"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-02"
* valueCodeableConcept.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
* valueCodeableConcept.coding[0].code = #S
* valueCodeableConcept.coding[0].display = "Susceptible"

// --- Beispiel 2: Mikrobiologie Urinkultur ---
// Kategorie MB, Nachweis E. coli, Ergebnis als Freitext (conclusion) + Keimnachweis-Observation
Instance: example-lab-dr-urinkultur
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: Urinkultur (Mikrobiologie)"
Description: "Mikrobiologischer Befund Urinkultur, Status final. Kategorie MB. Probe Mittelstrahlurin (MSU), E. coli-Nachweis mit Antibiogramm."
Usage: #example
* status = #final
* category[mb] = http://terminology.hl7.org/CodeSystem/v2-0074#MB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #630-4
* code.coding[0].display = "Bacteria identified in Urine by Culture"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-02"
* result[0] = Reference(lab-obs-example-leukozyten-urin)
* result[1] = Reference(lab-obs-example-ecoli-keim)
* result[2] = Reference(lab-obs-example-antibiogramm-cipro)
* specimen[0] = Reference(example-specimen-urin-msu)
* conclusion = "E. coli >10^5, sensibel auf Ciprofloxacin und Nitrofurantoin"

// --- Hilfsobservation: Histologische Diagnose Basalzellkarzinom ---
Instance: lab-obs-example-bcc-histologie
InstanceOf: PraxisLabObservation
Title: "Lab Observation: Histologische Diagnose Basalzellkarzinom"
Description: "Pathologie-Observation fuer histologische Diagnose Basalzellkarzinom. SNOMED-kodierter Befund."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[loinc].system = "http://loinc.org"
* code.coding[loinc].code = #60568-3
* code.coding[loinc].display = "Pathology Synoptic report"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-03"
* valueCodeableConcept.coding[0].system = "http://snomed.info/sct"
* valueCodeableConcept.coding[0].code = #254701007
* valueCodeableConcept.coding[0].display = "Basal cell carcinoma of skin"

// --- Hilfsspecimen: Biopsie-Probe (Gewebeprobe fuer Pathologie) ---
Instance: example-specimen-biopsy-haut
InstanceOf: PraxisSpecimen
Title: "Specimen: Hautbiopsie (Gewebeprobe)"
Description: "Hautbiopsie fuer histologische Untersuchung. SNOMED 258415003 Biopsy sample."
Usage: #example
* type.coding[snomed].system = "http://snomed.info/sct"
* type.coding[snomed].code = #258415003
* type.coding[snomed].display = "Biopsy sample"
* subject = Reference(example-patient)
* collection.collectedDateTime = "2026-04-03T09:00:00+02:00"
* collection.method.coding[0].system = "http://snomed.info/sct"
* collection.method.coding[0].code = #301480002
* collection.method.coding[0].display = "Shave biopsy"
* collection.bodySite.coding[0].system = "http://snomed.info/sct"
* collection.bodySite.coding[0].code = #368209003
* collection.bodySite.coding[0].display = "Right arm"

// --- Beispiel 3: Pathologie Histologie ---
// Kategorie PAT, Befundbericht als PDF (presentedForm) + narrative conclusion + SNOMED Observation + Biopsie-Specimen
Instance: example-lab-dr-histologie
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: Histologie Basalzellkarzinom (Pathologie)"
Description: "Pathologischer Histologiebericht, Status final. Kategorie PAT. Befund als URL-Referenz auf PDF (kein inline base64). Diagnose: Basalzellkarzinom, nodulaerer Typ, R0. Probe: Hautbiopsie."
Usage: #example
* status = #final
* category[pat] = http://terminology.hl7.org/CodeSystem/v2-0074#PAT
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #60568-3
* code.coding[0].display = "Pathology Synoptic report"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-03"
* result[0] = Reference(lab-obs-example-bcc-histologie)
* specimen[0] = Reference(example-specimen-biopsy-haut)
* resultsInterpreter[0] = Reference(example-practitioner)
* conclusion = "Basalzellkarzinom, nodulaerer Typ, R0"
* presentedForm[0].contentType = #application/pdf
* presentedForm[0].url = "https://befunde.labor-beispiel.de/pat-2026-00099.pdf"
* presentedForm[0].title = "Histologiebericht Basalzellkarzinom"

// --- Beispiel 4: Teilbefund (preliminary status) ---
// Kategorie LAB, Status preliminary (Ergebnis noch nicht vollstaendig)
Instance: example-lab-dr-preliminary
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: Kreatinin Teilbefund (preliminary)"
Description: "Laborbefund mit Status preliminary — Ergebnis liegt noch nicht vollstaendig vor. Kategorie LAB. Typischer Anwendungsfall: Labor meldet Teilergebnis vorab."
Usage: #example
* status = #preliminary
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #2160-0
* code.coding[0].display = "Creatinine [Mass/volume] in Serum or Plasma"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-05"
* issued = "2026-04-03T11:30:00+02:00"

// --- Beispiel 5: Kumulativbefund HbA1c Januar ---
// Zeigt das "separate DiagnosticReports pro Datum"-Pattern fuer Kumulativbefunde
Instance: example-lab-dr-hba1c-jan
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: HbA1c Kumulativbefund Januar 2026"
Description: "Kumulativbefund HbA1c Januar 2026. Separate DiagnosticReport-Instanz pro Messzeitpunkt — kein FHIR-eigener Gruppiermechanismus notwendig. LOINC 4548-4."
Usage: #example
* status = #final
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #4548-4
* code.coding[0].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-01-15"
* issued = "2026-01-15T14:00:00+01:00"
* result[0] = Reference(lab-obs-example-hba1c)
* specimen[0] = Reference(example-specimen-blut-edta)

// --- Beispiel 6: Kumulativbefund HbA1c April ---
// Zweiter Messpunkt im Kumulativbefund-Pattern (zeitlicher Abstand demonstriert Verlauf)
Instance: example-lab-dr-hba1c-apr
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: HbA1c Kumulativbefund April 2026"
Description: "Kumulativbefund HbA1c April 2026. Separate DiagnosticReport-Instanz mit spaeterem Datum — demonstriert zeitlichen Verlauf fuer Kumulativdarstellung. LOINC 4548-4."
Usage: #example
* status = #final
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #4548-4
* code.coding[0].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-05"
* issued = "2026-04-05T14:00:00+02:00"
* result[0] = Reference(lab-obs-example-hba1c)
* specimen[0] = Reference(example-specimen-blut-edta)

// --- Beispiel 7: Kumulativbefund HbA1c Juli ---
// Dritter Messpunkt im Kumulativbefund-Pattern — vervollstaendigt die Quartalsverlaufsreihe
Instance: example-lab-dr-hba1c-q3
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: HbA1c Kumulativbefund Juli 2026"
Description: "Kumulativbefund HbA1c Juli 2026. Dritter Messpunkt — zeigt Quartalsverlauf HbA1c Q1/Q2/Q3. LOINC 4548-4."
Usage: #example
* status = #final
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #4548-4
* code.coding[0].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-07-10"
* issued = "2026-07-10T12:00:00+02:00"
* result[0] = Reference(lab-obs-example-hba1c)
* specimen[0] = Reference(example-specimen-blut-edta)
