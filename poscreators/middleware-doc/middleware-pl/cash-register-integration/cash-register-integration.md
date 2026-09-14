---
slug: /poscreators/middleware-doc/poland/cash-register-integration
title: Cash Register Integration
---

# Cash Register Integration

This chapter describes the cash register integration in accordance with Polish law. The general rules for cash register integration are described in the Chapter [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) of the general part.

## Division of responsibilities

In Poland the certified register (kasa online or software register) owns fiscal compliance. The Middleware forwards fiscal receipt cases to the register through the configured SCU and returns the register's identifiers on the response. Concretely, the register — not the Middleware — owns:

- fiscal document numbering,
- the PTU (VAT) rate table and its slot letters (A–G),
- the daily (Z) report and periodic reports,
- the transmission of fiscal data to the CRK.

The Middleware validates protocol constraints the register would reject anyway (currency, mixed sale/return positions, missing buyer NIP on a paragon z NIP) and translates receipt cases into register operations.

## Available SCUs

| SCU | Type, Form factor | Status |
|-----|-------------------|--------|
| [POSNET Printer](../operation-modes/scu/posnet.md) (`fiskaltrust.Middleware.SCU.PL.PosNet`) | Hardware printer | in development (preview) |

For development without a physical register, the Polish sandbox provides a fake register with the same `IPLSSCD` behavior (used by the CloudCashbox sandbox and the developer sample).

## Fiscalization of the register

Fiscalizing a Polish register is a certified-technician (serwis) act — it is not an operation of the Middleware. The initial-operation receipt (`0x504C_2000_0000_4001`) therefore does not fiscalize a device: it registers the queue and verifies that the connected register reports itself as fiscalized.

## Register unreachable — Art. 111(3)

Under Art. 111(3) of the Polish VAT Act, sales must not continue without a working register. When the register cannot be reached, the Middleware does not queue the receipt for later signing; it responds with the dedicated error state `0x504C_2001_EEEE_EEEE` (see [Service Status: ftState](../reference-tables/service-status-ftstate.md)) so the POS can stop selling and surface the failure to the operator.

## Invoices

Invoice receipt cases (`0x1xxx`) are never sent to the cash register: invoices are fiscalized via KSeF. Until a KSeF SCU is configured, the Middleware persists the invoice request/response pair and marks the response with the informational signature *"Stored, not fiscalized"* (`0x504C_2000_0000_0106`).
