---
slug: /poscreators/middleware-doc/france/e-invoicing/overview
title: Overview
---

# eInvoicing in France — Overview

eInvoicing works the same way across fiskaltrust markets — the shared model, the `/sign` + `/issue` flow, and the no-webhook rule are described in **[eInvoicing — Overview](../../e-invoicing/overview.md)**. This page covers only what's specific to the **French (FR)** market.

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2B**, mandated. eReporting for B2C and cross-border runs alongside it. |
| Regulatory model | **Decentralised** — certified private platforms (**Plateforme Agréée / PDP**) deliver the invoice; the state receives a parallel report. |
| Receive mandate | **1 September 2026** — every business must be able to receive, regardless of size. |
| Issue mandate | **1 September 2026** for large & mid-size (ETI); **1 September 2027** for SMEs and micro-enterprises. |
| Penalties | No automatic penalties apply until **31 December 2026**. |
| Formats | **UBL 2.1** or **UN/CEFACT CII**, or the **Factur-X** hybrid (PDF/A-3 with embedded CII). |

:::warning Everyone must be able to receive from 1 September 2026
Issuance is phased (large/mid-size businesses from 1 September 2026, SMEs and micro-enterprises from 1 September 2027), but **every business must be able to receive** eInvoices from **1 September 2026**, regardless of size.
:::

## Terminology

| Term | Meaning |
| --- | --- |
| **Plateforme Agréée (PA)** | France's certified private exchange platforms — still called **PDP** in older material. |
| **Annuaire** | The central directory mapping each business to its platform. |
| **Factur-X** | Hybrid PDF/A-3 with CII XML embedded — same spec as Germany's ZUGFeRD. |
| **SIRET** | The French business identifier used in buyer master data. |

## Related pages

- [eInvoicing — Overview](../../e-invoicing/overview.md) — the shared model, integration flow, and prerequisites across markets.
- [Set up and test eInvoicing (France)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
- [Appendix: FR](../appendix-fr-boi-tva-decla-30-10-30.md) — France fiscalization details.
- [eInvoicing in France (European Commission)](https://ec.europa.eu/digital-building-blocks/sites/spaces/DIGITAL/pages/467108885/eInvoicing+in+France) — the EU Digital Building Blocks country factsheet.
