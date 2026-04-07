Extension: HonorarbescheidQuartalExt
Id: honorarbescheid-quartal
Title: "Honorarbescheid Quartal"
Description: "Quartal des Honorarbescheids, z.B. 3/2025"
Context: PaymentReconciliation, ClaimResponse
* value[x] only string

Extension: HonorarbescheidPatientNameExt
Id: honorarbescheid-patient-name
Title: "Honorarbescheid Patientenname"
Description: "Patientenname wenn keine FHIR-Patient-Referenz verfuegbar"
Context: ClaimResponse
* value[x] only string

Extension: HonorarbescheidPatientBirthDateExt
Id: honorarbescheid-patient-birthdate
Title: "Honorarbescheid Geburtsdatum"
Description: "Geburtsdatum des Patienten als Fallback"
Context: ClaimResponse
* value[x] only date

Extension: HonorarbescheidCorrectionSignExt
Id: honorarbescheid-correction-sign
Title: "Honorarbescheid Korrekturrichtung"
Description: "Korrekturrichtung: + (Zufuegung) oder - (Absetzung)"
Context: ClaimResponse
* value[x] only string
