---
slug: /poscreators/middleware-doc/germany/e-invoicing/overview
title: Overview
---

# eInvoicing in Germany — Overview

eInvoicing works the same way across fiskaltrust markets — the shared model, the `/sign` + `/issue` flow, and the no-webhook rule are described in **[eInvoicing — Overview](../../e-invoicing/overview.md)**. This page covers only what's specific to the **German (DE)** market.

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
Since **1 January 2025**, every German business must be able to **receive** eInvoices. Issuing is phased in — from **1 January 2027** for prior-year turnover above €800,000, and from **1 January 2028** for everyone else. Penalties run up to €5,000.
:::

## Terminology

| Term | Meaning |
| --- | --- |
| **XRechnung** | The German CIUS of EN 16931, in UBL 2.1, with 200+ added national rules. |
| **ZUGFeRD / Factur-X** | Hybrid PDF/A-3 with CII XML embedded — same spec as France's Factur-X. |
| **Leitweg-ID** | Routing ID a German public buyer issues, required for B2G delivery. |

## Related pages

- [eInvoicing — Overview](../../e-invoicing/overview.md) — the shared model, integration flow, and prerequisites across markets.
- [Set up and test eInvoicing (Germany)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and eDelivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
- [Appendix: DE (KassenSichV)](../appendix-de-kassensichv.md) — Germany fiscalization details.
- [eInvoicing in Germany (European Commission)](https://ec.europa.eu/digital-building-blocks/sites/spaces/DIGITAL/pages/467108886/eInvoicing+in+Germany) — the EU Digital Building Blocks country factsheet.
