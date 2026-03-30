Extension: KvBenchmarkKvRegionExt
Id: kv-benchmark-kv-region
Title: "KV-Benchmark KV-Region"
Description: "KV-Regionskennzeichen fuer Benchmark-Daten"
Context: Basic
* value[x] only string

Extension: KvBenchmarkFachgruppeExt
Id: kv-benchmark-fachgruppe
Title: "KV-Benchmark Fachgruppe"
Description: "Fachgruppenbezeichnung fuer Benchmark-Daten"
Context: Basic
* value[x] only string

Extension: KvBenchmarkFachgruppeCodeExt
Id: kv-benchmark-fachgruppe-code
Title: "KV-Benchmark Fachgruppe Code"
Description: "Fachgruppencode fuer Benchmark-Daten"
Context: Basic
* value[x] only string

Extension: KvBenchmarkGueltigJahrExt
Id: kv-benchmark-gueltig-jahr
Title: "KV-Benchmark Gueltigkeitsjahr"
Description: "Jahr der Gueltigkeit der Benchmark-Daten"
Context: Basic
* value[x] only integer

Extension: KvBenchmarkRlvFallwertAk1Ext
Id: kv-benchmark-rlv-fallwert-ak1
Title: "KV-Benchmark RLV-Fallwert Altersklasse 1"
Description: "RLV-Fallwert Altersklasse 1 (bis 5. Lebensjahr)"
Context: Basic
* value[x] only decimal

Extension: KvBenchmarkRlvFallwertAk2Ext
Id: kv-benchmark-rlv-fallwert-ak2
Title: "KV-Benchmark RLV-Fallwert Altersklasse 2"
Description: "RLV-Fallwert Altersklasse 2 (6.-59. Lebensjahr)"
Context: Basic
* value[x] only decimal

Extension: KvBenchmarkRlvFallwertAk3Ext
Id: kv-benchmark-rlv-fallwert-ak3
Title: "KV-Benchmark RLV-Fallwert Altersklasse 3"
Description: "RLV-Fallwert Altersklasse 3 (ab 60. Lebensjahr)"
Context: Basic
* value[x] only decimal

Extension: KvBenchmarkDurchschnittFallzahlExt
Id: kv-benchmark-durchschnitt-fallzahl
Title: "KV-Benchmark Durchschnittliche Fallzahl"
Description: "Durchschnittliche Fallzahl pro Arzt pro Quartal"
Context: Basic
* value[x] only decimal

Extension: KvBenchmarkAuszahlungsquoteExt
Id: kv-benchmark-auszahlungsquote
Title: "KV-Benchmark Auszahlungsquote"
Description: "Auszahlungsquote in Prozent"
Context: Basic
* value[x] only decimal

Extension: KvBenchmarkHonorarJeFallExt
Id: kv-benchmark-honorar-je-fall
Title: "KV-Benchmark Honorar je Fall"
Description: "Honorar pro Fall in EUR"
Context: Basic
* value[x] only decimal

Extension: KvBenchmarkQzvBereicheExt
Id: kv-benchmark-qzv-bereiche
Title: "KV-Benchmark QZV-Bereiche"
Description: "QZV-Leistungsbereiche mit Fallwerten, Format: name:fallwert,name:fallwert"
Context: Basic
* value[x] only string

Extension: KvBenchmarkQzvGopsExt
Id: kvbm-qzv-gops
Title: "KV-Benchmark QZV-GOP-Zuordnung"
Description: "Zuordnung von QZV-Bereichen zu EBM-Gebührenordnungspositionen (GOPs). Format: Bereichsname:gop1,gop2|Bereichsname:gop3,gop4"
Context: Basic
* value[x] only string
