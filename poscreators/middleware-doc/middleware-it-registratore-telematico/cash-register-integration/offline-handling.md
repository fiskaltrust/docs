---
slug: /poscreators/middleware-doc/italy/cash-register-integration/offline-handling
title: Offline Handling
description: Which setups in Italy need an internet connection, how RT servers buffer documents in asynchronous mode, and what the POS system must do when the RT device cannot be reached.
tags: [Italy, Offline, Failure Handling, RT, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in Italy when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in Italy.

## Which setups need an internet connection

- **RT printers and RT servers** are reached by the fiskaltrust.Middleware over the local network.
- The **IvaServizi** SCU connects to the government service of the Agenzia delle Entrate (Documento Commerciale Online) and needs an internet connection. For more information, see [IvaServizi](../operation-modes/scu/ivaservizi.md).
- The **CloudCashbox** needs an internet connection for every receipt. Its SCU can still connect to an RT printer or RT server on site.

## RT device not reachable

If the RT device cannot be reached, the receipt is not fiscalized, and the fiskaltrust.Middleware returns a `ftState` with the error value `EEEE_EEEE` and the error message in a failure signature item. Show the error to the operator and send the request again once the device is reachable. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).

### Asynchronous signing with RT servers

RT servers can be configured to buffer documents while the device is temporarily unreachable (`SendReceiptsSync = false`). In this mode, the POS system receives the signatures immediately, and the documents are cached on disk and transmitted to the device in the background, in blockchain order.

Asynchronous mode requires a persistent `ServiceFolder` or `CacheDirectory`. Without one, for example on the CloudCashbox, the SCU signs synchronously. For more information, see [Synchronous vs. asynchronous signing](../operation-modes/scu/epsonserver.md#synchronous-vs-asynchronous-signing).

## POS system cannot reach the fiskaltrust.Middleware

Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the receipt, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).

## Checklist

- Do not issue a fiscal receipt when the response contains an error state.
- On local installations with RT servers, decide whether to use asynchronous signing, and configure a persistent folder for it.
- Retry timeouts with the same `x-operation-id`.
