---
slug: /poscreators/middleware-doc/spain/cash-register-integration/offline-handling
title: Offline Handling
description: Why fiscalization in Spain needs a permanent internet connection, and what the POS system must do when the tax authority or the Middleware cannot be reached.
tags: [Spain, VERI*FACTU, TicketBAI, Offline, Failure Handling, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in Spain when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in Spain.

## Which setups need an internet connection

In Spain, every setup needs an internet connection for every document:

- The fiskaltrust.Middleware runs in the fiskaltrust cloud.
- The fiskaltrust.Middleware transmits every VERI\*FACTU or TicketBAI record synchronously, and the response of the tax authority decides whether the document is issued.

For more information, see [What you need to know](../go-to-market/go-to-market.md#what-you-need-to-know).

## Tax authority not reachable

If the record cannot be transmitted to the tax authority, the fiskaltrust.Middleware returns a `ftState` with the error value `EEEE_EEEE` and the error message in a failure signature item. The document is not issued, and no invoice number is consumed. Show the error to the operator and send the request again. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).

## POS system cannot reach the fiskaltrust.Middleware

1. Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the document, it returns the original response.
2. While the POS system cannot reach the fiskaltrust.Middleware, it cannot issue a numbered invoice. In exceptional situations, a provisional receipt may be handed to the customer and must be replaced by the official invoice as soon as the connection is back. Contact fiskaltrust for the recommended procedure for outages.

## Checklist

- Plan a reliable internet connection for every location.
- Issue a document only after a successful response, including all returned signature items.
- Retry timeouts with the same `x-operation-id`.
- Replace every provisional receipt by the official invoice once the connection is back.
