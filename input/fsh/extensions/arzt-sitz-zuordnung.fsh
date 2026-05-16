// arzt-sitz-zuordnung.fsh
// Extensions for Arzt-Sitz-Zuordnung on PractitionerRole
// Bead: fpde-e0o

Extension: SitzAnteilExt
Id: sitz-anteil
Title: "Sitz Anteil"
Description: "Anteil des Arztes am KV-Sitz als Dezimalzahl (z.B. 0.5 fuer halben Sitz)."
Context: PractitionerRole
* value[x] only decimal
* valueDecimal ^minValueDecimal = 0.0
* valueDecimal ^maxValueDecimal = 1.0

Extension: StundenProWocheExt
Id: stunden-pro-woche
Title: "Stunden pro Woche"
Description: "Vertraglich vereinbarte Arbeitsstunden pro Woche des Arztes an diesem Standort."
Context: PractitionerRole
* value[x] only decimal
* valueDecimal ^minValueDecimal = 0.0

Extension: ArztSitzStatusExt
Id: arzt-sitz-status
Title: "Arzt Sitz Status"
Description: "Status des Arztes in Bezug auf die Sitz-Zuordnung (Facharzt, WBA, Sicherstellung, Vertreter)."
Context: PractitionerRole
* value[x] only code
* valueCode from ArztStatusVS (required)
