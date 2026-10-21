---
slug: /poscreators/middleware-doc/general/cash-register-integration/offline-handling
title: Offline Handling
description: Which scenarios make the fiskaltrust.Middleware unreachable for the POS system, what keeps working in each setup, and what the POS system must implement.
tags: [Offline, Failure Handling, Cash Register Integration, Middleware]
---

# Offline Handling

This page describes what the POS system must do when the fiskaltrust.Middleware is not reachable. The mechanisms themselves are described in [Failure Scenarios](./cash-register-integration-failure-scenarios.md) and [Error Handling](./error-handling.md).

What the POS system and the PosOperator may and must do in this case depends on the market. Some markets allow receipts to be signed later, others do not allow sales to continue at all. For the rules of your market, see [Offline handling by market](#offline-handling-by-market).

## What offline means

On these pages, **offline** means every situation in which the POS system does not receive a processed response from the fiskaltrust.Middleware. It does not matter why: for the POS system, the result is the same. The fiskaltrust.Middleware is the cash register, so a receipt only becomes part of the fiscal records once the fiskaltrust.Middleware has processed it.

The following scenarios lead to this situation:

| Scenario | Examples | What the POS system sees |
|----------|----------|--------------------------|
| **The network between the POS system and the fiskaltrust.Middleware fails** | The local network or Wi-Fi to an on-premise fiskaltrust.Middleware fails. The internet connection of the location to the CloudCashbox fails. | The connection cannot be established. |
| **The host of the fiskaltrust.Middleware is not available** | The device or server on which the fiskaltrust.Middleware runs is switched off, has no power or fails. | The connection cannot be established. |
| **The fiskaltrust.Middleware itself is not running** | The fiskaltrust.Middleware has not been started, has been stopped or has crashed. | The connection cannot be established. |
| **The request times out or the connection is interrupted** | The connection drops while the request is processed, or the response takes longer than the timeout of the POS system. | No response. It is unknown whether the receipt was processed. |
| **The fiskaltrust.Middleware cannot store the request** | The fiskaltrust.Middleware has no access to its database. | A response with the `ftState` `FFFF_FFFF`: nothing was processed or persisted. |
| **The whole POS system is down** | Power outage or failure of the POS system. | Nothing: receipts are written by hand. |

*Table 1. Scenarios in which the POS system does not receive a processed response from the fiskaltrust.Middleware.*

The first five scenarios are handled as described in [POS system cannot reach the fiskaltrust.Middleware](#pos-system-cannot-reach-the-fiskaltrustmiddleware), the last one as described in [Complete outage of the POS system](#complete-outage-of-the-pos-system).

## Which setups need an internet connection

Whether an internet outage makes the fiskaltrust.Middleware unreachable depends on where it runs and which signature device it uses:

| Architecture | Internet needed for each receipt | Effect of an internet outage |
|--------------|----------------------------------|------------------------------|
| **Local**: fiskaltrust.Middleware and hardware signature device on site | No | The POS system keeps fiscalizing. |
| **Hybrid**: fiskaltrust.Middleware on site, cloud signing service | Yes, for the connection to the signing service | The fiskaltrust.Middleware stays reachable, but cannot reach the SCU. |
| **Cloud**: CloudCashbox hosted by fiskaltrust | Yes, for the connection from the POS system to the fiskaltrust.Middleware | The POS system cannot reach the fiskaltrust.Middleware. |

*Table 2. Effect of an internet outage per architecture model.*

In markets where every receipt is transmitted to the tax authority in real time, every receipt needs an internet connection regardless of the architecture. For more information on the architecture models and which market supports which, see [Choosing a Middleware Architecture](../../../getting-started/choosing-an-architecture.md).

## POS system cannot reach the fiskaltrust.Middleware

1. **Retry first.** The receipt may have been processed and only the response was lost. Retry the request with the same `x-operation-id` and the same body. For a response with the `ftState` `FFFF_FFFF`, correct the cause before sending the request again. For more information, see [Error Handling](./error-handling.md#how-the-pos-system-should-react).
2. **Follow the market rules.** If the fiskaltrust.Middleware stays unreachable, the market decides how to continue:
   - In markets that support late signing, the POS system issues a receipt marked as created during a failure, buffers it, and sends it later with the flag `0x0000000000010000` (**Process as Late Signing Receipt**). A Zero-Receipt ends late-signing mode. For more information, see [Middleware not reachable or failing](./cash-register-integration-failure-scenarios.md#middleware-not-reachable-or-failing) and [Late-signing mode](../components/queues-terminals-locations.md#late-signing-mode).
   - In other markets, the POS system must not issue a fiscal receipt of its own. Depending on the market, sales stop or documents are issued on paper and recovered later.

## Complete outage of the POS system

If the whole POS system is unavailable, for example during a power outage, receipts are written by hand where local law requires it. Once the POS system works again, they can be sent to the fiskaltrust.Middleware with the flag `0x0000000000080000` (**Process as Handwritten Receipt**), in the order in which they were created. For more information, see [Cash register outage](./cash-register-integration-failure-scenarios.md#cash-register-outage).

## Related situations: the fiskaltrust.Middleware is reachable

In the following situations, the POS system still reaches the fiskaltrust.Middleware and receives a response, but the fiskaltrust.Middleware itself has lost a connection.

### fiskaltrust.Middleware cannot reach the SCU

The fiskaltrust.Middleware reaches the POS system but not the signature device, signing service or tax authority service, for example because a cloud signing service cannot be reached without internet.

- In markets with a fallback, the fiskaltrust.Middleware continues to process receipts in failed mode and returns the `ftState` flag `0000_0002`. Print the returned signature items. Once the SCU is reachable again, a Zero-Receipt ends failed mode. The receipts processed in failed mode are not sent again. For more information, see [Signature Creation Unit not reachable or failing](./cash-register-integration-failure-scenarios.md#signature-creation-unit-not-reachable-or-failing).
- In markets without such a fallback, the fiskaltrust.Middleware returns an error state, and the receipt is not fiscalized. For more information, see [Error Handling](./error-handling.md#how-the-pos-system-should-react).

### fiskaltrust.Middleware cannot reach the fiskaltrust cloud

A locally installed fiskaltrust.Middleware uses the fiskaltrust cloud for its configuration and packages, for uploading receipt data and for notifications. For the hostnames, see [Network Requirements](../../../../posdealers/technical-operations/middleware/network-requirements.md).

- Depending on the market, the .NET Launcher and the Mono Launcher load the configuration and the required packages from the fiskaltrust package server during startup. For installations without an internet connection, the .NET Offline Launcher includes a static configuration and the required packages. For more information, see [Installing and Configuring Components](../components/components-install-config.md#download-of-the-launcher).
- In offline mode, notifications are transported via Zero-Receipts within the signature block. For more information, see [Notifications](../configuration/configuration.md#notifications).

## What the POS system must implement

- **Retry with the same `x-operation-id`** after a timeout or a missing response, before treating the receipt as failed.
- **Distinguish the error levels** (no response, HTTP error, `ftState`) and react to each as described in [Error Handling](./error-handling.md#how-the-pos-system-should-react).
- **Signal failure states to the operator**, for example the `ftState` flags `0000_0002` (SCU out of service) and `0000_0008` (late-signing mode), and print all returned signature items.
- **Offer a Zero-Receipt as a manual function**, so that the operator can end failed mode or late-signing mode once the connection is back.
- **Buffer receipts persistently** where the market allows sales to continue, and send them in ascending order of `cbReceiptMoment` before the next closing.
- **Offer a way to record handwritten receipts** after a complete outage, where the market requires it.
- **Implement the market rules** described on the offline page of each market you support.

## Offline handling by market

The rules for each market are described on its own page:

- [Austria](../../middleware-at-rksv/cash-register-integration/offline-handling.md)
- [Belgium](../../middleware-be/cash-register-integration/offline-handling.md)
- [France](../../middleware-fr-boi-tva-decla-30-10-30/cash-register-integration/offline-handling.md)
- [Germany](../../middleware-de-kassensichv/cash-register-integration/offline-handling.md)
- [Greece](../../middleware-gr/cash-register-integration/offline-handling.md)
- [Italy](../../middleware-it-registratore-telematico/cash-register-integration/offline-handling.md)
- [Poland](../../middleware-pl/cash-register-integration/offline-handling.md)
- [Portugal](../../middleware-pt/cash-register-integration/offline-handling.md)
- [Spain](../../middleware-es/cash-register-integration/offline-handling.md)
