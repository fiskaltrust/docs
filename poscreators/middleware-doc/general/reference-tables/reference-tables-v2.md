---
slug: /poscreators/middleware-doc/general/reference-tables/reference-tables-v2
title: Reference Tables V2
---

# ReceiptRequest related mapping

## ftReceiptCase

**Format**: _CCCC_vlll_gggg_txcc_

### t - ReceiptCaseType

| **Type** | **Category** | **Description** |
|-----------|-----------------|-------------------------|
| `0` | Receipt  | A basic receipt generated as part of a POS sale. It usually serves as proof of payment and is used after the transaction is completed (i.e., once goods are received). This is the usual process done at a POS.  |
| `1` | Invoice  | An invoice is generated when payment isn't handled immediately.  |
| `2` | DailyOperations  | This category contains receipt cases that the Middleware requires for various downstream processes (e.g., bookkeeping).  |
| `3` | Log  | Logs are used to store and secure events needed for additional processing or downstream processes (e.g., a log for when the cash drawer is opened). |
| `4` | Lifecycle  | These operations change the overall state of the Middleware. Depending on local regulations, these receipts are handed over as part of a notification (e.g., FinanzOnline). |

### txcc - ReceiptCase

| **Value** | **Description** |
|-----------|-----------------|
| `0000` | Unknown receipt type.<br />Use this as a fallback; it is handled the same way as a point-of-sale receipt. |
| `0001` | Point-of-sale receipt type. |
| `0002` | Payment transfer receipt type. |
| `0003` | Point-of-sale receipt without fiscalization obligation or with exceptions to fiscalization regulations. |
| `0004` | E-Commerce receipt type. |
| `0005` | Delivery note. |
| `0006` | Table Check [PT]/ Note [FR]/ Zwischenrechnung [AT]/  ??? |
| `0007` | Proforma invoice. |
| `1000` | Unknown invoice type (simplified invoice in the future).|
| `1001` | B2C invoice type. |
| `1002` | B2B invoice type. |
| `1003` | B2G invoice type. |
| `2000` | Zero receipt. |
| `2001` | (Reserved) One receipt. |
| `2010` | Shift closing receipt. |
| `2011` | Daily closing receipt. |
| `2012` | Monthly closing receipt. |
| `2013` | Yearly closing receipt. |
| `3000` | Protocol (unspecified type). |
| `3001` | Protocol (technical event). |
| `3002` | Protocol (audit event/accounting event). |
| `3003` | Internal usage/material consumption. |
| `3004` | Order (log order). |
| `3005` | Pay (log payment). |
| `3010` | Copy receipt/print existing receipt. |
| `3011` | Archive receipt/archive all data receipt. |
| `4001` | Queue-start-receipt (initial operations receipt). |
| `4002` | Queue-stop-receipt (out of operations receipt). |
| `4011` | Initiate SCU-switch. |
| `4012` | Finish SCU-switch. |
| `4021` | Initiate migration. |
| `4022` | Finish migration. |

### gggg - Global tagging/flags

#### ftReceiptCaseFlags

| **Value** | **Description** |
|-----------|-----------------|
| `0001` | **Process as Late Signing Receipt**<br />The cash register lost connection to the queue and processed receipts without communicating with the it. All processed receipts marked with the hint "Security mechanism not reachable" must be sent to the queue with this maker. | 
| `0002` | Training Receipt. |
| `0800` | **Group by Position-Number**<br />Position fields are represented as decimal numbers: the whole number indicates the grouped line item, and the fractional part is used within that group. The sum of all `ChargeItems` within a position must count toward the total receipt amount. If the quantity and amount are 0,00, the quantity and amount will not be visualized for this line on the digital receipt, regardless of whether it is a main item or a subitem. |
| `8000` | **ReceiptRequest**<br />If you don’t receive a response, try this flag first before taking any other action. This will return a stored result, for example in case of a timeout when cash register calls the queue. |

#### PosReceipt (Invoice only)

| **Value** | **Description** |
|-----------|-----------------|
| `0004` | **IsVoid**<br />Marks a receipt as **Void** relative to a previous one. Line items should also be marked as `IsVoid` to signal cleared data. |
| `0008` | **Process as Handwritten Receipt**<br />During a power outage, the cash register will not work, and the merchant issues handwritten receipts. These receipts must be sent to the Security Mechanism using this flag. |
| `0010` | **IssuerIsSmallBusiness**<br />Businesses below a country-specific size in revenue do not need to declare VAT. With this marker, the receipt shows no VAT, all prices are gross, and a country-specific hint must be printed. |
| `0020` | **ReceiverIsBusiness**<br />Specific data must be included on the receipt. |
| `0040` | **ReceiverIsKnown**<br />Characteristics related to UStG are provided. For example, Name, Adress, VAT-ID, other local details. |
| `0080` | **IsSaleInForeignCountry** | |
| `0100` | **IsReturn/IsRefund**<br />Marks the receipt as a return of goods or services. |
| `0200` | **InvoiceProcessingOnly/InvoiceDelivery**<br />Used when a `queueitemid` should be generated for later processing, e.g., issue. |
| `0400` | **HasTransportInformation**<br />If used, transport information is included in the document. |

