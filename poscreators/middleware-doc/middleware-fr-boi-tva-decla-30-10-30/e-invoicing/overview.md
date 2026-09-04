---
slug: /poscreators/middleware-doc/france/e-invoicing/overview
title: Overview
---

# E-Invoicing in France — Overview

This page explains e-invoicing in the **French (FR) market** from a PosCreator's perspective: what is regulated, how it affects your integration, and how the delivery flow maps onto your existing fiskaltrust setup.

For the product-level concept — structured invoices, Peppol, e-Delivery across all markets — see [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md). This page is the France-specific companion to it.

:::info Built into calls you already make
In France, e-invoicing is produced and delivered through the `/sign` and `/issue` calls your POS already uses — **same account, same CashBox, same credentials**. If your POS already fiscalizes in France, you have everything you need. The new behaviour is enabled by configuration, plus one added parameter on `/issue`.
:::

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2B**, mandated. eReporting for B2C and cross-border runs alongside it. |
| Regulatory model | **Decentralised** — certified private platforms (**Plateforme Agréée / PDP**) deliver the invoice; the state receives a parallel report. |
| Mandatory — large & mid-size (ETI) | **Must issue from 1 September 2026.** |
| Mandatory — SMEs & micro-enterprises | **Must issue from 1 September 2027.** |
| Penalties | No automatic penalties apply until **31 December 2026**. |
| Formats | **UBL 2.1** or **UN/CEFACT CII**, or the **Factur-X** hybrid (PDF/A-3 with embedded CII). |

:::warning Everyone must be able to receive from 1 September 2026
Issuance is phased (large/mid-size from 1 September 2026, SMEs and micro-enterprises from 1 September 2027), but **every business must be able to receive** e-invoices from **1 September 2026**, regardless of size.
:::

## Integration impact

The connection, authentication, and endpoint surface are **unchanged**. E-invoicing is **additive** — the new behaviour is layered inside the `/sign` and `/issue` calls you already make, with no new endpoints, request headers, or credentials.

### Unchanged interfaces

| Element | Status |
| --- | --- |
| Account and CashBox | Same account, same CashBox. No new registration. |
| Authentication | Same headers: `x-cashbox-id` and `x-cashbox-accesstoken`. No new credential type. |
| `/sign` | The same call you already use for fiscalization. You keep sending it exactly as today. |

### Extended endpoints

| Element | Change |
| --- | --- |
| `/sign` | Now **also produces an EN 16931-compliant document** (UBL, CII, or Factur-X, by configuration) alongside the existing fiscalized receipt. |
| `/issue` | Accepts a **new delivery target** for network transport to the merchant's Plateforme Agréée. This is the one new parameter. |
| `/journal` | Now **also holds the e-invoice archive copy**. No separate archive call to add. |

:::note Status is polled, not pushed
There is **no status webhook**. You poll `/issue` for delivery status — the same pattern you already use for fiscalization status. See the [end-to-end example](./setup.md#end-to-end-example).
:::

## The integration flow

Same shape as your existing fiscalization flow, with one added step.

| Step | What happens |
| --- | --- |
| 1. Sign | Call `/sign` as you do today. The response now also carries the EN 16931 document. |
| 2. Issue for delivery | Call `/issue` with the network delivery target — the one new parameter. |
| 3. Poll for status | Call `/issue` status until it reports **delivered**. No webhook. |
| 4. Archive | Already handled — the document sits in `/journal` alongside your existing records. |

:::caution Endpoint details pending final sign-off
The overall flow is confirmed, but the exact delivery-target parameter on `/issue` and the routing to the merchant's Plateforme Agréée are being finalised with product. Confirm both before scoping a go-live date.
:::

## Terminology

| Term | Meaning |
| --- | --- |
| **EN 16931** | The European semantic standard every format below is a profile of. |
| **Plateforme Agréée (PA)** | France's certified private exchange platforms — still called **PDP** in older material. |
| **Annuaire** | The central directory mapping each business to its platform. |
| **Factur-X** | Hybrid PDF/A-3 with CII XML embedded — same spec as Germany's ZUGFeRD. |
| **SIRET** | The French business identifier used in buyer master data. |

## Related pages

- [Set up and test e-invoicing (France)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
- [Appendix: FR](../appendix-fr-boi-tva-decla-30-10-30.md) — France fiscalization details.
