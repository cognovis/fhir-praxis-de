# German HL7 FHIR Ecosystem Research Summary

**Date of Research:** April 4, 2026  
**Focus:** HL7 Deutschland governance, key organizations, DMEA 2026, and strategic contacts for ambulatory practice management profiles

---

## 1. HL7 Deutschland Governance & De.basisprofil

### HL7 Deutschland Structure
- **Organization:** HL7 Deutschland e.V. (nonprofit association)
- **Scope:** One of ~40 national HL7 organizations worldwide
- **Headquarters:** Berlin (Rahel-Hirsch-Center) and Cologne (Mevissenstraße 16)
- **Website:** https://www.hl7.de/

### FHIR Technical Committee (TC FHIR)
**Leadership (through December 2026):**
- **Simone Heckmann** (Chair) — Simone.Heckmann@dmi.de
- **Alexander Zautke** (Vice Chair) — az@gefyra.de
- **Mareike Przysucha** (Vice Chair) — M.Przysucha@hs-osnabrueck.de

**TC FHIR Responsibilities:**
- Promotes FHIR standard adoption in German-speaking markets
- Ensures compliance with HL7 standards
- Creates German-language FHIR resources (profiles, ValueSets, implementation guides)
- Represents German interests in international standardization processes
- Organizes user meetings and educational events
- Evaluates infrastructure for publishing community profiles
- Organizes Connectathons for testing German profiles
- Evaluates translation of FHIR standards into German
- Provides a platform for experience/knowledge exchange

### De.basisprofil (German Base Profiles)
- **Governance:** Maintained through the Interoperabilitätsforum
- **Work discussed in:** Interoperabilitätsforum, TC FHIR, and related committees
- **Profile examples:** e-Arztbriefe, nursing information, pathology reports, discharge reports, FHIR base profiles
- **Process:** Collaborative effort across HL7 DE, IHE DE, bvitg, and DIN

---

## 2. The Interoperabilitätsforum (Interoperability Forum)

### What It Is
Established 2009. Cross-organizational meeting convened **4 times per year** (alternating locations, online/in-person).

### Founding Organizations
1. **HL7 Deutschland e.V.** (Technical Committees)
2. **IHE Deutschland** (Integrating Healthcare Enterprise)
3. **AG Interoperabilität & Standardisierung** (Bundesverband Gesundheits-IT bvitg e.V.) — formerly VHitG
4. **Fachbereich Medizinische Informatik** (German Institute for Standardization — DIN)

### Supporting Organizations
- Multiple universities
- BfArM (Bundesinstitut für Arzneimittel und Medizinprodukte)
- gematik

### Key Role
Eliminates duplicate efforts by bringing together stakeholders across organizations. Discusses:
- FHIR base profile development
- IHE integration profiles (XDS) — ambulatory and clinical sectors
- HL7 v2.x, CDA, and FHIR standards usage
- Legislative/market-driven interoperability questions

### Access
- **Website:** https://interoperabilitaetsforum.de/
- **Wiki portal:** http://wiki.hl7.de/ (shared documentation)
- **Newsletter:** https://cname.eu1.cleverreach.com/f/83172-200926/
- **Calendar:** Meeting dates posted on website
- **Contact:** https://interoperabilitaetsforum.de/ (contact form available)

---

## 3. Key Organizations & Their FHIR Roles

### HL7 Deutschland e.V.
- **Owns:** FHIR Technical Committee, liaison with international HL7 standards
- **Publishes:** German-language FHIR guides and base profiles
- **Leadership contact:** info@hl7.de, Tel. 0700 7777 6767
- **FHIR TC Newsletter:** https://newsletter.hl7.de/fl/f9dd0d69-6172-483f-b28e-90f7795646fc/

### KBV (Kassenärztliche Bundesvereinigung — Physicians' Association)
- **Scope:** Represents ambulatory physicians' interests at federal level (17 regional associations)
- **Current focus:** Digitalization initiatives, ePA (electronic patient records), EBM (billing), praxis management
- **DMEA 2026 participation:** Confirmed booth (Hall 1.2, Stand F-103) — April 21-23, 2026
- **Website:** https://www.kbv.de/
- **Sectors mentioned:** Ambulatory practices, digitization, PVS (practice management systems), eGK (electronic health card)
- **Note:** No explicit FHIR profiles found on KBV website — need to investigate further through direct contact or within IHE/Interop Forum discussions

### gematik (Nationale Agentur für Digitale Medizin)
**Role:** Operates German Telematic Infrastructure (TI); sets standards for digital health

**FHIR-related activities:**
- **INA (Interoperabilitätsnavigator):** https://www.ina.gematik.de/ — The national knowledge platform for standards/interoperability
- **Role as "Kompetenzzentrum für Interoperabilität im Gesundheitswesen" (KIG):** Ensures unified standards
- **Applications with FHIR potential:**
  - E-Rezept (e-prescription)
  - ePA für alle (electronic patient record for all)
  - KIM (Kommunikation im Medizinwesen — secure healthcare communication)
  - TI-Messenger
  - Notfalldaten (emergency data)
  - Elektronischer Medikationsplan (electronic medication plan)
  - Versichertenstammdaten-Management (insured person master data)

