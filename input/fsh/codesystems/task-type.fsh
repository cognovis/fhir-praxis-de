CodeSystem: TaskTypeCS
Id: task-type
Title: "Aufgabentyp"
Description: "Typen fuer Praxis-Aufgaben (Rueckruf, Dringend, etc.)"
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/task-type"
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* #callback "Rueckruf" "Patient bittet um Rueckruf"
* #urgent "Dringend" "Dringende Aufgabe"
* #lab "Labor" "Labor-Ergebnis bearbeiten"
* #recipe "Rezept" "Rezeptanforderung"
* #referral "Ueberweisung" "Ueberweisungsanforderung"
