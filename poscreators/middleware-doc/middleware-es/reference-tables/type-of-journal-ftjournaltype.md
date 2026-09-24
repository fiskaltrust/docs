---
slug: /poscreators/middleware-doc/spain/reference-tables/ftjournaltype
title: 'Type of Journal: ftJournalType'
---

# Type of Journal: ftJournalType

This table expands on the values provided in the [Type of Journal: ftJournalType](../../general/reference-tables/reference-tables.md#type-of-journal-ftjournaltype) reference table of the Compliance Middleware with values applicable to the Spanish market.

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `000` | Status Information QueueES | 1.3.45 |
| `001` | **VERI\*FACTU records export**<br />Full value `0x4553_2000_0000_0001`. Returns a JSON array with one entry per transmitted record, each containing the XML sent to the AEAT (`Request`), the XML answer of the AEAT (`Response`) and the schema version (`Version`).<br /><br />`From`: lower bound of the queue-item timestamp in UTC ticks, inclusive; `0` exports everything. `To`: `0` exports all items from `From` onwards; a negative value `-n` limits the export to the first `n` entries after `From`; a positive value is the upper bound. Any other Spanish journal type is rejected with `Unsupported journal type`. | 1.3.45 |

*Table 1. ftJournalType values applicable to the Spanish market.*