**DMEA 2026 participation:** Confirmed presence

**Key contacts:** 
- gematik GmbH, Rosenthaler Straße 30, 10178 Berlin
- Website: https://www.gematik.de/
- Fachportal: https://fachportal.gematik.de/

### IHE Deutschland
- Part of Interoperabilitätsforum governance
- Focuses on integration profiles (e.g., XDS for document exchange)
- Works with HL7 on cross-standard interoperability

### KZBV (Kassenzahnärztliche Bundesvereinigung — Dentists' Association)
- **Note:** No FHIR-specific mention found in research. May participate in Interop Forum.

### BÄK (Bundesärztekammer — German Medical Association)
- **Note:** No FHIR-specific mention found in research. Likely participant in broader governance structures.

### bvitg (Bundesverband Gesundheits-IT)
- **AG Interoperabilität & Standardisierung** — sits on Interop Forum council
- Website: https://www.bvitg.de/

---

## 4. ISiP (Informationstechnische Systeme in Praxen / IT Systems in Practices)

**Status:** Not explicitly documented in research results.

**What was found:**
- gematik focuses on TI (Telematic Infrastructure) standards and applications
- No specific "ISiP" initiative mentioned in official gematik documentation
- **Possible confusion:** ISiK (Informationstechnische Systeme im Krankenhaus) = hospital IT systems — well-documented on fachportal.gematik.de
- **Ambulatory focus:** gematik has a "Stabsstelle Versorgung" (Care/Provision Office) established Aug 2025, led by Dr. Johanna Ludwig, to integrate care perspectives into TI development

**Recommendation:** Direct inquiry to gematik or Interop Forum needed for clarification on ISiP status.

---

## 5. DMEA 2026

### Dates & Location
- **Dates:** April 21-23, 2026 (Berlin)
- **Venue:** Berliner Messehallen (Berlin Exhibition Halls)
- **Scale:** ~900 exhibitors, 20,500+ visitors, 470+ speakers
- **Status:** Nearly fully booked (only few spots left on DMEA sparks Careers track)

### Notable Exhibitors & Participants
- **KBV:** Hall 1.2, Stand F-103
- **gematik:** Official presence confirmed
- Multiple health IT vendors, pharmaceutical companies, and IT service providers

### Program Structure
- **Solutions Hub:** Innovation-focused
- **DMEA sparks:** Young professionals/startup track
- **DMEA nova Award:** Startup recognition
- **Networking:** DMEA Community on LinkedIn, YouTube, Instagram
- **Livestream:** Available online
- **Sessions:** Topics include digitalization, AI in healthcare, standards, interoperability

### Keynote Speakers (2026)
- Nina Warken (Federal Minister for Health)
- Nina Ruge (media personality)
- Philipp Westermeyer
- Prof. Dr. Kristina Sinemus
- Prof. Dr. David Matusiewicz
- Luis Teichmann

### HL7 DE Involvement
- **HL7 Deutschland workshops scheduled:**
  - FHIR Basis Workshop: Feb 2-4, 2026 (online)
  - FHIR Workshop (Reading/Creating/Publishing Specs): Feb 9-10, 2026 (online)
  - Note: These are pre-DMEA training events, not at DMEA itself
- **Likely presence at DMEA:** HL7 DE typically exhibits/participates at major German health IT conferences

### DMEA 2026 Website
- https://www.dmea.de/
- Full program: https://plus.dmea.de/program
- Ticket shop: Open now

### Networking Opportunities
- **DMEA Community:** On LinkedIn, YouTube, Instagram
- **DMEA sparks Careers:** Professional networking track
- **Industry mixers:** Typical at DMEA
- **Booth visits:** ~900 exhibitor booths

---

## 6. Key Contacts & Strategic Networking

### To Contact About De.basisprofil & FHIR Governance
1. **HL7 Deutschland TC FHIR:**
   - Simone Heckmann (Chair): Simone.Heckmann@dmi.de
   - Alexander Zautke (Vice Chair): az@gefyra.de
   - Mareike Przysucha (Vice Chair): M.Przysucha@hs-osnabrueck.de
   - General: info@hl7.de, Tel. 0700 7777 6767

2. **Interoperabilitätsforum Directly:**
   - Website contact form: https://interoperabilitaetsforum.de/
   - Newsletter: https://cname.eu1.cleverreach.com/f/83172-200926/

### To Contact About KBV & Ambulatory Profiles
- **KBV Main Office:** https://www.kbv.de/, Tel. listed in footer
- **KBV DMEA 2026 Booth:** Hall 1.2, Stand F-103 (direct contact on-site)
- Likely contacts via digitalization/ePA/praxis IT teams

