---
slug: /poscreators/middleware-doc/germany/cash-register-integration/middleware-not-reachable
title: Middleware Not Reachable
description: What the POS system must do in Germany when it cannot reach the Middleware, and how the receipts are recorded afterwards.
tags: [Germany, KassenSichV, Failure Handling, Failure Scenarios, Cash Register Integration]
---

# Middleware Not Reachable

This page describes the failure scenario in which the POS system cannot reach the fiskaltrust.Middleware in Germany. It expands on [Middleware Not Reachable](../../general/cash-register-integration/middleware-not-reachable.md) of the general part and documents only what applies in Germany. The other failure scenarios are described in [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

In Germany, the PosOperator must remedy the cause immediately (DE: unverzüglich). The law does not define a time frame. For more information, see [Resolving failures](./cash-register-integration.md#resolving-failures).

## Which connection the POS system depends on

- A **locally installed** fiskaltrust.Middleware is reached over the local network.
- The **CloudCashbox** is reached over the internet connection of the location.

## What the POS system must do

1. Find out whether the fiskaltrust.Middleware has already processed the receipt: retry the request with the same `x-operation-id`, or send it with the flag `0x0000800000000000` (**Receipt request**). For more information, see [Resending receipts without signing them twice](./cash-register-integration.md#resending-receipts-without-signing-them-twice).
2. If the fiskaltrust.Middleware stays unreachable, issue the receipt marked "electronic recording system failed" (DE: Elektronisches Aufzeichnungssystem ausgefallen) and buffer it.
3. Once the fiskaltrust.Middleware is reachable again, send the buffered receipts in ascending order of `cbReceiptMoment` with the flag `0x0000000000010000` (**Failed receipt**). These receipts are recorded in the fiskaltrust.Middleware, but not sent to the TSE. The `ftState` of their responses contains the flag `0x0000000000000008` (late-signing mode).
4. Send a Zero-Receipt to end late-signing mode.

For more information, see [ftReceiptCaseFlag](../reference-tables/type-of-receipt-ftreceiptcase.md#ftreceiptcaseflag).

## Checklist

- Buffer receipts persistently and send them before the next daily closing.
- Print the signature items returned for late-signed receipts.
- Signal the `ftState` flag `0x0000000000000008` to the operator, and offer a manual Zero-Receipt to end late-signing mode.