#### ZeroReceipt (Dailyoperation only)

| **Value** | **Description** |
|-----------|-----------------|
| `0010` | Request additional information from SCU (TseInfo in Germany, RTInfo in Italy, SignatureCertificate in Austria and France). |
| `0020` | Request Force Connection/Download from SCU. |
| `0040` | Request Bypass Connection/Download from SCU. |
| `0080` | Request Self-Test from SCU. |
| `0100` | Request MasterData update. |
| `8000` | **Direct SCU communication**<br />`ftReceiptCaseData` carries the request payload within `eu.fiskaltrust.Middleware.SCU.[CC].[implementation]`, and `ftStateData` carries the response payload in the same property name. |

#### LifecycleReceipt only

| **Value** | **Description** |
|-----------|-----------------|
| `0010` | Queue registration/de-registration only. Bypass SCU factory default initialization. |
| `0020` | Bypass SCU communication and execute when communication with SCU has failed. |

### lll - Local tagging/flags

#### AT (Austria)
cba … c=reserved ; b=reporting ; a = scu related

| **Value** | **Description** |
|-----------|-----------------|
| TBD | TBD |

#### DE (Germany)

**All Receipt Type (xxxx)**

| **Value** | **Description** |
|-----------|-----------------|
| `001`  | Implicit mode: create `StartTransaction` implicitly for each `ReceiptType`; no call to `Start-Transaction-Receipt` is required. |

**Log operation (3xxx)**

| **Value** | **Description** |
|-----------|-----------------|
| `010`  | Start-Transaction (with technical log type 3001) |
| `020`  | Update-Transaction (with technical log type 3001) |
| `030`  | Delta-Transaction (with technical log type 3001) |
| `040`  | Fail-Transaction-Receipt (with technical log type 3001) |

#### FR (France)
cba … c=reserved ; b=reporting ; a = scu related

| **Value** | **Description** |
|-----------|-----------------|
| TBD | TBD |

#### IT (Italy)
cba … c=reserved ; b=reporting ; a = scu related

| **Value** | **Description** |
|-----------|-----------------|
| `001`  | [RT-Printer/RT-Server/Government Service] not reachable.<br />Responded in case of a zero-receipt and other hard dependencies to the service. (TBD can this be replaced by Request Bypass Connec-tion/Download from SCU). |

#### ReceiptCaseData

- **Reference in case of "Void"** - used when `cbReceiptReference` cannot be used because of source receipt is in a different queue or system. Fields included: `{ RT-Device-Serialnumber, Z-Number, Document-Number, Document-Moment }`

- **Reference in case of "InvoicePayment"**

## ftChargeItemCase

**Format**: _CCCC_vlll_gggg_NNSV_

**v - version**
version 2

