// nursing-home-residency.fsh
// EpisodeOfCare profile for patient residency in a nursing home.

Profile: PraxisNursingHomeResidencyDE
Parent: EpisodeOfCare
Id: praxis-nursing-home-residency-de
Title: "Praxis Nursing Home Residency DE"
Description: "Standing fact that a patient resides in a nursing home (Pflegeheim). An active residency drives ambulatory billing code selection for home visits (Hausbesuch): nursing-home-specific EBM codes and Mitbesuch rules apply when the patient is an active resident. Physical placement (facility -> ward -> room) is expressed through gematik ISiK Location profiles (ISiKStandort / ISiKStandortRaum) and their partOf hierarchy, not through free-text fields. EpisodeOfCare has no native location element, so the Location is carried by the nursingHomeLocation extension."

* patient 1..1 MS
* status 1..1 MS
* period 0..1 MS
* managingOrganization 0..1 MS
* managingOrganization ^short = "Operator of the nursing home, if recorded"

* extension contains
    NursingHomeLocationExt named nursingHomeLocation 1..1 MS
* extension[nursingHomeLocation] ^short = "Reference to the patient's place within the nursing home"
* extension[nursingHomeLocation] ^definition = "Canonical link from the patient residency episode to the most-specific ISiK Location (ISiKStandortRaum when room is known, else the deepest ISiKStandort ward or facility node). Parent places resolve via Location.partOf and are not duplicated here."
