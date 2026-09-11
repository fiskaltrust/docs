---
slug: /poscreators/middleware-doc/poland/e-invoicing/overview
title: Overview
---

# eInvoicing in Poland — Overview

eInvoicing works the same way across fiskaltrust markets — the shared model, the `/sign` + `/issue` flow, and the no-webhook rule are described in **[eInvoicing — Overview](../../e-invoicing/overview.md)**. This page covers only what's specific to the **Polish (PL)** market.

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2B.** |
| Regulatory model | **Centralised clearance** — KSeF validates every invoice and assigns a **KSeF number** before it is legally effective. |
| Live since | **1 February 2026** (turnover above 200 million PLN); **1 April 2026** for everyone else. Both waves have passed. |
| Next changes | KSeF number required in payment transfer titles from **August 2026**; penalties begin **January 2027**. |
| Format | **KSeF FA(3)** — Poland's national invoice schema. |

:::info The mandate is already live
Both waves of the B2B mandate have passed (turnover above 200 million PLN from 1 February 2026; everyone else from 1 April 2026). From **August 2026** the KSeF number must be carried in payment transfer titles, and **penalties begin January 2027**.
:::

## Terminology

| Term | Meaning |
| --- | --- |
| **KSeF** | *Krajowy System e-Faktur*, Poland's centralised national clearance platform. |
| **FA(3)** | The current version of Poland's national invoice schema. |
| **KSeF number** | The identifier assigned on clearance, required in payment transfer titles from August 2026. |
| **Peppol BIS** | A separate Polish track from KSeF — not a candidate syntax for the domestic B2B mandate. |

## Related pages

- [eInvoicing — Overview](../../e-invoicing/overview.md) — the shared model, integration flow, and prerequisites across markets.
- [Set up and test eInvoicing (Poland)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
- [Appendix: PL](../appendix-pl.md) — Poland fiscalization details.