### V - VAT
For more information, see [VAT rules and rates](https://europa.eu/youreurope/business/taxation/vat/vat-rules-rates/index_en.htm).

| V (type of VAT) | Description                          | VAT table code | IT |
|-----------------|--------------------------------------|----------------|----|
| 0               | Unknown VAT rate                     | G              |    |
| 1               | Discounted-1 VAT rate                | B              |    |
| 2               | Discounted-2 VAT rate                | C              |    |
| 3               | Normal VAT rate                      | A              |    |
| 4               | Super reduced-1 VAT rate             | D              |    |
| 5               | Super reduced-2 VAT rate             | E              |    |
| 6               | Parking VAT rate                     | F              |    |
| 7               | Zero VAT rate                        | H              |    |
| 8               | Not taxable (in VAT context)         | I              |    |

### S - Type of Service

| S (type of service) | Description                       |
|---------------------|-----------------------------------|
| 0                   | Unknown type of service. |
| 1                   | Delivery (supply of goods) - goods purchased and sold. |
| 2                   | Other service (supply of service) – services provided. |
| 3                   | Tip. For owner, use V=0 to 7 (related to total amount). For employee, use V=8 (Not Taxable). |
| 4                   | Voucher. For Single-Use Voucher, use V=0 to 7. For Multi-Use Voucher, use V=8 (Not Taxable). Voucher sale is a positive (+) amount; voucher redeem is a negative (-) amount. `IsVoid` can be applied to reverse amounts. Avoid using this for Multi-Use Voucher; instead, use `PayItem` with `ShowInChargeItems` flag. For Single-Use Voucher, apply `ShowInPayItems` flag to visualize it like a payment and keep the total amount unreduced. |
| 5                   | Catalog service (service or good produced in-house) — To be modified!!! |
| 6                   | Not own sales/agency business. |
| 7                   | Own consumption. |
| 8                   | Grant. For unreal grant, use V=0 to 7. For real grant, use V=8. |
| 9                   | Receivable. Creation is a negative (-) amount; reduction is a positive (+) amount. `IsVoid` can be applied to reverse amounts. Avoid using this; use `PayItem` with the `ShowInChargeItems` flag instead. |
| A                   | Cash transfer. Cash transfer to the till is positive (+); from the till is negative (-). Only usable with V=8 (Not Taxable). `IsVoid` can be applied to reverse amounts. |
| F                   | Super-specific type of tax. Detailed definition in NN=nn. V=8 required. |

### NN - Nature of VAT

| NN (nature of VAT) | Description | IT | GR |
|--------------------|-------------|----|----|
| 00 | Usual VAT applies. | | |
| 10 | Not Taxable.<br />1x can be used to speci-fy more country-specific details, e.g, IGL. | **NI (N3)** marker mandatory<br />[10] Not taxable – exports<br />[11] Non-taxable – intra-community supplies<br />[12] Non-taxable – transfers to San Marino<br />[13] Non-taxable – transactions assimilated to export supplies<br />[14] Non-taxable – following declarations of intent<br />[15] Non-taxable – other operations which do not contribute to the formation of the ceiling | Marker to print [fiskaltrust]`{myData}`<br />[11] `(mydata:14)` Article 33. non-taxable - intra-community sup-plies Χωρίς ΦΠΑ - άρθρο 33 του Κώδικα ΦΠΑ<br />[12] `(mydata:8)` Article 29-Export of goods outside of EU Χωρίς ΦΠΑ - άρθρο 29 του Κώδικα ΦΠΑ<br />[13] `(mydata:28)` TAXFREE retail to non eu citi-zens Χωρίς ΦΠΑ – άρθρο 29 περ. β’ παρ.1 του Κώδικα ΦΠΑ<br />[14] (myda-ta:16)  Article 45 Includes the special regime of payment of tax from the receiver of goods and ser-vices NOT THE ISSUER Χωρίς ΦΠΑ - άρθρο 45 του Κώδικα ΦΠΑ<br />[15] `(mydata:6)` Article 24 Bottle package recycling, sales of tickets, sales of newspa-pers and maga-zines   Χωρίς ΦΠΑ - άρθρο 24 του Κώδικα ΦΠΑ<br />[16] `(mydata:7)` article 27 Services in Greece for med-ical services, ser-vices provided from doctors, den-tists, insurance services, bank ser-vices, sale of 1st residence Χωρίς ΦΠΑ - άρθρο 27 του Κώδικα ΦΠΑ |
| 20 |	Not Subject.<br />2x can be used to specify more country-specific details. | **NS (N2)** marker mandatory<br />[20] not subject to VAT pursuant to articles from 7 to 7-septies of Presidential Decree 633/72<br />[21] not subject, other cases | |
| 30 | Exempt.<br />3x | **ES (N4)** marker mandatory<br />[30] exempt | [31] `(mydata:20)` article 50 Comments Special regime for travel agencies, travel packages taxed in GR. ΦΠΑ εμπεριεχόμενος - άρθρο 50 του Κώδικα ΦΠΑ<br />[32] `(mydata:9)` article 30 It concerns the exemptions applied under special customs regimes. Goods placed in special customs regimes (e.g., customs warehousing, active processing, etc.) are exempt from VAT. Χωρίς ΦΠΑ - άρθρο 30 του Κώδικα ΦΠΑ<br />[33] `(mydata:15)` Article 44 It concerns the special regime for small businesses (below 10K invoices). Χωρίς ΦΠΑ - άρθρο 44 του Κώδικα ΦΠΑ |
| 40 | Margin scheme. Do not print/show VAT rate and amount on receipt/invoice. 4x can be used to specify more country specific details. | **RM (N5)** marker mandatory<br />[40] margin scheme / VAT not shown on the invoice | [41] (myda-ta:22) Article52 Special taxation regime for taxable resellers who deliver second-hand goods and objects of artistic, collector's or archaeological value. Χωρίς ΦΠΑ εμπεριεχόμενος - άρθρο 52 του Κώδικα ΦΠΑ |
| 50 | Reverse charge.<br />5x | **AL (N6)** marker mandatory<br />[50] reverse charge - disposal of scrap and other salvage materials<br />[51] reverse charge - sale of gold and silver pursuant to law 7/2000 as well as used jewelery to OPO<br />[52] reverse charge - subcontracting in the construction sector<br />[53] reverse charge - sale of buildings<br />[54] reverse charge - supply of mobile phones<br />[55] reverse charge - supply of electronic products<br />[56] reverse charge - performance in the construction sector and related sectors<br />[57] reverse charge - energy sector transactions<br />[58] reverse charge - other cases	[51] (myda-ta:19) Article54 The delivery, intra-Community acquisition and import of investment gold, including investment gold for which there are certificates, by type or by type or which is the subject of a transaction between gold accounts, including, in particular, gold loans and swaps, with a right of ownership or claim to investment gold, as well as investment gold transactions with futures and forward contracts, which cause a change of ownership or claim to investment gold, Χωρίς ΦΠΑ - άρθρο 54 του Κώδικα ΦΠΑ |
| 60 |	VAT paid in other EU country.<br />6x	| **(N7) marker** mandatory<br />[60] paid in another EU country (provision of telecommunications, broadcasting and electronic services pursuant to art. 7-octies, paragraph 1 letter a, b, art. 74-sexies of Presidential Decree 633/72) | [61] (myda-ta:3)  article 17 Sales of goods which DURING SALES are located outside Greece, sales on boats and or planes during an intra-eu sale Χωρίς ΦΠΑ - άρθρο 17 του Κώδικα ΦΠΑ<br />[62] `(mydata:4)` article 18 Services taxed outside Greece including restaurant and catering services provided abroad INCLUDING SERVICES provided digitally when the receiver is living abroad. Χωρίς ΦΠΑ - άρθρο 18 του Κώδικα ΦΠΑ |
| 70 | VAT distribution | *VI (VI) is a fiscal VAT (IVA) regime that certain retailers can adopt. It allows the global registration of the daily takings amount without distinguishing the individual VAT rates. Applies only to goods. | |
| 80 | Excluded<br />8x | *EE (N1) marker mandatory<br />[80] excluded pursuant to art. 15 of Presidential Decree 633/72 | [81] `(mydata:1)` Article 2&3 Includes transactions outside the scope of VAT (e.g., compensations for material damages, income from participations, subsidies, grants, etc., as well as the special regime of Mount Athos.<br />Χωρίς ΦΠΑ - άρθρο 2 και 3 του Κώδικα ΦΠΑ<br />[82] `(mydata:2)` Article 5 Case of transfer of assets of a business as a) a whole, b) a branch, or c) a part of it through onerous or gratuitous cause or in the form of contribution to an existing or newly established legal entity.<br />Χωρίς ΦΠΑ - άρθρο 5 του Κώδικα ΦΠΑ<br />[83] `(mydata:10)` Article 31 Rare case of tax warehouses sales<br />Χωρίς ΦΠΑ - άρθρο 31 του Κώδικα ΦΠΑ<br />[84] `(mydata:11)` Article 32 It includes exemptions applicable to: certain categories of ships and watercraft and aircraft, for diplomatic and consular authorities, recognized international organizations, the European Community, the European Central Bank, etc., NATO and its organizations, to meet the needs of refugees and vulnerable groups, public donors, etc. for certain transports for<br />[85] `(mydata:12)` Article 32.Open seas ships<br />[86] `(mydata:13)` Article 32.1.Open seas ships<br />[87] Χωρίς ΦΠΑ - ΠΟΛ.1029/1995<br />[88] `(mydata 26)` special case where you don’t pay vat as long as the goods or services are intented for another EU state or 3rd party country<br />Χωρίς ΦΠΑ - άρθρο 32 του Κώδικα ΦΠΑ |

