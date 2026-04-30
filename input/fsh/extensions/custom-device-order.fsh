// Extensions fuer individuelle Geraeteauftraege (Arzt → Werkstatt)
// Generisch nutzbar fuer: Zahntechnik, Orthopaedietechnik, Optik, Audiologie

Extension: ManufacturingDeadlineExt
Id: manufacturing-deadline
Title: "Fertigstellungstermin"
Description: "Gewuenschter Fertigstellungstermin fuer das individuell gefertigte Medizinprodukt (z.B. Zahnersatz, Orthese, Brille)."
Context: ServiceRequest
* value[x] only dateTime

Extension: DigitalWorkflowExt
Id: digital-workflow
Title: "Digitaler Workflow"
Description: "Art des Herstellungsworkflows: digital (z.B. Intraoralscan, CAD/CAM), konventionell (z.B. Alginatabformung, Gipsmodell) oder hybrid."
Context: ServiceRequest
* value[x] only code
* valueCode from DigitalWorkflowVS (required)
