---
slug: /poscreators/middleware-doc/poland/e-invoicing/overview
title: Overview
---

# E-Invoicing in Poland — Overview

This page explains e-invoicing in the **Polish (PL) market** from a PosCreator's perspective: what is regulated, how it is expected to affect your integration, and how the delivery flow will map onto your existing fiskaltrust setup once the adapter ships.

For the product-level concept — structured invoices, Peppol, e-Delivery across all markets — see [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md). This page is the Poland-specific companion to it.

:::warning Build in progress — not yet available
Poland is a **new country build** for fiskaltrust, not an extension of an existing local integration the way Germany, France, Italy, and Austria are. If you already integrate fiskaltrust for fiscalization in another market, the **same account and API pattern is expected to extend to Poland once the adapter ships** — but there is **nothing to build yet**. This page describes the **target state**. Confirm build status with your fiskaltrust contact before committing a go-live date to a merchant.
:::

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2B.** |
| Regulatory model | **Centralised clearance** — KSeF validates every invoice and assigns a **KSeF number** before it is legally effective. |
| Live since | **1 February 2026** for turnover above 200 million PLN; **1 April 2026** for everyone else. Both waves have passed. |
| Volume so far | 87 million invoices cleared in the first two months — the highest volume in this set. |
| Next changes | KSeF number required in payment transfer titles from **August 2026**; penalties begin **January 2027**. |
| Format | **KSeF FA(3)** — Poland's national invoice schema. |

:::info The mandate is already live
Both waves of the B2B mandate have passed (turnover above 200 million PLN from 1 February 2026; everyone else from 1 April 2026). From **August 2026** the KSeF number must be carried in payment transfer titles, and **penalties begin January 2027**. The regulation is live — only the fiskaltrust adapter is still pending.
:::

## Integration impact

If you already integrate fiskaltrust elsewhere, expect the **same shape of change** once the adapter ships. **Nothing to build yet.**

### Unchanged interfaces (expected)

| Element | Status |
| --- | --- |
| Account and CashBox | Same account, same CashBox. No new registration. |
| Authentication | Same headers: `x-cashbox-id` and `x-cashbox-accesstoken`. No new credential type. |
| `/sign` | The same call you already use for fiscalization. |

### Extended endpoints (expected once the adapter ships)

| Element | Change |
| --- | --- |
| `/sign` | Would **produce a KSeF FA(3) document** alongside the existing fiscalized receipt. |
| `/issue` | Would **accept a KSeF delivery target** and **return the KSeF clearance number**. |
| `/journal` | Would **hold the e-invoice archive copy**, as in the other markets. |

:::note Status is polled, not pushed
As in the other markets, the flow is expected to be request/response with **no status webhook** — you would poll `/issue` until KSeF returns the clearance number. See the [expected end-to-end example](./setup.md#end-to-end-example).
:::

## The integration flow

Once the adapter ships, the flow is expected to match the other markets, with one added step.

| Step | What would happen |
| --- | --- |
| 1. Sign | Call `/sign` as you do today. The response would also carry the KSeF FA(3) document. |
| 2. Issue for delivery | Call `/issue` with the KSeF delivery target — the one new parameter. |
| 3. Poll for status | Call `/issue` status until KSeF returns the **clearance number**. No webhook. |
| 4. Archive | Already handled — the document would sit in `/journal` alongside your existing records. |

:::caution Target state — confirm adapter status before scoping
The flow above is the **expected** shape once the fiskaltrust Poland adapter ships; it is **not yet available**, and endpoint and parameter names are pending. Confirm the adapter has shipped with your fiskaltrust contact before promising a go-live date.
:::

## Terminology

| Term | Meaning |
| --- | --- |
| **KSeF** | *Krajowy System e-Faktur*, Poland's centralised national clearance platform. |
| **FA(3)** | The current version of Poland's national invoice schema. |
| **KSeF number** | The identifier assigned on clearance, required in payment transfer titles from August 2026. |
| **Peppol BIS** | A separate Polish track from KSeF — not a candidate syntax for the domestic B2B mandate. |

## Related pages

- [Set up and test e-invoicing (Poland)](./setup.md) — prerequisites, what you can test today, and the expected end-to-end flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