| nn (nature of non-VAT/super specific tax V==8 && S==F) | Description               | IT | GR |
|--------------------------------------------------------|---------------------------|----|----|
| 00 | Exact description is used for mapping and printing. | |
| 10 | | | |
| 20 | | | |
| 30 | | | |
| 40 | | | |
| 50 | | | |
| 60 | | | |
| 70 | | | |
| 80 | | | |

### gggg - Global tagging/flags

| **Value** | **Description** |
|-----------|-----------------|
| `0001` | **IsVoid**<br />Marks `ChargeItem` as **Void** of the previous position. Quantity and amount are inverted, related to the original item. |
| `0002` | **IsReturn/IsRefund**<br />Marks ChargeItem as **Return** of good or service. Quantity and amount are inverted, related to the original item. |
| `0004` | **Discount**<br />Marks `ChargeItem` as **Discount / Extra** for the previous position. Positive (+) amount is extra, negative (-) amount is **discount**. `IsVoid` or `IsReturn/IsRefund` will invert this behavior. |
| `0008` | **Downpayment**<br />Marks `ChargeItem` as a **Downpayment**. Positive (+) amount creates a downpayment, negative (-) amount reduces it. `IsVoid` or `IsReturn/IsRefund` will invert this behavior. |
| `0010` | **Returnable**<br />Marks `ChargeItem` as **Returnable**. Positive (+) amount/quantity is handout, negative (-) is reverse**. `IsVoid` or `IsReturn/IsRefund` will invert this behavior. |
| `0020` | **TakeAway**<br />Marks `ChargeItem` as **TakeAway** item to prove special VAT application. |
| `4000` | **RespondInReceiptResponse**<br />Respond in **ReceiptResponse**. |
| `8000` | **ShowInPayments**<br />Visualize the item after Total Amount. Amount is inverted and not included in the visualized total amount on the receipt. |

### lll - Local tagging/flags

Is there any?

## ftPayItemCase

**Format**: _CCCC_vlll_gggg_xxPP_

**v - version**
version 2

### PP - Payment type

| **Value** | **Description** | **GR**            |
|-----------|-----------------|-------------------|
| `00` | Unknown | |
| `01` | Cash | GR: Cash |
| `02` | NonCash | |
| `03` | Crossed Cheque | GR: Cheque |
| `04` | Debit Card | GR: POS/e-POS |
| `05` | Credit Card | GR: POS/e-POS |
| `06` | Voucher | GR: Cheque |
| `07` | Online | |
| `08` | Loyalty Program/Customer Card | |
| `09` | Accounts Receivable | GR: On Credit |
| `0A` | SEPA Transfer (Wire Transfer) | GR: Default maps to Domestic payments.<br />GR: **Description == “IRIS”** maps to **IRIS**<br />GR: **Description == "RF code payment (Web banking)"** maps to **Web banking**. |
| `0B` | Other Bank Transfer | GR: maps to **International Business Payment Account** |
| `0C` | Transfer to Cashbook/Vault/ Owner/Employee.<br />Positive (`+`) amount increases cashbook/vault.<br />Negative (`-`) amount decreases cashbook/vault. |
| `0D` | Internal/Material Consumption | |
| `0E` | Grant | |
| `0F` | Ticket Restaurant (Sodexo, Edenred, etc.) | |

