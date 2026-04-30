// Imaging Workflow Subscription Templates (R4 pattern, Aidbox-compatible)
//
// These are TEMPLATE instances, not live subscriptions.
// MIRA (the rule engine) instantiates them at runtime with real endpoint URLs.
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
Description: "R4 Subscription template. Triggers when a DiagnosticReport reaches status=final. MIRA instantiates this template at runtime with the actual webhook endpoint URL. Used to drive automated report distribution (PDF delivery, referrer notification)."
Usage: #example
* status = #requested
* reason = "Notify downstream distribution service when a DiagnosticReport is finalized. Template — MIRA sets the real endpoint at runtime."
* criteria = "DiagnosticReport?status=final"
* channel.type = #rest-hook
// Placeholder URL — MIRA replaces this with the real distribution endpoint at runtime.
* channel.endpoint = "https://mira.example.com/hooks/report-distributed"
* channel.payload = #application/fhir+json

// --- SubscriptionStudySigned ---
// Trigger: DiagnosticReport with report-substatus extension = signed
//   (status=preliminary is used in criteria because R4 search cannot filter
//   by extension value directly; the MIRA subscription handler checks the
//   report-substatus extension value post-receive to confirm the trigger.
//   The pattern is: status=preliminary AND report-substatus=signed.)
// Consumer: Workflow engine (e.g. radiologist sign-off handoff)

Instance: example-subscription-study-signed
InstanceOf: Subscription
Title: "Subscription Template: DiagnosticReport Signed — Workflow Engine"
Description: "R4 Subscription template. Triggers when a DiagnosticReport reaches status=preliminary (candidate for signed substatus). MIRA post-filters by the report-substatus extension (value=signed) to confirm the trigger. Used to hand off signed studies to the workflow engine."
Usage: #example
* status = #requested
* reason = "Notify workflow engine when a radiologist signs off a study. R4 criteria uses status=preliminary; MIRA handler post-filters by report-substatus extension (signed) post-receive. Template — MIRA sets the real endpoint at runtime."
// R4 limitation: extension values are not filterable in criteria search expressions.
// Use status=preliminary as the broad trigger; MIRA handler applies the substatus filter.
* criteria = "DiagnosticReport?status=preliminary"
* channel.type = #rest-hook
// Placeholder URL — MIRA replaces this with the real workflow engine endpoint at runtime.
* channel.endpoint = "https://mira.example.com/hooks/study-signed"
* channel.payload = #application/fhir+json

// --- SubscriptionAppointmentArrived ---
// Trigger: Appointment.status reaches "arrived"
// Consumer: Worklist service (modality worklist update, DICOM MWL push)

Instance: example-subscription-appointment-arrived
InstanceOf: Subscription
Title: "Subscription Template: Appointment Arrived — Worklist Service"
Description: "R4 Subscription template. Triggers when an Appointment reaches status=arrived (patient checked in). MIRA instantiates this template at runtime with the actual worklist service endpoint. Used to push modality worklist (DICOM MWL) updates when a patient arrives."
Usage: #example
* status = #requested
* reason = "Notify worklist service when a patient arrives for an imaging appointment. Template — MIRA sets the real endpoint at runtime."
* criteria = "Appointment?status=arrived"
* channel.type = #rest-hook
// Placeholder URL — MIRA replaces this with the real worklist service endpoint at runtime.
* channel.endpoint = "https://mira.example.com/hooks/appointment-arrived"
* channel.payload = #application/fhir+json
