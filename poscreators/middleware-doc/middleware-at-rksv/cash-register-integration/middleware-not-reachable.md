---
slug: /poscreators/middleware-doc/austria/cash-register-integration/middleware-not-reachable
title: Middleware Not Reachable
description: What the POS system must do in Austria when it cannot reach the Middleware, including late signing and the 48-hour FinanzOnline notification.
tags: [Austria, RKSV, Failure Handling, Failure Scenarios, Cash Register Integration]
---

# Middleware Not Reachable

This page describes the failure scenario in which the POS system cannot reach the fiskaltrust.Middleware in Austria. It expands on [Middleware Not Reachable](../../general/cash-register-integration/middleware-not-reachable.md) of the general part and documents only what applies in Austria. The other failure scenarios are described in [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

## Which connection the POS system depends on

- A **locally installed** fiskaltrust.Middleware is reached over the local network.
- The **hosted** fiskaltrust.Middleware (SignatureCloud) is reached over the internet connection of the location.

## What the POS system must do

1. Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).
2. If the fiskaltrust.Middleware stays unreachable, issue the receipt with the hint "Security mechanism not reachable" and buffer it.
3. Once the fiskaltrust.Middleware is reachable again, send the buffered receipts in ascending order of `cbReceiptMoment` with the flag `0x0000_0000_0001_0000` (**Process as Late Signing Receipt**). These receipts are signed when they are processed: the QR code contains the time of processing, and `cbReceiptMoment` keeps the original time. The `ftState` contains the flag `0000_0008`.
4. Send a Zero-Receipt to end late-signing mode. It must be signed. The fiskaltrust.Middleware returns a signature item `Ausfall-Nacherfassung` with the range of receipts covered.

If the original receipt times of the late-signed receipts span more than 48 hours, FinanzOnline notifications are generated for the outage. They are carried out automatically with a fiskaltrust.Carefree or Notification subscription. For more information, see [FinanzOnline Management](../../../../posdealers/buy-resell/products/3rd-party/finanzonline-management.md).

For more information, see [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md), [Receipt Request](../data-structures/data-structures.md#receipt-request) and [Signature entries returned by the Queue](../data-structures/data-structures.md#signature-entries-returned-by-the-queue).

## Checklist

- Buffer receipts persistently and send them with the late signing flag once the fiskaltrust.Middleware is reachable again.
- Signal the `ftState` flag `0000_0008` to the operator, and offer a manual Zero-Receipt to end late-signing mode.
- Make sure outages of more than 48 hours are notified to FinanzOnline, either automatically through a subscription or manually.
