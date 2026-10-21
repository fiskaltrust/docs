---
slug: /poscreators/middleware-doc/poland/cash-register-integration/middleware-not-reachable
title: Middleware Not Reachable
description: What the POS system must do in Poland when it cannot reach the Middleware.
tags: [Poland, Failure Handling, Failure Scenarios, Cash Register Integration]
---

# Middleware Not Reachable

This page describes the failure scenario in which the POS system cannot reach the fiskaltrust.Middleware in Poland. It expands on [Middleware Not Reachable](../../general/cash-register-integration/middleware-not-reachable.md) of the general part and documents only what applies in Poland. The other failure scenarios are described in [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

## What the POS system must do

Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).

Sales must not continue without a working register. For what applies when the register itself cannot be reached, see [Register unreachable — Art. 111(3)](./cash-register-integration.md#register-unreachable--art-1113).
