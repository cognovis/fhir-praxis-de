// PraxisContractDE — typed contract for PVS billing regime resolution.

Profile: PraxisContractDE
Parent: Contract
Id: praxis-contract
Title: "Praxis Contract DE"
Description: "Typed contract for PVS billing regimes. type.coding.code drives Coverage→Contract resolution. Select the right Contract by matching Contract.type to the patient's billing regime."
* ^status = #active
* ^experimental = false
* ^publisher = "cognovis GmbH"

// --- Contract status and identifiers ---
* status 1..1 MS
* identifier MS

// --- Billing regime discriminator ---
* type 1..1 MS
* type from PvsRegimeTypeVS (required)

// --- Resolution targets ---
* subject MS
* subject only Reference(Coverage or Patient)