### gggg - Global tagging/flags

| **Value** | **Description** |
|-----------|-----------------|
| `0001` | **IsVoid**<br />Marks `PayItem` as **Void** of the previous position. Quantity and amount are inverted, related to the original item. Used when the exchange of money has not been executed yet. |
| `0002` | **IsReturn / IsRefund**<br />Marks `PayItem` as **Return** of good or service. Quantity and amount are inverted, related to the original item. Used when the exchange of money has already been executed. |
| `0004` | (reserved) |
| `0008` | **Downpayment**<br />Marks `PayItem` as a downpayment. Positive (+) amount is reduction of downpayment. Negative (-) amount is creation of downpayment. |
| `0010` | **IsForeignCurrency**<br />Amount is still in EUR at the moment of acceptance. `ftPayItemData` requires two data elements with `foreignCurrencySymbol` and `foreignCurrencyAmount` to persist data for daily closing and later bookkeeping transactions. |
| `0020` | **IsChange**<br />Usually contains a negative (-) amount. (`IsVoid` => can be inverted) |
| `0040` | **IsTip**<br />Must be a negative (-) amount to flow out of the payment method. `ShowInChargeItems` flag can be used to raise the total amount by the tip amount for better visualization. |
| `0080` | **IsDigital/IsElectronic**<br />Electronic or digital money. |
| `0100` | **IsInterface/AmountVerified**<br />Amount was verified by interface; automated amount transfer. |
| `4000` | Respond in **ReceiptResponse**. |
| `8000` | **ShowInChargeItems**<br />Visualize the item before Total Amount. This inverts amount and does include the amount into the visualized total amount on the receipt. |

# ReceiptResponse related mapping

## ftReceiptnumber

`ft{ReiceiptNumeratorHex}#{RT-Device-Z-Number}-{RT-Device-recNumber}`

## ftState

**Format**: _CCCC_vlll_gggg_gggg_

**v - version**
version 2

### gggg_gggg - Global tagging/flags

| **Value** | **Description** |
|-----------|-----------------|
| `0000_0001` | Security Mechanism is Out of Operation.<br />Queue is not started or already stopped. |
| `0000_0008` | Deferred Queue Mode/Late Signing Mode is active.<br />When the cash register doesn’t reach the queue, it queues up the receipt requests while continuing to do business. Also, with a major failure of the cash register or a power outage, handwritten paper receipts are queued up while continuing to do business. After returning to a fully functional state, these queued `ReceiptRequests` are sent to the queue, keeping the original `cbReceipt-Moment` of the business case `ReceiptCase` tagged/flagged with `0001` (Deferred Queue/Late Signing) or `0008` (Handwritten).<br />A result of this is a marker within the `ftState`, which can be resolved via `ZeroReceipt`. The reason for the marker is a mismatch between processed time along the receipt chain and a manual event to clean up the state, and maybe notify 3rd parties of an outage. |
| `0000_0040` | Message Pending.<br />Middleware/Queue is a headless background service, but there are situations where communication with the cashier/operator or the cash register is necessary. For example, if the last daily closing was missed or if a special condition related to the signature creation unit or service happened. This is when the message pending flag is set by the middleware and should be signaled to the cashier by the POS system. By executing a `ZeroReceipt`, the cashier can read the message or instruction on the printed or displayed receipt.<br />Related to local regulations, this receipt may be stored/archived for bookkeeping purposes; if so, this is also visualized.
| `0000_0100` | `DailyClosing` due.<br />When the first `cbReceiptMoment` used since the last `DailyClosing` and the current/latest `cbReceiptMoment` in the `ReceiptRequest` have a date gap of more than two days (e.g., the first since the last daily closing is 24/08 and the current is 26/08), then this state indicates a `DailyClosing` should be done.<br />`DailyClosing` is an essential part of the security mechanism and executes additional market-specific clean-up tasks. Therefore, each queue should perform a `DailyClsoing` to clear persistent changes in business data and updates in the business period. |
| `0000_0200` | `MonthlyClosing` due.<br />When the first `cbReceiptMoment` used since last `MonthlyClosing` and the current/latest `cbReceiptMoment` in the `ReceiptRequest` are different, this state indicates a `MonthlyClosing` should be done. |
| `0000_0400` | `YearlyClosing` due. |
| `EEEE_EEEE` | Error.<br />Something went wrong while processing the last request. `QueueItem` exists but didn’t reach the state of a `ReceiptItem` and didn’t consume a `ftReceiptNumber` within the chain. Error reason is shown within the responded `ftSignatureItems`. This happens, for example, if the `ReceiptCase` is not recognized or is wrong. |
| `FFFF_FFFF` | Fail.<br />Something went wrong while processing the last request, and nothing persisted within the Queue. Fail reason is shown within the responded `ftSignatureItems`. This happens, for example, when the flag `ReceiptRequest` is used after a communication outage, and no properly processed item is found. |

