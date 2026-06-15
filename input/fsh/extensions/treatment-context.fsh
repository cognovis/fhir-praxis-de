Extension: TreatmentContextExt
Id: treatment-context
Title: "Treatment Context"
Description: "Establishes the treatment context for an Encounter, referencing the reception check-in event and workplace function."
Context: Encounter
* extension contains
    workplaceFunction 0..1 and
    checkInTimestamp 0..1
* extension[workplaceFunction] ^short = "Workplace function that established the treatment context"
* extension[workplaceFunction].value[x] only Coding
* extension[workplaceFunction].value[x] from https://fhir.cognovis.de/praxis/ValueSet/praxis-workplace-function (extensible)
* extension[checkInTimestamp] ^short = "Timestamp of the check-in event"
* extension[checkInTimestamp].value[x] only dateTime
