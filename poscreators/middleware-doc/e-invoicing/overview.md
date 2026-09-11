---
slug: /poscreators/middleware-doc/e-invoicing/overview
title: eInvoicing
sidebar_label: "eInvoicing — Overview"
---

# eInvoicing — Overview

This page describes how eInvoicing works across fiskaltrust markets from a PosCreator's perspective: the **shared integration model** that every market follows, what changes from one market to the next, and how far each market is today. For a specific market, follow its country page (see [Availability by market](#availability-by-market)).

For the product-level concept — structured invoices, Peppol, eDelivery — see [Delivery (`/issue` Endpoint)](../experience-middleware/delivery.md). This page is the integration-focused companion to it.

:::info One integration, many markets
eInvoicing is produced and delivered through the `/sign` and `/issue` calls your POS already uses — **same account, same fiskaltrust.Middleware, same credentials**. It is enabled by **configuration** per market, not by a new integration. The behaviour is additive inside calls you already make. Producing a valid eInvoice is new behaviour enabled by configuration; **fiscalizing a receipt does not by itself make it a valid eInvoice**.
:::

:::caution Target state vs. today
This page describes the **target model** fiskaltrust is building towards in every market. Where a market or a capability is not shipped yet, it is marked as such in [Availability by market](#availability-by-market) and in [What is available today](#what-is-available-today). Do not plan a go-live on a row marked *target state* — contact your fiskaltrust partner manager for the roadmap.
:::

## The shared model

Across markets, eInvoicing is layered onto the existing fiscalization flow through three endpoints you already have:

| Element | Role in eInvoicing |
| --- | --- |
| `/sign` | Fiscalizes the receipt. **Target state:** the response also carries the structured eInvoice document (an EN 16931 profile, or a national schema) alongside the fiscalized receipt. **Today:** the document is produced from the fiscalized receipt when you request it via `/issue` (see below). |
| `/issue` | **Optional.** Registers the receipt (`ReceiptRequest` + `ReceiptResponse`) with fiskaltrust, then lets you **download** it in a structured format or **send** it to a target — email, SMS, or a Peppol participant. |
| `/journal` | Exports the operation data you sent, for audit and closings. It does **not** archive the eInvoice — revision-safe archiving is a separate concern. |

The connection, authentication, and endpoint surface do **not** change — no new endpoints, request headers, or credentials.

:::note Status is polled, not pushed
The PosSystem API is request/response and idempotent. **There is no status webhook** in any market. A `send` via `/issue` returns its result synchronously; to re-check afterwards whether a receipt has been delivered at least once, call `GET /issue/{queueId}/{queueItemId}/delivered` (`200` delivered, `204` not yet), or use the long-polling variant `GET /BlockIssueRequest/{queueId}/{queueItemId}/WhileDelivered`. The `x-operation-id` header is the **idempotency key** that makes retries safe (reused unchanged on a retry, it re-returns the original result instead of re-executing) — it is not itself a status channel. This is the one invariant across every market.

Note that `GET /issue/{queueId}/{queueItemId}` (without `/delivered`) returns the **content** of the issued receipt in the format given by the `Accept` header — it is not a status call.
:::

## The integration flow

Where the API path is available, the flow is the same shape everywhere — your existing fiscalization flow with one added step:

| Step | What happens |
| --- | --- |
| 1. Sign | Call `/sign` as you do today. The receipt is fiscalized. *(Target state: the response also carries the eInvoice document.)* |
| 2. Issue (optional) | Register the receipt via `PUT /issue/{queueId}/{queueItemId}`. Then either **download** the eInvoice (`Action: "download"` with `Format: "en16931"` or `"zugferd"`) or **send** it (`Action: "send"` with a `Target` of scheme `email`, `sms`, or `peppol`). |
| 3. Check delivery | Poll `GET /issue/{queueId}/{queueItemId}/delivered` if you need to confirm delivery later. No webhook. |

Clearance status from a national hub (SDI, KSeF) is **not** exposed through the PosSystem API today — see [What varies by market](#what-varies-by-market) for the target-state model per market.

## What varies by market

The model is constant; the specifics are market-driven:

- **Format** — an EN 16931 profile (XRechnung, Factur-X/ZUGFeRD) or a national schema (FatturaPA, KSeF FA(3), ebInterface).
- **Network / target** — Peppol, a national clearance hub (SDI, KSeF), or a national portal.
- **Regulatory model** — post-audit (no clearance) vs. centralised clearance (the invoice is cleared before it is legally valid).
- **Availability** — some markets are live via the API, some are in sandbox, and some are a build in progress.
- **Signatures & identifiers** — e.g. an XAdES signature (Italy) or routing identifiers (Leitweg-ID, CodiceDestinatario, KSeF number).

Exact case codes, delivery targets, and go-live status live on each **country page**.

## Availability by market

| Market | Regulatory model | Delivery path (target state) | Status today |
| --- | --- | --- | --- |
| **Greece (GR)** | B2B/B2G/B2C, real-time reporting (myDATA) | API — `/sign` transmits to myDATA; `/issue` provides the EN 16931 document | **Live** (myDATA + EN 16931 download); Peppol sending sandbox only |
| [**Germany (DE)**](../middleware-de-kassensichv/e-invoicing/overview.md) | B2B, post-audit | API — `/sign` + `/issue` via Peppol (XRechnung / ZUGFeRD) | **Sandbox** — EN 16931 / ZUGFeRD output and Peppol sending are available on the sandbox only |
| **EU (cross-border)** | Voluntary — no national mandate | API — `/sign` + `/issue` via Peppol (EN 16931 UBL) | **Sandbox** — same restriction as Germany |
| [**Austria (AT)**](../middleware-at-rksv/e-invoicing/overview.md) | B2G mandated; B2B optional | API — `/sign` + `/issue` via Peppol / the national portal | **Sandbox** (API path); InStore App B2B delivery in preview |
| [**France (FR)**](../middleware-fr-boi-tva-decla-30-10-30/e-invoicing/overview.md) | B2B, decentralised (PDP) | API — `/sign` + `/issue` via the Plateforme Agréée | **Target state** — not yet available |
| [**Italy (IT)**](../middleware-it-registratore-telematico/e-invoicing/overview.md) | B2G/B2B/B2C, centralised clearance | API — `/sign` + `/issue` via SDI (FatturaPA, XAdES) | **Target state** — not yet available |
| [**Poland (PL)**](../middleware-pl/e-invoicing/overview.md) | B2B, centralised clearance | API — `/sign` + `/issue` via KSeF (FA(3)) | **Preview** — KSeF adapter not yet shipped; invoice receipt cases are stored, not fiscalized (see the [Poland guide](../middleware-pl/appendix-pl.md)) |

Each linked market has an **Overview** and a **Setup & testing** page under its entry in **Country-Specific Guides**. Greece and the EU cross-border path do not have dedicated eInvoicing pages yet.

### What is available today

- `/issue` download in `en16931` (EN 16931 UBL) and `zugferd` (ZUGFeRD / Factur-X) format.
- `/issue` send to a `peppol:` target through the fiskaltrust Peppol access point.
- The EN 16931 download is **production-enabled for Greece**; for every other market it is available on the **sandbox** only. Peppol sending is **sandbox-only in every market** for now. The eInvoice document is generated from the fiscalized receipt at `/issue` time — it is not yet part of the `/sign` response.

## Prerequisites (shared)

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes via `/sign` in the target market. |
| fiskaltrust.Middleware country configuration | Set to the market's locale. The eInvoice format itself is selected per call on `/issue` (`Format` / `Accept`). |
| Receipt settings in the Portal | Company master data (name, address, VAT ID, country) and — for Peppol sending — the sender's Peppol participant ID. |
| PosSystem API (v2) | eInvoicing is exposed through the **PosSystem API (v2)**. If you don't integrate with it yet, start with the [PosSystem API introduction](../possystem-api/introduction.md). |
| Sandbox validation | Run one document end to end against a sandbox fiskaltrust.Middleware before the first live document. |

## Terminology

| Term | Meaning |
| --- | --- |
| **EN 16931** | The European semantic standard for eInvoices. XRechnung, Factur-X/ZUGFeRD and Peppol BIS are profiles of it; national schemas such as FatturaPA or KSeF FA(3) are separate formats. |
| **Peppol** | A network eInvoices can be delivered over; fiskaltrust holds the access point. |
| **Receive mandate** | The date from which a business must be able to accept an incoming eInvoice. |
| **Issue mandate** | The date from which a business must send its invoices as eInvoices. |

Market-specific terms (XRechnung, ZUGFeRD, FatturaPA, XAdES, SDI, `CodiceDestinatario`, KSeF, Leitweg-ID, …) are defined on each country page.

## Related pages

- [Delivery (`/issue` Endpoint)](../experience-middleware/delivery.md) — the product-level eInvoicing and eDelivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
- Country pages — see [Availability by market](#availability-by-market).

## External references

- [eInvoicing HUB (European Commission)](https://ec.europa.eu/digital-building-blocks/sites/spaces/DIGITAL/pages/894304326/eInvoicing+HUB) — the EU Digital Building Blocks knowledge hub.
- [eInvoicing Country Factsheets (European Commission)](https://ec.europa.eu/digital-building-blocks/sites/spaces/DIGITAL/pages/467108874/eInvoicing+Country+Factsheets+for+each+Member+State+and+other+countries) — regulatory factsheets per Member State and other countries.
