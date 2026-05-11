// ChargeItemDefinition Demo-Examples fuer Tax-Pattern (fpde-shp.9)
// Zeigt: ext-tax-category auf ChargeItemDefinition.propertyGroup.priceComponent
// System: urn:un:unece:uncefact:codelist:standard:5305 (UNECE-5305)
// Canonical-Muster: https://fhir.cognovis.de/praxis/ChargeItemDefinition/<id>
// ASCII-safe: keine Umlaute in Kommentaren.

Alias: $UNECE5305 = urn:un:unece:uncefact:codelist:standard:5305
Alias: $BEMA = https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BEMA
Alias: $GOZ = https://fhir.de/CodeSystem/bzaek/goz

// ============================================================
// Beispiel 1: BEMA-Heilbehandlung — steuerbefreit §4 Nr.14a UStG
// Steuerkategorie E (befreit), Befreiungsgrund para4-nr14a
// Zahnaeztliche GKV-Behandlung nach BEMA Ziffer 01 (Untersuchung)
// ============================================================

Instance: example-cid-bema-heilbehandlung
InstanceOf: ChargeItemDefinition
Title: "ChargeItemDefinition — BEMA 01 Untersuchung (steuerbefreit)"
Description: "BEMA Ziffer 01 (Klinische Untersuchung). Steuerkategorie E (steuerbefreit) gemaess §4 Nr. 14a UStG — aerztliche Heilbehandlungsleistung. Tax-Extension auf propertyGroup.priceComponent als unverbindliche Vorbelegung fuer das PVS. Finale Klassifikation liegt beim PVS/Steuerberater."
Usage: #example

* url = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/bema-01-untersuchung"
* status = #active
* title = "BEMA 01 — Klinische Untersuchung"
* description = "Klinische Untersuchung (GKV-Abrechnung BEMA Ziffer 01). Heilbehandlungsleistung eines Zahnarztes, steuerbefreit nach §4 Nr. 14a UStG."
* code.coding[0].system = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BEMA"
* code.coding[0].code = #01
* code.coding[0].display = "Klinische Untersuchung"
// propertyGroup: Preis mit Steuer-Vorbelegung (Kategorie E — Heilbehandlung)
* propertyGroup[0].priceComponent[0].type = #base
* propertyGroup[0].priceComponent[0].code.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
* propertyGroup[0].priceComponent[0].code.coding[0].code = #BILLED
* propertyGroup[0].priceComponent[0].code.text = "Basispreis BEMA 01"
* propertyGroup[0].priceComponent[0].amount.value = 13.50
* propertyGroup[0].priceComponent[0].amount.currency = #EUR
// Tax-Extension: Vorbelegung Steuerkategorie E (steuerbefreit, Heilbehandlung §4 Nr.14a)
* propertyGroup[0].priceComponent[0].extension[ext-tax-category].valueCodeableConcept = $UNECE5305#E "Steuerfrei"
* propertyGroup[0].priceComponent[0].extension[ext-tax-exemption-reason].valueCodeableConcept = UStBefreiungsgrundCS#para4-nr14a "§ 4 Nr. 14a UStG"

// ============================================================
// Beispiel 2: IGeL Bleaching — 19% Regelsteuersatz (Kategorie S)
// Kosmetische Leistung ohne therapeutischen Zweck — nicht steuerbefreit
// GOZ Ziffer 1000 (aequivalent, IGeL-Kontext)
// ============================================================

Instance: example-cid-igel-bleaching
InstanceOf: ChargeItemDefinition
Title: "ChargeItemDefinition — IGeL Bleaching (19% USt, Kategorie S)"
Description: "IGeL-Leistung Zahnaufhellung (Bleaching). Kosmetische Behandlung ohne Heilbehandlungszweck — steuerpflichtig mit Regelsteuersatz 19% (UNECE-5305 Kategorie S). Tax-Extension auf propertyGroup.priceComponent als unverbindliche Vorbelegung. Finale Klassifikation liegt beim PVS/Steuerberater."
Usage: #example

