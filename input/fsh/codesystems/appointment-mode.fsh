CodeSystem: AppointmentModeCS
Id: appointment-mode
Title: "Appointment Mode"
Description: "Codes für die Durchführungsart eines Termins (Praxisbesuch, Videosprechstunde, Telefontermin, Hausbesuch)."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #in-person "Praxisbesuch" "Patient erscheint persönlich in der Praxis"
* #video "Videosprechstunde" "Termin findet per Videokonferenz statt"
* #phone "Telefontermin" "Termin findet telefonisch statt"
* #home-visit "Hausbesuch" "Arzt besucht den Patienten zu Hause"
