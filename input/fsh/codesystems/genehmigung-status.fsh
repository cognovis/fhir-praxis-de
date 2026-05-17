CodeSystem: GenehmigungenStatusCS
Id: genehmigung-status
Title: "Genehmigung Status"
Description: "Lifecycle status of a KV approval entry"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #active "Active" "Approval is currently valid"
* #expired "Expired" "Approval has passed its Ablaufdatum"
* #revoked "Revoked" "Approval was withdrawn by the KV (entzogen)"
