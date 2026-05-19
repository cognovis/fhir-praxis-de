CodeSystem: HvgVertragCS
Id: hvg-vertrag
Title: "HVG-Vertrag"
Description: "Codes for selective care contract identifiers used in x.pvs (HVGVertrag.VertragsID slugs). Each code represents a specific contract variant. Slug derivation: VertragsID.toLowerCase().replace(/_/g, '-'). Source: adapter-7ihe, hvg_vertrag_to_episode_metadata.yaml (24 contracts with non-empty VertragsID; ~67 additional entries pending re-query before v2-cutover 2026-06-22)."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/hvg-vertrag"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true

// Bayern HzV cluster
* #aok-by-hzv "AOK Bayern / HAEVG - HzV" "AOK Bayern / HAEVG - HzV (§73b SGB V)"
* #ek-by-hzv "EK Bayern / HAEVG - HzV" "EK Bayern / HAEVG - HzV (§73b SGB V)"
* #aok-by-hzv-s12 "HzV AOK Bayern Schiedsspruch 12" "HzV AOK Bayern Schiedsspruch 12 (HAEVG)"
* #ek-by-hzv-s12 "HzV EK Bayern Schiedsspruch 12" "HzV EK Bayern Schiedsspruch 12 (HAEVG)"

// NRW HzV cluster
* #aok-no-hzv "HzV AOK Nordrhein" "HzV AOK Nordrhein (HAEVG)"
* #aok-wl-hzv "HzV AOK Westfalen-Lippe" "HzV AOK Westfalen-Lippe (HAEVG)"
* #bkk-no-hzv "HzV GWQ Hausarzt+ Nordrhein" "HzV GWQ Hausarzt+ NO (HAEVG)"
* #bkk-wl-hzv "HzV GWQ Hausarzt+ Westfalen-Lippe" "HzV GWQ Hausarzt+ WL (HAEVG)"
* #ek-no-hzv "HzV EK Nordrhein" "HzV EK Nordrhein (HAEVG)"
* #ek-wl-hzv "HzV EK Westfalen-Lippe" "HzV EK Westfalen-Lippe (HAEVG)"
* #ikk-no-hzv "HzV IKK Nordrhein" "HzV IKK Nordrhein (HAEVG)"

// IKK / RV / LKK / Gartenbau Bayern
* #ikk-cl-by-hzv "IKK Classic Bayern HzV" "IKK Classic Bayern / HAEVG - HzV (§73b SGB V)"
* #ikk-gplus-by-hzv "IKK Gesund Plus Bayern HzV" "IKK Gesund Plus Bayern / HAEVG - HzV (§73b SGB V)"
* #kk-gb-by-hzv "KK Gartenbau Bayern HzV" "Krankenkasse fuer den Gartenbau Bayern / HAEVG - HzV (§73b SGB V)"
* #rv-kbs-by-hzv "RV KBS Bayern HzV" "RV Knappschaft Bahn-See Bayern / HAEVG - HzV (§73b SGB V)"
* #kk-gb-hzv "KK Gartenbau HzV" "Krankenkasse fuer den Gartenbau / HAEVG - HzV (§73b SGB V)"

// FaV Baden-Wuerttemberg (Facharztvertrag=true)
* #aok-fa-gastro-bw "FaV Gastro AOK BW" "FaV Gastro AOK Baden-Wuerttemberg (MEDIVERBUND)"
* #aok-fa-nppp-bw "FaV PNP AOK BW" "FaV PNP AOK Baden-Wuerttemberg (MEDIVERBUND)"
* #bkk-bosch-fa-bw "FaV PNP BKK Bosch BW" "FaV PNP BKK Bosch Baden-Wuerttemberg (MEDIVERBUND)"
* #bkk-fa-kardio-bw "FaV Kardio BKK Bosch BW" "FaV Kardio BKK Bosch Baden-Wuerttemberg (MEDIVERBUND)"
* #bkk-fa-gastro-bw "FaV Gastro BKK Bosch BW" "FaV Gastro BKK Bosch Baden-Wuerttemberg (MEDIVERBUND)"

// IV / Pflegeheime / Sondersituationen BW
* #aok-bw-iv-p "IV Pflegeheim AOK BW" "IV Pflegeheim AOK BW / HAEVG / MEDI - HzV (§140a SGB V)"
* #lkk-bw-hzv "LKK Baden-Wuerttemberg HzV" "LKK Baden-Wuerttemberg / HAEVG - HzV (§73b SGB V)"

// KV-Sondervertrag
* #kv-ikk-gp-san "KV IKK gp Sachsen-Anhalt" "KV IKK gp Sachsen-Anhalt"
