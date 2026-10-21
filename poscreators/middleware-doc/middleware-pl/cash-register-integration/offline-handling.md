---
slug: /poscreators/middleware-doc/poland/cash-register-integration/offline-handling
title: Offline Handling
description: Why sales must stop in Poland when the register cannot be reached, and how the POS system handles ambiguous outcomes.
tags: [Poland, Offline, Failure Handling, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in Poland when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in Poland.

## No sales without a working register

Under Art. 111(3) of the Polish VAT Act, sales must not continue without a working register. There is no late-signing fallback for fiscal receipts: when the register cannot be reached, the fiskaltrust.Middleware does not queue the receipt for later signing. For more information, see [Register unreachable — Art. 111(3)](./cash-register-integration.md#register-unreachable--art-1113).

## Register not reachable

The fiskaltrust.Middleware responds with the error state `0x504C_2001_EEEE_EEEE`. In this case, the POS system:

1. stops selling,
2. shows the failure to the operator,
3. sends the request again once the register is reachable.

For more information, see [Service Status: ftState](../reference-tables/service-status-ftstate.md).

### Ambiguous outcomes

If the connection to the register or the register itself times out, it is unknown whether the register printed a fiscal document. The SCU never retries such a command, because a retry can produce a duplicate fiscal printout. The fiskaltrust.Middleware returns the state `0x504C_2001_EEEE_EEEE`, and the operator must verify the state of the device, for example via a Zero-Receipt, before the request is sent again. For more information, see [Response handling — ambiguous outcomes](../operation-modes/scu/posnet.md#response-handling--ambiguous-outcomes).

## POS system cannot reach the fiskaltrust.Middleware

Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).

## Checklist

- Stop selling and show the error when the response contains `0x504C_2001_EEEE_EEEE`.
- Before sending a request again after this state, have the operator verify the device state.
- Retry timeouts of the fiskaltrust.Middleware with the same `x-operation-id`.
