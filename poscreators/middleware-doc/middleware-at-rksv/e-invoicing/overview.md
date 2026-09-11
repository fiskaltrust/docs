---
slug: /poscreators/middleware-doc/austria/e-invoicing/overview
title: Overview
---

# eInvoicing in Austria — Overview

eInvoicing works the same way across fiskaltrust markets — the shared model, the `/sign` + `/issue` flow, and the no-webhook rule are described in **[eInvoicing — Overview](../../e-invoicing/overview.md)**. This page covers only what's specific to the **Austrian (AT)** market.

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2G mandatory**; B2B optional — early adoption, no deadline set. |
| Regulatory model | Exchange via the **Peppol** network or Austria's national portal (e-Rechnung.gv.at). |
| Live since | Federal **B2G mandatory since 18 April 2020**. |
| Format | **ebInterface** (Austria's national XML, versions 4.3, 5, 6), or a Peppol BIS / EN 16931 document. |

:::info B2B is not mandated in Austria
There is **no B2B eInvoicing deadline** in Austria today. Offering B2B eInvoicing is **early adoption, not compliance** — B2B eInvoices route through the same Peppol rails already used for B2G.
:::

## Terminology

| Term | Meaning |
| --- | --- |
| **ebInterface** | Austria's national invoice XML, versions 4.3, 5 and 6. |
| **e-Rechnung.gv.at** | The Austrian government eInvoice portal, reached through the USP. |
| **USP** | *Unternehmensserviceportal*, the Austrian business service portal. |

## Related pages

- [eInvoicing — Overview](../../e-invoicing/overview.md) — the shared model, integration flow, and prerequisites across markets.
- [Set up and test eInvoicing (Austria)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
- [Appendix: AT (RKSV)](../appendix-at-rksv.md) — Austria fiscalization details.
