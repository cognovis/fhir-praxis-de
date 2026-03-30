Extension: AiGeneratedExt
Id: ai-generated
Title: "KI-generiert"
Description: "Kennzeichen ob Inhalt durch ein KI-System erzeugt wurde"
Context: Provenance
* value[x] only boolean

Extension: AiProviderExt
Id: ai-provider
Title: "KI-Anbieter"
Description: "Name des KI-Anbieters/Herstellers"
Context: Provenance
* value[x] only string

Extension: AiModelExt
Id: ai-model
Title: "KI-Modell"
Description: "Bezeichner des verwendeten KI-Modells"
Context: Provenance
* value[x] only string

Extension: AiTimestampExt
Id: ai-timestamp
Title: "KI-Erzeugungszeitpunkt"
Description: "Zeitstempel der KI-Erzeugung"
Context: Provenance
* value[x] only dateTime

Extension: AiPurposeExt
Id: ai-purpose
Title: "KI-Verwendungszweck"
Description: "Zweck der KI-Nutzung"
Context: Provenance
* value[x] only string

Extension: HumanReviewedExt
Id: human-reviewed
Title: "Menschlich geprueft"
Description: "Kennzeichen ob eine menschliche Pruefung erfolgt ist"
Context: Provenance
* value[x] only boolean

Extension: HumanReviewerExt
Id: human-reviewer
Title: "Pruefender Arzt"
Description: "Referenz auf den pruefenden Arzt"
Context: Provenance
* value[x] only Reference(Practitioner)

Extension: HumanReviewTimestampExt
Id: human-review-timestamp
Title: "Pruefungszeitpunkt"
Description: "Zeitstempel der menschlichen Pruefung"
Context: Provenance
* value[x] only dateTime
