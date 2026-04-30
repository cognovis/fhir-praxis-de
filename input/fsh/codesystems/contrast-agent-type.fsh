// ContrastAgentTypeCS — Local DE CodeSystem for approved contrast agents
// Used in imaging workflows to specify contrast medium type.
// External coding properties:
//   atc-code:        WHO ATC classification (L01/V08 range)
//   dicom-cid12-code: DICOM CID 12 (Contrast/Bolus Agent codes)
//   goae-code:       GOÄ billing code for contrast administration
//   pzn-code:        Pharmazentralnummer (IFA PZN) — product-specific; populate per batch

CodeSystem: ContrastAgentTypeCS
Id: contrast-agent-type
Title: "Contrast Agent Type"
Description: "Local DE CodeSystem for radiological contrast agents approved in Germany. Includes external coding properties for ATC classification, DICOM CID 12 mapping, GOÄ billing codes, and PZN (Pharmazentralnummer) for ATC/PZN external reference (AK2)."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/contrast-agent-type"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

// External coding property declarations
* ^property[0].code = #atc-code
* ^property[0].uri = "http://www.whocc.no/atc"
* ^property[0].description = "WHO ATC classification code for the contrast agent"
* ^property[0].type = #string

* ^property[1].code = #dicom-cid12-code
* ^property[1].uri = "http://dicom.nema.org/resources/ontology/DCM"
* ^property[1].description = "DICOM CID 12 Contrast/Bolus Agent code"
* ^property[1].type = #string

* ^property[2].code = #goae-code
* ^property[2].uri = "https://fhir.de/CodeSystem/bak/goae"
* ^property[2].description = "GOÄ billing code for contrast agent administration"
* ^property[2].type = #string

// PZN property — Pharmazentralnummer per IFA (http://fhir.de/CodeSystem/ifa/pzn)
// PZN values are product-specific; populate per batch
* ^property[3].code = #pzn-code
* ^property[3].uri = "http://fhir.de/CodeSystem/ifa/pzn"
* ^property[3].description = "Pharmazentralnummer (PZN) per IFA — product-specific identifier for contrast agent preparations approved in Germany"
* ^property[3].type = #string

// Iodinated contrast agents (CT / conventional X-ray)
* #iodinated-low-osmolar "Low-osmolar Iodinated Contrast" "Niederosmolares iodhaltiges Kontrastmittel (LOCM) fuer CT/Roentgen"
  * ^property[0].code = #atc-code
  * ^property[0].valueString = "V08AA"
  * ^property[1].code = #dicom-cid12-code
  * ^property[1].valueString = "127508"
  * ^property[2].code = #goae-code
  * ^property[2].valueString = "345"

* #iodinated-iso-osmolar "Iso-osmolar Iodinated Contrast" "Isoosmolares iodhaltiges Kontrastmittel fuer CT"
  * ^property[0].code = #atc-code
  * ^property[0].valueString = "V08AB"
  * ^property[1].code = #dicom-cid12-code
  * ^property[1].valueString = "127508"
  * ^property[2].code = #goae-code
  * ^property[2].valueString = "345"

// Gadolinium-based contrast agents (MRI)
* #gadolinium-extracellular "Extracellular Gadolinium Contrast" "Extrazellulaeres Gadolinium-Kontrastmittel fuer MRT"
  * ^property[0].code = #atc-code
  * ^property[0].valueString = "V08CA"
  * ^property[1].code = #dicom-cid12-code
  * ^property[1].valueString = "127504"
  * ^property[2].code = #goae-code
  * ^property[2].valueString = "5730"

* #gadolinium-hepatobiliary "Hepatobiliary Gadolinium Contrast" "Hepatobiliaeres Gadolinium-Kontrastmittel fuer Leber-MRT"
  * ^property[0].code = #atc-code
  * ^property[0].valueString = "V08CA"
  * ^property[1].code = #dicom-cid12-code
  * ^property[1].valueString = "127504"
  * ^property[2].code = #goae-code
  * ^property[2].valueString = "5730"

// Ultrasound contrast agents (CEUS)
* #ultrasound-microbubble "Microbubble Ultrasound Contrast" "Mikroblaeschen-Kontrastmittel fuer Kontrastmittelsonographie (CEUS)"
  * ^property[0].code = #atc-code
  * ^property[0].valueString = "V08DA"
  * ^property[1].code = #dicom-cid12-code
  * ^property[1].valueString = "127502"
  * ^property[2].code = #goae-code
  * ^property[2].valueString = "420"

// Barium sulfate (GI fluoroscopy)
* #barium-sulfate "Barium Sulfate" "Bariumsulfat fuer gastrointestinale Roentgenuntersuchungen"
  * ^property[0].code = #atc-code
  * ^property[0].valueString = "V08BA"
  * ^property[1].code = #dicom-cid12-code
  * ^property[1].valueString = "127510"
  * ^property[2].code = #goae-code
  * ^property[2].valueString = "344"
