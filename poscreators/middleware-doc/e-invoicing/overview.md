---
slug: /poscreators/middleware-doc/e-invoicing/overview
title: E-Invoicing
---

# E-Invoicing — Overview

This page describes how e-invoicing works across fiskaltrust markets from a PosCreator's perspective: the **shared integration model** that every market follows, and what changes from one market to the next. For a specific market, follow its country page (see [Availability by market](#availability-by-market)).

For the product-level concept — structured invoices, Peppol, e-Delivery — see [Delivery (`/issue` Endpoint)](../experience-middleware/delivery.md). This page is the integration-focused companion to it.

:::info One integration, many markets
E-invoicing is produced and delivered through the `/sign` and `/issue` calls your POS already uses — **same account, same CashBox, same credentials**. It is enabled by **configuration** per market, not by a new integration. Where a market is live via the API, the new behaviour is additive inside calls you already make.
:::

## The shared model

Across markets, e-invoicing is layered onto the existing fiscalization flow through three endpoints you already have:

| Element | Role in e-invoicing |
| --- | --- |
| `/sign` | Produces the structured e-invoice document (an EN 16931 profile, or a national schema) **alongside** the existing fiscalized receipt. |
| `/issue` | Delivers the document to the market's network or target, and returns the delivery/clearance status. |
| `/journal` | Holds the e-invoice archive copy. No separate archive call to add. |

The connection, authentication, and endpoint surface do **not** change — no new endpoints, request headers, or credentials.

:::note Status is polled, not pushed
The PosSystem API is request/response and idempotent. **There is no status webhook** in any market — you poll `/issue` for delivery/clearance status, reusing the same `x-operation-id` to re-check. This is the one invariant across every market.
:::

## The integration flow

Where the API path is available, the flow is the same shape everywhere — your existing fiscalization flow with one added step:

| Step | What happens |
| --- | --- |
| 1. Sign | Call `/sign` as you do today. The response also carries the e-invoice document. |
| 2. Issue for delivery | Call `/issue` with the market's delivery target — the one new parameter. |
| 3. Poll for status | Call `/issue` status until it reports delivered / cleared. No webhook. |
| 4. Archive | Already handled — the document sits in `/journal`. |

## What varies by market

The model is constant; the specifics are market-driven:

- **Format** — an EN 16931 profile (XRechnung, Factur-X/ZUGFeRD) or a national schema (FatturaPA, KSeF FA(3), ebInterface).
- **Network / target** — Peppol, a national clearance hub (SDI, KSeF), or a national portal.
- **Regulatory model** — post-audit (no clearance) vs. centralised clearance (the invoice is cleared before it is legally valid).
- **Availability** — some markets are live via the API, one runs through the Portal / InStore App, and one is a build in progress.
- **Signatures & identifiers** — e.g. an XAdES signature (Italy) or routing identifiers (Leitweg-ID, CodiceDestinatario, KSeF number).

Exact case codes, delivery-target parameters, and go-live status live on each **country page** and may be marked `TBC` until confirmed with product.

## Availability by market

| Market | Regulatory model | Delivery path | Pages |
| --- | --- | --- | --- |
| **Austria (AT)** | B2G mandated; B2B optional | Portal back office / InStore App today (POS-driven API pending) | [Overview](../middleware-at-rksv/e-invoicing/overview.md) · [Setup](../middleware-at-rksv/e-invoicing/setup.md) |
| **France (FR)** | B2B, decentralised (PDP) | API — `/sign` + `/issue` over the Plateforme Agréée | [Overview](../middleware-fr-boi-tva-decla-30-10-30/e-invoicing/overview.md) · [Setup](../middleware-fr-boi-tva-decla-30-10-30/e-invoicing/setup.md) |
| **Germany (DE)** | B2B, post-audit | API — `/sign` + `/issue` over Peppol | [Overview](../middleware-de-kassensichv/e-invoicing/overview.md) · [Setup](../middleware-de-kassensichv/e-invoicing/setup.md) |
| **Italy (IT)** | B2G/B2B/B2C, centralised clearance | API — `/sign` + `/issue` over SDI | [Overview](../middleware-it-registratore-telematico/e-invoicing/overview.md) · [Setup](../middleware-it-registratore-telematico/e-invoicing/setup.md) |
| **Poland (PL)** | B2B, centralised clearance | Build in progress — adapter not yet shipped | [Overview](../middleware-pl-ksef/e-invoicing/overview.md) · [Setup](../middleware-pl-ksef/e-invoicing/setup.md) |

## Prerequisites (shared)

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + CashBox | An active account with a configured CashBox. See [Portal registration](../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes via `/sign` in the target market. |
| CashBox country configuration | Set to the market's locale — this drives the output format. |
| PosSystem API (v2) | E-invoicing is exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../possystem-api/migration-guide.md) first. |
| Sandbox validation | Run one document end to end against a sandbox CashBox before the first live document. |

## Related pages

- [Delivery (`/issue` Endpoint)](../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
- Country pages — see [Availability by market](#availability-by-market).
