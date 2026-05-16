// sitz.fsh
// Extensions for KV-Sitz (practice seat) data on Organization
// Bead: fpde-e0o

Extension: SitzUmfangExt
Id: sitz-umfang
Title: "Sitz Umfang"
Description: "Umfang des KV-Sitzes in Vollzeitstellen (z.B. 0.5 fuer halben Sitz)."
Context: Organization
* value[x] only decimal
* valueDecimal ^minValueDecimal = 0.0
* valueDecimal ^maxValueDecimal = 1.0

Extension: SitzStatusExt
Id: sitz-status-ext
Title: "Sitz Status"
Description: "Aktueller Status des KV-Sitzes (aktiv, vakant, ruhend, verkauft)."
Context: Organization
* value[x] only code
* valueCode from SitzStatusVS (required)

Extension: VakanzSeitExt
Id: vakanz-seit
Title: "Vakanz seit"
Description: "Datum, ab dem der KV-Sitz vakant ist."
Context: Organization
* value[x] only date

Extension: VakanzFristExt
Id: vakanz-frist
Title: "Vakanz Frist"
Description: "Datum, bis zu dem der vakante KV-Sitz neu besetzt werden muss."
Context: Organization
* value[x] only date
