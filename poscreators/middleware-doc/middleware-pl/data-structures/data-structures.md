---
slug: /poscreators/middleware-doc/poland/data-structures
title: Data Structures
description: Data structure rules for Poland — mandatory PLN currency on every request, separating return positions from sales, and how discounts and extras are assigned to sale lines.
tags: [Data Structures, Currency, Receipt Case, Discount, Poland]
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Polish market.

## Currency

The queue currency for Poland is **PLN**. The receipt (`Currency`) and every charge item and pay item must carry `PLN` explicitly — the data format defaults to EUR, so POS Creators must set the currency on each request. Requests violating this rule are rejected with the validation error code `CurrencyMustMatchMarket`.

## Sale and return positions

A Polish fiscal document must not mix sale and return positions: the register protocol processes returns as separate non-fiscal documents. Send returns as their own receipts flagged with `IsReturn/IsRefund` (`0x0100_0000_0000`) and reference the original receipt via `cbPreviousReceiptReference`. Discounts/extras and voids are position modifiers, not return positions.

## Discounts and extras

The [POSNET register](../operation-modes/scu/posnet.md) prints a charge item with the flag `Discount` (`0x0000_0000_0004_0000`) as a discount (rabat, negative amount) or an extra (narzut, positive amount) on the sale line it belongs to. In addition to the general rules in [Discounts and Extras](../../general/cash-register-integration/discounts-and-extras.md), the following rules apply. They describe the POSNET SCU, which is in preview; see [Scope of the preview](../operation-modes/scu/posnet.md#scope-of-the-preview).

- **Assignment by `Position`**: if the discount or extra has a `Position`, it belongs to the sale line whose `Position` has the same integer part; for example, `1.1` belongs to position `1`, even if another position was sent in between. A fractional `Position` whose integer part matches no sale line of the receipt is rejected.
- **Assignment by order**: without a `Position`, the discount or extra belongs to the sale line before it.
- **Subtotal discount**: a discount or extra without a `Position` and with no sale line before it applies to the subtotal of the receipt (rabat od podsumy); the register distributes it over the VAT rates of the receipt.
- **One per sale line**: a sale line carries at most one discount or extra. Send several discounts on one position as a single discount, or split the sale into one position per discount.
- **VAT rate**: a discount or extra uses the same VAT rate in `ftChargeItemCase` as the position it belongs to, or no VAT rate (`0`); it is then granted at the rate of the position.
- **Amount**: the amount of a discount or extra is not `0`. A line discount must not exceed the value of its position, and a subtotal discount must be less than the subtotal, because the register cannot print a negative sale line or a receipt with a total of zero or less.
- **Voids**: a discount or extra cannot be voided with `IsVoid`. Send the position with the discount or extra it ends up with. A discount or extra that directly follows the void (storno) of the position it would belong to is rejected; send it after the position, before the void, or name the position in `Position`.
- **Returns**: a return document cannot contain discounts or extras. Send the returned positions with the value that is handed back.
