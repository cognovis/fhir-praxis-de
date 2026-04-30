// Imaging Workflow Subscription Templates (R4 pattern, Aidbox-compatible)
//
// These are TEMPLATE instances, not live subscriptions.
// The consuming rule engine instantiates them at runtime with real endpoint URLs.
//
// R4 Subscription pattern note:
//   R5 introduced SubscriptionTopic for structured event definitions.
//   In R4, Subscription uses a criteria-based approach: a FHIR search URL
//   in the `criteria` field defines the trigger condition.
//   These templates follow the R4 backport pattern — migration to R5
//   SubscriptionTopic is a future task tracked separately.
//
// ASCII-safe: keine Umlaute in Kommentaren (ae, ue, oe, ss statt Umlauten).

// --- SubscriptionReportDistributed ---
// Trigger: DiagnosticReport.status reaches "final"
// Consumer: Webhook distribution service (e.g. PDF delivery, PACS notification)

Instance: example-subscription-report-distributed
InstanceOf: Subscription
Title: "Subscription Template: DiagnosticReport Final — Webhook Distribution"
Description: "R4 Subscription template. Triggers when a DiagnosticReport reaches status=final. The consuming rule engine instantiates this template at runtime with the actual webhook endpoint URL. Used to drive automated report distribution (PDF delivery, referrer notification)."
Usage: #example
* status = #requested
* reason = "Trigger downstream report distribution when a DiagnosticReport is finalized."
* criteria = "DiagnosticReport?status=final"
* channel.type = #rest-hook
// Placeholder URL — replaced at runtime with the real distribution endpoint.
* channel.endpoint = "https://rule-engine.example.com/hooks/report-distributed"
* channel.payload = #application/fhir+json

// --- SubscriptionStudySigned ---
// Trigger: DiagnosticReport with report-substatus extension = signed
//   (status=final is correct per IG: report-substatus#signed is only valid
//   when DiagnosticReport.status=final. R4 search cannot filter by extension
//   value directly; the consuming subscription handler checks the report-substatus
//   extension value post-receive to confirm the trigger.
//   The pattern is: status=final AND report-substatus=signed.)
// Consumer: Workflow engine (e.g. radiologist sign-off handoff)

Instance: example-subscription-study-signed
InstanceOf: Subscription
Title: "Subscription Template: DiagnosticReport Signed — Workflow Engine"
Description: "R4 Subscription template. Triggers when a DiagnosticReport reaches status=final (required for report-substatus#signed per IG). The consuming handler post-filters by the report-substatus extension (value=signed) to confirm the trigger. Used to hand off signed studies to the workflow engine."
Usage: #example
* status = #requested
* reason = "Trigger workflow-engine processing when a DiagnosticReport is signed off by the radiologist."
// R4 limitation: extension values are not filterable in criteria search expressions.
// Use status=final as the broad trigger; the consuming handler applies the substatus filter post-receive.
* criteria = "DiagnosticReport?status=final"
* channel.type = #rest-hook
// Placeholder URL — replaced at runtime with the real workflow engine endpoint.
* channel.endpoint = "https://rule-engine.example.com/hooks/study-signed"
* channel.payload = #application/fhir+json

// --- SubscriptionAppointmentArrived ---
// Trigger: Appointment.status reaches "arrived"
// Consumer: Worklist service (modality worklist update, DICOM MWL push)

Instance: example-subscription-appointment-arrived
InstanceOf: Subscription
Title: "Subscription Template: Appointment Arrived — Worklist Service"
Description: "R4 Subscription template. Triggers when an Appointment reaches status=arrived (patient checked in). The consuming rule engine instantiates this template at runtime with the actual worklist service endpoint. Used to push modality worklist (DICOM MWL) updates when a patient arrives."
Usage: #example
* status = #requested
* reason = "Trigger worklist refresh when a patient appointment transitions to arrived status."
* criteria = "Appointment?status=arrived"
* channel.type = #rest-hook
// Placeholder URL — replaced at runtime with the real worklist service endpoint.
* channel.endpoint = "https://rule-engine.example.com/hooks/appointment-arrived"
* channel.payload = #application/fhir+json
