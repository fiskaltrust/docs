---
slug: /poscreators/middleware-doc/italy/e-invoicing/overview
title: Overview
---

# eInvoicing in Italy — Overview

eInvoicing works the same way across fiskaltrust markets — the shared model, the `/sign` + `/issue` flow, and the no-webhook rule are described in **[eInvoicing — Overview](../../e-invoicing/overview.md)**. This page covers only what's specific to the **Italian (IT)** market.

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2G, B2B, and B2C.** fiskaltrust supports B2C and B2B — see [What fiskaltrust supports](#what-fiskaltrust-supports). |
| Regulatory model | **Centralised clearance** — SDI validates and clears every invoice before it is legally effective. |
| Live since | **2019** (full B2B mandate). No upcoming deadline to plan around. |
| Current spec | **FatturaPA v1.9.1** — live since 15 May 2026; derogation running to December 2027. |
| Format | **FatturaPA** — Italy's own XML schema (predates EN 16931). The FPA12 format (B2G) requires a signature; FPR12 (B2B, B2C) does not. |
| Transmission | The FatturaPA is **generated as part of `/sign`** and returned **unsigned** in the response; it is **transmitted to SDI through `/issue`**, by an **accredited partner**. See [FatturaPA mapping](./fatturapa-mapping.md#transmission-to-sdi-through-issue). |

*Table 1. Regulatory status of eInvoicing in Italy.*

:::info Already live — usually a displacement
Italy's eInvoicing has been mandatory since **2019**, and SDI clearance covers B2G, B2B, and B2C. Most merchants already run some eInvoicing arrangement, so integrating through fiskaltrust is typically **replacing an existing setup, not a first-time build**. There is no upcoming deadline forcing the question.
:::

## What fiskaltrust supports

| Aspect | Supported today |
| --- | --- |
| B2C, B2B | **Yes** — generation of the FatturaPA as part of `/sign`, transmission to SDI through `/issue`. |
| B2G | **No.** |
| Sending eInvoices | **Yes.** |
| Receiving eInvoices | **No** — eInvoices sent to the merchant through SDI are not received. |

*Table 2. eInvoicing scope supported by fiskaltrust in Italy.*

## Terminology

| Term | Meaning |
| --- | --- |
| **FatturaPA** | Italy's own XML schema — predates EN 16931. Transmitted as FPA12 (B2G) or FPR12 (B2B, B2C). |
| **SDI** | *Sistema di Interscambio*, the centralised hub that clears every invoice. |
| **CodiceDestinatario** | The routing code identifying a buyer's channel in SDI. Sent in `ftReceiptCaseData`. |
| **PEC** | Certified email — the fallback delivery channel for an unknown buyer. |
| **XAdES** | A digital signature standard for FatturaPA documents; a signature is required for the FPA12 format (B2G). |

*Table 3. Italian eInvoicing terms.*

## Related pages

- [eInvoicing — Overview](../../e-invoicing/overview.md) — the shared model, integration flow, and prerequisites across markets.
- [Set up and test eInvoicing (Italy)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [FatturaPA mapping (Italy)](./fatturapa-mapping.md) — how a receipt maps to FatturaPA, and the validation rules a receipt must pass.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
- [Appendix: IT (Registratore Telematico)](../appendix-it-registratore-telematico.md) — Italy fiscalization details.
- [eInvoicing in Italy (European Commission)](https://ec.europa.eu/digital-building-blocks/sites/spaces/DIGITAL/pages/467108890/eInvoicing+in+Italy) — the EU Digital Building Blocks country factsheet.
