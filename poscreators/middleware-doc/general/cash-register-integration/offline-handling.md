---
slug: /poscreators/middleware-doc/general/cash-register-integration/offline-handling
title: Offline Handling
description: Which connections the fiskaltrust.Middleware depends on, what keeps working when one of them is lost, and what the POS system must implement for offline situations.
tags: [Offline, Failure Handling, Cash Register Integration, Middleware]
---

# Offline Handling

This page gives an overview of the offline situations a POS system must handle when it uses the fiskaltrust.Middleware: which connections exist, what happens when one of them is lost, and what the POS system must implement. The mechanisms themselves are described in [Failure Scenarios](./cash-register-integration-failure-scenarios.md) and [Error Handling](./error-handling.md).

What the POS system and the PosOperator may and must do while offline depends on the market. Some markets allow receipts to be signed later, others do not allow sales to continue at all. For the rules of your market, see [Offline handling by market](#offline-handling-by-market).

## Connections the fiskaltrust.Middleware depends on

"Offline" can mean that one of the following connections is lost. Each one has different consequences:

| Connection | Needed for | If it is lost |
|------------|------------|---------------|
| POS system → fiskaltrust.Middleware | Every receipt. The fiskaltrust.Middleware is the cash register; a receipt is only part of the fiscal records once it has processed it. | The POS system receives no response. See [POS system cannot reach the fiskaltrust.Middleware](#pos-system-cannot-reach-the-fiskaltrustmiddleware). |
| fiskaltrust.Middleware → signature device, signing service or tax authority (SCU) | Signing or registering receipts, where the market requires it. | Depending on the market, the fiskaltrust.Middleware continues in failed mode or returns an error. See [fiskaltrust.Middleware cannot reach the SCU](#fiskaltrustmiddleware-cannot-reach-the-scu). |
| fiskaltrust.Middleware → fiskaltrust cloud | Downloading the configuration and packages, uploading receipt data, notifications. | Receipt processing of a locally installed fiskaltrust.Middleware continues. See [fiskaltrust.Middleware cannot reach the fiskaltrust cloud](#fiskaltrustmiddleware-cannot-reach-the-fiskaltrust-cloud). |
| Power or the whole POS system | Everything. | Receipts are written by hand. See [Complete outage of the POS system](#complete-outage-of-the-pos-system). |

*Table 1. Connections of the fiskaltrust.Middleware and the consequences of losing them.*

## Which setups need an internet connection

Whether an internet outage interrupts fiscalization depends on where the fiskaltrust.Middleware runs and which signature device it uses:

| Architecture | Internet needed for each receipt | Effect of an internet outage |
|--------------|----------------------------------|------------------------------|
| **Local**: fiskaltrust.Middleware and hardware signature device on site | No | The POS system keeps fiscalizing. |
| **Hybrid**: fiskaltrust.Middleware on site, cloud signing service | Yes, for the connection to the signing service | The fiskaltrust.Middleware cannot reach the SCU. |
| **Cloud**: CloudCashbox hosted by fiskaltrust | Yes, for the connection from the POS system to the fiskaltrust.Middleware | The POS system cannot reach the fiskaltrust.Middleware. |

*Table 2. Effect of an internet outage per architecture model.*

In markets where every receipt is transmitted to the tax authority in real time, every receipt needs an internet connection regardless of the architecture. For more information on the architecture models and which market supports which, see [Choosing a Middleware Architecture](../../../getting-started/choosing-an-architecture.md).

## POS system cannot reach the fiskaltrust.Middleware

The POS system receives no response, for example because the network, the host of the fiskaltrust.Middleware or the internet connection to the CloudCashbox fails.

1. **Retry first.** The receipt may have been processed and only the response was lost. Retry the request with the same `x-operation-id` and the same body. For more information, see [Error Handling](./error-handling.md#how-the-pos-system-should-react).
2. **Follow the market rules.** If the fiskaltrust.Middleware stays unreachable, the market decides how to continue:
   - In markets that support late signing, the POS system issues a receipt marked as created during a failure, buffers it, and sends it later with the flag `0x0000000000010000` (**Process as Late Signing Receipt**). A Zero-Receipt ends late-signing mode. For more information, see [Middleware not reachable or failing](./cash-register-integration-failure-scenarios.md#middleware-not-reachable-or-failing) and [Late-signing mode](../components/queues-terminals-locations.md#late-signing-mode).
   - In other markets, the POS system must not issue a fiscal receipt of its own. Depending on the market, sales stop or documents are issued on paper and recovered later.

## fiskaltrust.Middleware cannot reach the SCU

The fiskaltrust.Middleware reaches the POS system but not the signature device, signing service or tax authority service, for example because a cloud signing service cannot be reached without internet.

- In markets with a fallback, the fiskaltrust.Middleware continues to process receipts in failed mode and returns the `ftState` flag `0000_0002`. Print the returned signature items. Once the SCU is reachable again, a Zero-Receipt ends failed mode. The receipts processed in failed mode are not sent again. For more information, see [Signature Creation Unit not reachable or failing](./cash-register-integration-failure-scenarios.md#signature-creation-unit-not-reachable-or-failing).
- In markets without such a fallback, the fiskaltrust.Middleware returns an error state, and the receipt is not fiscalized. For more information, see [Error Handling](./error-handling.md#how-the-pos-system-should-react).

## fiskaltrust.Middleware cannot reach the fiskaltrust cloud

A locally installed fiskaltrust.Middleware uses the fiskaltrust cloud for its configuration and packages, for uploading receipt data and for notifications. For the hostnames, see [Network Requirements](../../../../posdealers/technical-operations/middleware/network-requirements.md).

- Depending on the market, the .NET Launcher and the Mono Launcher load the configuration and the required packages from the fiskaltrust package server during startup. For installations without an internet connection, the .NET Offline Launcher includes a static configuration and the required packages. For more information, see [Installing and Configuring Components](../components/components-install-config.md#download-of-the-launcher).
- In offline mode, notifications are transported via Zero-Receipts within the signature block. For more information, see [Notifications](../configuration/configuration.md#notifications).

## Complete outage of the POS system

If the whole POS system is unavailable, for example during a power outage, receipts are written by hand where local law requires it. Once the POS system works again, they can be sent to the fiskaltrust.Middleware with the flag `0x0000000000080000` (**Process as Handwritten Receipt**), in the order in which they were created. For more information, see [Cash register outage](./cash-register-integration-failure-scenarios.md#cash-register-outage).

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
