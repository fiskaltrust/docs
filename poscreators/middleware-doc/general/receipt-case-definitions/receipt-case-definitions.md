---
slug: /poscreators/middleware-doc/general/receipt-case-definitions
title: Receipt Case Definitions
description: Definitions of business cases such as POS sales receipt, invoice, single and multi-use vouchers, agency business, downpayment, payment transfer, proforma invoice, delivery note and tips (including tips as pay items).
tags: [Receipt Case, Vouchers, Agency Business, Downpayment, Payment Transfer, Proforma Invoice, Tips, Middleware]
---

# Receipt Case Definitions

The below list is provided to ensure the common understanding of different types of business cases and to facilitate the implementation of their correct handling by the fiskaltrust.Middleware.

## POS Sales Receipt

A POS Sales Receipt can contain multiple and different types of services, items, and payments. POS sales receipt can generate turnover depending on the type of the receipt. A POS sales receipt can optionally, depending on the country's law, support the sum-up for a daily, monthly, yearly, and/or periodically closing, before it is transferred to bookkeeping/accounting.

## Invoice

An Invoice can contain multiple and different types of services, items, and payments. Usually, an invoice includes a detailed information about the customer.

## Voucher for single usage

A voucher for single use is usually a voucher for a single product. The turnover is created and VAT is already known and owed right in the moment of voucher’s sale.

There is no turnover created when the voucher is redeemed. This action is also not relevant to VAT. It is a kind of a hand-out or a delivery note.

## Voucher for multiple usage

A voucher for multiple use is usually a voucher with a value. There is no turnover created when the voucher is handed out.

Turnover is created in the moment when the voucher is redeemed. This is usually done by a POS Sales Receipt using the voucher as a payitem.

## Agency Business

Agency businesses are not own sales but sales made on behalf of a 3<sup>rd</sup> party. Thus, no own sales can be processed on the same receipt as an agency business.

For further information, refer to the appropriate Appendix for the specific country. Not every market supports agency business; whether a market accepts the type of service `6` Not own sales is described in the type of service table of the market.

## Downpayment

A downpayment is money the customer pays before the goods are delivered or the service is provided. It is recorded when it is received and deducted from the final receipt or invoice.

For more information, see [Downpayments](../cash-register-integration/downpayments.md).

## Payment Transfer

A payment transfer moves money without a sale, for example cash taken out of the till or put into it. It creates no turnover and is not sent as a sale with a negative price: the POS system sends it as its own receipt, either with a charge item of the type of service `A` Cash transfer or, where the market supports it, with offsetting pay items only.

For more information, see [Cash Drawer Movements](../cash-register-integration/cash-drawer-movements.md).

## Proforma Invoice

A proforma invoice (`ftReceiptCase` `0007`) is the bill or offer handed to the customer before the sale. It contains the charge items and no payment: the POS system sends `cbPayItems` as an empty array. The Middleware does not compare the sum of the charge items with the sum of the pay items for a proforma invoice.

The sale itself is recorded afterwards with its own receipt or invoice, which can reference the proforma invoice in `cbPreviousReceiptReference`. Whether a market accepts pay items on a proforma invoice and what it does with the reference is described in the receipt case table of the market.

## Delivery Note

A delivery note can not be processed mixed with cash transaction receipts. Delivery notes are indicated with the ftReceiptCase "delivery note" and the individual positions can be annotated with the respective ftChargeItemCase data.

For further information, refer to the appropriate Appendix for the specific country.

## Tips

Tips are to be divided into two categories:

  - Tips that go to the company are normal sales.
  - Tips that do not go to the company, are to be treated like obligations or not own sales in the charge items block.

A tip that does not go to the company can also be sent as a pay item with the flag `IsTip` (`0x0000_0000_0040_0000`) in `ftPayItemCase`. The pay item of the payment contains the whole amount the customer pays, including the tip. The tip pay item follows it directly, with the same payment type and a negative amount, so that the sum of the pay items equals the receipt total. With `Position`, the tip can be numbered as a sub-position of the payment, for example `1.1` for a tip on payment `1`.

For example, the customer pays 67.42 by debit card for a sale of 63.42, of which 4.00 is a tip:

| `Position` | Line | `Amount` | `ftPayItemCase` |
|-----------:|------|---------:|-----------------|
| 1 | **Debit card** (pay item) | 67.42 | `0xCCCC_2000_0000_0004` |
| 1.1 | **Tip** (pay item) | -4.00 | `0xCCCC_2000_0040_0004` |

*Table 1. A tip sent as a pay item, for a receipt total of 63.42.*

For further information, refer to the appropriate Appendix for the specific country.