### lll - Local tagging/flags

#### AT (Austria)
cba … c=reserved ; b=reporting ; a = scu related

| **Value** | **Description** |
|-----------|-----------------|
| `001` | SCU permanent out of service.<br />48h FinanzOnline timeout reached. |
| `002` | Backup SCU in use. |

#### DE (Germany)
cba … c=reserved ; b=reporting ; a = scu related

| **Value** | **Description** |
|-----------|-----------------|
| `001`  | SCU is in a switching state.<br />The queue is in the process of switching SCUs. This state is returned in case any receipts are processed between the initialize-switch and finish-switch receipts. These receipts are protected by **fiskaltrust.SecurityMechanism**, but are not sent to any TSE, as no SCU is connected at this point. |

#### FR (France)
cba … c=reserved ; b=reporting ; a = scu related

| **Value** | **Description** |
|-----------|-----------------|
| TBD | TBD |

#### IT (Italy)
cba … c=reserved ; b=reporting ; a = scu related

| **Value** | **Description** |
|-----------|-----------------|
| `001`  | [RT-Printer/RT-Server/Government Service] not reachable.<br />Responded in case of a zero-receipt and other hard dependencies to the service. |

#### ES (Spain)
cba … c=reserved ; b=reporting ; a = scu related

| **Value** | **Description** |
|-----------|-----------------|
| TBD | TBD |

## ftSignature

### ftSignatureFormat

**Format**: p_ffff_

#### ffff - Format

| **Value** | **Description** |
|-----------|-----------------|
| `0000`	| Unknown/no format defined |
| `0001`	| Text |
| `0002`	| Link |
| `0003`	| QR-Code (2D Code) |
| `0004`	| Code128 (Barcode) |
| `0005`	| OCR-A (optical character recognition, possible for Base32 data) |
| `0006`	| PDF417-(2D Code) |
| `0007`	| DATAMATRIX-(2D Code) |
| `0008`	| AZTEC-(2D Code) |
| `0009`	| EAN-8 (Barcode) |
| `000A`	| EAN-13 (Barcode) |
| `000B`	| UPC-A (Barcode) |
| `000C`	| Code39 (Barcode, possible for Base32 data) |
| `000D`	| Base64 (Raw Data) |

#### p - Position

The Basic Layout is:
[Header]
[ChargeItemBlock]
[TotalTaxBlock]
[PayItemBlock]
[SignatureBlock]
[Footer]

`SignatureItems` must be printed or visualized on the Receipt within the `SignatureBlock`, in the order they were received, and according to any additional format and visualization flags. For each `SignatureItem`, the first line should display its caption in text format, followed by a new line showing the content of the `SignatureItem` formatted according to the specified format.

| **Value** | **Description** |
|-----------|-----------------|
| `0`	| After `PayItemBlock`/Before `Footer` |
| `1`	| After `Header`/Before `ChargeItemBlock` |
| `2`	| After `ChargeItemBlock`/Before `TotalTaxBlock` |
| `3`	| After `TotalTaxBlock`/Before `PayItemBlock` |
| `4`	| After `Footer` |
| `5`	| Before `Header` |

| **Value** | **Description** |
|-----------|-----------------|
| `0100`	| Print/Visualize after `Header` (usual position is after `PayItems`/before `Footer`) |
| `0200`	| Print/Visualize after `ChargeItems` (usual position is after `PayItems`) |
| `0400`	| Print/Visualize after `Total` (usual position is after `PayItems`) |
| `0800`	| Print/Visualize after `ChargeItems` (usual position is after `PayItems`) |

### ftSignatureFormatFlags

TBD

### ftSignatureType

**Format**: _CCCC_vlll_gggg_tsss

**v - version**
version 2

#### t - Type/Category

| **Value** | **Description** |
|-----------|-----------------|
| `0`	| Uncategorized; Normal use (notification) |
| `1`	| Information (notification); low priority |
| `2`	| Alert (notification); high priority |
| `3`	| Failure (notification); high priority |

#### sss - SignatureCase

| **Case**   | **Description**        | **Caption**     |
|------------|------------------------|-----------------|
| `000`	 | Notification	| |
| `001`	 | Primary market-related compliance signature	| |
| `010??` |	Middleware version: the version of the middlware used to generate the given receipt	| |
| `Exx??` |	Related information to `EEEE_EEEE` `ftState`<br />Flag: do not print/visualize<br />Data: Base64 stack trace if debug/sandbox | Exception Number/Name |
| `Fxx??` |	Related information to `FFFF_FFFF` `ftState`<br />Flag: do not print/visualize<br />Data: Base64 stack trace if debug/sandbox | Exception Number/Name |

#### gggg - Global tagging/flags

