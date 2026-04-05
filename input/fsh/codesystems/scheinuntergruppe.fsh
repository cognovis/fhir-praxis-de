// INTENTIONAL SYNTAX ERROR FOR RED PHASE — missing CodeSystem keyword
Id: kvdt-scheinuntergruppe
Title: "KVDT Scheinuntergruppe (KBV Schlüsseltabelle)"
Description: "KVDT-konforme Scheinuntergruppe-Codes gemäß KBV Schlüsseltabelle. Spiegelt KBV_CS_SFHIR_KBV_SCHEINART wider (OID 1.2.276.0.76.5.235)."
* ^url = "https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_KBV_SCHEINART"
* ^identifier.system = "urn:ietf:rfc:3986"
* ^identifier.value = "urn:oid:1.2.276.0.76.5.235"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #00 "Behandlungsausweis" "Primärfall, ambulant kurativ-Hausarzt"
* #01 "Überweisungsschein" "Kurativ-Arzt"
* #10 "Behandlungsschein für ambulante Behandlung" "Notfall"
* #21 "Überweisungsschein zur Mitbehandlung" "Kurativ-spezialärztlich"
* #22 "Überweisungsschein zur Konsiliaruntersuchung"
* #23 "Überweisungsschein zur Auftragsleistung"
* #24 "Überweisungsschein zur Weiterbehandlung"
* #25 "Überweisungsschein zur Mitbehandlung bei Schwangerschaft"
* #27 "Überweisungsschein Labor"
* #28 "Überweisungsschein Pathologie"
* #31 "Überweisungsschein zur belegärztlichen Behandlung" "Aufnahme"
* #32 "Belegärztliche Notaufnahme"
* #41 "Notfallschein"
