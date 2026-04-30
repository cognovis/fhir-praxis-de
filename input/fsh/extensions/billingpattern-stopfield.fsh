Extension: BillingPatternStopfield
Id: billingpattern-stopfield
Title: "BillingPattern Stopfield"
Description: "A stopfield (Stoppfeld) in a billing pattern chain (Ziffernkette). Stopfields prompt the user for additional input at point-of-care when executing the pattern."
Context: PlanDefinition
* extension contains
    label 1..1 and
    type 1..1 and
    required 1..1
* extension[label].value[x] only string
* extension[type].value[x] only code
* extension[type].valueCode from BillingPatternStopfieldTypeVS (required)
* extension[required].value[x] only boolean
