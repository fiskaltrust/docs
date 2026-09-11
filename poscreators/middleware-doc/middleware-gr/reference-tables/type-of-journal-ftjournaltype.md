---
slug: /poscreators/middleware-doc/greece/reference-tables/ftjournaltype
title: 'Type of Journal: ftJournalType'
---

# Type of Journal: ftJournalType

This table expands on the values provided in the [Type of Journal: ftJournalType](../../general/reference-tables/reference-tables.md#type-of-journal-ftjournaltype) reference table of the Compliance Middleware with values applicable to the Greek market.

| **Value** | **Description** | **Version** |
| --------- | --------------- |------------ |
| `000` | Status Information QueueGR | 1.3.45 |

*Table 1. ftJournalType values for the Greek market.*

No further Greek-specific journal case values are currently defined beyond status information.

The Greek journal processor does not yet produce a market-specific export: a request with the Greek journal type returns an empty XML document. The complete myDATA XML of every transmitted document is available in the `MyDataXML` signature item of the receipt response (see [Type of Signature: ftSignatureType](type-of-signature-ftsignaturetype.md)), and exports for tax audits are provided through the fiskaltrust.Portal. A dedicated journal export is being clarified with the Greek market team.
