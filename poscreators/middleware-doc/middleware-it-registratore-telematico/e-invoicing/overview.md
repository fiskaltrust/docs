---
slug: /poscreators/middleware-doc/italy/e-invoicing/overview
title: Overview
---

# E-Invoicing in Italy — Overview

This page explains e-invoicing in the **Italian (IT) market** from a PosCreator's perspective: what is regulated, how it affects your integration, and how the delivery flow maps onto your existing fiskaltrust setup.

For the product-level concept — structured invoices, Peppol, e-Delivery across all markets — see [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md). This page is the Italy-specific companion to it.

:::info Built into calls you already make
In Italy, e-invoicing is produced and submitted through the `/sign` and `/issue` calls your POS already uses — **same account, same CashBox, same credentials**. The Middleware produces the FatturaPA document and applies the required **XAdES signature** — you don't handle signing. The new behaviour is enabled by configuration, plus one added parameter on `/issue`.
:::

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2G, B2B, and B2C.** |
| Regulatory model | **Centralised clearance** — SDI validates and clears every invoice before it is legally valid. |
| Live since | **2019** (full B2B mandate). No upcoming deadline to plan around. |
| Current spec | **FatturaPA v1.9.1** — live since 15 May 2026; derogation running to December 2027. |
| Format | **FatturaPA** — Italy's own XML schema (predates EN 16931), requires an **XAdES signature**. |

:::info Already live — usually a displacement
Italy's e-invoicing has been mandatory since **2019**, and SDI clearance covers B2G, B2B, and B2C. Most merchants already run some e-invoicing arrangement, so integrating through fiskaltrust is typically **replacing an existing setup, not a first-time build**. There is no upcoming deadline forcing the question.
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
| `/sign` | Now **also produces a FatturaPA document** with the XAdES signature applied, alongside the existing fiscalized receipt. |
| `/issue` | Accepts a **new delivery target** for SDI submission (direct channel, `CodiceDestinatario`, or PEC fallback). |
| `/journal` | Now **also holds the e-invoice archive copy**. No separate archive call to add. |

:::note Status is polled, not pushed
There is **no status webhook**. You poll `/issue` for status until it reports **cleared by SDI** — the same pattern you already use for fiscalization status. See the [end-to-end example](./setup.md#end-to-end-example).
:::

## The integration flow

Same shape as your existing fiscalization flow, with one added step.

| Step | What happens |
| --- | --- |
| 1. Sign | Call `/sign` as you do today. The response now also carries the FatturaPA document (XAdES signature applied). |
| 2. Issue for delivery | Call `/issue` with the SDI delivery target — the one new parameter. |
| 3. Poll for status | Call `/issue` status until it reports **cleared by SDI**. No webhook. |
| 4. Archive | Already handled — the document sits in `/journal` alongside your existing records. |

:::caution Endpoint details pending final sign-off
The overall flow is confirmed, but the exact delivery-target parameter on `/issue` and the SDI routing behaviour (direct channel vs `CodiceDestinatario` vs PEC fallback) are being finalised with product. Confirm before scoping a go-live date.
:::

## Terminology

| Term | Meaning |
| --- | --- |
| **FatturaPA** | Italy's own XML schema — predates EN 16931, requires an XAdES signature. |
| **SDI** | *Sistema di Interscambio*, the centralised hub that clears every invoice. |
| **CodiceDestinatario** | The routing code identifying a buyer's channel in SDI. |
| **PEC** | Certified email — the fallback delivery channel for an unknown buyer. |
| **XAdES** | The digital signature standard required on FatturaPA documents. |

## Related pages

- [Set up and test e-invoicing (Italy)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
- [Appendix: IT (Registratore Telematico)](../appendix-it-registratore-telematico.md) — Italy fiscalization details.
