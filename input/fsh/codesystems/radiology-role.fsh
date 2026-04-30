// RadiologyRoleCS — Radiology workflow roles for German ambulatory radiology
// No international FHIR CS covers these workflow-specific roles.
// Used in CareTeam, PractitionerRole, and Task resources for imaging workflows.

CodeSystem: RadiologyRoleCS
Id: radiology-role
Title: "Radiology Role"
Description: "Radiology workflow roles in German ambulatory radiology. Covers technical (MTR) and physician roles needed for imaging workflow tracking (acquisition, reading, supervision, sign-off)."
* ^url = "https://fhir.cognovis.de/praxis/CodeSystem/radiology-role"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #MTR "MTR" "Medizinisch-Technische Radiologieassistentin / Medizinisch-Technischer Radiologieassistent — performs image acquisition"
* #Radiologist "Radiologist" "Radiologin / Radiologe — general radiologist performing or supervising examinations"
* #ReadingRadiologist "Reading Radiologist" "Befundende Radiologin / Befundender Radiologe — responsible for interpreting images and dictating/signing reports"
* #SupervisingRadiologist "Supervising Radiologist" "Supervisierende Radiologin / Supervisierender Radiologe — provides oversight and final approval, e.g. for residents"
