---
slug: /poscreators/middleware-doc/austria/receipt-case-definitions
title: Receipt Case Definitions
---

# Receipt Case Definitions

This chapter expands on the definitions of Receipt Cases covered in Chapter ["Receipt Case Definitions"](../../general/receipt-case-definitions/receipt-case-definitions.md) of the General Part, with country-specific information applicable to the Austrian market.

It describes only the business cases whose handling differs in Austria. The receipts an Austrian integration has to send are listed in [What your POS system has to implement](../cash-register-integration/cash-register-integration.md#what-your-pos-system-has-to-implement): the [basic receipts](../cash-register-integration/cash-register-integration.md#basic-receipts) of everyday business, including void and refund, and the [operational receipts](../cash-register-integration/cash-register-integration.md#operational-receipts) the RKSV requires - [Startbeleg](../cash-register-integration/cash-register-integration.md#start-receipt-initial-receipt), [Nullbeleg](../cash-register-integration/cash-register-integration.md#zero-receipt), [Monatsbeleg](../cash-register-integration/cash-register-integration.md#monthly-receipt), [Jahresbeleg](../cash-register-integration/cash-register-integration.md#annual-receipt) and [Schlussbeleg](../cash-register-integration/cash-register-integration.md#stop-receipt-closing-receipt) - each with its `ftReceiptCase`, when it is issued and a sample. The Sammelbeleg is not listed separately: it is a Nullbeleg, see [End of Failure Receipt (Collective Failure Report)](../cash-register-integration/cash-register-integration.md#end-of-failure-receipt-collective-failure-report). The Austrian terms used below are defined in [Terminology](../terminology/terminology.md).

Delivery notes and agency business have no Austrian specifics; they are described in ["Delivery Note"](../../general/receipt-case-definitions/receipt-case-definitions.md#delivery-note) and ["Agency Business"](../../general/receipt-case-definitions/receipt-case-definitions.md#agency-business) of the General Part, and a [delivery note sample](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_DeliveryNote_1) for the Austrian market is published on the Developer portal.

The case values on this page are the PosSystem API (v2) tagging values documented in [Type of service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md#s---type-of-service) and [Type of payment: ftPayItemCase](../reference-tables/type-of-payment-ftpayitemcase.md#pp---payment-type), where `S` is the type of service and `PP` the payment type of the respective format. If your integration still uses the v0 interface, the [Migration guide](../../possystem-api/migration-guide.md) lists the corresponding v0 values for the Austrian market. The samples linked below open in the [fiskaltrust Developer portal](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign) with the Austrian market preselected and show the receipt request for each case.

## Voucher Service/Product (Einzweckgutschein)

The issuance is a process with RKSV requirement and determines the time of sale. The redemption of a voucher, and thus the distribution of the goods, constitutes a process without RKSV requirement but has to be recorded according to §131 BAO.

The voucher is a charge item `S=4` (voucher) with the VAT rate of the goods or service it is good for.

Samples: [issuing a single purpose voucher](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_SinglePurposeVoucher_1), [redeeming a single purpose voucher](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_SinglePurposeVoucher_2).

## Voucher Value (Mehrzweckgutschein)

A voucher with a specific value constitutes a means of payment, and its issuance is thus a process without RKSV requirement. Once a business transaction is made and paid for by redeeming a voucher, it constitutes a process with RKSV requirement - therefore, (value) vouchers can usually be found in the pay items block, as a pay item `PP=06` (voucher payment - voucher by money value).

Samples: [issuing a multi purpose voucher](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_MultiPurposeVoucher_1), [redeeming a multi purpose voucher](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_MultiPurposeVoucher_2).

## Tips

Tips are to be divided into two categories: tips that go to the company are regular sales, and tips that do not go to the company but, e.g. to staff, are not. Both are charge items `S=3` (tip) and are distinguished by the VAT rate.

Samples: [sale incl. tip to owner](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_CashSaleReceipt_2), [sale incl. tip to employee](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_CashSaleReceipt_3).
