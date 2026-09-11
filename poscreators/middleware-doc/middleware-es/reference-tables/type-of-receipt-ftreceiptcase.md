---
slug: /poscreators/middleware-doc/spain/reference-tables/ftreceiptcase
title: 'Type of Receipt: ftReceiptCase'
---

# Type of Receipt: ftReceiptCase

The `ftReceiptCase` indicates the receipt type and defines how the fiskaltrust.SecurityMechanism should process it following Spanish law.

For Spain (ES), the country code is `0x4553`. Thus, the value of an unknown `ftReceiptCase` in Spain is `0x4553000000000000`.

## Format

_CCCC_vlll_gggg_txcc_

#### v - version
version 2

| **Value** | **Description** |
| --------- | --------------- |
| t | ReceiptCaseType |
| txcc | ReceiptCase |
| gggg | global tagging/flag |
| lll | local tagging/flag |

*Table 1. Structure of the ftReceiptCase value for Spain.*

#### t - ReceiptCaseType

| **Value** | **Category** | **Description** |
| --------- | ------------ | --------------- |
| `0` | Receipt | A basic receipt that is generated as part of a POS sale. A receipt usually serves as proof of payment. The receipt is used after the transaction is done (if goods are received). This is the usual process that is done at a POS. |
| `1` | Invoice | An invoice is generated for those cases where payment isn't handled immediately. |
| `2` | DailyOperations | This category contains receipt cases that the Middleware requires for various downstream processes (e.g. book keeping) |
| `3` | Log | Logs can be used for storing / securing events that are needed for additional processing or downstream processes. (e.g. log for cash drawer opened) |
| `4` | Lifecycle | These operations are used for changing the overall state of the Middleware. Depending on the local regulations these receipts are handed over as part of a notification (e.g. FinanzOnline) |

*Table 2. ReceiptCaseType categories (t) for Spain.*

