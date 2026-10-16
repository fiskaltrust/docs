---
slug: /poscreators/middleware-doc/general/components/queues-terminals-locations
title: Queues, Terminals and Locations
description: Why the fiskaltrust.Middleware is the electronic recording system, how POS terminals connect to a queue, and how many queues a location needs.
tags: [Architecture, Queue, cbTerminalID, Rollout, Middleware]
---

# Queues, Terminals and Locations

This page describes the role of the fiskaltrust.Middleware from a regulatory point of view and how to decide how many Middleware instances (queues) to roll out per location. For more information on the components themselves, see [Middleware Components](components.md).

## The Middleware is the electronic recording system

The fiskaltrust.Middleware (queue) is the electronic recording system (ECR) in the regulatory sense, that is, the cash register. It is the authoritative system for:

- the numbering of receipts,
- the chaining of receipts (receipt chain),
- the communication with the signing device or service (via the SCU).

The Middleware is therefore the system that is registered with the authorities.

Every device, client or POS terminal that sends requests to the Middleware is an **input device** (input station). From a regulatory point of view, an input device is not the electronic recording system. Several input devices can send their receipts to the same queue. The POS system identifies the sending input device in the `ReceiptRequest` with `cbTerminalID`. For more information, see [Data Structures](../data-structures/data-structures.md).

This model is shared across markets: in every market, the queue is the central unit for fiscalization, number series and receipt chaining. It is also independent of the platform and the [operation mode](../operation-modes/operation-modes.md): the same applies to an on-premise Middleware and to a Middleware hosted in the cloud.

## One receipt chain and one daily closing per queue

Every queue has exactly one receipt chain. This means that all input devices connected to the same queue share:

- **One number series.** The Middleware assigns `ftReceiptIdentification` from one sequence for all receipts of the queue and makes sure that the numbers are unique. Whether one number series for all input devices fits the internal processes of the PosOperator (for example for reconciliation) must be clarified by the PosCreator and the PosOperator.
- **One daily closing.** A daily closing is executed per queue and covers the receipts of all input devices of that queue.

## How many queues to roll out

There has to be at least one fiskaltrust.Middleware (queue) per location.

The number of queues per location is decided by the architectural and operational requirements, in particular:

- **Number series:** If separate number series are required, for example per POS terminal, roll out one queue per number series.
- **Daily closings:** If separate daily closings are required, for example per POS terminal or per area, roll out one queue per daily closing.
- **Performance:** On-premise and cloud-hosted Middleware instances can differ in the load they can handle. In high-load scenarios (many input devices sending receipts simultaneously), evaluate the expected load for the chosen operation mode.

If none of these requirements applies, a single queue with all input devices of the location connected to it is sufficient.

Country-specific requirements, for example regarding the signing device, are described in the market appendices:

- Germany: [Queues, terminals and the TSE](../../middleware-de-kassensichv/cash-register-integration/cash-register-integration.md#queues-terminals-and-the-tse)

For commercial limits, for example the number of queues or terminals per outlet, see the fair use policy of your market or contact your fiskaltrust commercial contact.

## When the Middleware is not reachable

Whether the Middleware runs on-premise or in the cloud, the POS system must handle the case that the Middleware is not reachable. The required steps depend on the market regulations; in general, the receipts are re-sent to the Middleware in late-signing mode once it is reachable again. For more information, see [Failure Scenarios](../cash-register-integration/cash-register-integration-failure-scenarios.md) and [Error Handling](../cash-register-integration/error-handling.md).
