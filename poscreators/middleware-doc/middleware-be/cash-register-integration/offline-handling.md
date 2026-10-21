---
slug: /poscreators/middleware-doc/belgium/cash-register-integration/offline-handling
title: Offline Handling
description: Why there is no offline mode in Belgium, and what the POS system must do when the FDM or the Middleware cannot be reached.
tags: [Belgium, Offline, Failure Handling, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in Belgium when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in Belgium.

## No offline mode in Belgium

The FPS Finance requires that a transaction cannot be completed until the FDM has signed it, and that sales may only be registered while the FDM is connected and working. Unlike in some other markets, there is no offline mode in which the fiskaltrust.Middleware signs receipts later. For more information, see [Must the POS wait for the FDM before completing a transaction, and what happens after payment?](../go-to-market/faq.md#must-the-pos-wait-for-the-fdm-before-completing-a-transaction-and-what-happens-after-payment)

## Which setups need an internet connection

Whether the fiskaltrust.Middleware runs in the cloud or locally on Windows, Linux or Android, it reaches the FDM over HTTPS. If the connection to the FDM runs over the internet and fails, the cash register system can no longer register sales. Plan the internet connection of the site accordingly. For more information, see [Where is the FDM installed, and how does the fiskaltrust.Middleware connect to it?](../go-to-market/faq.md#where-is-the-fdm-installed-and-how-does-the-fiskaltrustmiddleware-connect-to-it)

## FDM not reachable

If the FDM refuses the event or cannot be reached, the response is marked as failed with the `ftState` `0x4245_2000_EEEE_EEEE`, contains no FDM signature, and carries the error message in a failure signature item. In this case, the POS system:

1. must not issue a VAT receipt,
2. keeps the transaction open and shows the error to the user,
3. sends the transaction again once the cause is resolved.

A card payment that was already authorised remains valid while the POS system retries the registration. Only if the sale cannot be registered at all must the payment be reversed with the payment provider, outside the fiskaltrust.Middleware.

For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react) and [Service Status: ftState](../reference-tables/service-status-ftstate.md).

## POS system cannot reach the fiskaltrust.Middleware

If the call to the fiskaltrust.Middleware times out or gets no answer, retry the request with the same `x-operation-id` and the same body. If the receipt was already processed, its result is returned; the sale is never registered twice. While the fiskaltrust.Middleware cannot be reached, no sale can be registered, and no VAT receipt may be issued.

## Checklist

- Do not issue a VAT receipt without the FDM signature items in the response.
- Keep the transaction open after an error and offer to send it again.
- Retry timeouts with the same `x-operation-id`.
- Register the sale right after the payment is confirmed, to keep reversals of payments rare.
