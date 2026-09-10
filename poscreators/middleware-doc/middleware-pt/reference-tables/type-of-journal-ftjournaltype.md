---
slug: /poscreators/middleware-doc/portugal/reference-tables/ftjournaltype
title: 'Type of Journal: ftJournalType'
---

# Type of Journal: ftJournalType

This table expands on the values provided in the [Type of Journal: ftJournalType](../../general/reference-tables/reference-tables.md#type-of-journal-ftjournaltype) reference table of the Compliance Middleware with values applicable to the Portuguese market.

| **Value** | **Description** | **Version** |
| --------- | --------------- | ----------- |
| `001` | **SAF-T (PT) export**<br />Full value `0x5054_2000_0000_0001` (decimal `5788286605450018817`). Returns the SAF-T (PT) audit file in structure 1.04_01 (*Portaria n.º 302/2016*) as XML encoded in Windows-1252, containing the header with certificate number and product identification, the master files (customers, products, tax table), and all documents of the queue: `SalesInvoices` (FS, FT, NC), `WorkingDocuments` (PF, OR, CM), and `Payments` (RG), including voided documents with status `A`.<br /><br />`From`: lower bound of the queue-item timestamp in UTC ticks, inclusive; `0` exports everything. `To`: `0` exports all items from `From` onwards; a negative value `-n` limits the export to the last `n` documents. | 1.3.83 |

*Table 1. Portugal-specific ftJournalType values.*

:::note

Every journal request whose `ftJournalType` carries the Portuguese country code `0x5054` is handled by the Portuguese journal processor and returns the SAF-T (PT) export, independent of the case value. Use the value above. The common journal types of the General Part (action journal, receipt journal, queue items, configuration) remain available without the country code.

:::

The export is the file the merchant submits to the AT. See [Certification](../certification/certification.md#what-has-been-certified) for its role in the certified program and [What this means for PosOperators](../certification/certification.md#what-this-means-for-posoperators) for the submission obligation.
