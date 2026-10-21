---
slug: /poscreators/middleware-doc/belgium/cash-register-integration/middleware-not-reachable
title: Middleware Not Reachable
description: Why sales cannot be registered in Belgium while the POS system cannot reach the Middleware, and what the POS system must do.
tags: [Belgium, Failure Handling, Failure Scenarios, Cash Register Integration]
---

# Middleware Not Reachable

This page describes the failure scenario in which the POS system cannot reach the fiskaltrust.Middleware in Belgium. It expands on [Middleware Not Reachable](../../general/cash-register-integration/middleware-not-reachable.md) of the general part and documents only what applies in Belgium. The other failure scenarios are described in [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

## No sales without the fiskaltrust.Middleware

The FPS Finance requires that a transaction cannot be completed until the FDM has signed it. There is no offline mode in which the fiskaltrust.Middleware signs receipts later. While the POS system cannot reach the fiskaltrust.Middleware, no sale can be registered and no VAT receipt may be issued. For more information, see [Must the POS wait for the FDM before completing a transaction, and what happens after payment?](../go-to-market/faq.md#must-the-pos-wait-for-the-fdm-before-completing-a-transaction-and-what-happens-after-payment)

## Which connection the POS system depends on

- A **locally installed** fiskaltrust.Middleware on Windows, Linux or Android is reached over the local network.
- The **fiskaltrust.Middleware for Cloud** is reached over the internet connection of the location.

## What the POS system must do

1. Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react). The sale is never registered twice.
2. If the fiskaltrust.Middleware stays unreachable, keep the transaction open, show the error to the user, and send it again once the fiskaltrust.Middleware is reachable.

A card payment that was already authorised remains valid while the POS system retries the registration. Only if the sale cannot be registered at all must the payment be reversed with the payment provider, outside the fiskaltrust.Middleware.

## Checklist

- Do not issue a VAT receipt without a response from the fiskaltrust.Middleware.
- Keep the transaction open after a failure and offer to send it again.
- Register the sale right after the payment is confirmed, to keep reversals of payments rare.
