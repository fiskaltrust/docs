---
slug: /poscreators/middleware-doc/portugal/cash-register-integration/offline-handling
title: Offline Handling
description: Why fiscalization in Portugal needs an internet connection, why late signing is not available, and how documents issued on pre-printed forms are recovered.
tags: [Portugal, Offline, Failure Handling, Handwritten Receipts, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in Portugal when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in Portugal.

## Which setups need an internet connection

With the fiskaltrust certificate ([Route 1](../go-to-market/route-1-fiskaltrust-certificate.md)), the fiskaltrust.Middleware runs in the fiskaltrust cloud, so every document needs an internet connection. For more information, see [Certification](../certification/certification.md).

## POS system cannot reach the fiskaltrust.Middleware

In Portugal, late signing is not available. A receipt that the POS system prints on its own, without a response from the fiskaltrust.Middleware, is not a valid fiscal document. Instead:

1. **Retry the request** with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response.
2. **Do not issue a document without a response.** A request that did not receive a response must not be sent again later with its original `cbReceiptMoment`; it is rejected.
3. **Switch to pre-printed forms.** During the outage, the merchant issues documents manually on pre-printed forms from a printing company authorized by the AT.
4. **Recover the paper documents.** After the outage, send each paper document with the flag `0x0000_0000_0008_0000` (**Process as Handwritten Receipt**) and the series and number of the form in `ftReceiptCaseData`. The fiskaltrust.Middleware issues it in a dedicated manual series.

The procedure, including the required fields, an example and the refunds of recovered documents, is described in [Middleware Not Reachable](./middleware-not-reachable.md).

## Checklist

- Make sure the merchant has pre-printed forms for every document type that is issued, and that a manual series is configured for the queue.
- Do not print a fiscal document without a response from the fiskaltrust.Middleware.
- Offer a function to record paper documents after the outage, including the series and number of the form.
