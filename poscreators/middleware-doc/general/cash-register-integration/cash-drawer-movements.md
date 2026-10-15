---
slug: /poscreators/middleware-doc/general/cash-register-integration/cash-drawer-movements
title: Cash Drawer Movements
description: How to record cash that goes into or out of the cash drawer without a sale, for example transfers to the bank or safe, owner deposits and withdrawals, or the opening float, and how change is recorded in a sale.
tags: [Cash Drawer, Till, Cash Transfer, Payment Transfer, Change, ftChargeItemCase, ftPayItemCase, Cash Register Integration]
---

# Cash Drawer Movements

The cash drawer (also: till) holds the cash of a POS system. Its content changes in two ways:

- **in a sale**, when the customer pays in cash and, if necessary, gets change back,
- **without a sale**, when cash is put into or taken out of the drawer, for example when cash is taken to the bank or the safe, the owner takes out or puts in money, or a float is placed in the drawer at the start of the day.

The fiskaltrust.Middleware records both, so that every change of the cash in the drawer can be traced. A cash movement without a sale is not recorded as a sale with a negative price: the POS system sends a payment transfer receipt with a charge item of the type of service `A` Cash transfer, which marks the money as moved, not sold.

This page describes how the POS system records cash drawer movements in the data model. Which purposes of a cash movement a market distinguishes, and how they are reported to the authorities, is market specific; see [Market-specific considerations](#market-specific-considerations).

## Overview

| Business case | `ftReceiptCase` | Charge item | Pay item |
|---------------|-----------------|-------------|----------|
| [Cash movement without a sale](#recording-a-cash-movement-without-a-sale), for example cash to the bank or from the owner | `0002` Payment transfer | Type of service `A` Cash transfer, not taxable: `0xCCCC_2000_0000_00A8` | Payment type `01` Cash, same amount |
| [Transfer between drawer and vault with pay items only](#transfer-between-drawer-and-vault-with-pay-items-only) | `0002` Payment transfer | none | Payment type `01` Cash and payment type `0C` Transfer to cashbook/vault/owner/employee, with opposite signs |
| [Change in a sale](#change-in-a-sale) | `0001` Point-of-sale receipt | The items sold | Payment type `01` Cash for the money received, and payment type `01` Cash with the flag `IsChange` for the change |
| [Reversing a cash movement](#reversing-a-cash-movement) | `0002` Payment transfer with the flag `IsVoid` | As in the original, inverted, with the flag `IsVoid` | As in the original, inverted, with the flag `IsVoid` |

*Table 1. Cash drawer movements and how they are recorded.*

The values are described in the [Reference Tables](../reference-tables/reference-tables.md): `ftReceiptCase` `0002` in [txcc - ReceiptCase](../reference-tables/reference-tables.md#txcc---receiptcase), the type of service `A` in [S - Type of Service](../reference-tables/reference-tables.md#s---type-of-service), and the payment types and flags in [Type of Payment: ftPayItemCase](../reference-tables/reference-tables.md#type-of-payment-ftpayitemcase). In the examples on this page, `CCCC` stands for the country code of the queue.

### Sign of the amount

The sign of the amount describes the direction of the movement, seen from the cash drawer:

- a **positive** amount means cash goes **into** the drawer,
- a **negative** amount means cash goes **out of** the drawer.

The charge item and the cash pay item of a cash movement carry the same sign and the same amount, so that the receipt is balanced, as every receipt must be.

## Recording a cash movement without a sale

The POS system sends every cash movement as its own receipt with:

- the `ftReceiptCase` `0xCCCC_2000_0000_0002` (payment transfer),
- one charge item with the type of service `A` Cash transfer and the VAT rate `8` Not taxable, i.e. `ftChargeItemCase` `0xCCCC_2000_0000_00A8`, a `Quantity` of `1`, a `VATRate` of `0`, and a `Description` that explains the movement,
- a positive `Amount` for cash going into the drawer, or a negative `Amount` for cash going out of the drawer,
- one pay item with the payment type `01` Cash, i.e. `ftPayItemCase` `0xCCCC_2000_0000_0001`, with the same amount.

The charge item does not create turnover: a cash transfer is not taxable, it only moves money.

Markets can specify the purpose of the movement with local flags in the `lll` part of `ftChargeItemCase`, for example whether the cash goes to the bank or to the owner. Without local flags, the movement is a generic cash deposit or cash payout. See [Market-specific considerations](#market-specific-considerations).

### Examples

The examples are taken from the business cases `SignRequestReceipt_CashMovements` and `SignRequestReceipt_DrawerMoneyManagement`.

The cashier puts 500.00 from the safe into the drawer:

| Line | `Quantity` | `Amount` | Case |
|------|-----------:|---------:|------|
| Cash transfer (charge item) | 1 | 500.00 | `0xCCCC_2000_0000_00A8` |
| **Cash** (pay item) | | 500.00 | `0xCCCC_2000_0000_0001` |

*Table 2. Cash put into the drawer, with `ftReceiptCase` `0xCCCC_2000_0000_0002`.*

The cashier takes 100.00 out of the drawer:

| Line | `Quantity` | `Amount` | Case |
|------|-----------:|---------:|------|
| Cash transfer (charge item) | 1 | -100.00 | `0xCCCC_2000_0000_00A8` |
| **Cash** (pay item) | | -100.00 | `0xCCCC_2000_0000_0001` |

*Table 3. Cash taken out of the drawer, with `ftReceiptCase` `0xCCCC_2000_0000_0002`.*

## Transfer between drawer and vault with pay items only

A transfer between the drawer and the vault can also be recorded without a charge item, as two pay items with opposite signs:

- one pay item with the payment type `01` Cash, whose sign describes the direction from the point of view of the drawer, as above,
- one pay item with the payment type `0C` Transfer to cashbook/vault/owner/employee, with the opposite sign: a positive amount increases the vault, a negative amount decreases it.

The pay items cancel each other out, so the receipt is balanced without a charge item. For example, moving 500.00 from the vault to the drawer:

| Line | `Amount` | Case |
|------|---------:|------|
| **Transfer** (pay item) | -500.00 | `0xCCCC_2000_0000_000C` |
| **Cash** (pay item) | 500.00 | `0xCCCC_2000_0000_0001` |

*Table 4. Cash moved from the vault to the drawer with pay items only, with `ftReceiptCase` `0xCCCC_2000_0000_0002`.*

Which purpose a market assigns to this variant, and whether it supports it, is market specific. Use the [charge item variant](#recording-a-cash-movement-without-a-sale) if the market distinguishes purposes with local flags.

## Change in a sale

When the customer pays more in cash than the receipt total, the POS system records the money received and the change as two cash pay items:

- one pay item with the payment type `01` Cash for the money received,
- one pay item with the payment type `01` Cash and the flag `IsChange` (`0x0000_0000_0020_0000`), i.e. `ftPayItemCase` `0xCCCC_2000_0020_0001`, with a negative amount for the change.

| Line | `Quantity` | `Amount` | Case |
|------|-----------:|---------:|------|
| Coffee (charge item) | 1 | 4.00 | `0xCCCC_2000_0000_0013` |
| **Cash** (pay item) | | 10.00 | `0xCCCC_2000_0000_0001` |
| **Change** (pay item) | | -6.00 | `0xCCCC_2000_0020_0001` |

*Table 5. A sale paid with 10.00 in cash, with 6.00 change.*

If the customer pays in a foreign currency and gets change in the national currency, the money received is sent with the flag `IsForeignCurrency` (`0x0000_0000_0010_0000`) and the foreign amount in `ftPayItemCaseData`, and the change with the flag `IsChange`. The business case `SignRequestReceipt_DrawerMoneyManagement` contains an example.

## Reversing a cash movement

A cash movement is reversed like any other receipt: the POS system sends the payment transfer receipt again with the flag `IsVoid`, references the original receipt in `cbPreviousReceiptReference`, and inverts the amounts of the charge item and the pay item, marking them with the flag `IsVoid`. For more information, see [Refunds and Voids](refunds-and-voids.md#void).

## Market-specific considerations

The model on this page is the interface default. Markets add constraints, depending on what the national format and the fiscal device or service can represent. Before implementing, consult the market pages for:

- which purposes of a cash movement the market distinguishes, and which local flags `lll` it defines for them,
- whether a purpose is only allowed in one direction, for example only out of the drawer,
- whether a cash payout that contains VAT, for example a purchase paid from the drawer, may use a VAT rate other than `8` Not taxable,
- which purpose the market assigns to the [transfer with pay items only](#transfer-between-drawer-and-vault-with-pay-items-only),
- how the movements are reported, for example in a national export format.

For the market rules, see:

- Germany: [Cash Drawer Movements (Kassenlade)](../../middleware-de-kassensichv/cash-register-integration/cash-drawer-movements.md)

## Related pages

- [Refunds and Voids](refunds-and-voids.md)
- [Reference Tables](../reference-tables/reference-tables.md): `ftReceiptCase`, `ftChargeItemCase` and `ftPayItemCase` values and flags
- [Data Structures](../data-structures/data-structures.md#chargeitem): `ChargeItem` and `PayItem`
