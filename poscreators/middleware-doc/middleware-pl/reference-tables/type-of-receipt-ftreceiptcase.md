---
slug: /poscreators/middleware-doc/poland/reference-tables/ftreceiptcase
title: 'Type of Receipt: ftReceiptCase'
---

# Type of Receipt: ftReceiptCase

The `ftReceiptCase` indicates the receipt type and defines how the fiskaltrust.SecurityMechanism should process it following Polish law.

For Poland (PL), the country code is `0x504C`. Thus, the value of an unknown `ftReceiptCase` in Poland is `0x504C000000000000`.

:::info Preview

Support for the Polish market is currently in preview; the Middleware Version columns will be filled with the first general-availability release.

:::

## Format

_CCCC_vlll_gggg_txcc_ 

#### v - version
version 2

| **Value** | **Description**  |
| --------- |----------------- |
| t | ReceiptCaseType |
| txcc | ReceiptCase |
| gggg | global tagging/flag |
| lll | local tagging/flag |

#### t - ReceiptCaseType

| **Value** | **Category** | **Description** |
| --------- | ------------ | --------------- |
| `0` | Receipt | A basic receipt that is generated as part of a POS sale. A receipt usually serves as proof of payment. The receipt is used after the transaction is done (if goods are received). This is the usual process that is done at a POS. |
| `1` | Invoice | An invoice is generated for those cases where payment isn't handled immediately. In Poland invoices are fiscalized via KSeF, not via the cash register. |
| `2` | DailyOperations | This category contains receipt cases that the Middleware requires for various downstream processes. (e.g. book keeping) |
| `3` | Log | Logs can be used for storing / securing events that are needed for additional processing or downstream processes. (e.g. log for cash drawer opened)  |
| `4` | Lifecycle | These operations are used for changing the overall state of the Middleware. |

#### txcc - ReceiptCase

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0000` | **Unknown type for country-code "PL"**<br />This receipt case is handled like a "pos-receipt" (`0001`). See below: | preview |
| `0001` | **POS receipt**<br />Represents the main kind of receipt processed by a POS system. Creates a turnover and/or a change in the amount of cash in the till or similar operations. <br />Use the `ftChargeItems` and `ftPayItems` to hand over details about goods, services and payments for processing. The `ftChargeItems` and `ftPayItems` should contain the full final state of the receipt.<br />In Poland this case is sent to the certified register, which assigns the fiscal document number and reports to the CRK. | preview |
| `0002` | **Payment transfer receipt type**<br />Recorded by the queue; not sent to the register. | preview |
| `0003` | **Point-Of-Sale receipt without fiscalization**<br />Obligation or with exception on fiscalization regulation. Recorded by the queue; not sent to the register. | preview |
| `0004` | **E-Commerce receipt type**<br />Sent to the certified register like a POS receipt. | preview |
| `0005` | **Delivery Note**<br />Not supported for the Polish market; the request is rejected. | preview |
| `1000` | **Unknown invoice type**<br />Persisted and marked *"Stored, not fiscalized"*; fiscalized via KSeF once a KSeF SCU is configured. | preview |
| `1001` | **B2C invoice type**<br />See `1000`. | preview |
| `1002` | **B2B invoice type**<br />See `1000`. | preview |
| `1003` | **B2G invoice type**<br />See `1000`. | preview |
| `2000` | **Zero Receipt**<br />Used for communication test and functional test of the fiskaltrust.SecurityMechanism. The request is only valid when the charge items block (ftChargeItems) and the pay items block (ftPayItems) in the ftReceiptRequest are empty arrays.<br />In Poland the zero receipt reads the register status through the SCU. | preview |
| `2001` | **(reserved) One Receipt** | preview |
| `2010` | **Shift Closing Receipt**<br />Recorded by the queue; not sent to the register. | preview |
| `2011` | **Daily Closing Receipt**<br />Triggers the legally required daily (Z) report (raport dobowy) on the register. | preview |
| `2012` | **Monthly Closing Receipt**<br />Triggers the periodic report on the register. | preview |
| `2013` | **Yearly Closing Receipt**<br />Triggers the periodic report on the register. | preview |
| `3000` | **Protocol (unspecified type)** | preview |
| `3001` | **Protocol (technical event)** | preview |
| `3002` | **Protocol (audit event / accounting event)** | preview |
| `3003` | **Internal usage / Material consumption** | preview |
| `3004` | **Order** | preview |
| `3010` | **Copy Receipt / Print existing Receipt** | preview |
| `4001` | **Queue-Start-Receipt (Initial operations receipt)**<br />Registers the queue and verifies that the connected register reports itself as fiscalized. Fiscalizing the register itself is a certified-technician (serwis) act. | preview |
| `4002` | **Queue-Stop-Receipt (Out of operations receipt)** | preview |
| `4011` | **Initiate SCU-switch** | preview |
| `4012` | **Finish SCU-switch** | preview |

#### gggg - global tagging/flag 

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | **Process as Late Signing Receipt**<br />The cash register lost connection to the queue and processed receipts without communicating with the queue. All processed receipts marked with the hint “Security mechanism not reachable” need to be sent to the queue with this marker.<br />Note for Poland: under Art. 111(3) VAT Act, sales must not continue without a working register. | preview |
| `0002` | **Training Receipt** | preview |
| `0004` | **IsVoid**<br />Marks Receipt as Void to previous one. Mark lineitems also as IsVoid to signal clear data. | preview |
| `0008` | **Process as Handwritten Receipt**<br />During a power outage, the Cash register will not work, and the merchant hands out handwritten receipts. These handwritten receipts need to be sent to the Security Mechanism by using this flag. | preview |
| `0010` | **IssuerIsSmallBusiness**<br />Businesses below a country-specific size in revenue need not declare VAT.<br />With this marker, the receipt shows no VAT, all prices are gross, and a country-specific hint must be printed. | preview |
| `0020` | **ReceiverIsBusiness**<br />Specific data need to be placed onto the receipt.<br />In Poland this marks a paragon z NIP: the buyer's NIP must be handed over as `CustomerVATId` in `cbCustomer`, otherwise the request is rejected. | preview |
| `0040` | **ReceiverIsKnown**<br />Characteristics related to VAT taxes are given. For example, Name, Address, VAT-ID, other local info. | preview |
| `0080` | **IsSaleInForeignCountry**<br /> | preview |
| `0100` | **IsReturn/IsRefund**<br />Marks Receipt as Return of good or service.<br />In Poland a return must be its own document referencing the original receipt via `cbPreviousReceiptReference`; mixing sale and return positions in one document is rejected. | preview |
| `0800` | **Group by Position-Number / 100**<br />100 = first position, 101 first subitem, 102 second subitem.<br />The sum of all chargeitems within a position must count toward the total receipt amount.<br />If the quantity and amount are 0,00, the quantity and amount will not be visualized for this line on the digital receipt. Independent if main or subitem. | preview |
| `8000` | **ReceiptRequest**<br />If you don’t receive a response, try this flag first before taking any other action.<br />This will return a stored result for example in case of a timeout when cashregister calls queue. | preview |

#### lll - local tagging/flag 

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| TBD | TBD | TBD |