| **Value** | **Description** |
|-----------|-----------------|
| `0001`	| Archiving required.<br />Signatures marked with this flag are known to be archived related to market-specific bookkeeping requirements. For offline usage or pure open-source usage, receipts or artefacts with this flag should be treated as bookkeeping/accounting-relevant items. |
| `0010`	| Printing/Visualization is optional. |
| `0020`	| Do not print/visualize. |
| `0040`	| Printed receipt only. |
| `0080`	| Digital receipt only. |

#### sss - SignatureCase (by market)

##### AT (Austria)

| **Case**   | **Description**        | **Caption**     |
|------------|------------------------|-----------------|
| `001`	 | Signature/Payload according to RKSV | [www.fiskaltrust.at] |
| `002`  |	Daily operation notification | |
| `003`  | FinanzOnline notification<br />2D code to execute FinanzOnline notification in case of offline usage or pure open-source usage. | |

##### DE (Germany)

| **Case**   | **Description**                                                  | **Caption**              |
|--------|--------------------------------------------------------------|----------------------|
| `001`  | Signature/Payload according to Kassen-SichV<br />[qr] format | [www.fiskaltrust.de] |
| `010`  | Start-transaction-result<br />[do-not-print] flag | |
| `011`  | Finish-transaction-payload<br />[do-not-print] flag | |
| `012`  | Finish-transaction-result<br />[do-not-print] flag | |
| `013`  | QR-Code Version for receipt<br />[optional-print] flag | |
| `014`  | Cashregister Serialnumber for receipt<br />[optional-print] flag | |
| `015`  | ProcessType for receipt<br />[optional-print] flag | |
| `016`  | ProcessData for receipt<br />[optional-print] flag | |
| `017`  | Transaction number for receipt<br />[optional-print] flag | |
| `018`  | Signature counter for receipt<br />[optional-print] flag | |
| `019`  | Transaction start time for receipt<br />[optional-print] flag | |
| `01A`  | Signature logtime for receipt<br />[optional-print] flag | |
| `01B`  | Signature algorithm for receipt<br />[optional-print] flag | |
| `01C`  | Signature logtime format for receipt<br />[optional-print] flag | |
| `01D`  | Signature for receipt<br />[optional-print] flag | |
| `01E`  | Public key for receipt<br />[optional-print] flag | |
| `01F`  | Process start time for receipt | |
| `020`  | Update-transaction-payload<br />[do-not-print] flag | |
| `021`  | Update-transaction-result<br />[do-not-print] flag | |
| `022`  | Certification identification and protection profile restrictions for receipt |  |
| `023`  | TSE serial number for receipt |  |

##### FR (France)

| **Case** | **Description** | **Caption** |
|----------|-----------------|-------------|
| `001`  | Signature/Payload according to French security mechanism (BOI-TVA-DECLA-30-10-30)<br />This is a JWT [qr] format. | [www.fiskaltrust.fr] |
| `010`  | Shift closing payload |  |
| `011`  | Day closing payload |  |
| `012`  | Month closing payload |  |
| `013`  | Year closing payload |  |
| `014`  | Archive Totals payload |  |
| `015`  | Perpetual Totals payload |  |
|        | Zertification status of cashregister ??? |  |

##### IT (Italy)

