---
slug: /poscreators/middleware-doc/germany/cash-register-integration/cash-drawer-movements
title: Cash Drawer Movements (Kassenlade)
description: How cash movements into and out of the cash drawer (Kassenlade) are recorded in Germany, with the local flags for Geldtransit, Privateinlage, Privatentnahme, Lohnzahlung, Anfangsbestand, DifferenzSollIst, Einzahlung and Auszahlung and their DSFinV-K GV_TYP mapping.
tags: [Germany, Cash Drawer, Kassenlade, Geldtransit, Privatentnahme, Privateinlage, Anfangsbestand, DifferenzSollIst, DSFinV-K, GV_TYP, Cash Register Integration]
---

# Cash Drawer Movements (Kassenlade)

This page describes the German rules for cash that goes into or out of the cash drawer (DE: Kassenlade) without a sale. The general model, which applies to all markets, is described in [Cash Drawer Movements](../../general/cash-register-integration/cash-drawer-movements.md) of the general part.

The DSFinV-K distinguishes cash movements by their purpose. Each purpose is a business case type (GV_TYP) that only affects the cash balance (DE: Kassenbestand), for example _Geldtransit_ for cash taken to the bank or _Privatentnahme_ for cash the owner takes out for private purposes. The POS system therefore specifies the purpose of every cash movement with a local flag `lll` in `ftChargeItemCase`.

## Overview

