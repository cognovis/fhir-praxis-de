// praxis-workplace-function.fsh
// Ambulatory workplace operational functions for Location.type (room/area granularity)
// Bead: fpde-b74

CodeSystem: PraxisWorkplaceFunctionCS
Id: praxis-workplace-function
Title: "Praxis Workplace Function"
Description: "PVS-agnostic operational workplace functions for ambulatory practice rooms and areas. Codes describe how a physical place is used in day-to-day practice operations. Distinct from Location.physicalType (shape), HealthcareService (offered service), Practitioner.qualification (who may perform), and live occupancy or queue state."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #reception-check-in "Reception / Check-in" "Patient arrival, registration, and front-desk check-in area"
* #waiting-area "Waiting Area" "Patient waiting space before consultation or procedure"
* #consultation-room "Consultation Room" "Examination and consultation room for ambulatory encounters"
* #treatment-procedure-room "Treatment / Procedure Room" "Room for minor procedures, wound care, or general treatment not covered by a specialty-specific code"
* #blood-draw "Blood Draw" "Phlebotomy / venipuncture workplace"
* #vaccination-injection "Vaccination / Injection" "Workplace for immunization and injection administration"
* #ecg-room "ECG Room" "Electrocardiography recording workplace"
* #ultrasound-room "Ultrasound Room" "Ultrasound examination workplace"
* #wound-care "Wound Care" "Dedicated wound care and dressing workplace"
* #specimen-lab-handling "Specimen / Lab Handling" "Specimen collection, labeling, and pre-analytic handling area (not a full external laboratory)"
* #imaging-radiology-room "Imaging / Radiology Room" "In-practice diagnostic imaging room (X-ray, CT suite within practice, etc.)"
* #dental-treatment-room "Dental Treatment Room" "Dental operatory or treatment room"
* #sterilization-utility "Sterilization / Utility" "Instrument reprocessing, supply, or utility room"
* #back-office "Back Office" "Administrative back-office workplace without direct patient care"
* #telehealth-virtual-workspace "Telehealth / Virtual Workspace" "Configured virtual care workspace (not a physical room); use when the Location represents a telehealth endpoint"
