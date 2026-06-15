Extension: PoPPTokenAnchorExt
Id: popp-token-anchor
Title: "PoPP Token Anchor"
Description: "Stub identifier anchor for a patient presence proof token associated with an Encounter check-in."
Context: Encounter
* . ^comment = "Adapter boundary: this extension records only a local PoPP token anchor. Cryptographic PoPP token validation is deferred until TI connector availability and must be implemented by the future adapter."
* value[x] only Identifier
* valueIdentifier.system 1..1
* valueIdentifier.system = "https://fhir.cognovis.de/praxis/NamingSystem/popp-token-id" (exactly)
* valueIdentifier.value 1..1
* valueIdentifier ^short = "Local PoPP token identifier anchor"
* valueIdentifier ^comment = "The identifier value must not be interpreted as proof of presence until the adapter validates the token against the productive PoPP service."
