---
slug: /poscreators/middleware-doc/germany/e-invoicing/overview
title: Overview
---

# E-Invoicing in Germany — Overview

This page explains e-invoicing in the **German (DE) market** from a PosCreator's perspective: what is regulated, how it affects your integration, and how the delivery flow maps onto your existing fiskaltrust setup.

For the product-level concept — structured invoices, Peppol, e-Delivery across all markets — see [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md). This page is the Germany-specific companion to it.

:::info Built into calls you already make
In Germany, e-invoicing is produced and delivered through the `/sign` and `/issue` calls your POS already uses — **same account, same CashBox, same credentials**. If your POS already fiscalizes in Germany, nothing to re-register. The new behaviour is enabled by configuration, plus one added parameter on `/issue`.
:::

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2B**, business to business. |
| Regulatory model | **Post-audit** — EN 16931 mandatory, no real-time clearance. |
| Receive mandate | **Live since 1 January 2025** — every business must be able to receive. |
| Issue mandate | **1 January 2027** for prior-year turnover above **€800,000**; **1 January 2028** for everyone else. |
| Penalties | Up to **€5,000**. |
| Formats | **XRechnung** (UBL 2.1) or **ZUGFeRD / Factur-X** (hybrid PDF/A-3 with CII) — both EN 16931 profiles. |

:::warning Receiving is already mandatory
Since **1 January 2025**, every German business must be able to **receive** e-invoices. Issuing is phased in — from **1 January 2027** for prior-year turnover above €800,000, and from **1 January 2028** for everyone else. Penalties run up to €5,000.
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
| `/sign` | Now **also produces an EN 16931-compliant document** (XRechnung or ZUGFeRD, by configuration) alongside the existing fiscalized receipt. |
| `/issue` | Accepts a **new delivery target** for network transport over **Peppol**, alongside the print and download targets you already use. |
| `/journal` | Now **also holds the e-invoice archive copy**. No separate archive call to add. |

:::note Status is polled, not pushed
There is **no status webhook**. You poll `/issue` for delivery status — the same pattern you already use for fiscalization status. See the [end-to-end example](./setup.md#end-to-end-example).
:::

## The integration flow

Same shape as your existing fiscalization flow, with one added step.

| Step | What happens |
| --- | --- |
| 1. Sign | Call `/sign` as you do today. The response now also carries the EN 16931 document. |
| 2. Issue for delivery | Call `/issue` with the network delivery target (Peppol) — the one new parameter. |
| 3. Poll for status | Call `/issue` status until it reports **delivered**. No webhook. |
| 4. Archive | Already handled — the document sits in `/journal` alongside your existing records. |

:::caution Endpoint details pending final sign-off
The overall flow is confirmed, but the exact delivery-target parameter on `/issue` is being finalised with product. Confirm it before scoping a go-live date.
:::

## Terminology

| Term | Meaning |
| --- | --- |
| **EN 16931** | The European semantic standard every format below is a profile of. |
| **XRechnung** | The German CIUS of EN 16931, in UBL 2.1, with 200+ added national rules. |
| **ZUGFeRD / Factur-X** | Hybrid PDF/A-3 with CII XML embedded — same spec as France's Factur-X. |
| **Leitweg-ID** | Routing ID a German public buyer issues, required for B2G delivery. |
| **Peppol** | The network your e-invoice travels over. fiskaltrust holds the access point. |

## Related pages

- [Set up and test e-invoicing (Germany)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
- [Appendix: DE (KassenSichV)](../appendix-de-kassensichv.md) — Germany fiscalization details.
