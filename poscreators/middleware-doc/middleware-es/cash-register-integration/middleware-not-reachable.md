---
slug: /poscreators/middleware-doc/spain/cash-register-integration/middleware-not-reachable
title: Middleware Not Reachable
description: What the POS system must do in Spain when it cannot reach the Middleware, and why no numbered invoice can be issued in that case.
tags: [Spain, VERI*FACTU, TicketBAI, Failure Handling, Failure Scenarios, Cash Register Integration]
---

# Middleware Not Reachable

This page describes the failure scenario in which the POS system cannot reach the fiskaltrust.Middleware in Spain. It expands on [Middleware Not Reachable](../../general/cash-register-integration/middleware-not-reachable.md) of the general part and documents only what applies in Spain. The other failure scenarios are described in [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

## Which connection the POS system depends on

In Spain, the fiskaltrust.Middleware runs in the fiskaltrust cloud. The POS system reaches it over the internet connection of the location. For more information, see [What you need to know](../go-to-market/go-to-market.md#what-you-need-to-know).

## What the POS system must do

1. Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).
2. While the POS system cannot reach the fiskaltrust.Middleware, it cannot issue a numbered invoice. In exceptional situations, a provisional receipt may be handed to the customer and must be replaced by the official invoice as soon as the connection is back. Contact fiskaltrust for the recommended procedure for outages.

## Checklist

- Plan a reliable internet connection for every location.
- Retry timeouts with the same `x-operation-id`.
- Replace every provisional receipt by the official invoice once the connection is back.
