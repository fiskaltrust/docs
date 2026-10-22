---
slug: /poscreators/middleware-doc/general/components/queues-terminals-locations
title: fiskaltrust.Middleware, Terminals and Locations
description: Why the fiskaltrust.Middleware is the cash register in the regulatory sense, how POS terminals connect to it, and how many fiskaltrust.Middleware instances a location needs.
tags: [Architecture, Queue, cbTerminalID, Rollout, Middleware]
---

# fiskaltrust.Middleware, Terminals and Locations

This page describes the role of the fiskaltrust.Middleware from a regulatory point of view and how to decide how many fiskaltrust.Middleware instances to roll out per location. For more information on the components themselves, see [Middleware Components](components.md).

## The fiskaltrust.Middleware is the cash register

The fiskaltrust.Middleware (queue) is the cash register in the regulatory sense. The national regulations use their own terms for it, which are described in the market appendices. The fiskaltrust.Middleware is the authoritative system for:

- the numbering of receipts,
- the chaining of receipts (receipt chain),
- the cumulative counters (for example totals),
- the storage of receipts and journals,
- the communication with the signing device or service (via the SCU),
- the closings (for example daily, monthly and yearly closings),
- the exports required by the national regulations (for example the DSFinV-K in Germany or the DEP 7 in Austria).

Wherever national regulations require the cash register itself to be registered with the authorities, the fiskaltrust.Middleware is the authoritative system for this registration.

Every device, client or POS terminal that sends requests to the fiskaltrust.Middleware is an **input device** (input station). From a regulatory point of view, an input device is not the cash register. Several input devices can send their receipts to the same fiskaltrust.Middleware.

