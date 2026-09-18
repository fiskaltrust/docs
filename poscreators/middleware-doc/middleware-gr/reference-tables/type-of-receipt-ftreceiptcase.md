---
slug: /poscreators/middleware-doc/greece/reference-tables/ftreceiptcase
title: 'Type of Receipt: ftReceiptCase'
---

# Type of Receipt: ftReceiptCase

The `ftReceiptCase` indicates the receipt type and defines how the fiskaltrust.SecurityMechanism should process it following Greek law.

For Greece (GR), the country code is `0x4752`. Thus, the value of an unknown `ftReceiptCase` in Greece is `0x4752000000000000`.

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

*Table 1. Structure of the ftReceiptCase value for Greece.*

#### t - ReceiptCaseType

| **Value** | **Category** | **Description** |
| --------- | ------------ | --------------- |
| `0` | Receipt | A basic receipt that is generated as part of a POS sale. A receipt usually serves as proof of payment. The receipt is used after the transaction is done (if goods are received). This is the usual process that is done at a POS. |
| `1` | Invoice | An invoice is generated for those cases where payment isn't handled immediately. |
| `2` | DailyOperations | This category contains receipt cases that the Middleware requires for various downstream processes. (e.g. book keeping) |
| `3` | Log | Logs can be used for storing / securing events that are needed for additional processing or downstream processes. (e.g. log for cash drawer opened) |
| `4` | Lifecycle | These operations are used for changing the overall state of the Middleware. Depending on the local regulations these receipts are handed over as part of a notification. (e.g. FinanzOnline) |

*Table 2. ReceiptCaseType categories (t) for Greece.*

