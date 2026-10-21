---
slug: /poscreators/middleware-doc/france/cash-register-integration/offline-handling
title: Offline Handling
description: What the POS system must do in France when the Middleware cannot be reached, and which parts of the Middleware need an internet connection.
tags: [France, Offline, Failure Handling, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in France when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in France.

## Which setups need an internet connection

- In France, the Queue signs the receipts itself; there is no separate signature creation device. A **locally installed** fiskaltrust.Middleware therefore signs receipts without an internet connection.
- The **hosted** fiskaltrust.Middleware (ChaîneCloud) needs an internet connection for every receipt.
- Archive receipts are uploaded to the fiskaltrust.Portal, which needs an internet connection. For more information, see [Archive Receipt](./cash-register-integration.md#archive-receipt).

## POS system cannot reach the fiskaltrust.Middleware

1. Find out whether the fiskaltrust.Middleware has already processed the receipt: retry the request with the same `x-operation-id`, or send it with the flag `0x0000800000000000` (**Receipt request**).
2. If the fiskaltrust.Middleware stays unreachable, the POS system issues a receipt and a copy marked "mode dégradé" (degraded mode) with the current failure counter, and keeps the copy.
3. Once the fiskaltrust.Middleware is reachable again, send the receipts with the "failed receipt" flag `0x0000000000010000`, in ascending order of `cbReceiptMoment`.
4. Send a Zero-Receipt to end the failure state.

The procedure, including the flow diagrams, is described in [Failure Scenario](./failure-scenario.md#middleware-not-reachable-or-failing).

## Checklist

- Print the "mode dégradé" receipt with the failure counter, and keep its copy until the failure is resolved.
- Buffer the receipts persistently and send them with the failed receipt flag once the fiskaltrust.Middleware is reachable again.
- Offer a manual Zero-Receipt to end the failure state.
