---
slug: /poscreators/middleware-doc/general/pos-system
title: POS System and ftPosSystemId
description: What a POS system is in fiskaltrust, how a PosCreator registers it in the fiskaltrust.Portal, why its ID must be sent as ftPosSystemId in every receipt request, and how to fix a missing or unknown ID.
tags: [PosSystem, ReceiptRequest, Data Structures, Portal, PosCreators, PosDealers]
---

# POS System and ftPosSystemId

:::info summary

Every receipt request must contain the ID of the POS system that created it, in the field `ftPosSystemId`. The PosCreator registers the POS system in the fiskaltrust.Portal, receives its ID there, and hard-codes that ID in the POS software. This page explains where the ID comes from, what it is used for, and how to fix a receipt whose POS system ID is missing or unknown.

:::

## What a POS system is {#what-a-pos-system-is}

In fiskaltrust, a **POS system** is a POS software product as its PosCreator distributes it: one model of a cash register software, not a single installed device. A POS system is described by its master data:

| Field | Description |
|-------|-------------|
| `Name` | The name of the POS system. |
| `Brand` | The brand under which the POS system is sold. |
| `Model` | The model of the POS system. |
| `Software Major Version` | The major version of the POS software. |
| `Type` | The type of the POS system. |

*Table 1. Master data of a POS system in the fiskaltrust.Portal.*

The PosCreator who registers the POS system owns it. PosDealers who sell and install the POS system are assigned to it, see [Assignment of a PosSystem](../../../getting-started/onboarding-posdealers.md#assignment-of-a-possystem).

## Getting the POS system ID {#getting-the-pos-system-id}

The **POS system ID** is a UUID that the fiskaltrust.Portal assigns when the POS system is created:

1. Log in to the fiskaltrust.Portal as a PosCreator.
2. Select `PosSystems`, then `Add`, enter the master data and select `Create new`.
3. The new POS system appears in the list of your POS systems, together with its `PosSystemId`. The ID cannot be changed.

The step-by-step instructions with screenshots are in [Creation of a PosSystem](../../../getting-started/onboarding-posdealers.md#creation-of-a-possystem).

Create **one POS system per model**, not one per device or per installation. All installations of the same model send the same ID.

:::caution One ID per Portal

Each market has its own fiskaltrust.Portal, and the sandbox Portal is separate from the production Portal. A POS system is known only in the Portal where it was created. Create the POS system in the production Portal of every market where it is used, and send the ID from that market's Portal; see the [Integration Checklist](../../../getting-started/integration-checklist.md).

:::

## Sending the ID in every receipt request {#sending-ftpossystemid}

`ftPosSystemId` is a **mandatory** field of the [ReceiptRequest](../data-structures/data-structures.md#receiptrequest). The PosCreator implements the POS system ID as a constant in the POS software, so that every receipt request contains it, including special receipts such as zero receipts and closing receipts:

```json
{
  "ftCashBoxID": "<your CashBox ID>",
  "ftPosSystemId": "<the PosSystemId from the fiskaltrust.Portal>",
  "cbTerminalID": "T1",
  "cbReceiptReference": "R-1001",
  ...
}
```

The ID is **not** configured per installation and is not entered by the PosDealer or PosOperator.

## What the ID is used for {#what-the-id-is-used-for}

The POS system ID connects each receipt to the POS software that created it. fiskaltrust uses it:

- **For audits:** it identifies the POS system behind a queue and behind each receipt.
- **For tax-authority exports and notifications:** in markets where the POS system must be declared, its master data comes from the POS system registered under this ID. In Germany, for example, the POS system is part of the DSFinV-K and of the notification to the tax office; see [Data Structures (Germany)](../../middleware-de-kassensichv/data-structures/data-structures.md#single-fields).
- **As a basis for commission calculation** between fiskaltrust and its partners.

The fiskaltrust.Portal also checks the receipts of a queue: the queue validation shows whether the receipts include the POS system ID (`Do the receipts include the PosSystemId?`).

## When the POS system ID is wrong {#when-the-pos-system-id-is-wrong}

The Middleware does not validate `ftPosSystemId`: a receipt with a missing or unknown POS system ID is still signed. The problem only shows later — in the queue validation, on the receipt page of the fiskaltrust.Portal, in a tax-authority notification or in an export — when the POS system behind the receipt has to be determined.

The ID can only be fixed in the POS software. Receipts that were already signed keep the value they were sent with.

### The ID is missing {#missing-pos-system-id}

The receipt request contains no `ftPosSystemId`, an empty value, or the empty UUID `00000000-0000-0000-0000-000000000000`. The fiskaltrust.Portal shows the warning **This receipt does not identify its POS system**.

The POS system that created the receipt cannot be determined. In Germany, for example, the cash register then has no POS system for the notification to the tax office.

**How to fix it:**

- **PosCreator:** implement the ID of your POS system as a constant and send it in every receipt request, as described in [Sending the ID in every receipt request](#sending-ftpossystemid). Placeholder values from examples, such as the empty UUID, must be replaced.
- **PosDealer or PosOperator:** contact your PosDealer or PosCreator. The ID cannot be set in the fiskaltrust.Portal or in the Middleware configuration; it must be sent by the POS software.

### The ID is malformed {#malformed-pos-system-id}

The value is not a UUID, for example a product name, a version number or a placeholder text such as `POS-Systemid-guid`. With the ifPOS v1 interface, the Middleware accepts any text in this field, so the receipt is signed; the fiskaltrust.Portal treats the value as an unknown POS system (see below). With the ifPOS v2 interface, the field is a UUID, so a value that is not a UUID cannot be read.

**How to fix it:** as for a [missing ID](#missing-pos-system-id): the PosCreator sends the POS system ID exactly as the fiskaltrust.Portal shows it, a UUID in the format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

### The ID is unknown {#unknown-pos-system-id}

The receipt request contains a UUID, but no POS system with this ID is registered in the fiskaltrust.Portal of this market. The fiskaltrust.Portal shows the warning **This receipt names an unknown POS system**.

Common causes:

- The ID was copied from an example in this documentation or from a sample collection.
- The ID belongs to a POS system in the **sandbox** Portal, but the receipt was sent to a production queue.
- The ID belongs to a POS system registered in the Portal of **another market**. Each market has its own Portal, so an ID from another market is unknown here.
- The ID was typed or generated instead of copied from the `PosSystems` list.

**How to fix it:**

- **PosCreator:** check the `PosSystems` list in the production fiskaltrust.Portal of the market of the queue. If the POS system is not there, create it in that Portal and send its ID; if it is there, send exactly the ID shown in the list.
- **PosDealer or PosOperator:** contact your PosDealer or PosCreator and give them the POS system ID shown on the receipt page. As a PosDealer, you find the POS systems assigned to you and their IDs under `PosSystems` in the fiskaltrust.Portal.
