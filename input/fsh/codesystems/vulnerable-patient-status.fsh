// vulnerable-patient-status.fsh
// Bead: fpde-0wb
// Local terminology for vulnerable patient master-data modifiers

CodeSystem: PflegegradStatusCS
Id: pflegegrad-status
Title: "Pflegegrad Status"
Description: "Statuswerte fuer den Pflegegrad als Patient-Master-Data-Modifikator."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/pflegegrad-status"
* ^property[0].code = #snomed-family
* ^property[0].uri = "http://snomed.info/sct"
* ^property[0].description = "SNOMED CT family or grouping reference for the Pflegegrad concept"
* ^property[0].type = #string
* #PG1 "Pflegegrad 1" "Geringe Beeintraechtigungen der Selbststaendigkeit (SGB XI)"
  * ^property[0].code = #snomed-family
  * ^property[0].valueString = "276239002"
* #PG2 "Pflegegrad 2" "Erhebliche Beeintraechtigungen der Selbststaendigkeit (SGB XI)"
  * ^property[0].code = #snomed-family
  * ^property[0].valueString = "276239002"
* #PG3 "Pflegegrad 3" "Schwere Beeintraechtigungen der Selbststaendigkeit (SGB XI)"
  * ^property[0].code = #snomed-family
  * ^property[0].valueString = "276239002"
* #PG4 "Pflegegrad 4" "Schwerste Beeintraechtigungen der Selbststaendigkeit (SGB XI)"
  * ^property[0].code = #snomed-family
  * ^property[0].valueString = "276239002"
* #PG5 "Pflegegrad 5" "Schwerste Beeintraechtigungen mit besonderem Versorgungsbedarf (SGB XI)"
  * ^property[0].code = #snomed-family
  * ^property[0].valueString = "276239002"

ValueSet: PflegegradStatusVS
Id: pflegegrad-status-vs
Title: "Pflegegrad Status"
Description: "Auswahl der lokalen Pflegegrad-Statuscodes."
* ^status = #active
* ^experimental = false
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/pflegegrad-status-vs"
* include codes from system PflegegradStatusCS

CodeSystem: EingliederungshilfeStatusCS
Id: eingliederungshilfe-status
Title: "Eingliederungshilfe Status"
Description: "Statuswerte fuer die Eingliederungshilfe als Patient-Master-Data-Modifikator."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/eingliederungshilfe-status"
* ^property[0].code = #icf-domain
* ^property[0].uri = "http://hl7.org/fhir/sid/icf"
* ^property[0].description = "ICF domain reference for the Eingliederungshilfe concept"
* ^property[0].type = #string
* #active "Aktiv" "Eingliederungshilfe aktiv (SGB IX, Teil 2)"
* #inactive "Inaktiv" "Keine Eingliederungshilfe"
* #physical "Koerperliche Behinderung" "Koerperliche Behinderung nach § 99 SGB IX"
  * ^property[0].code = #icf-domain
  * ^property[0].valueString = "b7"
* #cognitive "Geistige Behinderung" "Geistige Behinderung nach § 99 SGB IX"
  * ^property[0].code = #icf-domain
  * ^property[0].valueString = "b1"
* #psychological "Seelische Behinderung" "Seelische Behinderung nach § 99 SGB IX"
  * ^property[0].code = #icf-domain
  * ^property[0].valueString = "b1"

ValueSet: EingliederungshilfeStatusVS
Id: eingliederungshilfe-status-vs
Title: "Eingliederungshilfe Status"
Description: "Auswahl der lokalen Eingliederungshilfe-Statuscodes."
* ^status = #active
* ^experimental = false
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/eingliederungshilfe-status-vs"
* include codes from system EingliederungshilfeStatusCS

CodeSystem: KooperationsvertragStatusCS
Id: kooperationsvertrag-status
Title: "Kooperationsvertrag Status"
Description: "Statuswerte fuer den Kooperationsvertrag als Patient-Master-Data-Modifikator."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/kooperationsvertrag-status"
* #active "Aktiv" "Aktiver Kooperationsvertrag nach § 119b SGB V"
* #inactive "Inaktiv" "Kein Kooperationsvertrag"
* #pending "In Vorbereitung" "Kooperationsvertrag in Vorbereitung"

ValueSet: KooperationsvertragStatusVS
Id: kooperationsvertrag-status-vs
Title: "Kooperationsvertrag Status"
Description: "Auswahl der lokalen Kooperationsvertrag-Statuscodes."
* ^status = #active
* ^experimental = false
* ^url = "https://fhir.cognovis.de/praxis/ValueSet/kooperationsvertrag-status-vs"
* include codes from system KooperationsvertragStatusCS
