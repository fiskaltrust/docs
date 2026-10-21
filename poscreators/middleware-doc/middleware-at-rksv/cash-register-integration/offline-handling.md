---
slug: /poscreators/middleware-doc/austria/cash-register-integration/offline-handling
title: Offline Handling
description: What the POS system must do in Austria when the signature creation device or the Middleware cannot be reached, including the 48-hour FinanzOnline notification.
tags: [Austria, RKSV, Offline, Failure Handling, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in Austria when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in Austria.

## Which setups need an internet connection

- A **locally installed** fiskaltrust.Middleware with a smart card as signature creation device signs receipts without an internet connection.
- A fiskaltrust.Middleware that uses a **signing service** reaches it over the internet, for example the signing service at `signing.fiskaltrust.at`. For more information, see [Local or managed SCU](../../../getting-started/choosing-an-architecture.md#local-or-managed-scu).
- The **hosted** fiskaltrust.Middleware (SignatureCloud) needs an internet connection for every receipt.
- **FinanzOnline** registrations and notifications are carried out by the fiskaltrust.Portal, automatically only with a fiskaltrust.Carefree or Notification subscription. In offline setups, the Zero-Receipt returns pending FinanzOnline notifications as AZTEC codes, so that they can be carried out manually. For more information, see [Signature entries returned by the Queue](../data-structures/data-structures.md#signature-entries-returned-by-the-queue).

## Signature creation device not reachable

If the signature creation device cannot be reached, the fiskaltrust.Middleware continues in failed mode:

1. The receipts are still numbered and chained. Instead of a signature, the RKSV value for a failed signature creation device is used, and the receipt carries the caption `Sicherheitseinrichtung ausgefallen` with the QR code. Print the returned signature items. For more information, see [Signature entries returned by the Queue](../data-structures/data-structures.md#signature-entries-returned-by-the-queue).
2. The `ftState` contains the flag `0000_0002` (**SCU temporary out of service**). Signal this state to the operator.
3. If the failure lasts more than 48 hours, the `ftState` additionally contains the flag `0000_0004` (**SCU permanently out of service**), and a FinanzOnline notification is generated. Outages that exceed 48 hours must be notified to FinanzOnline. For more information, see [FinanzOnline Management](../../../../posdealers/buy-resell/products/3rd-party/finanzonline-management.md).
4. Once the signature creation device is reachable again, send a Zero-Receipt. The fiskaltrust.Middleware issues a signed collective receipt (`Sammelbeleg`) covering the receipts issued during the failure, and ends failed mode. If a FinanzOnline notification was generated for the outage, the end of the outage is notified as well.

For more information, see [End of Failure Receipt](./cash-register-integration.md#end-of-failure-receipt-collective-failure-report) and [Service Status: ftState](../reference-tables/service-status-ftstate.md).

## POS system cannot reach the fiskaltrust.Middleware

1. Retry the request with the same `x-operation-id` and the same body. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).
2. If the fiskaltrust.Middleware stays unreachable, issue the receipt marked "security mechanism failed" and buffer it.
3. Once the fiskaltrust.Middleware is reachable again, send the buffered receipts in ascending order of `cbReceiptMoment` with the flag `0x0000_0000_0001_0000` (**Process as Late Signing Receipt**). These receipts are signed when they are processed: the QR code contains the time of processing, and `cbReceiptMoment` keeps the original time. The `ftState` contains the flag `0000_0008`.
4. Send a Zero-Receipt to end late-signing mode. It must be signed. The fiskaltrust.Middleware returns a signature item `Ausfall-Nacherfassung` with the range of receipts covered. If the original receipt times of the late-signed receipts span more than 48 hours, FinanzOnline notifications are generated for the outage.

For more information, see [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md) and [Receipt Request](../data-structures/data-structures.md#receipt-request).

## Handwritten receipts

After a complete outage of the POS system, send the handwritten receipts with the flag `0x0000_0000_0008_0000` (**Process as Handwritten Receipt**), in the order in which they were written. The `ftState` contains the flag `0000_0008`. The Zero-Receipt that ends this state returns a signature item `Mobil-Nacherfassung`; it does not need to be signed.

## Checklist

- Print the signature items returned in failed mode, including `Sicherheitseinrichtung ausgefallen` and its QR code.
- Signal the `ftState` flags `0000_0002`, `0000_0004` and `0000_0008` to the operator.
- Offer a manual Zero-Receipt to end failed mode and late-signing mode.
- Make sure outages of more than 48 hours are notified to FinanzOnline, either automatically through a subscription or manually.
