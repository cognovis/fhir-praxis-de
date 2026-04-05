// Lab DiagnosticReport Beispiele — PraxisLabDiagnosticReport Profil
// Vier Szenarien: Einzelbefund, Mikrobiologie, Pathologie, Teilbefund (preliminary)
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss).

// --- Beispiel 1: Einzelbefund Blutbild (CBC) ---
// Standard-Labor, Status final, Probe EDTA-Blut
Instance: example-lab-dr-blutbild
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: Blutbild CBC (Einzelbefund)"
Description: "Standard-Laborbefund mit CBC-Panel (Blutbild), Status final. Kategorie LAB. Probe EDTA-Blut, Ergebnis-Verweis auf HbA1c-Observation als Platzhalter."
Usage: #example
* status = #final
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #58410-2
* code.coding[0].display = "CBC panel - Blood by Automated count"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-01"
* issued = "2026-04-01T14:00:00+02:00"
* result[0] = Reference(lab-obs-example-hba1c)
* specimen[0] = Reference(example-specimen-blut-edta)
* resultsInterpreter[0] = Reference(example-practitioner)

// --- Hilfsobservation: E. coli Keimnachweis (Urinkultur) ---
Instance: lab-obs-example-ecoli-keim
InstanceOf: PraxisLabObservation
Title: "Lab Observation: E. coli Keimnachweis (Urinkultur)"
Description: "Mikrobiologie-Observation fuer E. coli-Nachweis in Urinkultur. LDT-only Code mit LOINC-Mapping."
Usage: #example
* status = #final
* category[laboratory] = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #6463-4
* code.coding[0].display = "Bacteria identified in Urine by Culture"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-02"
* valueCodeableConcept.coding[0].system = "http://snomed.info/sct"
* valueCodeableConcept.coding[0].code = #112283007
* valueCodeableConcept.coding[0].display = "Escherichia coli"

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
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #60568-3
* code.coding[0].display = "Pathology Synoptic report"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-03"
* valueCodeableConcept.coding[0].system = "http://snomed.info/sct"
* valueCodeableConcept.coding[0].code = #254701007
* valueCodeableConcept.coding[0].display = "Basal cell carcinoma of skin"

// --- Beispiel 3: Pathologie Histologie ---
// Kategorie PAT, Befundbericht als PDF (presentedForm) + narrative conclusion + SNOMED Observation
Instance: example-lab-dr-histologie
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: Histologie Basalzellkarzinom (Pathologie)"
Description: "Pathologischer Histologiebericht, Status final. Kategorie PAT. Befund als URL-Referenz auf PDF (kein inline base64). Diagnose: Basalzellkarzinom, nodulaerer Typ, R0."
Usage: #example
* status = #final
* category[pat] = http://terminology.hl7.org/CodeSystem/v2-0074#PAT
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #60568-3
* code.coding[0].display = "Pathology Synoptic report"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-03"
* result[0] = Reference(lab-obs-example-bcc-histologie)
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

// --- Beispiel 5: Kumulativbefund HbA1c Q1 ---
// Zeigt das "separate DiagnosticReports pro Datum"-Pattern fuer Kumulativbefunde
Instance: example-lab-dr-hba1c-q1
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: HbA1c Kumulativbefund Q1 2026"
Description: "Kumulativbefund HbA1c Q1 2026 (Januar). Separate DiagnosticReport-Instanz pro Messzeitpunkt — kein FHIR-eigener Gruppiermechanismus notwendig."
Usage: #example
* status = #final
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #4548-4
* code.coding[0].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-01-15"
* result[0] = Reference(lab-obs-example-hba1c)

// --- Beispiel 6: Kumulativbefund HbA1c Q2 ---
// Zweiter Messpunkt im Kumulativbefund-Pattern
Instance: example-lab-dr-hba1c-q2
InstanceOf: PraxisLabDiagnosticReport
Title: "Lab DiagnosticReport: HbA1c Kumulativbefund Q2 2026"
Description: "Kumulativbefund HbA1c Q2 2026 (April). Separate DiagnosticReport-Instanz pro Messzeitpunkt."
Usage: #example
* status = #final
* category[lab] = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* code.coding[0].system = "http://loinc.org"
* code.coding[0].code = #4548-4
* code.coding[0].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* subject = Reference(example-patient)
* effectiveDateTime = "2026-04-01"
* result[0] = Reference(lab-obs-example-hba1c)
