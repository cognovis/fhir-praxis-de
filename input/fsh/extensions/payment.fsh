Extension: ZahlungsartExt
Id: zahlungsart
Title: "Zahlungsart"
Description: "Art der Zahlung"
Context: PaymentReconciliation
* value[x] only CodeableConcept

Extension: PaymentPatientRefExt
Id: payment-patient-ref
Title: "Zahlungs-Patientenreferenz"
Description: "Referenz auf den Patienten fuer die Zahlung"
Context: PaymentReconciliation
* value[x] only Reference(Patient)