Integrators can optionally use `cbTerminalID` in the `ReceiptRequest` to differentiate between the input devices. `cbTerminalID` has no effect on the numbering of receipts or on the receipt chain. If it is used, keep it stable per input device: some markets use it to match a resent request to the original receipt (for example [Germany](../../middleware-de-kassensichv/cash-register-integration/cash-register-integration.md#resending-receipts-without-signing-them-twice)). For more information, see [Data Structures](../data-structures/data-structures.md).

This model is shared across markets: in every market, the fiskaltrust.Middleware is the central unit for fiscalization, number series and receipt chaining. It is also independent of the platform and the [operation mode](../operation-modes/operation-modes.md): the same applies to an on-premise fiskaltrust.Middleware and to a fiskaltrust.Middleware hosted in the cloud.

## One receipt chain and shared closings per fiskaltrust.Middleware

Every fiskaltrust.Middleware has exactly one receipt chain. This means that all input devices connected to the same fiskaltrust.Middleware share:

- **One number series.** The fiskaltrust.Middleware assigns `ftReceiptIdentification` from one sequence for all its receipts and makes sure that the numbers are unique. Whether one number series for all input devices fits the internal processes of the PosOperator (for example for reconciliation) must be clarified by the PosCreator and the PosOperator.
- **The same closings.** All closings (for example daily, monthly and yearly closings) are executed per fiskaltrust.Middleware and cover the receipts of all input devices connected to it.
- **The same exports.** The exports of the fiskaltrust.Middleware contain the receipts of all input devices connected to it.

## How many fiskaltrust.Middleware instances to roll out

There has to be at least one fiskaltrust.Middleware per location.

The number of fiskaltrust.Middleware instances per location is decided by the architectural and operational requirements, in particular:

- **Number series:** If separate receipt number series are required, for example per POS terminal, roll out one fiskaltrust.Middleware per number series. This applies to the receipt counter of the fiskaltrust.Middleware (`ftReceiptIdentification`). Fiscal invoice numbers can follow their own rules per market: in Italy, for example, FatturaPA invoice numbers are assigned per merchant and year across all cashboxes, so additional fiskaltrust.Middleware instances do not create separate invoice series.
- **Closings:** If separate closings are required, for example per POS terminal or per area, roll out one fiskaltrust.Middleware per closing scope.
- **Performance:** On-premise and cloud-hosted fiskaltrust.Middleware instances can differ in the load they can handle. In high-load scenarios (many input devices sending receipts simultaneously), evaluate the expected load for the chosen operation mode.

If none of these requirements applies, a single fiskaltrust.Middleware with all input devices of the location connected to it is sufficient.

Country-specific requirements, for example regarding the signing device, are described in the market appendices:

- Austria: [fiskaltrust.Middleware and input stations](../../middleware-at-rksv/cash-register-integration/cash-register-integration.md#fiskaltrustmiddleware-and-input-stations)
- Germany: [fiskaltrust.Middleware, terminals and the TSE](../../middleware-de-kassensichv/cash-register-integration/cash-register-integration.md#fiskaltrustmiddleware-terminals-and-the-tse)

For commercial limits, for example the number of fiskaltrust.Middleware instances (queues) or terminals per outlet, see the fair use policy of your market or contact your fiskaltrust commercial contact.

## When the fiskaltrust.Middleware is not reachable

Whether the fiskaltrust.Middleware runs on-premise or in the cloud, the POS system must handle the case that the fiskaltrust.Middleware is not reachable.

How this case must be handled depends on the market. Not every market allows sales to continue while the fiskaltrust.Middleware is not reachable. Check the market appendix for the rules that apply before implementing the buffering described below.

As the fiskaltrust.Middleware is the cash register, a receipt only becomes part of the fiscal records once the fiskaltrust.Middleware has processed it. While the fiskaltrust.Middleware is not reachable, the receipts created by the input devices:

- have no receipt number of the fiskaltrust.Middleware and are not part of the receipt chain,
- are not signed by the signing device or service,
- are not stored in the journals of the fiskaltrust.Middleware,
- are not counted in the closings and are not contained in the exports.

Where the market allows sales to continue, the POS system must consider the following:

- **Buffer every receipt.** Store all receipts that could not be sent, so that none is lost, for example on a restart of the POS system.
- **Re-send all buffered receipts** as soon as the fiskaltrust.Middleware is reachable again, so that the fiskaltrust.Middleware processes them in late-signing mode (see below).
- **Avoid processing a receipt twice.** If no response was received, the fiskaltrust.Middleware may already have processed the receipt. Retry the original request before sending it as a failed receipt. For more information, see [Error Handling](../cash-register-integration/error-handling.md#how-the-pos-system-should-react).
- **Send all buffered receipts before a closing**, so that the closing covers them.
- **Issue receipts according to the market regulations.** The receipts handed out during the failure do not contain the data returned by the fiskaltrust.Middleware. What these receipts must contain depends on the market regulations.

### Late-signing mode

Late-signing mode is the mode in which the fiskaltrust.Middleware processes the receipts that the POS system created while the fiskaltrust.Middleware was not reachable. It works as follows:

1. **Re-send the buffered receipts.** The POS system sends each buffered receipt with the `ftReceiptCaseFlag` `0x0000000000010000` (**Process as Late Signing Receipt**). Keep the original `cbReceiptMoment` of each receipt and send the receipts in ascending order of `cbReceiptMoment`.
2. **The fiskaltrust.Middleware enters late-signing mode.** It processes each of these receipts like a regular receipt: it assigns the receipt number, adds the receipt to the receipt chain, stores it and, where the market regulations require it, signs it afterwards. The response contains the `ftState` flag `0000_0008` (Late Signing Mode is active).
3. **End late-signing mode with a Zero-Receipt.** After all buffered receipts have been sent successfully, the POS system sends a Zero-Receipt. The response contains the normal `ftState` again, and the fiskaltrust.Middleware is back in normal operation.

From the moment they are processed in late-signing mode, the receipts are part of the receipt chain, the closings and the exports of the fiskaltrust.Middleware.

For more information, see [Failure Scenarios](../cash-register-integration/cash-register-integration-failure-scenarios.md#middleware-not-reachable-or-failing), [ftReceiptCaseFlag](../reference-tables/reference-tables.md#ftreceiptcaseflag) and [Service Status: ftState](../reference-tables/reference-tables.md#service-status-ftstate).
