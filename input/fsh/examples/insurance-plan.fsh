// =============================================================================
// InsurancePlan Examples: GKV (AOK Bayern) und PKV (Debeka)
//
// AK3 — Coverage-Referenz Designhinweis:
// Wenn ein Patient einer Kasse angehoert und einen bestimmten Tarif hat,
// wird dies ueber Coverage.class abgebildet:
//
//   Coverage.class[0].type  = http://terminology.hl7.org/CodeSystem/coverage-class#plan
//   Coverage.class[0].value = "aok-bayern-pzr"   // Tarif-Identifier
//   Coverage.class[0].name  = "AOK Bayern PZR Satzungsleistung"
//
// Die vollstaendige InsurancePlan-Ressource (z.B. example-aok-bayern) kann
// ueber Coverage.class[0].value als Identifier referenziert werden.
// Ein direkter FHIR-Reference-Link von Coverage auf InsurancePlan ist
// im R4-Kern nicht vorgesehen; der Identifier-Abgleich ist das empfohlene
// Muster fuer dieses IG.
// =============================================================================

// -----------------------------------------------------------------------------
// GKV Example: AOK Bayern mit PZR Satzungsleistung
// -----------------------------------------------------------------------------
Instance: example-aok-bayern
InstanceOf: InsurancePlanDE
Title: "AOK Bayern — PZR Satzungsleistung"
Description: "GKV-Tarif AOK Bayern mit Satzungsleistung Professionelle Zahnreinigung (PZR)."
Usage: #example
* name = "AOK Bayern — Basis + PZR Satzungsleistung"
* status = #active
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#PUBLICPOL "public healthcare"
// GKV plan: Satzungsleistung PZR
* plan[gkv].type = http://fhir.cognovis.de/praxis/CodeSystem/InsurancePlanType#gkv "GKV"
* plan[gkv].specificCost[0].category.text = "Satzungsleistung"
* plan[gkv].specificCost[0].benefit[0].type.text = "Professionelle Zahnreinigung (PZR)"
* plan[gkv].specificCost[0].benefit[0].cost[0].type.text = "Kassenleistung"
// Coverage-Leistungskatalog
* coverage[0].type.text = "Zahnleistungen"
* coverage[0].benefit[0].type.text = "Professionelle Zahnreinigung (PZR)"

// -----------------------------------------------------------------------------
// PKV Example: Debeka Premium Plus mit GOÄ-Faktor-Limit 2.3
// -----------------------------------------------------------------------------
Instance: example-debeka-plus
InstanceOf: InsurancePlanDE
Title: "Debeka — PKV Tarif mit GOÄ-Faktor 2.3"
Description: "PKV-Tarif Debeka mit GOÄ-Faktor-Limit 2.3 fuer aerztliche Leistungen."
Usage: #example
* name = "Debeka Premium Plus"
* status = #active
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#PRVPOL "private healthcare"
// PKV plan: GOÄ-Faktor-Limit
* plan[pkv].type = http://fhir.cognovis.de/praxis/CodeSystem/InsurancePlanType#pkv "PKV"
* plan[pkv].specificCost[0].category.text = "GOÄ-Faktor-Limit"
* plan[pkv].specificCost[0].benefit[0].type.text = "GOÄ-Faktor 2.3"
* plan[pkv].specificCost[0].benefit[0].cost[0].type.text = "Maximaler GOÄ-Faktor"
* plan[pkv].specificCost[0].benefit[0].cost[0].value.value = 2.3
* plan[pkv].specificCost[0].benefit[0].cost[0].value.system = "http://unitsofmeasure.org"
* plan[pkv].specificCost[0].benefit[0].cost[0].value.code = #1
// Coverage-Leistungskatalog
* coverage[0].type.text = "Aerztliche Leistungen"
* coverage[0].benefit[0].type.text = "GOÄ-Positionen bis Faktor 2.3"