### To Contact About gematik & ISiP/Standards
- **gematik Main:** https://www.gematik.de/, Rosenthaler Straße 30, 10178 Berlin
- **INA (Interoperability Navigator):** https://www.ina.gematik.de/ (portal, likely has contact info)
- **Fachportal:** https://fachportal.gematik.de/ (technical specifications)
- **Stabsstelle Versorgung (Care Office):** Dr. Johanna Ludwig — for ambulatory/provision perspective on TI development
- **gemmunity Forum:** https://www.gemmunity.de/community (technical community, active discussions)

### To Propose New Profiles for De.basisprofil
**Process:**
1. Engage with **Interoperabilitätsforum** via quarterly meetings
2. Work through **HL7 Deutschland TC FHIR** formal review channels
3. Coordinate with relevant sector organizations (KBV, IHE, bvitg)
4. Document use cases in **Interop Forum wiki:** http://wiki.hl7.de/
5. Propose through standard balloting process: https://hl7.de/technische-komitees/ballotierung/

---

## 7. Other Ecosystem Notes

### Gevko (Gematik-Kompressionsstelle)
- Manages **eGK** (electronic health card) and **VSDM** (insured person master data)
- Likely FHIR-aware for interoperability (Gevko data interchange with TI applications)
- Not explicitly found in research — need direct inquiry

### mio42 / MIO (Medizinische Informationsobjekte)
- **Current status unclear.** May have been absorbed into gematik or HL7 DE structures.
- MIO covers specific clinical domains (maternal records, dental records, etc.)
- Integration with FHIR base profiles ongoing through Interop Forum

### HL7 International Liaison
- HL7 Deutschland represents German interests in HL7 International ballot processes
- German profiles feed into international FHIR discussions

---

## 8. Recommendations for Ambulatory Practice Management Profile Strategy

### Near-term (Pre-DMEA 2026)
1. **Connect with HL7 Deutschland TC FHIR:**
   - Email TC leadership (Heckmann, Zautke, Przysucha)
   - Propose participation in next Interop Forum meeting
   - Discuss integration with de.basisprofil

2. **Engage Interoperabilitätsforum:**
   - Attend next quarterly meeting (dates at https://interoperabilitaetsforum.de/)
   - Present use cases for ambulatory practice profiles
   - Identify existing profiles that might be extended

3. **Research KBV FHIR Landscape:**
   - Direct inquiry to KBV about existing FHIR work (EBM coding, billing integration)
   - Schedule pre-DMEA call with their digitalization team

### DMEA 2026 (April 21-23)
1. **Visit KBV booth** (Hall 1.2, Stand F-103)
2. **Network with gematik** representatives on ISiP/ambulatory priorities
3. **Attend HL7 DE presentations** (if scheduled)
4. **Host booth or session** about ambulatory FHIR needs
5. **Schedule follow-up meetings** with key contacts

### Post-DMEA
1. Formalize profile proposals via Interop Forum
2. Initiate balloting process through HL7 DE
3. Coordinate with gematik/INA for integration with ISiK/ISiP roadmap

---

## 9. Key Resources & Links

### Official Sites
- **HL7 Deutschland:** https://www.hl7.de/
- **Interoperabilitätsforum:** https://interoperabilitaetsforum.de/
- **gematik:** https://www.gematik.de/
- **gematik Fachportal:** https://fachportal.gematik.de/
- **INA (Standards Navigator):** https://www.ina.gematik.de/
- **KBV:** https://www.kbv.de/
- **DMEA 2026:** https://www.dmea.de/

### Community & Knowledge Platforms
- **HL7 Wiki:** http://wiki.hl7.de/
- **gemmunity Forum:** https://www.gemmunity.de/community
- **HL7 Magazine:** https://magazin.hl7.de/
- **HL7 TV:** http://hl7.tv/

### Newsletters
- **HL7 Newsletter:** https://newsletter.hl7.de/fl/8e652376-6683-4ad0-8c7e-e79de9f7284a/
- **Interop Forum Newsletter:** https://cname.eu1.cleverreach.com/f/83172-200926/
- **FHIR Newsletter:** https://newsletter.hl7.de/fl/f9dd0d69-6172-483f-b28e-90f7795646fc/

---

## 10. Gaps & Follow-up Questions

1. **ISiP Status:** Clarify gematik's ISiP initiative for ambulatory settings
2. **KBV FHIR Work:** Direct contact needed to assess existing FHIR/MIO efforts
3. **KZBV & BÄK:** Confirm FHIR involvement or potential collaboration
4. **mio42 Status:** Clarify current organizational structure and FHIR integration
5. **Gevko/eGK:** Understand FHIR relevance and interoperability points
6. **Specific Contacts at gematik:** Identify key person for ambulatory/practice management initiatives

---

**Document Compiled:** April 4, 2026  
**Research Method:** Web research via official sites, newsletters, and published documentation
