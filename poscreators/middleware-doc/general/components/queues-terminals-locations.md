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
- the communication with the signing device or service (via the SCU).

Wherever national regulations require the cash register itself to be registered with the authorities, the fiskaltrust.Middleware is the authoritative system for this registration.

Every device, client or POS terminal that sends requests to the fiskaltrust.Middleware is an **input device** (input station). From a regulatory point of view, an input device is not the cash register. Several input devices can send their receipts to the same fiskaltrust.Middleware.

Integrators can optionally use `cbTerminalID` in the `ReceiptRequest` to differentiate between the input devices. `cbTerminalID` has no effect on the numbering of receipts or on any other mechanism of the fiskaltrust.Middleware. For more information, see [Data Structures](../data-structures/data-structures.md).

This model is shared across markets: in every market, the fiskaltrust.Middleware is the central unit for fiscalization, number series and receipt chaining. It is also independent of the platform and the [operation mode](../operation-modes/operation-modes.md): the same applies to an on-premise fiskaltrust.Middleware and to a fiskaltrust.Middleware hosted in the cloud.

## One receipt chain and one daily closing per fiskaltrust.Middleware

Every fiskaltrust.Middleware has exactly one receipt chain. This means that all input devices connected to the same fiskaltrust.Middleware share:

- **One number series.** The fiskaltrust.Middleware assigns `ftReceiptIdentification` from one sequence for all its receipts and makes sure that the numbers are unique. Whether one number series for all input devices fits the internal processes of the PosOperator (for example for reconciliation) must be clarified by the PosCreator and the PosOperator.
- **One daily closing.** A daily closing is executed per fiskaltrust.Middleware and covers the receipts of all input devices connected to it.

## How many fiskaltrust.Middleware instances to roll out

There has to be at least one fiskaltrust.Middleware per location.

The number of fiskaltrust.Middleware instances per location is decided by the architectural and operational requirements, in particular:

- **Number series:** If separate number series are required, for example per POS terminal, roll out one fiskaltrust.Middleware per number series.
- **Daily closings:** If separate daily closings are required, for example per POS terminal or per area, roll out one fiskaltrust.Middleware per daily closing.
- **Performance:** On-premise and cloud-hosted fiskaltrust.Middleware instances can differ in the load they can handle. In high-load scenarios (many input devices sending receipts simultaneously), evaluate the expected load for the chosen operation mode.

If none of these requirements applies, a single fiskaltrust.Middleware with all input devices of the location connected to it is sufficient.

Country-specific requirements, for example regarding the signing device, are described in the market appendices:

- Austria: [fiskaltrust.Middleware and input stations](../../middleware-at-rksv/cash-register-integration/cash-register-integration.md#fiskaltrustmiddleware-and-input-stations)
- Germany: [fiskaltrust.Middleware, terminals and the TSE](../../middleware-de-kassensichv/cash-register-integration/cash-register-integration.md#fiskaltrustmiddleware-terminals-and-the-tse)

For commercial limits, for example the number of fiskaltrust.Middleware instances (queues) or terminals per outlet, see the fair use policy of your market or contact your fiskaltrust commercial contact.

## When the fiskaltrust.Middleware is not reachable

Whether the fiskaltrust.Middleware runs on-premise or in the cloud, the POS system must handle the case that the fiskaltrust.Middleware is not reachable. The required steps depend on the market regulations; in general, the receipts are re-sent to the fiskaltrust.Middleware in late-signing mode once it is reachable again. For more information, see [Failure Scenarios](../cash-register-integration/cash-register-integration-failure-scenarios.md) and [Error Handling](../cash-register-integration/error-handling.md).
