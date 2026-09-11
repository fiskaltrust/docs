---
slug: /poscreators/middleware-doc/italy/e-invoicing/overview
title: Overview
---

# eInvoicing in Italy — Overview

eInvoicing works the same way across fiskaltrust markets — the shared model, the `/sign` + `/issue` flow, and the no-webhook rule are described in **[eInvoicing — Overview](../../e-invoicing/overview.md)**. This page covers only what's specific to the **Italian (IT)** market.

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2G, B2B, and B2C.** |
| Regulatory model | **Centralised clearance** — SDI validates and clears every invoice before it is legally effective. |
| Live since | **2019** (full B2B mandate). No upcoming deadline to plan around. |
| Current spec | **FatturaPA v1.9.1** — live since 15 May 2026; derogation running to December 2027. |
| Format | **FatturaPA** — Italy's own XML schema (predates EN 16931), requires an **XAdES signature**. |

:::info Already live — usually a displacement
Italy's eInvoicing has been mandatory since **2019**, and SDI clearance covers B2G, B2B, and B2C. Most merchants already run some eInvoicing arrangement, so integrating through fiskaltrust is typically **replacing an existing setup, not a first-time build**. There is no upcoming deadline forcing the question.
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

- [eInvoicing — Overview](../../e-invoicing/overview.md) — the shared model, integration flow, and prerequisites across markets.
- [Set up and test eInvoicing (Italy)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
- [Appendix: IT (Registratore Telematico)](../appendix-it-registratore-telematico.md) — Italy fiscalization details.
