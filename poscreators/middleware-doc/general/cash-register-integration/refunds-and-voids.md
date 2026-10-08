---
slug: /poscreators/middleware-doc/general/cash-register-integration/refunds-and-voids
title: Refunds and Voids
description: How to void a receipt, refund a receipt in full or in part, exchange goods, and void single positions, using the IsVoid and IsReturn/IsRefund flags and cbPreviousReceiptReference.
tags: [Refund, Partial Refund, Exchange, Void, Return, cbPreviousReceiptReference, Receipt Case, Cash Register Integration]
---

# Refunds and Voids

Data sent to the fiskaltrust.Middleware cannot be changed or deleted afterwards. A completed receipt is therefore never corrected in place: every correction is a new receipt that contains the inverted values and, where possible, references the original receipt (see [Referenced and unreferenced refunds](#referenced-and-unreferenced-refunds)). Only a [position void](#position-void) corrects a line within the receipt that is still being created.

This page describes the corrections that the data model supports, how the POS system marks them, and which rules the Middleware applies. Which corrections are permitted in a country, and how they are reported to the authorities, is market specific; see the reference tables and data structures of the respective market.

## Overview

| Correction | Use case | `ftReceiptCase` flag | `ftChargeItemCase` flag | `ftPayItemCase` flag | `cbPreviousReceiptReference` |
|------------|----------|----------------------|-------------------------|----------------------|------------------------------|
| [Void](#void) | Cancel a complete receipt before goods and money were exchanged, usually because of a technical problem. | `0004` IsVoid | `0001` IsVoid | `0001` IsVoid | Single reference for a receipt of the same queue; otherwise an [external reference](#referenced-refund-with-an-external-reference), depending on the market |
| [Full refund](#full-refund) | Give back everything that was bought and get all of the money back. | `0100` IsReturn/IsRefund | Optional, ignored | Optional, ignored | Single reference for a receipt of the same queue; otherwise external or none, depending on the market |
| [Partial refund](#partial-refund) | Give back a part of the original receipt and get back a part of the money. | none | `0002` IsReturn/IsRefund on all items | `0002` IsReturn/IsRefund on all items | Single reference for a receipt of the same queue; otherwise external or none, depending on the market |
| [Exchange](#exchange) | Give back something and get another product for it. | none | `0002` IsReturn/IsRefund on the returned items only | `0002` IsReturn/IsRefund on the paid-back items only | Single reference for a receipt of the same queue; otherwise external or none, depending on the market |
| [Position void](#position-void) | Cancel a position within the receipt that is being created. | none | `0001` IsVoid on the correcting item | none | none |

*Table 1. Corrections supported by the data model and the flags they use.*

The flags are part of the global tagging section `gggg` of the case values, see [Reference Tables](../reference-tables/reference-tables.md). In the examples on this page, `CCCC` stands for the country code of the queue.

## Void or refund

Voiding and refunding both reverse a previously recorded transaction, but they describe different business cases and use different flags. A **void** cancels a receipt as if the business case had not happened. A **refund/return** records a new business case that offsets an earlier, already paid sale; the original receipt stays on record. Choosing the wrong flag produces a receipt that passes validation but misrepresents the business case in the fiscal records.

The deciding question is: **have goods and money already been exchanged?** A void is only used when neither the goods nor the money have changed hands. This is usually the case when the cashier notices a technical problem. The pay item flags define it the same way: `IsVoid` is used when the exchange of money has not been executed yet, `IsReturn/IsRefund` when it has already been executed.

| | Void | Refund / Return |
|---|------|-----------------|
| **Meaning** | Cancels or corrects a receipt as if the business case had not happened. | Reverses a completed sale: goods or services are given back after the fact. |
| **Goods and money already exchanged?** | No, neither the goods nor the money have changed hands. | Yes, the customer already received the goods or service and paid, and is paid back. |
| **Typical trigger** | A technical problem that the cashier notices. | The customer returns a purchased product, or a service is refunded. |
| **Relates to** | The receipt or position that is being corrected. | An earlier, already closed sale. |

*Table 2. Differences between a void and a refund/return.*

:::tip Rule of thumb
Goods and money not yet exchanged → **Void**. Goods or money already exchanged → **Refund/Return**. If you are not sure whether a case is a void or a refund, use a **refund**.
:::

### Decision flow

1. **Have goods and money already been exchanged?**
   - **No**: this is a [void](#void) (`IsVoid`).
   - **Yes**, or **not sure**: continue with step 2.
2. **Are goods or services given back, or a paid service reversed?**
   - **Yes**: this is a [full refund](#full-refund), a [partial refund](#partial-refund) or an [exchange](#exchange) (`IsReturn/IsRefund`), see [Full refund, partial refund or exchange](#full-refund-partial-refund-or-exchange).
   - **No**, for example a pure correction of an already settled receipt: follow the market-specific correction rules, see [Market-specific considerations](#market-specific-considerations).

### Full refund, partial refund or exchange

Where the `IsReturn/IsRefund` flag is set decides how the Middleware interprets the receipt:

| Business case | `ftReceiptCase` | Charge items and pay items |
|---------------|-----------------|----------------------------|
| [Full refund](#full-refund): everything that was bought is given back, and all of the money is paid back. | `IsReturn/IsRefund` set | All items of the original receipt, inverted. Item flags are optional and ignored. |
| [Partial refund](#partial-refund): only a part of the original receipt is given back, and only a part of the money is paid back. | No flag | Only the returned items, all flagged with `IsReturn/IsRefund`. |
| [Exchange](#exchange): something is given back, and another product is taken in exchange. | No flag | A mix of items with and without `IsReturn/IsRefund`. Not allowed in many markets. |

*Table 3. How the position of the IsReturn/IsRefund flag distinguishes full refund, partial refund and exchange.*

## Values in a correction

In a void or refund, **both** quantity and amount of every charge item and pay item are always the **inverse** of the original item: each value is multiplied by -1. Inverted does not mean negative: a value that was positive in the original receipt is negative in the correction, and a value that was negative in the original receipt is positive in the correction.

### Quantity and amount

`Quantity` and `Amount` are two separate values with different meanings:

- `Quantity` is the quantity of the line item, i.e. the goods or services that move.
- `Amount` is the total amount of the line item, i.e. the money that moves.

Because they describe different things, their signs do not have to match. A discount line, for example, has a positive quantity and a negative amount, and a deposit return has a negative quantity and a negative amount. The correction therefore must not simply set both values to negative; it inverts each of them on its own:

| Line | Original `Quantity` | Original `Amount` | Correction `Quantity` | Correction `Amount` |
|------|--------------------:|------------------:|----------------------:|--------------------:|
| Coffee | 2 | 6.00 | -2 | -6.00 |
| Discount | 1 | -1.00 | -1 | 1.00 |
| Deposit return (`Returnable`) | -3 | -0.75 | 3 | 0.75 |
| **Cash** (pay item) | 1 | 4.25 | -1 | -4.25 |

*Table 4. Quantity and amount of a receipt and of its void or full refund: each value is inverted.*

The flags `Discount`, `Downpayment` and `Returnable` of a charge item define the meaning of a positive and a negative amount. Combined with `IsVoid` or `IsReturn/IsRefund`, this meaning is inverted, so a discount on a refunded item is sent with a positive amount. See [gggg - Global tagging/flags](../reference-tables/reference-tables.md#type-of-service-ftchargeitemcase) of `ftChargeItemCase`.

## Void

A void cancels a complete receipt before goods and money were exchanged. It is usually only used when the cashier notices a technical problem. If it is not clear whether goods or money have already been exchanged, use a [full refund](#full-refund) or [partial refund](#partial-refund) instead. The POS system sends a new receipt with:

- the same `ftReceiptCase` as the original receipt, with the flag `IsVoid` (`0x0000_0000_0004_0000`) set,
- if the original receipt was processed by the same queue, `cbPreviousReceiptReference` set to its `cbReceiptReference`; otherwise see [Referenced and unreferenced refunds](#referenced-and-unreferenced-refunds),
- all charge items and pay items of the original receipt with inverted quantity and amount, marked with the flag `IsVoid` (`0x0000_0000_0001_0000`).

A receipt can only be voided once, and a voided receipt can no longer be referenced by other receipts (see [Rules applied by the Middleware](#rules-applied-by-the-middleware)).

**Example**: Because of a technical problem, the POS system records a receipt for 2 × coffee, although the customer has neither paid nor received anything yet. The cashier notices the problem. The POS system voids the receipt: it sends the same receipt again with quantity `-2`, `IsVoid` set on the receipt and the charge item, and `cbPreviousReceiptReference` pointing to the erroneous receipt. It then issues a correct receipt for the sale.

## Full refund

In a full refund, the customer gives back everything they bought and gets all of their money back. As soon as the flag `IsReturn/IsRefund` is set in `ftReceiptCase`, the Middleware treats the receipt as a full refund and assumes that all charge items and pay items of the original receipt are reversed. The POS system sends a new receipt with:

- the same `ftReceiptCase` as the original receipt, with the flag `IsReturn/IsRefund` (`0x0000_0000_0100_0000`) set,
- if the original receipt was processed by the same queue, `cbPreviousReceiptReference` set to its `cbReceiptReference`; otherwise see [Referenced and unreferenced refunds](#referenced-and-unreferenced-refunds),
- all charge items of the original receipt with inverted quantity and amount,
- the pay items for the money paid back, with inverted amounts.

The POS system may also set the flag `IsReturn/IsRefund` (`0x0000_0000_0002_0000`) on the charge items and pay items, but the Middleware ignores these item flags in a full refund. The sum of the charge items must equal the sum of the pay items, as in every receipt.

**Example**: A customer bought a jacket last week (paid, receipt closed) and returns it today. The POS system sends a full refund with quantity `-1` and the negative amount for the jacket, a negative cash pay item, `IsReturn/IsRefund` set in `ftReceiptCase`, and `cbPreviousReceiptReference` pointing to the original sale. The money is paid back to the customer.

A refund does not always have an electronic link to the original receipt; see [Referenced and unreferenced refunds](#referenced-and-unreferenced-refunds).

## Partial refund

In a partial refund, the customer gives back only a part of the original receipt (some of the items, or a smaller quantity than was sold) and therefore gets back only a part of the money. The receipt itself is not flagged; the flag is set on the items instead. The POS system sends a new receipt with:

- the `ftReceiptCase` of a regular receipt, **without** the receipt flag `IsReturn/IsRefund`,
- if the original receipt was processed by the same queue, `cbPreviousReceiptReference` set to its `cbReceiptReference`; otherwise see [Referenced and unreferenced refunds](#referenced-and-unreferenced-refunds),
- only the returned charge items, with inverted quantity and amount and the flag `IsReturn/IsRefund`,
- the pay items for the money paid back, with inverted amounts and the flag `IsReturn/IsRefund`.

All charge items and pay items of a partial refund carry the flag. A receipt that mixes flagged and unflagged items is an [exchange](#exchange).

A receipt can be partially refunded several times, for example when a customer returns items on different days. Each partial refund references the original receipt.

### Example

The original receipt with `cbReceiptReference` `R-1001` contains two items and was paid in cash:

| Item | `Quantity` | `Amount` | `ftChargeItemCase` |
|------|-----------:|---------:|--------------------|
| Coffee | 2 | 6.00 | `0xCCCC_2000_0000_0013` |
| Cake | 1 | 4.00 | `0xCCCC_2000_0000_0013` |
| **Cash** (pay item) | 1 | 10.00 | `0xCCCC_2000_0000_0001` |

*Table 5. Original receipt `R-1001` with `ftReceiptCase` `0xCCCC_2000_0000_0001`.*

The customer returns one coffee. The partial refund keeps the `ftReceiptCase` `0xCCCC_2000_0000_0001`, sets `cbPreviousReceiptReference` to `R-1001`, and contains only the returned coffee:

| Item | `Quantity` | `Amount` | `ftChargeItemCase` |
|------|-----------:|---------:|--------------------|
| Coffee | -1 | -3.00 | `0xCCCC_2000_0002_0013` |
| **Cash** (pay item) | -1 | -3.00 | `0xCCCC_2000_0002_0001` |

*Table 6. Partial refund of one coffee from receipt `R-1001`.*

If the customer returned both coffees and the cake instead, the POS system would send a [full refund](#full-refund) with the receipt flag `IsReturn/IsRefund` (`ftReceiptCase` `0xCCCC_2000_0100_0001`) and all three items inverted.

## Exchange

In an exchange, the customer gives back something and gets another product for it. The receipt itself is not flagged. It contains a mix of charge items with the flag `IsReturn/IsRefund` (the returned goods, with inverted quantity and amount) and charge items without the flag (the new goods). The same applies to the pay items: pay items for money paid back carry the flag, pay items for money received do not.

:::warning
An exchange is not allowed in many markets. There, the POS system sends the return and the new sale as separate receipts: a [partial refund](#partial-refund) or [full refund](#full-refund) for the returned goods, and a regular receipt for the new goods. See the market pages.
:::

## Referenced and unreferenced refunds

A refund, partial refund or exchange can be linked to the original receipt in different ways, depending on where the original receipt was issued and what the POS system knows about it. The same reference mechanisms apply to a void.

| Type | Original receipt | How it is referenced | Also known as |
|------|------------------|----------------------|---------------|
| [Referenced refund](#referenced-refund) | Processed by the same queue. | `cbPreviousReceiptReference` | Linked refund, return with receipt |
| [Referenced refund with an external reference](#referenced-refund-with-an-external-reference) | Issued by another device or system, for example another cash register in the same store. | Market-specific reference data in `ftReceiptCaseData` | Cross-device or cross-store return |
| [Manually referenced refund](#manually-referenced-refund) | Handed to the customer, for example on paper, but not available for an electronic link. | Depending on the market, the data printed on the original receipt | Return with paper receipt |
| [Unreferenced refund](#unreferenced-refund) | Unknown, or no receipt at all. | None | Unlinked refund, blind refund, return without receipt |

*Table 7. Ways to reference the original receipt in a refund.*

### Referenced refund

The original receipt was processed by the same queue. The POS system sets `cbPreviousReceiptReference` to the `cbReceiptReference` of the original receipt. This is the preferred way of referencing, because the Middleware can check the reference:

- It looks up the original receipt in the queue. Receipts that were answered with an error state are ignored.
- It rejects the request if no receipt or more than one receipt matches the reference, see [Rules applied by the Middleware](#rules-applied-by-the-middleware).
- Depending on the market, the `ReceiptResponse` returns the request and the response of the referenced receipt in `ftStateData`, and the Middleware uses the data of the original receipt, for example its signatures or document numbers, for the national reporting of the refund.

### Referenced refund with an external reference

The original receipt was issued by another device or system, for example by another cash register or fiscal printer in the same store, and therefore cannot be found via `cbPreviousReceiptReference`. Depending on the market, the POS system passes the data that identifies the original receipt in `ftReceiptCaseData`, for example the identifier of the issuing device and the document number. The structure of this data is market specific and described in the data structures of the respective market. Markets that do not define such a structure do not support external references.

### Manually referenced refund

The customer brings back a receipt that was handed to them, for example a printed or handwritten receipt, but the receipt is not available for an electronic link. Depending on the market:

- the original document is recorded in the Middleware first, for example as a handwritten receipt, and the refund then references it via `cbPreviousReceiptReference`, or
- the data printed on the original receipt is passed as an [external reference](#referenced-refund-with-an-external-reference).

If the market supports neither, the refund is an [unreferenced refund](#unreferenced-refund).

### Unreferenced refund

The refund has no reference to an original receipt, for example a goodwill refund or a return without a receipt. There is no separate flag for an unreferenced refund: it is a refund without `cbPreviousReceiptReference` and without an external reference. Whether unreferenced refunds are allowed is market specific: some markets reject them, others accept them and report them as a separate document type. Depending on the market, a void always requires a reference.

## Position void

A position void cancels a position within the receipt that is currently being created, for example an item that was scanned by mistake. It does not reference another receipt. The receipt contains the original position and a correcting charge item with inverted quantity and amount, marked with the flag `IsVoid` (`0x0000_0000_0001_0000`), which marks it as void of the previous position.

## Other corrections

- **Returnables (deposit)**: Charge items with the flag `Returnable` (`0x0000_0000_0010_0000`) use a positive amount for the handout and a negative amount for the return, for example of empty bottles. A deposit return is therefore a negative `Returnable` item, not a refund. Depending on the market, a negative `Returnable` item is only accepted in a void, full refund, partial refund or exchange, see [Rules applied by the Middleware](#rules-applied-by-the-middleware).
- **Downpayments**: A downpayment is reduced with a negative `Downpayment` charge item (`0x0000_0000_0008_0000`); see [Reference Tables](../reference-tables/reference-tables.md#type-of-service-ftchargeitemcase). Depending on the market, a negative `Downpayment` item is only accepted in a void, full refund, partial refund or exchange, see [Rules applied by the Middleware](#rules-applied-by-the-middleware).
- **Handwritten receipts**: A refund that is itself recorded with the flag `Process as Handwritten Receipt` (`0x0000_0000_0008_0000`) does not require `cbPreviousReceiptReference`. Depending on the market, combining the handwritten flag with a void or refund is not allowed; see the market pages.
- **Card payments**: For payments processed through the fiskaltrust payment endpoint, see [Payment](../../experience-middleware/payment.md#payment-service-provider-psp-feature-matrix) for the refund and cancel operations supported per payment service provider.
- **Original receipt from another device or system**: see [Referenced refund with an external reference](#referenced-refund-with-an-external-reference).

## Market-specific considerations

The model on this page is the interface default. National fiscalization law can restrict these operations, rename them or add constraints. Before implementing, consult the market pages for:

- whether unreferenced refunds are permitted, and under which conditions,
- mandatory references to the original document when the source receipt was processed in a different queue or system,
- the document types and reference lines required on the printed receipt,
- time limits or approval requirements for voids and refunds.

See the country-specific guides, for example [Austria (RKSV)](../../middleware-at-rksv/appendix-at-rksv.md), [Germany (KassenSichV)](../../middleware-de-kassensichv/appendix-de-kassensichv.md) and [France](../../middleware-fr-boi-tva-decla-30-10-30/appendix-fr-boi-tva-decla-30-10-30.md).

## Rules applied by the Middleware

The Middleware looks up the receipt given in `cbPreviousReceiptReference` in the same queue. Receipts that were answered with an error state are ignored. Depending on the market, the Middleware rejects a request if:

- no processed receipt matches the reference,
- more than one processed receipt matches the reference,
- a void, full refund, partial refund or exchange uses more than one reference (an array in `cbPreviousReceiptReference`),
- a full refund has no `cbPreviousReceiptReference`, unless it is a handwritten receipt,
- a void references a receipt that has already been voided,
- any receipt references a receipt that has already been voided,
- a receipt that is not a void, full refund, partial refund or exchange contains charge items with negative quantity or amount that are not flagged as `IsVoid`, `IsReturn/IsRefund` or `Discount`; this also applies to negative `Returnable` and `Downpayment` items,
- the sum of the charge items does not match the sum of the pay items.

Markets can define further rules, for example that a partial refund must not exceed the quantity that is left to refund, or that the articles and prices must match the original receipt. These rules are described on the market pages.

When the request is rejected, the `ReceiptResponse` contains an error state and the error message; see [Error Handling](error-handling.md).

## Related pages

- [Receipt Case Definitions](../receipt-case-definitions/receipt-case-definitions.md)
- [Reference Tables](../reference-tables/reference-tables.md): `ftReceiptCase`, `ftChargeItemCase` and `ftPayItemCase` flags
- [Data Structures](../data-structures/data-structures.md#receiptrequest): `cbPreviousReceiptReference`
