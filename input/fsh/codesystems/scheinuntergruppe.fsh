CodeSystem: KvdtScheinuntergruppeCS
Id: kvdt-scheinuntergruppe
Title: "KVDT Scheinuntergruppe (KBV Schlüsseltabelle)"
Description: "KVDT-konforme Scheinuntergruppe-Codes gemäß KBV Schlüsseltabelle. Intentionaler lokaler Spiegel von KBV_CS_SFHIR_KBV_SCHEINART (OID 1.2.276.0.76.5.235): Die KBV-Canonical-URL wird bewusst als ^url verwendet, damit Codes systemkonform gegen das offizielle KBV-System validiert werden können."
* ^url = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* ^identifier.system = "urn:ietf:rfc:3986"
* ^identifier.value = "urn:oid:1.2.276.0.76.5.235"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #00 "Behandlungsausweis" "Primärfall, ambulant kurativ-Hausarzt"
* #01 "Überweisungsschein" "Kurativ-Arzt"
* #10 "Behandlungsschein ambulante Notfallbehandlung" "Notfall- oder Vertretungsfall"
* #21 "Überweisungsschein zur Mitbehandlung" "Kurativ-spezialärztlich"
* #22 "Überweisungsschein zur Konsiliaruntersuchung" "Konsiliaruntersuchung durch Facharzt"
* #23 "Überweisungsschein zur Auftragsleistung" "Laborauftrag oder Einzelleistungsauftrag"
* #24 "Überweisungsschein zur Weiterbehandlung" "Weiterbehandlung durch anderen Arzt"
* #25 "Überweisungsschein zur Mitbehandlung bei Schwangerschaft" "Schwangerschaftsbegleitende Mitbehandlung"
* #27 "Überweisungsschein Labor" "Laborüberweisung"
* #28 "Überweisungsschein Pathologie" "Pathologieüberweisung"
* #31 "Überweisungsschein zur belegärztlichen Behandlung" "Aufnahme zur stationären Behandlung"
* #32 "Belegärztliche Notaufnahme" "Notfallaufnahme durch Belegarzt"
* #41 "Notfallschein" "Ambulante Notfallbehandlung"
