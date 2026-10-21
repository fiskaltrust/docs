---
slug: /poscreators/middleware-doc/germany/cash-register-integration/offline-handling
title: Offline Handling
description: What the POS system must do in Germany when the TSE or the Middleware cannot be reached, and how receipts are recorded after an outage.
tags: [Germany, KassenSichV, Offline, Failure Handling, TSE, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in Germany when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in Germany.

In Germany, the PosOperator must remedy the cause of every failure immediately (DE: unverzüglich). The law does not define a time frame. For more information, see [Resolving failures](./cash-register-integration.md#resolving-failures).

## Which setups need an internet connection

- A **hardware TSE** (USB or microSD) is connected to the device on which the fiskaltrust.Middleware runs.
- A **cloud TSE** is reached over the internet. Without a connection to the TSE provider, the fiskaltrust.Middleware cannot reach the TSE and switches to failed mode. For the hostnames of each cloud TSE, see [Network Requirements](../../../../posdealers/technical-operations/middleware/network-requirements.md).
- The **CloudCashbox** needs an internet connection for every receipt.

## TSE not reachable

If the fiskaltrust.Middleware cannot reach the TSE, it continues to accept receipts in failed mode:

1. The `ftState` contains the flag `0x4445000000000002` (communication with the TSE failed). Signal this state to the operator.
2. The receipts are not signed by the TSE. The response contains the text `Kommunikation mit der technischen Sicherheitseinrichtung (TSE) fehlgeschlagen` and the failure counter. Print the returned signature items.
3. Once the TSE is reachable again, send a Zero-Receipt. It ends failed mode. The receipts processed in failed mode are not sent again.

For more information, see [Signature Creation Unit not reachable or failing](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md#signature-creation-unit-not-reachable-or-failing) and [Service Status: ftState](../reference-tables/service-status-ftstate.md).

## POS system cannot reach the fiskaltrust.Middleware

1. Find out whether the fiskaltrust.Middleware has already processed the receipt: retry the request with the same `x-operation-id`, or send it with the flag `0x0000800000000000` (**Receipt request**). For more information, see [Resending receipts without signing them twice](./cash-register-integration.md#resending-receipts-without-signing-them-twice).
2. If the fiskaltrust.Middleware stays unreachable, the POS system issues the receipt marked "electronic recording system failed" (DE: Elektronisches Aufzeichnungssystem ausgefallen) and buffers it.
3. Once the fiskaltrust.Middleware is reachable again, send the buffered receipts in ascending order of `cbReceiptMoment` with the flag `0x0000000000010000` (**Failed receipt**). These receipts are recorded in the fiskaltrust.Middleware, but not sent to the TSE. The `ftState` of their responses contains the flag `0x0000000000000008` (late-signing mode).
4. Send a Zero-Receipt to end late-signing mode.

For more information, see [ftReceiptCaseFlag](../reference-tables/type-of-receipt-ftreceiptcase.md#ftreceiptcaseflag).

## Handwritten receipts

After a complete outage of the POS system, send the handwritten receipts with the flag `0x0000000000080000` (**Paper/handwritten receipt**). These receipts are recorded in the fiskaltrust.Middleware, but not sent to the TSE. No Zero-Receipt is needed afterwards.

## Checklist

- Print the signature items returned in failed mode and for late-signed receipts.
- Signal the `ftState` flags `0x4445000000000002` and `0x0000000000000008` to the operator.
- Offer a manual Zero-Receipt to end failed mode and late-signing mode.
- With a cloud TSE, make sure the hosts of the TSE provider are reachable.
- Buffer receipts persistently and send them before the next daily closing.
