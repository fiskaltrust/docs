---
slug: /poscreators/middleware-doc/general/cash-register-integration/discounts-and-extras
title: Discounts and Extras
description: How to record discounts and extras (surcharges) on a receipt with the Discount flag of ftChargeItemCase, including percentage discounts, multi-buy offers, discounts in refunds and voids, and how they differ from vouchers.
tags: [Discount, Extra, Surcharge, ftChargeItemCase, Cash Register Integration]
---

# Discounts and Extras

A discount reduces the price of a position on the receipt, an extra (surcharge) increases it. In the fiskaltrust.Middleware data model, neither is recorded by changing the price of the position. The POS system sends the position with its regular price and adds a separate charge item for the discount or extra directly after it. This charge item carries the flag `Discount` (`0x0000_0000_0004_0000`) in `ftChargeItemCase`, which marks it as a discount or extra for the previous position.

This page describes how the POS system records discounts and extras, and which rules the Middleware applies. Whether extras are allowed and how discounts are reported to the authorities is market specific; see [Market-specific considerations](#market-specific-considerations).

## Overview

| | Discount | Extra |
|---|----------|-------|
| **Meaning** | Reduces the price of the previous position. | Increases the price of the previous position. |
| **`ftChargeItemCase` flag** | `0004` Discount | `0004` Discount |
| **`Quantity`** | Positive | Positive |
| **`Amount`** | Negative | Positive |
| **Examples** | Percentage discount, staff discount, "buy 3, pay 2" | Surcharge on a position |

*Table 1. Discounts and extras use the same flag; the sign of the amount distinguishes them.*

The flag is part of the global tagging section `gggg` of `ftChargeItemCase`, see [gggg - Global tagging/flags](../reference-tables/reference-tables.md#type-of-service-ftchargeitemcase). In the examples on this page, `CCCC` stands for the country code of the queue.

## Recording a discount or extra

The POS system sends the discount or extra as its own charge item with:

- the flag `Discount` (`0x0000_0000_0004_0000`) set in `ftChargeItemCase`,
- the same type of service and the same VAT rate in `ftChargeItemCase` as the position it belongs to, and the same `VATRate`; for example, a discount on a position with `ftChargeItemCase` `0xCCCC_2000_0000_0013` uses `0xCCCC_2000_0004_0013`,
- a positive `Quantity`,
- a negative `Amount` for a discount, or a positive `Amount` for an extra; `Amount` is the gross amount of the reduction or increase, not the resulting price,
- a `Description` that explains the discount or extra, for example `10% off` or `Staff discount`.

The discount or extra follows directly after the position it belongs to in `cbChargeItems`. If the POS system uses `Position`, it can number the discount as a sub-position of the item, for example `1.1` for a discount on position `1.0`.

The position keeps its regular price; the discount or extra is not deducted from or added to its `Amount`. The receipt total is the sum of all charge items, including the discounts and extras, and must equal the sum of the pay items.

:::info Negative amounts
Outside of voids and refunds, a negative `Amount` on a charge item is only accepted if the item carries the flag `Discount`. Depending on the market, a price reduction sent as a negative charge item without the flag is rejected, see [Rules applied by the Middleware](#rules-applied-by-the-middleware).
:::

## Examples

The discount examples are taken from the business cases `SignRequestReceipt_Discount` and `SignRequestReceipt_CashSaleDiscount`. All positions use the normal VAT rate and are paid in cash.

### Percentage discount on every position

The customer gets 10 % off the whole purchase. Because a discount always belongs to one position, the POS system sends one discount per position:

| `Position` | Description | `Quantity` | `Amount` | `ftChargeItemCase` |
|-----------:|-------------|-----------:|---------:|--------------------|
| 1.0 | Dress | 1 | 150.00 | `0xCCCC_2000_0000_0013` |
| 1.1 | 10% off | 1 | -15.00 | `0xCCCC_2000_0004_0013` |
| 2.0 | Shoes | 1 | 70.00 | `0xCCCC_2000_0000_0013` |
| 2.1 | 10% off | 1 | -7.00 | `0xCCCC_2000_0004_0013` |
| | **Cash** (pay item) | | 193.00 | `0xCCCC_2000_0000_0001` |

*Table 2. A 10 % discount on the whole purchase, sent as one discount per position.*

### Multi-buy offer ("buy 3, pay 2")

The customer buys three dresses and gets the cheapest one for free. The POS system sends all three positions with their regular price and a discount on the free one:

| `Position` | Description | `Quantity` | `Amount` | `ftChargeItemCase` |
|-----------:|-------------|-----------:|---------:|--------------------|
| 1.0 | Dress | 1 | 87.00 | `0xCCCC_2000_0000_0013` |
| 2.0 | Dress | 1 | 95.00 | `0xCCCC_2000_0000_0013` |
| 3.0 | Dress | 1 | 69.00 | `0xCCCC_2000_0000_0013` |
| 3.1 | Buy 3, pay 2 | 1 | -69.00 | `0xCCCC_2000_0004_0013` |
| | **Cash** (pay item) | | 182.00 | `0xCCCC_2000_0000_0001` |

*Table 3. A multi-buy offer, sent as a discount of the full price on one position.*

Whether a discount may reduce a position to zero is market specific; see [Market-specific considerations](#market-specific-considerations).

### Extra on a position

An extra is sent in the same way as a discount, with a positive amount. For example, a surcharge of 2.00 on a position:

| `Position` | Description | `Quantity` | `Amount` | `ftChargeItemCase` |
|-----------:|-------------|-----------:|---------:|--------------------|
| 1.0 | Pizza | 1 | 12.00 | `0xCCCC_2000_0000_0013` |
| 1.1 | Surcharge | 1 | 2.00 | `0xCCCC_2000_0004_0013` |
| | **Cash** (pay item) | | 14.00 | `0xCCCC_2000_0000_0001` |

*Table 4. An extra that increases the price of one position.*

## Discounts on several positions or on the whole receipt

A charge item with the flag `Discount` always belongs to the previous position; the flag has no receipt-level variant. A discount without a preceding position, for example as the first charge item of the receipt, is not handled uniformly across markets, so the POS system always sends it directly after a position. To grant a discount on several positions or on the whole receipt, the POS system distributes it to the positions and sends one discount after each position it applies to, as in [Percentage discount on every position](#percentage-discount-on-every-position).

Distributing the discount to the positions also assigns it to the correct VAT rate. If a receipt contains positions with different VAT rates, each discount uses the VAT rate of its own position, so that the VAT of every rate is reduced by the matching part of the discount.

## Discounts in refunds and voids

In a void or refund, every charge item is inverted, including the discounts and extras. A discount line that was sent with a negative amount is therefore sent with a positive amount in the void or refund, together with the inverted position. Combined with the flag `IsVoid` or `IsReturn/IsRefund` on the charge item, the meaning of the sign is inverted as well, so the positive amount still describes the discount. See [Values in a correction](refunds-and-voids.md#values-in-a-correction).

| Line | Original `Quantity` | Original `Amount` | Correction `Quantity` | Correction `Amount` |
|------|--------------------:|------------------:|----------------------:|--------------------:|
| Dress | 1 | 150.00 | -1 | -150.00 |
| 10% off | 1 | -15.00 | -1 | 15.00 |
| **Cash** (pay item) | 1 | 135.00 | -1 | -135.00 |

*Table 5. A discounted position and its full refund.*

In a partial refund, the POS system sends the returned positions together with their discounts, so that the customer gets back the price that was actually paid. See [Partial refund](refunds-and-voids.md#partial-refund).

## Discounts, vouchers and other price reductions

Not every reduction of the amount to pay is a discount. The following cases have their own types of service or pay items and must not be sent with the flag `Discount`:

| Case | How it is recorded |
|------|--------------------|
| **Multi-purpose voucher** redeemed, for example a gift voucher with a monetary value | Pay item with payment type `06` Voucher. The receipt total is not reduced; the voucher pays for the purchase. |
| **Single-purpose voucher** redeemed, for example a voucher for 2 × coffee | Charge item with type of service `4` Voucher, a negative amount and the flag `ShowInPayments` (`0x0000_0000_8000_0000`), which shows it like a payment and keeps the total amount unreduced. |
| **Downpayment** deducted from the final receipt | Charge item with the flag `Downpayment` (`0x0000_0000_0008_0000`) and a negative amount. |
| **Tip** | Charge item with type of service `3` Tip, or pay item with the flag `IsTip`. |

*Table 6. Price reductions that are not discounts.*

The type of service `4` Voucher and the payment type `06` Voucher are described in the [Reference Tables](../reference-tables/reference-tables.md#type-of-service-ftchargeitemcase). The business cases `SignRequestReceipt_SinglePurposeVoucher` and `SignRequestReceipt_MultiPurposeVoucher` show the sale and the redemption of both voucher types.

## Market-specific considerations

The model on this page is the interface default. Markets restrict it or add constraints, depending on what the national format and the fiscal device or service can represent. Before implementing, consult the market pages for:

- whether extras (positive amounts) are allowed,
- whether a discount may reduce a position to zero, or must be smaller than the position,
- whether the discount must use the same VAT rate as its position,
- how many discounts or extras a single position may carry,
- whether discounts are allowed in refunds and voids,
- market-specific flags, for example the Italian local flags for subtotal discounts and surcharges in [ftChargeItemCase](../../middleware-it-registratore-telematico/reference-tables/type-of-service-ftchargeitemcase.md).

For the market rules, see:

- Greece: [Data Structures](../../middleware-gr/data-structures/data-structures.md#discounts-and-extras)
- Poland: [Data Structures](../../middleware-pl/data-structures/data-structures.md#discounts-and-extras)
- Portugal: charge item validations in [Error Handling](../../middleware-pt/cash-register-integration/error-handling.md#charge-items)

## Rules applied by the Middleware

The Middleware assigns every charge item with the flag `Discount` to the last preceding charge item that is not itself a discount, an extra or a redeemed voucher. Depending on the market, it rejects a request if:

- a charge item has a negative `Quantity` or `Amount` and is neither a discount nor flagged as `IsVoid` or `IsReturn/IsRefund`, in a receipt that is not a void, full refund, partial refund or exchange,
- the discounts that follow a position, together with redeemed vouchers that follow it, exceed the amount of the position; the gross amounts are compared.

Markets can define further rules, for example that extras are not allowed, that a discount uses the same VAT rate as its position, or that a position carries at most one discount or extra. These rules are described on the market pages.

When the request is rejected, the `ReceiptResponse` contains an error state and the error message; see [Error Handling](error-handling.md).

## Related pages

- [Refunds and Voids](refunds-and-voids.md)
- [Reference Tables](../reference-tables/reference-tables.md): `ftChargeItemCase` flags and types of service
- [Data Structures](../data-structures/data-structures.md#chargeitem): `ChargeItem`