| **Case** | **Description** | **Caption** |
|----------|-----------------|-------------|
| `001` | Print below [PayItemBlock]/Document fiscalization<br />**RT-Printer**<br />[DATE(DD-MM-YYYY)]<br />[TIME(HH:MM)][NEWLINE]<br />DOCUMENTO N. [z-Number]-[Document-Number][NEWLINE]<br />Codice Lotteria: [LotteryID][NEWLINE]<br />Codice Fiscale: [CustomerID][NEWLINE]<br />RT [SERIALNUMBER][NEWLINE]<br />**RT-Server**<br />[DATE(DD-MM-YYYY)] [TIME(HH:MM)][NEWLINE]<br />DOCUMENTO N. [z-Number]-[Document-Number][NEWLINE]<br />Codice Lotteria: [LotteryID][NEWLINE]<br />Codice Fiscale: [CustomerID][NEWLINE]<br />Server RT [SERIALNUMBER][NEWLINE]<br />Cassa [ftCashboxIdentifica-tion][NEWLINE]<br />-----FIRMA ELETTRONICA-----[NEWLINE]<br />[SHA-METADATA][NEWLINE]<br />---------------------------[NEWLINE]<br />**FE (Fattura Elettronica)**<br />[DATE(DD-MM-YYYY)] [TIME(HH:MM)][NEWLINE]<br />[VAT-ID][NEWLINE]<br />[ftReceiptIdentification][NEWLINE]<br />[ftCashboxIdentification][NEWLINE]<br />If number/signature is present/not null | [www.fiskaltrust.it] |
| `002` | Print below [Header]/Document Type<br />**Document-Type (1) Vendita**<br />DOCUMENTO COMMERCIA-LE[NEWLINE]<br />di vendita o prestazione[NEWLINE]<br />**Document-Type (3) Reso**<br />DOCUMENTO COMMERCIA-LE[NEWLINE]<br />emesso per ANNULLAMEN-TO[NEWLINE]<br />[NEWLINE]<br />Documento di riferimento:<br />N. [reference-z-Number]-[reference-Document-Number] del [reference-Document-Date(DD-MM-YYYY)][NEWLINE]<br />N. [reference-z-Number]-[reference-Document-Number] del [reference-Document-Date(DD-MM-YYYY)][NEWLINE]<br />RT [reference-RT-Printer-Serialnumber][NEWLINE]<br />Server RT [reference-RT-Server-Serialnumber][NEWLINE]<br />Cassa [reference-ftCashboxIdentification][NEWLINE]<br />XXX del [reference-Document-Date(DD-MM-YYYY)][NEWLINE]<br />**Document-Type (5) Annullo**<br />DOCUMENTO COMMERCIA-LE[NEWLINE]<br />emesso per RESO MERCE[NEWLINE]<br />[NEWLINE]<br />Documento di riferimento:<br />N. [reference-z-Number]-[reference-Document-Number] del [reference-Document-Date(DD-MM-YYYY)][NEWLINE]<br />N. [reference-z-Number]-[reference-Document-Number] del [reference-Document-Date(DD-MM-YYYY)][NEWLINE]RT<br />[reference-RT-Printer-Serialnumber][NEWLINE]<br />Server RT [reference-RT-Server-Serialnumber][NEWLINE]<br />Cassa [reference-ftCashboxIdentification][NEWLINE]<br />XXX del [reference-Document-Date(DD-MM-YYYY)][NEWLINE]<br />If number is on same system<br />If number is on different system<br />If number is unknown XXX<br />"POS" in the case of a POS receipt;<br />"VR" in the case of returnable containers;<br />“ND” in other cases | DOCUMENTO COMMERCIALE |
| `010`  | RT printer/server serial number | |
| `011`  | RT printer/server Z-Number | |
| `012`  | RT printer/server Document-Number | |
| `013`  | RT printer/server Document-Moment | |
| `014`  | RT printer/server Document Type | |
| `015`  | RT printer/server LotteryID | |
| `016`  | RT printer/server CustomerID | |
| `017`  | RT server SHA Metadata | |
| `018`  | Amount | |
| | ReceiptURL ??? | |
| | ESC/POS content ??? | |
| | ????<br />"serialNumber": "99IEC018305",<br />"recNumber": "18",<br />"zRepNumber": "Z0007",<br />"recDate": "2023-08-28T13:21:32+02:00",<br />"recAmount": "5077.14",<br />"customerId": "123456789",<br />"lotteryId": "",<br />"docType": "SALES", | |
| `020` | RT Reference ZNumber | |
| `021`  | RT Reference DocNumber | |
| `022`  | RT Reference Document Moment | |

##### ES (Spain)

| **Case** | **Description** | **Caption** |
|----------|-----------------|-------------|
| TBD | TBD | |

##### PT (Portugal)

| **Case** | **Description** | **Caption** |
|----------|-----------------|-------------|
| TBD | TBD | |

##### GR (Greece)

| **Case** | **Description** | **Caption** |
|----------|-----------------|-------------|
| TBD | TBD | |

## ftJournalType

**Format**: _CCCC_vlll_gggg_tjjj_

**v - version**
version 2

### t - Type/Category

| **Value** | **Description** |
|-----------|-----------------|
| `0`	| Common |
| `1`	| Market specific |

### jjj -  JournalCase

| **Case** | **Description** |
|-----------|-----------------|
|`000`	| Version Information |
|`001`	| ActionJournal |
|`002`	| ReceiptJournal |
|`003`	| QueueItemJournal |

### gggg -  Global tagging/flags

| **Value** | **Description** |
|-----------|-----------------|
| `0001`	| Use ZIP compressed stream |

### jjj - JournalCase (by market)

#### AT (Austria)

| **Case**   | **Description**        |
|------------|------------------------|
| `001`	 | Status Information QueueAT |
| `002`  |RKSV-DEP-Export |

#### DE (Germany)

| **Case** | **Description**                                         |
|--------|-------------------------------------------------------------|
| `000`  | Status Information QueueDE |
| `001`  | .TAR-File-Export passthrough from TSE device<br />Limited to data at device. Usually, data are purged from device after successful export. |
| `002`  | DSFinV-K Export<br />ZIP compression required. |
| `003`  | .TAR-File-Export |

#### FR (France)

| **Case** | **Description** |
|----------|-----------------|
| `000`  | Status Information QueueFR |
| `001`  | Ticket ("T" group) export |
| `002`  | Payment Prove ("P" group) export |
| `003`  | Invoice ("I" group) export |
| `004`  | Grand Total ("G" group) export |
| `007`  | Bill ("B" group) export |
| `008`  | Archive ("A" group) export |
| `009`  | Log ("L" group) export |
| `00A`  | Copy ("C" group) export |
| `00B`  | Training ("X" group) export |
| `010`  | Export (in conjunction with Archiv) |

#### IT (Italy)

| **Case** | **Description** |
|----------|-----------------|
| `000`  | Status Information QueueIT |
| `001`  | TBD passthrough from RT device |
| `002`  |  |
| `003`  |  |


#### ES (Spain)

| **Case** | **Description** |
|----------|-----------------|
| `000`  | Status Information QueueES |
| `001`  |  |
| `002`  |  |
| `003`  |  |
