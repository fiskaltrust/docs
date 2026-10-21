---
slug: /poscreators/middleware-doc/general/cash-register-integration/middleware-not-reachable
title: Middleware Not Reachable
description: The failure scenario in which the POS system cannot reach the fiskaltrust.Middleware - its causes, which setups depend on which connection, and what the POS system must implement.
tags: [Failure Handling, Failure Scenarios, Offline, Cash Register Integration, Middleware]
---

# Middleware Not Reachable

This page describes one of the [failure scenarios](./cash-register-integration-failure-scenarios.md): the POS system cannot reach the fiskaltrust.Middleware. The other failure scenarios, in which the fiskaltrust.Middleware cannot reach its signature creation unit or the whole cash register is down, are described in [Failure Scenarios](./cash-register-integration-failure-scenarios.md).

The fiskaltrust.Middleware is the cash register: a receipt only becomes part of the fiscal records once the fiskaltrust.Middleware has processed it. What the POS system and the PosOperator may and must do while it is not reachable depends on the market. Some markets allow receipts to be signed later, others do not allow sales to continue. For the rules of your market, see [Middleware not reachable by market](#middleware-not-reachable-by-market).

## Causes

The fiskaltrust.Middleware is not reachable whenever the POS system does not receive a response from it. The cause does not matter: for the POS system, the result is the same.

| Cause | Examples | What the POS system sees |
|-------|----------|--------------------------|
| **The network between the POS system and the fiskaltrust.Middleware fails** | The local network or Wi-Fi to an on-premise fiskaltrust.Middleware fails. The internet connection of the location to the CloudCashbox fails. | The connection cannot be established. |
| **The host of the fiskaltrust.Middleware is not available** | The device or server on which the fiskaltrust.Middleware runs is switched off, has no power or fails. | The connection cannot be established. |
| **The fiskaltrust.Middleware is not running** | The fiskaltrust.Middleware has not been started, has been stopped or has crashed. | The connection cannot be established. |
| **The request times out or the connection is interrupted** | The connection drops while the request is processed, or the response takes longer than the timeout of the POS system. | No response. It is unknown whether the receipt was processed. |

*Table 1. Causes of the failure scenario "Middleware not reachable".*

## Which connection the POS system depends on

Where the fiskaltrust.Middleware runs decides which connection the POS system needs to reach it:

| Where the fiskaltrust.Middleware runs | Connection from the POS system |
|---------------------------------------|--------------------------------|
| **On premise**, on the POS device or a local server | Local network. An internet outage alone does not make the fiskaltrust.Middleware unreachable. |
| **In the cloud** (CloudCashbox) | Internet connection of the location. An internet outage makes the fiskaltrust.Middleware unreachable. |

*Table 2. Connection the POS system needs to reach the fiskaltrust.Middleware.*

For more information on the architecture models, see [Choosing a Middleware Architecture](../../../getting-started/choosing-an-architecture.md).

## What the POS system must do

1. **Retry first.** The receipt may have been processed and only the response was lost. Retry the request with the same `x-operation-id` and the same body. For more information, see [Error Handling](./error-handling.md#how-the-pos-system-should-react).
2. **Follow the market rules.** If the fiskaltrust.Middleware stays unreachable, the market decides how to continue:
   - In markets that support late signing, the POS system issues a receipt marked as created during a failure, buffers it, and sends it later with the flag `0x0000000000010000` (**Process as Late Signing Receipt**). A Zero-Receipt ends late-signing mode. For more information, see [Middleware not reachable or failing](./cash-register-integration-failure-scenarios.md#middleware-not-reachable-or-failing) and [Late-signing mode](../components/queues-terminals-locations.md#late-signing-mode).
   - In other markets, the POS system must not issue a fiscal receipt of its own. Depending on the market, sales stop or documents are issued on paper and recovered later.

For what a receipt created during the failure lacks and how to buffer receipts, see [When the fiskaltrust.Middleware is not reachable](../components/queues-terminals-locations.md#when-the-fiskaltrustmiddleware-is-not-reachable).

## What the POS system must implement

- **Retry with the same `x-operation-id`** after a timeout or a missing response, before treating the receipt as failed.
- **Detect the failure and signal it to the operator.**
- **Buffer receipts persistently** where the market allows sales to continue, and send them in ascending order of `cbReceiptMoment` before the next closing.
- **Offer a Zero-Receipt as a manual function**, so that the operator can end late-signing mode once the fiskaltrust.Middleware is reachable again.
- **Implement the market rules** described on the page of each market you support.

## Middleware not reachable by market

The rules for each market are described on its own page:

- [Austria](../../middleware-at-rksv/cash-register-integration/middleware-not-reachable.md)
- [Belgium](../../middleware-be/cash-register-integration/middleware-not-reachable.md)
- [France](../../middleware-fr-boi-tva-decla-30-10-30/cash-register-integration/failure-scenario.md#middleware-not-reachable-or-failing)
- [Germany](../../middleware-de-kassensichv/cash-register-integration/middleware-not-reachable.md)
- [Greece](../../middleware-gr/cash-register-integration/middleware-not-reachable.md)
- [Italy](../../middleware-it-registratore-telematico/cash-register-integration/middleware-not-reachable.md)
- [Poland](../../middleware-pl/cash-register-integration/middleware-not-reachable.md)
- [Portugal](../../middleware-pt/cash-register-integration/middleware-not-reachable.md)
- [Spain](../../middleware-es/cash-register-integration/middleware-not-reachable.md)