A cash movement is sent as a payment transfer receipt (`ftReceiptCase` `0x4445_2000_0000_0002`) with one charge item of the type of service `A` Cash transfer and one cash pay item (`ftPayItemCase` `0x4445_2000_0000_0001`) with the same amount, as described in [Recording a cash movement without a sale](../../general/cash-register-integration/cash-drawer-movements.md#recording-a-cash-movement-without-a-sale). The local flag `lll` selects the purpose:

| Purpose | `lll` | `ftChargeItemCase` | Allowed sign | GV_TYP (DSFinV-K) |
|---------|-------|--------------------|--------------|-------------------|
| Cash to or from the bank, the safe or another drawer, or refilling the drawer after it was emptied | `091` | `0x4445_2091_0000_00A8` | `+` (into the drawer) and `-` (out of the drawer) | Geldtransit |
| The owner puts in private money | `092` | `0x4445_2092_0000_00A8` | `+` | Privateinlage |
| The owner takes out money for private purposes | `092` | `0x4445_2092_0000_00A8` | `-` | Privatentnahme |
| Wages paid from the drawer, for example a salary advance | `093` | `0x4445_2093_0000_00A8` | `-` only | Lohnzahlung |
| Cash already in the drawer when the register is opened | `094` | `0x4445_2094_0000_00A8` | `+` only | Anfangsbestand |
| Difference between the expected and the counted cash | `095` | `0x4445_2095_0000_00A8` | `+` (surplus) and `-` (shortage) | DifferenzSollIst |
| Any other cash coming in, not covered by another purpose | `000` | `0x4445_2000_0000_00A8` | `+` | Einzahlung |
| Any other cash going out, for example office supplies paid in cash | `000` | `0x4445_2000_0000_00A8` | `-` | Auszahlung |

*Table 1. Purposes of a cash movement in Germany, their local flags and their DSFinV-K business case type.*

The values `090` and `096` to `09F` of `lll` are reserved. Cash movements are not taxable: they are exported with the DSFinV-K VAT key (UST_SCHLUESSEL) `5`, except an [Einzahlung or Auszahlung with VAT](#einzahlung-and-auszahlung-with-vat). The receipt is a regular DSFinV-K receipt (BON_TYP `Beleg`) that is signed by the TSE with the process type `Kassenbeleg-V1`. A purpose with a sign that is not allowed, or a reserved value of `lll`, is not mapped to a cash movement.

The local flags are also listed in the [Reference Tables](../../general/reference-tables/reference-tables.md#germany-de) of the general part.

## Choosing the purpose

The DSFinV-K defines the purposes as follows:

- **Geldtransit**: cash or cheques are moved out of or into the register, for example to the bank or a safe. It also covers moving cash between registers and topping up the drawer after it was emptied. Money that goes into the private sphere of the owner is a _Privatentnahme_, not a _Geldtransit_.
- **Privateinlage** and **Privatentnahme**: the owner puts private money into the register, or takes cash out for private, non-business purposes.
- **Lohnzahlung**: the employer pays all or part of an employee's wages from the register.
- **Anfangsbestand**: records the cash already in the drawer when the register is opened at the start of a period; this can also happen during the day. It is a purely technical entry and optional. If the drawer was emptied at the last closing, the starting balance is 0.00, and any new cash put into the drawer is a _Geldtransit_.
- **DifferenzSollIst**: records the difference between the calculated (expected) and the counted (actual) cash balance when the cash is counted or checked. It can be a shortage or a surplus, and it must be documented further in the cash book.
- **Einzahlung** and **Auszahlung**: a catch-all for cash coming in or going out that no other purpose covers, for example paying for office supplies in cash or getting money back from a supplier for a returned good.

:::tip Refilling the drawer
Putting change money (DE: Wechselgeld) from the safe into an emptied drawer is a _Geldtransit_, not an _Anfangsbestand_. Use _Anfangsbestand_ only for cash that is already in the drawer.
:::

## Einzahlung and Auszahlung with VAT

An Einzahlung or Auszahlung can contain VAT, for example when office supplies are paid from the drawer. The POS system then sends the VAT rate of the purchase in the last digit of `ftChargeItemCase` instead of `8` Not taxable, for example `0x4445_2000_0000_00A3` for the normal VAT rate (19 %) or `0x4445_2000_0000_00A1` for the discounted VAT rate (7 %). If the payment contains several VAT rates, the POS system sends one charge item per VAT rate, each with its amount, together with one cash pay item for the total.

The VAT rate is exported as the DSFinV-K VAT key of the business case Einzahlung or Auszahlung, and the sign of the amount decides between the two, as in Table 1. A VAT rate is only taken into account with `lll` `000`; all other purposes are not taxable.

## Example

The cashier takes 100.00 out of the drawer to deposit it at the bank. The example is taken from the business case `SignRequestReceipt_CashMovements_Germany`:

| Line | `Quantity` | `Amount` | Case |
|------|-----------:|---------:|------|
| Cash transfer from till (charge item) | 1 | -100.00 | `0x4445_2091_0000_00A8` |
| **Cash** (pay item) | | -100.00 | `0x4445_2000_0000_0001` |

*Table 2. A Geldtransit of 100.00 from the drawer to the bank, with `ftReceiptCase` `0x4445_2000_0000_0002`.*

The business case contains one example for each purpose in Table 1 except Einzahlung and Auszahlung.

## Transfer with pay items only

A [transfer with pay items only](../../general/cash-register-integration/cash-drawer-movements.md#transfer-between-drawer-and-vault-with-pay-items-only) uses the payment type `0C` Transfer to cashbook/vault/owner/employee. In Germany, this payment type is always mapped to the purpose _Geldtransit_. To record any other purpose, use a charge item with the matching local flag from Table 1.

## Change

Change paid out in a sale (payment type `01` Cash with the flag `IsChange`) is mapped by the PosSystem API to the German `ftPayItemCase` `0x4445_0000_0000_000B` (change in national currency) and is a cash payment (ZAHLART_TYP `Bar`) in the DSFinV-K. Change for a payment in a foreign currency (flags `IsChange` and `IsForeignCurrency`) is mapped to `0x4445_0000_0000_000C`. Change is not a cash movement of its own and needs no local flag.

## Integrations with v0 case values

POS systems that send the German v0 case values (`0x4445_0000_...`) record a cash movement with the `ftReceiptCase` `0x4445_0000_0000_0011` (cash deposit, cash pay-in, cash pay-out, exchange) and a dedicated `ftChargeItemCase` per purpose. When the POS system sends v2 case values through the PosSystem API, they are mapped as follows:

| v2 `ftChargeItemCase` | Sign | v0 `ftChargeItemCase` | GV_TYP (DSFinV-K) |
|-----------------------|------|-----------------------|-------------------|
| `0x4445_2094_0000_00A8` | `+` | `0x4445_0000_0000_0090` | Anfangsbestand |
| `0x4445_2092_0000_00A8` | `-` | `0x4445_0000_0000_0091` | Privatentnahme |
| `0x4445_2092_0000_00A8` | `+` | `0x4445_0000_0000_0092` | Privateinlage |
| `0x4445_2091_0000_00A8` | `+` and `-` | `0x4445_0000_0000_0093` | Geldtransit |
| `0x4445_2093_0000_00A8` | `-` | `0x4445_0000_0000_0094` | Lohnzahlung |
| `0x4445_2000_0000_00A8` | `+` | `0x4445_0000_0000_0095` | Einzahlung |
| `0x4445_2000_0000_00A8` | `-` | `0x4445_0000_0000_0096` | Auszahlung |
| `0x4445_2095_0000_00A8` | `+` and `-` | `0x4445_0000_0000_0097` | DifferenzSollIst |
| `0x4445_2000_0000_00A3` | `+` and `-` | `0x4445_0000_0000_00B1` | Einzahlung (`+`) or Auszahlung (`-`) with VAT, normal VAT rate |
| `0x4445_2000_0000_00A1` | `+` and `-` | `0x4445_0000_0000_00B2` | Einzahlung (`+`) or Auszahlung (`-`) with VAT, discounted VAT rate |
| `0x4445_2000_0000_00A4` | `+` and `-` | `0x4445_0000_0000_00B3` | Einzahlung (`+`) or Auszahlung (`-`) with VAT, average rate 10.7 % |
| `0x4445_2000_0000_00A5` | `+` and `-` | `0x4445_0000_0000_00B4` | Einzahlung (`+`) or Auszahlung (`-`) with VAT, average rate 5.5 % |
| `0x4445_2000_0000_00A7` | `+` and `-` | `0x4445_0000_0000_00B6` | Einzahlung (`+`) or Auszahlung (`-`) with VAT, zero VAT rate |
| `0x4445_2000_0000_00A0`, `00A2`, `00A6` | `+` and `-` | `0x4445_0000_0000_00B7` | Einzahlung (`+`) or Auszahlung (`-`), VAT rate unknown |

*Table 3. Mapping of the v2 cash movement values to the German v0 `ftChargeItemCase` values.*

The v0 values are described in [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md). The v0 data model can also express the purpose with a pay item instead of a charge item (`ftPayItemCase` `0x4445_0000_0000_0012` to `0x4445_0000_0000_0017`); see [Type of Payment: ftPayItemCase](../reference-tables/type-of-payment-ftpayitemcase.md).

## Related pages

- [Cash Drawer Movements](../../general/cash-register-integration/cash-drawer-movements.md): the general model
- [DSFinV-K Generation](../procedural-documentation/dsfinv-k-generation.md)
- [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md) and [Type of Payment: ftPayItemCase](../reference-tables/type-of-payment-ftpayitemcase.md) for Germany
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md#ftchargeitemcase)
