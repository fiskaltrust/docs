---
slug: /poscreators/middleware-doc/greece/cash-register-integration/middleware-not-reachable
title: Middleware Not Reachable
description: What the POS system must do in Greece when it cannot reach the Middleware, and how the documents are transmitted to myDATA afterwards.
tags: [Greece, myDATA, Failure Handling, Failure Scenarios, Cash Register Integration]
---

# Middleware Not Reachable

This page describes the failure scenario in which the POS system cannot reach the fiskaltrust.Middleware in Greece. It expands on [Middleware Not Reachable](../../general/cash-register-integration/middleware-not-reachable.md) of the general part and documents only what applies in Greece. The other failure scenarios are described in [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

AADE calls this failure **transmission failure 1**: the loss of connection between the business and the provider. For more information, see [Key factors for the Greek market](../go-to-market/go-to-market.md#key-factors-for-the-greek-market).

## Which connection the POS system depends on

In Greece, the fiskaltrust.Middleware runs in the fiskaltrust cloud. The POS system reaches it over the internet connection of the location.

## What the POS system must do

1. Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).
2. If the fiskaltrust.Middleware stays unreachable, issue the receipt with the hint "Security mechanism not reachable" and buffer it.
3. Once the fiskaltrust.Middleware is reachable again, send the buffered receipts without delay with the flag `0x0000_0000_0001_0000` (**Process as Late Signing Receipt**), in ascending order of `cbReceiptMoment`. The fiskaltrust.Middleware transmits them to myDATA with `transmissionFailure = 1`.
4. The response contains the signature item `TransmissionFailure` with the notice *Απώλεια Διασύνδεσης Οντότητας - Παρόχου*. It must be printed.

For more information, see [Signature items returned by the Middleware](../receipt-printing/receipt-printing.md#signature-items-returned-by-the-middleware) and [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md).

## Checklist

- Plan a reliable internet connection for every location.
- Buffer receipts persistently, and send them without delay once the fiskaltrust.Middleware is reachable again.
- Print the `TransmissionFailure` notice on late-signed receipts.