#### txcc - ReceiptCase

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0000` | **Unknown type for country-code "ES"**<br />This receipt case is handled like a "pos-receipt" (`0001`). See below: | 1.3.45 |
| `0001` | **POS receipt**<br />Represents the main kind of receipt processed by a POS system. Creates a turnover and/or a change in the amount of cash in the till or similar operations.<br />Use the `ftChargeItems` and `ftPayItems` to hand over details about goods, services and payments for processing. The `ftChargeItems` and `ftPayItems` should contain the full final state of the receipt.<br />Issued as **simplified invoice** (*factura simplificada*): numbered in the simplified-invoice sequence of the queue, transmitted to the AEAT as *registro de alta* with `TipoFactura` `F2` or to the province as TicketBAI file with `FacturaSimplificada` = `S`. The request is validated against the Spanish rules before transmission (see [Boundaries](../declaration/declaration.md#boundaries)). | 1.3.45 |
| `0002` | **Payment transfer receipt type**<br />Stored in the queue without number, record or transmission; no fiscal effect in Spain. | 1.3.45 |
| `0003` | **Point-Of-Sale receipt without fiscalization**<br />Obligation or with exception on fiscalization regulation.<br />Stored in the queue without number, record or transmission. Use it only for documents that are not invoices. | 1.3.45 |
| `0004` | **E-Commerce receipt type**<br />Stored in the queue without number, record or transmission. | 1.3.45 |
| `0005` | **Delivery Note**<br />Stored in the queue without number, record or transmission (also `0006` Table check and `0007` Pro forma). Non-fiscal documents must not carry a TicketBAI code or an AEAT QR code. | 1.3.45 |
| `1000` | **Unknown invoice type**<br />Handled like `1001`. | 1.3.45 |
| `1001` | **B2C invoice type**<br />Issued as **complete invoice** (*factura*): numbered in the invoice sequence of the queue, transmitted to the province as TicketBAI file with `FacturaSimplificada` = `N` and the recipient from `cbCustomer`, or to the AEAT as *registro de alta* (currently `TipoFactura` `F2` without recipient data; the `F1` mapping is being completed). A `cbCustomer`, when provided, must carry name, street, postcode and, for Spanish customers, a NIF in a valid format. | 1.3.45 |
| `1002` | **B2B invoice type**<br />See `1001`. | 1.3.45 |
| `1003` | **B2G invoice type**<br />See `1001`. Transmission to the public sector (Facturae / FACe) is not part of the current scope. | 1.3.45 |
| `2000` | **Zero Receipt**<br />Used for communication test and functional test of the fiskaltrust.SecurityMechanism. The request is only valid when the charge items block (ftChargeItems) and the pay items block (ftPayItems) in the ftReceiptRequest are empty arrays.<br />In Spain the zero receipt and all closing receipts (`2001` to `2013`) are accepted as no-ops; no record is created or transmitted. | 1.3.45 |
| `2001` | **(reserved) One Receipt** | 1.3.45 |
| `2010` | **Shift Closing Receipt** | 1.3.45 |
| `2011` | **Daily Closing Receipt** | 1.3.45 |
| `2012` | **Monthly Closing Receipt** | 1.3.45 |
| `2013` | **Yearly Closing Receipt** | 1.3.45 |
| `3000` | **Protocol (unspecified type)**<br />Stored in the queue, no transmission (also `3001` to `3005`). | 1.3.45 |
| `3001` | **Protocol (technical event)** | 1.3.45 |
| `3002` | **Protocol (audit event / accounting event)** | 1.3.45 |
| `3003` | **Internal usage / Material consumption** | 1.3.45 |
| `3004` | **Order** | 1.3.45 |
| `3010` | **Copy Receipt / Print existing Receipt**<br />Stored in the queue, no transmission. Reprint the original signature items and mark the print as a copy. | 1.3.45 |
| `4001` | **Queue-Start-Receipt (Initial operations receipt)**<br />Activates the queue and creates its two numbering sequences (simplified invoices and invoices). Recorded as start event in the action journal. | 1.3.45 |
| `4002` | **Queue-Stop-Receipt (Out of operations receipt)**<br />Deactivates the queue; recorded as stop event. | 1.3.45 |
| `4011` | **Initiate SCU-switch**<br />Accepted as no-op in Spain (also `4012`). | 1.3.45 |
| `4012` | **Finish SCU-switch** | 1.3.45 |

*Table 3. ReceiptCase values (txcc) for Spain.*

See [Declaration and Registration](../declaration/declaration.md#supported-document-types) for the complete mapping to VERI\*FACTU records and TicketBAI files and the [boundaries](../declaration/declaration.md#boundaries) of the implementation.

#### gggg - global tagging/flag

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | **Process as Late Signing Receipt**<br />The cash register lost connection to the queue and processed receipts without communicating with the queue. All processed receipts marked with the hint “Security mechanism not reachable” need to be sent to the queue with this marker.<br />In Spain the flag has no market-specific processing yet; the record is numbered and transmitted like a regular record. See [Offline handling](../go-to-market/go-to-market.md#key-factors-for-the-spanish-market). | 1.3.45 |
| `0002` | **Training Receipt**<br />Training mode is not supported in Spain. | 1.3.45 |
| `0004` | **IsVoid**<br />Marks Receipt as Void to previous one. Mark lineitems also as IsVoid to signal clear data.<br />In Spain the void requires exactly one `cbPreviousReceiptReference` and must repeat the original lines exactly; only one void per document. On VERI\*FACTU queues a *registro de anulación* is transmitted to the AEAT; on TicketBAI queues the cancellation file is not yet available. | 1.3.45 |
| `0008` | **Process as Handwritten Receipt**<br />During a power outage, the Cash register will not work, and the merchant hands out handwritten receipts. These handwritten receipts need to be sent to the Security Mechanism by using this flag.<br />In Spain the flag has no market-specific processing yet. | 1.3.45 |
| `0010` | **IssuerIsSmallBusiness**<br />Businesses below a country-specific size in revenue need not declare VAT.<br />With this marker, the receipt shows no VAT, all prices are gross, and a country-specific hint must be printed. | 1.3.45 |
| `0020` | **ReceiverIsBusiness**<br />Specific data need to be placed onto the receipt. | 1.3.45 |
| `0040` | **ReceiverIsKnown**<br />Characteristics related to VAT taxes are given. For example, Name, Address, VAT-ID, other local info. | 1.3.45 |
| `0080` | **IsSaleInForeignCountry** | 1.3.45 |
| `0100` | **IsReturn/IsRefund**<br />Marks Receipt as Return of good or service.<br />In Spain the refund requires exactly one `cbPreviousReceiptReference` to the original document and is transmitted as a new record with negative amounts in the sequence of the receipt case. Partial refunds mark the returned lines with the charge-item refund flag. Corrective invoice types (`R1` to `R5`) are not emitted yet. | 1.3.45 |
| `0800` | **Group by Position-Number / 100**<br />100 = first position, 101 first subitem, 102 second subitem.<br />The sum of all chargeitems within a position must count toward the total receipt amount.<br />If the quantity and amount are 0,00, the quantity and amount will not be visualized for this line on the digital receipt. Independent if main or subitem. | 1.3.45 |
| `8000` | **ReceiptRequest**<br />If you don’t receive a response, try this flag first before taking any other action.<br />This will return a stored result for example in case of a timeout when cashregister calls queue. | 1.3.45 |

*Table 4. Global tagging/flag values (gggg) for Spain.*

#### lll - local tagging/flag

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| TBD | TBD | TBD |

*Table 5. Local tagging/flag values (lll) for Spain.*