#### txcc - ReceiptCase

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0000` | **Unknown type for country-code "GR"**<br />This receipt case is handled like a "pos-receipt" (`0001`). See below: | 1.3.45 |
| `0001` | **POS receipt**<br />Represents the main kind of receipt processed by a POS system. Creates a turnover and/or a change in the amount of cash in the till or similar operations. <br />Use the `ftChargeItems` and `ftPayItems` to hand over details about goods, services and payments for processing. The `ftChargeItems` and `ftPayItems` should contain the full final state of the receipt. <br />Transmitted as myDATA type **11.1** (ΑΛΠ) for goods, **11.2** (ΑΠΥ) when all items are services, **11.5** when all items are *not own sales* (`S` = `6`), **6.1** when all items are *own consumption* (`S` = `7`); with the IsRefund flag (`0100`) as **11.4** (Πιστωτικό Στοιχείο Λιανικής) referencing the original receipts by MARK. The IsVoid flag (`0004`) is not supported on receipts. | 1.3.45 |
| `0002` | **Payment transfer receipt type**<br />Transmitted as myDATA type **8.4** (Απόδειξη Είσπραξης POS), with the IsRefund flag (`0100`) as **8.5** (Απόδειξη Επιστροφής POS). Classified as other income information (`category1_95`). | 1.3.45 |
| `0003` | **Point-Of-Sale receipt without fiscalization**<br />Obligation or with exception on fiscalization regulation.<br />**Not supported in Greece**: the request is rejected with an error. | 1.3.45 |
| `0004` | **E-Commerce receipt type**<br />Transmitted to myDATA only when an `invoiceType` override is present in `ftReceiptCaseData` (`GR.mydataoverride.invoice.invoiceHeader.invoiceType`). Without an override the receipt is stored in the queue and no myDATA document is created. | 1.3.45 |
| `0005` | **Delivery Note**<br />Transmitted as myDATA type **9.3** (Δελτίο Αποστολής) only together with the `HasTransportInformation` flag (`0400`); the transport details come from `ftReceiptCaseData`. With the IsRefund flag (`0100`) a reverse delivery note is issued, with the IsVoid flag (`0004`) and a `cbPreviousReceiptReference` the referenced delivery note is cancelled at myDATA. **Without the `0400` flag the request is rejected.** | 1.3.45 |
| `1000` | **Unknown invoice type**<br />Handled like `1001`. | 1.3.45 |
| `1001` | **B2C invoice type**<br />All invoice cases are transmitted as myDATA type **1.1** (goods, domestic), **1.2** (goods, EU customer) or **1.3** (goods, third-country customer); with only service items as **2.1** / **2.2** / **2.3**; with only *not own sales* items (`S` = `6`) as **1.4**; with only *own consumption* items (`S` = `7`) as **6.1**. With the IsRefund flag (`0100`) a credit note **5.1** (with a reference to the original) or **5.2** (without reference) is issued. A `cbCustomer` with VAT number and country is mandatory. | 1.3.45 |
| `1002` | **B2B invoice type**<br />See `1001`. | 1.3.45 |
| `1003` | **B2G invoice type**<br />See `1001`. Transmission to the public sector through the national interoperability centre is not part of the current scope. | 1.3.45 |
| `2000` | **Zero Receipt**<br />Used for communication test and functional test of the fiskaltrust.SecurityMechanism. The request is only valid when the charge items block (ftChargeItems) and the pay items block (ftPayItems) in the ftReceiptRequest are empty arrays. In Greece the zero receipt and all closing receipts (`2001` to `2013`) are accepted as no-ops; no myDATA document is created. | 1.3.45 |
| `2001` | **(reserved) One Receipt** | 1.3.45 |
| `2010` | **Shift Closing Receipt** | 1.3.45 |
| `2011` | **Daily Closing Receipt** | 1.3.45 |
| `2012` | **Monthly Closing Receipt** | 1.3.45 |
| `2013` | **Yearly Closing Receipt** | 1.3.45 |
| `3000` | **Protocol (unspecified type)**<br />Stored in the queue, no myDATA transmission (also `3001`, `3002`). | 1.3.45 |
| `3001` | **Protocol (technical event)** | 1.3.45 |
| `3002` | **Protocol (audit event / accounting event)** | 1.3.45 |
| `3003` | **Internal usage / Material consumption**<br />**Not supported in Greece**: the request is rejected. Use *own consumption* charge items (`S` = `7`) on a receipt or invoice to issue a 6.1 document. | 1.3.45 |
| `3004` | **Order**<br />Transmitted as myDATA type **8.6** (Δελτίο Παραγγελίας Εστίασης); `cbArea` is transmitted as table number. The response carries the informational notice that must be printed. With the IsVoid flag (`0004`), a reference to the original order and `cbArea`, the order is cancelled (one zero line, `totalCancelDeliveryOrders`). Charge items flagged IsRefund (`0002`) inside an order are transmitted as returned lines. | 1.3.45 |
| `3005` | **Pay**<br />Reports a payment for an already transmitted invoice through the myDATA `SendPaymentsMethod` call: requires `cbPreviousReceiptReference` to the invoice and at least one pay item that carries the Greek local pay item flag (bit `0x0000_0001_0000_0000`). Without these the request is accepted as a no-op. No MARK of its own is created. | 1.3.45 |
| `3010` | **Copy Receipt / Print existing Receipt**<br />Stored in the queue, no myDATA transmission. Reprint the original signature items. | 1.3.45 |
| `4001` | **Queue-Start-Receipt (Initial operations receipt)**<br />Activates the queue and initialises its invoice series (by default the cash box identification). | 1.3.45 |
| `4002` | **Queue-Stop-Receipt (Out of operations receipt)** | 1.3.45 |
| `4011` | **Initiate SCU-switch**<br />Accepted as no-op in Greece (also `4012`). | 1.3.45 |
| `4012` | **Finish SCU-switch** | 1.3.45 |

*Table 3. ReceiptCase values (txcc) for Greece.*

The receipt cases `0006` (Table check) and `0007` (Pro forma) of the general part are **not supported in Greece** and are rejected by the Middleware since version 1.3.81. Restaurant order slips are issued with the order case `3004`. See [Licensing](../licensing/licensing.md#supported-document-types) for the complete mapping to myDATA document types and the [boundaries](../licensing/licensing.md#boundaries) of the implementation.

#### gggg - global tagging/flag

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | **Process as Late Signing Receipt**<br />The cash register lost connection to the queue and processed receipts without communicating with the queue. All processed receipts marked with the hint “Security mechanism not reachable” need to be sent to the queue with this marker.<br />In Greece the document is transmitted with `transmissionFailure = 1` (loss of connection between the entity and the provider) and the response carries the notice *Απώλεια Διασύνδεσης Οντότητας - Παρόχου*. | 1.3.45 |
| `0002` | **Training Receipt** | 1.3.45 |
| `0004` | **IsVoid**<br />Marks Receipt as Void to previous one. Mark lineitems also as IsVoid to signal clear data.<br />In Greece only supported for orders (`3004`, cancellation of an 8.6 order slip) and delivery notes (`0005` with `0400`, cancellation at myDATA). On every other receipt case the request is rejected; use the IsRefund flag instead. | 1.3.45 |
| `0008` | **Process as Handwritten Receipt**<br />During a power outage, the Cash register will not work, and the merchant hands out handwritten receipts. These handwritten receipts need to be sent to the Security Mechanism by using this flag.<br />In Greece the document is transmitted with the series and number of the paper document. `ftReceiptCaseData.GR` must contain `Series` (different from the queue's own series), `AA` (greater than 0), `MerchantVATID` (matching the account), `HashAlg` and `HashPayload` (`MerchantVATID-Series-AA-cbReceiptReference-cbReceiptMoment-TotalAmount`). | 1.3.45 |
| `0010` | **IssuerIsSmallBusiness**<br />Businesses below a country-specific size in revenue need not declare VAT.<br />With this marker, the receipt shows no VAT, all prices are gross, and a country-specific hint must be printed. | 1.3.45 |
| `0020` | **ReceiverIsBusiness**<br />Specific data need to be placed onto the receipt. | 1.3.45 |
| `0040` | **ReceiverIsKnown**<br />Characteristics related to VAT taxes are given. For example, Name, Address, VAT-ID, other local info. | 1.3.45 |
| `0080` | **IsSaleInForeignCountry**<br /> | 1.3.45 |
| `0100` | **IsReturn/IsRefund**<br />Marks Receipt as Return of good or service.<br />In Greece this produces the credit document: 11.4 for receipts, 5.1 / 5.2 for invoices, 8.5 for payment transfers, a reverse delivery note for 9.3. Reference the original via `cbPreviousReceiptReference` or by MARK in `ftReceiptCaseData.GR.PreviousReceiptReference.invoiceMark`. | 1.3.45 |
| `0400` | **HasTransportInformation** <br />Marks the receipt as carrying transport/delivery details (dispatch date/time, vehicle number, loading and delivery addresses, purpose of movement). Required together with Delivery Note (`0005`) to produce myDATA document type 9.3 (Δελτίο Αποστολής). Combine with `0100` (IsReturn/IsRefund) to produce a 9.3 reverse delivery note. | 1.3.45 |
| `0800` | **Group by Position-Number / 100**<br />100 = first position, 101 first subitem, 102 second subitem.<br />The sum of all chargeitems within a position must count toward the total receipt amount.<br />If the quantity and amount are 0,00, the quantity and amount will not be visualized for this line on the digital receipt. Independent if main or subitem. | 1.3.45 |
| `8000` | **ReceiptRequest**<br />If you don’t receive a response, try this flag first before taking any other action.<br />This will return a stored result for example in case of a timeout when cashregister calls queue. | 1.3.45 |

*Table 4. Global tagging/flag values (gggg) for Greece.*

#### lll - local tagging/flag

Greece does not currently define any bits in the dedicated local (`lll`) flag range. The Greek-specific transport flag (`HasTransportInformation`) instead occupies bit `0400` within the shared `gggg` global-flag nibble above.
