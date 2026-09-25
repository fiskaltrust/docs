---
slug: /poscreators/middleware-doc/austria/cash-register-integration
title: Cash Register Integration
---

# Cash Register Integration

This chapter describes the cash register integration for the Austrian market. It expands on the [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) chapter of the General Part and documents only what Austrian law (RKSV) adds to it.

What Austria requires of a cash register as a whole - signing cash transactions, keeping and exporting the data collection log, and registering and notifying through FinanzOnline - is described in the [Introduction](../appendix-at-rksv.md). The Austrian terms used below are defined in [Terminology](../terminology/terminology.md). This page covers the part the POS system implements: which receipts it has to send, how the workflows behave, and how the receipt is structured.

## What your POS system has to implement

An Austrian integration consists of two groups of receipts: the **basic receipts** of everyday business, and the **operational receipts** the RKSV requires around them, which are all Nullbelege (zero receipts). Both groups are sent through the same sign call and are distinguished by their `ftReceiptCase`; zero receipts additionally require an empty charge items block and an empty pay items block.

The values below are the PosSystem API (v2) tagging values documented in [Type of receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md) for Austria, and the format they follow (`CCCC_vlll_gggg_txcc`) is explained in the [Reference Tables](../../general/reference-tables/reference-tables.md#type-of-receipt-ftreceiptcase) of the General Part. If your integration still uses the v0 interface, the [Migration guide](../../possystem-api/migration-guide.md) lists the corresponding v0 values for the Austrian market.

### Basic receipts

| Business case | `ftReceiptCase` | Sample |
| --- | --- | --- |
| Sale paid at the point of sale | receipt case `0001` (POS receipt) | [Cash sale](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_CashSaleReceipt_1) |
| Void of a receipt issued before | flag `0004` (IsVoid), with the line items marked as void as well; the receipt is annotated "STO" in the signature block | [Void](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_VoidReceipt_1) |
| Refund or return of goods and services | flag `0100` (IsReturn/IsRefund) | [Refund of an earlier receipt](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_CashSaleRefund_1), [refund without reference](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_CashSaleRefund_3) |
| Training booking, annotated "TRA" and not counted towards the cumulative sales counter (Umsatzzähler) | flag `0002` (training receipt) | - |
| Receipts recorded while the fiskaltrust.Middleware was unreachable and sent later | flag `0001` (late signing), closed with an [end of failure receipt](#end-of-failure-receipt-collective-failure-report) | - |
| Handwritten receipt entered afterwards | flag `0008` (handwritten receipt) | - |
| Delivery note, vouchers, agency business, tips | see [Receipt Case Definitions](../receipt-case-definitions/receipt-case-definitions.md) | - |

*Table 1. Basic receipt cases an Austrian integration has to cover.*

### Operational receipts

| Receipt | `ftReceiptCase` | Issued | Sample |
| --- | --- | --- | --- |
| [Start receipt](#start-receipt-initial-receipt) (Startbeleg) | receipt case `4001` | when the signature creation unit and the cash register have been registered with FinanzOnline | [Start receipt](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_StartReceipt_1) |
| [Zero receipt](#zero-receipt) (Nullbeleg) | receipt case `2000` | to check operability, to collect a service status and to end a failure state | [Zero receipt](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_ZeroReceipt_1) |
| [Monthly receipt](#monthly-receipt) (Monatsbeleg) | receipt case `2012` | before the beginning of a new monthly period | [Monthly closing](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_MonthlyClosing_1) |
| [Annual receipt](#annual-receipt) (Jahresbeleg) | receipt case `2013` | at the end of the calendar year, replacing that month's monthly receipt | [Yearly closing](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_YearlyClosing_1) |
| [Stop receipt](#stop-receipt-closing-receipt) (Schlussbeleg) | receipt case `4002` | on scheduled decommissioning of the cash register or the security mechanism | [Stop receipt](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_StopReceipt_1) |

*Table 2. Operational receipts required by the RKSV.*

The start receipt and the annual receipt must also be validated with FinanzOnline, and a failure of the signature creation device lasting longer than 48 hours as well as the deregistration of a signature creation unit or a queue must be notified there. These validations and notifications are not sent by the POS system: they are handled in the fiskaltrust.Portal, automatically with a fiskaltrust.Carefree or Notification subscription, see [FinanzOnline Management](../../../../posdealers/buy-resell/products/3rd-party/finanzonline-management.md).

:::tip Try the samples

Every sample above opens in the [fiskaltrust Developer portal](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign) with the Austrian market preselected, and can be sent against the sandbox from there. Demo implementations in several languages and a Postman collection are linked in [Communication](../../general/communication/communication.md) of the General Part.

:::

## Receipt Creation Process

This chapter describes the general process of creating receipts with fiskaltrust.Middleware and its workflow, following the Austrian law.

### The fiskaltrust.SecurityMechanism

The regular workflow of the fiskaltrust.SecurityMechanism in the Austrian market defines the steps required for the creation of a receipt as follows:

  - assign a sequential receipt number
  - increase the cumulative sales counter (Umsatzzähler) according to the RKSV
  - encrypt the cumulative sales counter with the AES key
  - create a signature
  - create machine-readable code according to the RKSV and
  - create all other necessary receipts
  - save all data

## Receipt for special functions

This section describes receipt types used for special functions on the Austrian market and expands on the descriptions from the Chapter ["Receipt for special functions"](../../general/cash-register-integration/cash-register-integration-regular-workflow.md#receipt-for-special-functions) of the general part.

In accordance with §131b para. 2 BAO and the RKSV, as per 1.1.2017 (now 1.4.2017), each transaction receipt needs to be cryptographically signed with a signature creation device assigned to the taxpayer, to guarantee the immutability of the recording. In addition to these receipts, several other requirements are stated by the RKSV which can be met by creating the following receipts with special functions.

### Zero Receipt

A zero receipt is a cash transaction recorded with amount zero, described in general terms in ["Zero Receipt"](../../general/cash-register-integration/cash-register-integration-regular-workflow.md#zero-receipt) of the general part. In Austria, all receipts described in this section are zero receipts (Nullbelege): the start, monthly, annual, end of failure and stop receipt. All of these have specific ftReceiptCase IDs so they can be distinguished.

### Start Receipt (Initial Receipt)

When a POS (more specifically: a new Queue) is put into operation, an initial receipt must be created and validated by Finanzonline. The Queue will only start signing, once an initial receipt is created. Such validation can be done automatically by fiskaltrust when the appropriate product is purchased and Finanzonline Access set up or directly with Finanzonline. The validation will check if the Queue (ftCashboxIdentification and AES Key) and SCU (Serial Number and VDA) used are registered with this data in the PosOperators Finanzonline account.

The PosOperator must archive this receipt.
When the receipts are uploaded to the fiskaltrust.Portal and an appropriate product has been purchased, the receipt will be available via the fiskaltrust.Portal for audits.

### Stop Receipt (Closing Receipt)

In case of a scheduled decommissioning of a POS (a Queue), the RKSV requires a generation of a closing receipt. The closing receipt concludes the data collection log (RKSV-DEP) and has to be archived.

After sending a closing receipt to the fiskaltrust.Middleware, the Queue will not sign any receipts anymore.The Queue must be deregistered in Finanzonline, a corresponding notification is created with the closing receipt and will be automatically sent to Finanzonline, if the appropriate product is purchased and Finanzonline Access set up. Only the decommissioning of the queue will be notified, if the SCU should be decomissioned too, this has to be done manually or via the remove SCU workflow in the ft.Portal. 

Once the queue has been closed with a stop receipt, no hashing and signing of receipts will be done for that queue. This cannot be reversed.

### End of Failure Receipt (Collective Failure Report)

If, for technical reasons, signatures cannot be created by the fiskaltrust.SecurityMechanism, receipts need to be issued (according to the RKSV) and marked with a comment "security mechanism failed". Once the technical failure has been resolved, a signed collective receipt must be issued to make up for the signature linking of all receipts issued during the technical failure.

Outages that exceed 48 hours must be notified to FinanzOnline. This can be done automatically with a fiskaltrust.Carefree or Notification subscription, see [FinanzOnline Management](http://localhost:3000/docs/posdealers/buy-resell/products/3rd-party/finanzonline-management). Find more details on possible Failure Scenarios and handling in the Chapter "[Failure Scenarios](https://docs.fiskaltrust.cloud/docs/poscreators/middleware-doc/general/cash-register-integration/failure-scenarios)" of the general part

### Monthly Receipt

Before the beginning of a new monthly period, the preliminary result of the cumulative sales counter (monthly counter) has to be recorded accordingly to §8 Abs 2 RKSV. The POS can request this by sending a monthly receipt request to the fiskaltrust.Middleware. The running sales counter is sent back to the POS within the signature items block in an unencrypted format.

### Annual Receipt

Before the beginning of a new annual period, the PosOperator must note the counter reading in accordance with §8 para. 3 RKSV. This procedure replaces the monthly receipt at the end of the year. The annual receipt must be validated by FinanzOnline. With a fiskaltrust.Carefree or Notification subscription, the check is processed automatically. Otherwise, the PosOperator can do it manually through the [BMF apps](https://www.bmf.gv.at/services/apps.html).

### Signature Block

If a cryptographic signature is required by §131b para. 2 BAO the signature block is generated by the fiskaltrust.SecurityMechanism. This includes receipt signature as required by RKSV, information about the signature format, and potential further details such as references to training or reverse posting, or an operational failure of the signature creation device. The cash register should contain the signature block between the Pay Items block and the Receipt Footer.

## Data Collection Log

The RKSV defines the following logging features as obligatory for cash registers. The corresponding journal call is described in [RKSV-DEP Export](../function-structures/function-structures.md#rksv-dep-export); the records must be retained for seven years (§132 BAO), and how the PosOperator creates those exports in case of an audit is described in [Exports](../../../../posdealers/technical-operations/maintenance/exports.md) and [Revision-safe archiving](../../../../posdealers/buy-resell/products/revision-safe-archiving.md).

### Data Collection Log according to RKSV (DEP 7)

The fiskaltrust.Middleware autonomously manages the RKSV-DEP. We recommend saving the values returned from the fiskaltrust.Middleware in the cash register's database. 

Data from the data collection log can also be provided in the form of a data stream, following the format specified by the RKSV.

When using the fiskaltrust.Carefree package, the DEP-7 is stored legally compliant in a revision-safe archive and is available in the fiskaltrust.Portal for the required seven years.

### Data Collection Log according to §131 para. 1 Z 6 b BAO (E131-DEP)

With the fiskaltrust.Carefree package, the E131-DEP is stored in a revision-safe archive and is available for export in the fiskaltrust.Portal for the seven years required by §132 BAO.
