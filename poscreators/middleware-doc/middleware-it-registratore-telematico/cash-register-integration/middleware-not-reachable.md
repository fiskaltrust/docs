---
slug: /poscreators/middleware-doc/italy/cash-register-integration/middleware-not-reachable
title: Middleware Not Reachable
description: What the POS system must do in Italy when it cannot reach the Middleware.
tags: [Italy, Failure Handling, Failure Scenarios, Cash Register Integration]
---

# Middleware Not Reachable

This page describes the failure scenario in which the POS system cannot reach the fiskaltrust.Middleware in Italy. It expands on [Middleware Not Reachable](../../general/cash-register-integration/middleware-not-reachable.md) of the general part and documents only what applies in Italy. The other failure scenarios are described in [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

## Which connection the POS system depends on

- A **locally installed** fiskaltrust.Middleware is reached over the local network.
- The **CloudCashbox** is reached over the internet connection of the location.

## What the POS system must do

Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).
