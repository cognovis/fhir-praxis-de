// AiProvenanceApplicableExt — Marker for AI provenance tracking at DomainResource level
// Complement to the Provenance-scoped AI extensions in ai-provenance.fsh
// Bead: fpde-shp.6

Extension: AiProvenanceApplicableExt
Id: ai-provenance-applicable
Title: "KI-Provenance anwendbar"
Description: "Marker ob fuer diesen FHIR-Eintrag KI-Provenance dokumentiert wurde (EU AI Act Art. 13). Details in einer zugehoerigen Provenance-Ressource mit AiGeneratedExt, AiProviderExt, AiModelExt etc. (siehe ai-provenance.fsh). Ermoeglicht schnelle Filterung ohne Provenance-Join."
Context: DomainResource
* value[x] only boolean
