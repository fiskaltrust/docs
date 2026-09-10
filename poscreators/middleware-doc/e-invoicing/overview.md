---
slug: /poscreators/middleware-doc/e-invoicing/overview
title: E-Invoicing
---

# E-Invoicing — Overview

This page describes how e-invoicing works across fiskaltrust markets from a PosCreator's perspective: the **shared integration model** that every market follows, and what changes from one market to the next. For a specific market, follow its country page (see [Availability by market](#availability-by-market)).

For the product-level concept — structured invoices, Peppol, e-Delivery — see [Delivery (`/issue` Endpoint)](../experience-middleware/delivery.md). This page is the integration-focused companion to it.

:::info One integration, many markets
E-invoicing is produced and delivered through the `/sign` and `/issue` calls your POS already uses — **same account, same fiskaltrust.Middleware, same credentials**. It is enabled by **configuration** per market, not by a new integration. Where a market is live via the API, the new behaviour is additive inside calls you already make. Producing a valid e-invoice is new behaviour enabled by configuration; **fiscalizing a receipt does not by itself make it a valid e-invoice**.
:::

## The shared model

Across markets, e-invoicing is layered onto the existing fiscalization flow through three endpoints you already have:

| Element | Role in e-invoicing |
| --- | --- |
| `/sign` | Produces the structured e-invoice document (an EN 16931 profile, or a national schema) **alongside** the existing fiscalized receipt. |
| `/issue` | **Optional.** Registers the receipt (`ReceiptRequest` + `ReceiptResponse`) and delivers it to a recipient — a channel such as email/SMS, print, download, or a network. |
| `/journal` | Exports the operation data you sent, for audit and closings. It does **not** archive the e-invoice — revision-safe archiving is a separate concern. |

The connection, authentication, and endpoint surface do **not** change — no new endpoints, request headers, or credentials.

:::note Status is polled, not pushed
The PosSystem API is request/response and idempotent. **There is no status webhook** in any market — you re-check delivery/clearance status by calling the issue endpoint again (`GET /issue/{queueId}/{queueItemId}`). The `x-operation-id` header is the **idempotency key** that makes retries safe (reused unchanged on a retry, it re-returns the original result instead of re-executing) — it is not itself a status channel. This is the one invariant across every market.
:::

## The integration flow

Where the API path is available, the flow is the same shape everywhere — your existing fiscalization flow with one added step:

| Step | What happens |
| --- | --- |
| 1. Sign | Call `/sign` as you do today. The response also carries the e-invoice document. |
| 2. Issue for delivery (optional) | Register the receipt via `/issue`, then deliver it to a channel. |
| 3. Poll for status | Poll `GET /issue/{queueId}/{queueItemId}` until delivered / cleared. No webhook. |

## What varies by market

The model is constant; the specifics are market-driven:

- **Format** — an EN 16931 profile (XRechnung, Factur-X/ZUGFeRD) or a national schema (FatturaPA, KSeF FA(3), ebInterface).
- **Network / target** — Peppol, a national clearance hub (SDI, KSeF), or a national portal.
- **Regulatory model** — post-audit (no clearance) vs. centralised clearance (the invoice is cleared before it is legally valid).
- **Availability** — some markets are live via the API, one runs through the Portal / InStore App, and one is a build in progress.
- **Signatures & identifiers** — e.g. an XAdES signature (Italy) or routing identifiers (Leitweg-ID, CodiceDestinatario, KSeF number).

Exact case codes, delivery targets, and go-live status live on each **country page**.

## Availability by market

| Market | Regulatory model | Delivery path |
| --- | --- | --- |
| **Austria (AT)** | B2G mandated; B2B optional | Portal back office / InStore App today (POS-driven API pending) |
| **France (FR)** | B2B, decentralised (PDP) | API — `/sign` + `/issue` via the Plateforme Agréée |
| **Germany (DE)** | B2B, post-audit | API — `/sign` + `/issue` via Peppol |
| **Italy (IT)** | B2G/B2B/B2C, centralised clearance | API — `/sign` + `/issue` via SDI |
| **Poland (PL)** | B2B, centralised clearance | Build in progress — adapter not yet shipped |
| **EU (cross-border)** | Voluntary — no national mandate | API — `/sign` + `/issue` via Peppol |

Each market's **Overview** and **Setup & testing** pages live under its entry in **Country-Specific Guides** (in the sidebar).

## Prerequisites (shared)

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes via `/sign` in the target market. |
| fiskaltrust.Middleware country configuration | Set to the market's locale — this drives the output format. |
| PosSystem API (v2) | E-invoicing is exposed through the **PosSystem API (v2)**. If you don't integrate with it yet, start with the [PosSystem API introduction](../possystem-api/introduction.md). |
| Sandbox validation | Run one document end to end against a sandbox fiskaltrust.Middleware before the first live document. |

## Terminology

| Term | Meaning |
| --- | --- |
| **EN 16931** | The European semantic standard the national e-invoice formats are profiles of. |
| **Peppol** | A network e-invoices can be delivered over; fiskaltrust holds the access point. |
| **Receive mandate** | The date from which a business must be able to accept an incoming e-invoice. |
| **Issue mandate** | The date from which a business must send its invoices as e-invoices. |

Market-specific terms (XRechnung, ZUGFeRD, FatturaPA, XAdES, SDI, `CodiceDestinatario`, KSeF, Leitweg-ID, …) are defined on each country page.

## Related pages

- [Delivery (`/issue` Endpoint)](../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
- Country pages — see [Availability by market](#availability-by-market).
