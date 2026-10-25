---
slug: /poscreators/middleware-doc/general/cash-register-integration/downpayments
title: Downpayments
description: How to record a downpayment with the Downpayment flag of ftChargeItemCase, deduct it on the final receipt or invoice, and reverse it.
tags: [Downpayment, ftChargeItemCase, Invoice, Refund, Cash Register Integration]
---

# Downpayments

A downpayment is money the customer pays before the goods are delivered or the service is provided. The fiskaltrust.Middleware records it as a charge item with the flag `Downpayment` (`0x0000_0000_0008_0000`) in `ftChargeItemCase`, first when the downpayment is received and again when it is deducted from the final receipt or invoice.

This page describes how the POS system records downpayments in the data model. Which VAT rate a downpayment carries, and when VAT is due on it, is a tax decision: the Middleware takes the VAT rate and the type of service from the charge item as the POS system sends it. Which receipts may contain a negative downpayment item is market specific; see [Market-specific considerations](#market-specific-considerations).

## Overview

| Step | `ftReceiptCase` | Downpayment charge item |
|------|-----------------|-------------------------|
| [Receiving the downpayment](#receiving-a-downpayment) | Point-of-sale receipt (`0001`) or invoice (`1001`, `1002`, `1003`) | Flag `Downpayment`, positive amount |
| [Deducting the downpayment](#deducting-the-downpayment) on the final receipt or invoice | The same as for the sale | Flag `Downpayment`, negative amount, next to the goods or services sold |
| [Reversing the downpayment](#reversing-a-downpayment), for example when the order is cancelled | Like the original receipt, with the flag of the correction | Flag `Downpayment` together with `IsVoid` or `IsReturn/IsRefund` |

*Table 1. The steps of a downpayment and how they are recorded.*

The flag is described in [gggg - Global tagging/flags](../reference-tables/reference-tables.md#gggg---global-taggingflags-1) of `ftChargeItemCase`: a positive amount creates a downpayment, a negative amount reduces it, and `IsVoid` or `IsReturn/IsRefund` invert this behavior. In the examples on this page, `CCCC` stands for the country code of the queue.

## Receiving a downpayment

The POS system sends the downpayment as a charge item with:

- the flag `Downpayment` in `ftChargeItemCase`,
- the type of service (`S`) and VAT rate (`V`) that apply to the downpayment, together with the matching `VATRate`,
- a positive `Amount`,

and a pay item for the money received. If the downpayment covers goods or services with different VAT rates, the POS system sends one downpayment charge item per VAT rate.

On an invoice, every downpayment charge item also carries the expected date of the delivery or service in `Moment`. eInvoicing requires it; for more information, see [Downpayments in eInvoicing](../../e-invoicing/overview.md#downpayments).

## Deducting the downpayment

The final receipt or invoice lists the goods or services sold with their full amounts and deducts the downpayment with a downpayment charge item with a negative `Amount`. The receipt total, and therefore the sum of the pay items, is what the customer still has to pay.

The deducting item uses the same type of service and VAT rate as the downpayment it reduces. A negative downpayment item is not a discount and is not sent with the flag `Discount`; for more information, see [Discounts and Extras](discounts-and-extras.md#discounts-vouchers-and-other-price-reductions).

### Example

The example is taken from the business case `SignRequestReceipt_Downpayment`. Both receipts are point-of-sale receipts and are paid in cash.

The customer pays a downpayment of 120.00:

| Line | `Amount` | Case |
|------|---------:|------|
| Downpayment (charge item) | 120.00 | `0xCCCC_2000_0008_0013` |
| **Cash** (pay item) | 120.00 | `0xCCCC_2000_0000_0001` |

*Table 2. The downpayment, with `ftReceiptCase` `0xCCCC_2000_0000_0001`.*

On the final receipt, the goods cost 1,200.00 and the downpayment is deducted:

| Line | `Amount` | Case |
|------|---------:|------|
| Goods (charge item) | 1,200.00 | `0xCCCC_2000_0000_0013` |
| Downpayment (charge item) | -120.00 | `0xCCCC_2000_0008_0013` |
| **Cash** (pay item) | 1,080.00 | `0xCCCC_2000_0000_0001` |

*Table 3. The final receipt, with `ftReceiptCase` `0xCCCC_2000_0000_0001`.*

## Reversing a downpayment

A receipt or invoice with a downpayment is voided or refunded like any other receipt, for example with a full refund when the order is cancelled and the downpayment is paid back. The downpayment charge item is inverted together with the other items; combined with `IsVoid` or `IsReturn/IsRefund`, the meaning of its sign is inverted as well. For more information, see [Refunds and Voids](refunds-and-voids.md).

## Market-specific considerations

The model on this page is the interface default. Markets add constraints, depending on what the national format and the fiscal device or service can represent. Before implementing, consult the market pages for:

- whether a negative downpayment item is accepted outside a void, full refund, partial refund or exchange; for the rule, see [Rules applied by the Middleware](refunds-and-voids.md#rules-applied-by-the-middleware),
- which receipt cases accept downpayments.

## Related pages

- [Discounts and Extras](discounts-and-extras.md)
- [Refunds and Voids](refunds-and-voids.md)
- [eInvoicing](../../e-invoicing/overview.md)
- [Reference Tables](../reference-tables/reference-tables.md): `ftChargeItemCase` values and flags
- [Data Structures](../data-structures/data-structures.md#chargeitem): `ChargeItem`