* url = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/igel-bleaching-zahnaufhellung"
* status = #active
* title = "IGeL Bleaching — Zahnaufhellung"
* description = "Professionelle Zahnaufhellung (Bleaching) als IGeL-Leistung. Keine Heilbehandlung im umsatzsteuerlichen Sinne (§4 Nr. 14a UStG nicht anwendbar) — regulaere 19% USt."
* code.coding[0].system = "https://fhir.de/CodeSystem/bzaek/goz"
* code.coding[0].code = #1000
* code.coding[0].display = "Bleaching (Zahnaufhellung)"
// propertyGroup: Basispreis 19% USt
* propertyGroup[0].priceComponent[0].type = #base
* propertyGroup[0].priceComponent[0].code.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
* propertyGroup[0].priceComponent[0].code.coding[0].code = #BILLED
* propertyGroup[0].priceComponent[0].code.text = "Basispreis netto"
* propertyGroup[0].priceComponent[0].amount.value = 126.05
* propertyGroup[0].priceComponent[0].amount.currency = #EUR
// Tax-Extension: Vorbelegung Steuerkategorie S (19% Regelsteuersatz)
* propertyGroup[0].priceComponent[0].extension[ext-tax-category].valueCodeableConcept = $UNECE5305#S "Normaler Steuersatz"
// Tax-Komponente: 19% auf Nettopreis
* propertyGroup[0].priceComponent[1].type = #tax
* propertyGroup[0].priceComponent[1].factor = 0.19
* propertyGroup[0].priceComponent[1].amount.value = 23.95
* propertyGroup[0].priceComponent[1].amount.currency = #EUR

// ============================================================
// Beispiel 3: Eigenlabor-Material — 7% ermaessigter Steuersatz (Kategorie AA)
// Dentaltechnisches Eigenlabormaterial — potentiell §12 Abs. 2 Nr. 2 UStG
// (Lieferung zahntechnischer Erzeugnisse durch den Zahnarzt selbst)
// ============================================================

Instance: example-cid-eigenlabor-material
InstanceOf: ChargeItemDefinition
Title: "ChargeItemDefinition — Eigenlabor-Material (7% USt, Kategorie AA)"
Description: "Dentaltechnisches Eigenlabormaterial (Zahnarztpraxis mit eigenem Labor). Lieferung zahntechnischer Erzeugnisse durch den Zahnarzt unterliegt dem ermaessigten Steuersatz 7% (§12 Abs. 2 Nr. 2 UStG, UNECE-5305 Kategorie AA). Tax-Extension auf propertyGroup.priceComponent als unverbindliche Vorbelegung. Finale Klassifikation liegt beim PVS/Steuerberater."
Usage: #example

* url = "https://fhir.cognovis.de/praxis/ChargeItemDefinition/eigenlabor-material-kunststoffverblendung"
* status = #active
* title = "Eigenlabor-Material — Kunststoffverblendung"
* description = "Zahntechnisches Eigenlabormaterial: Kunststoffverblendung (Frontzahnversorgung). Hergestellt und geliefert durch das praxiseigene Dentallabor. Ermaessigter Umsatzsteuersatz 7% nach §12 Abs. 2 Nr. 2 UStG."
* code.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-NullFlavor"
* code.coding[0].code = #OTH
* code.coding[0].display = "Other"
* code.text = "Kunststoffverblendung Eigenlabor"
// propertyGroup: Materialpreis 7% ermaessigter Steuersatz
* propertyGroup[0].priceComponent[0].type = #base
* propertyGroup[0].priceComponent[0].code.coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
* propertyGroup[0].priceComponent[0].code.coding[0].code = #BILLED
* propertyGroup[0].priceComponent[0].code.text = "Materialpreis netto"
* propertyGroup[0].priceComponent[0].amount.value = 93.46
* propertyGroup[0].priceComponent[0].amount.currency = #EUR
// Tax-Extension: Vorbelegung Steuerkategorie AA (7% ermaessigter Steuersatz)
* propertyGroup[0].priceComponent[0].extension[ext-tax-category].valueCodeableConcept = $UNECE5305#AA "Ermaessigter Steuersatz"
// Tax-Komponente: 7% auf Nettomaterialpreis
* propertyGroup[0].priceComponent[1].type = #tax
* propertyGroup[0].priceComponent[1].factor = 0.07
* propertyGroup[0].priceComponent[1].amount.value = 6.54
* propertyGroup[0].priceComponent[1].amount.currency = #EUR
