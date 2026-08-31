---
slug: /poscreators/middleware-doc/austria/e-invoicing/overview
title: Overview
---

# E-Invoicing in Austria — Overview

This page explains e-invoicing in the **Austrian (AT) market** from a PosCreator's perspective: what is regulated, how it affects your integration, and how the available delivery paths map onto your existing fiskaltrust setup.

For the product-level concept — structured invoices, Peppol, e-Delivery across all markets — see [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md). This page is the Austria-specific companion to it.

:::info No code change required today
E-invoicing for Austria runs through the **fiskaltrust Portal** back office or the **InStore App** — not through the `/sign` calls your POS already makes. If your integration is fiscalizing receipts today, it is already ready for the paths described below. There is nothing new to build.
:::

## Regulatory status

| Aspect | Current status |
| --- | --- |
| Scope | **B2G only**, federally mandated. B2B is optional and partner-driven. |
| Regulatory model | Exchange via the **Peppol** 4-corner network, or Austria's national portal. |
| Live since | Federal **B2G mandatory since 18 April 2020**. |
| B2B status | **No mandate exists today.** Adoption is getting ahead of a requirement that has not been set. |

:::warning B2B is not mandated in Austria
There is **no B2B e-invoicing deadline** in Austria today. Offering B2B e-invoicing is **early adoption, not compliance** — position it accordingly. If a B2B mandate is eventually set, it is expected to route through the same Peppol rails already used for B2G.
:::

## Integration impact

No code changes today. The two delivery paths available now — Portal back office (Method A) and InStore App (Method B) — run **entirely outside the POS API**: no new endpoints, request headers, or `/sign` payload changes.

### Existing integration

| Element | Status |
| --- | --- |
| Account and CashBox | Same account, same CashBox. No new registration. |
| Authentication | Same headers: `x-cashbox-id` and `x-cashbox-accesstoken`. No new credential type. |
| `/sign` | The same call you already use for fiscalization. You keep sending it exactly as today. |

### Delivery paths available today

| Path | Definition |
| --- | --- |
| **Method A — Portal back office** | The merchant's receipts are already in the fiskaltrust Portal from your existing fiscalization integration. A user selects the transactions, attaches the buyer, and transmits the e-invoice. **No integration work.** |
| **Method B — [InStore App](../../instore-app/introduction/introduction.md)** | Configuration only — at most a minor change to the local CashBox helper config. **No endpoints or POS-side code.** |
| **Method C — POS-driven (API)** | **Not built yet.** No endpoint exists today. See [Method C: the POS-driven workflow](#method-c-the-pos-driven-workflow). |

## Method A: the Portal workflow today

No API call is involved — this is a Portal workflow. It is useful to understand so you can explain it to a merchant, but it is **not part of your API integration**.

| Step | Portal-side action |
| --- | --- |
| 1. Receipt exists | The merchant's receipt is already in the Portal from your existing fiscalization integration. |
| 2. Attach the buyer | A Portal user attaches the buyer's details from master data. |
| 3. Generate and send | The Portal generates the e-invoice and transmits it, via the national portal or Peppol. |
| 4. Done | No status polling on your side — this is not part of your API integration. |

:::tip Already integrated? You're ready
Any merchant already integrated with `/sign` can use Method A with **no additional development**. It works on receipts that are already in the Portal.
:::

## Method C: the POS-driven workflow

Method C is the POS-driven, API-based path. It does not exist yet, but when it ships it is expected to follow **the same pattern as the other country packs** (Germany, France, Italy, Poland):

- an **enrichment to `/sign`**, and
- a **delivery target on `/issue`** — no webhook.

E-invoicing features are delivered exclusively through the **PosSystem API (v2)**. If you are still on the v0 interface (WCF/REST), plan your migration first — see the [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) guide.

:::note Method C (POS-driven API) is not yet available
This page will be updated with an **API delta** — in the same format as the other country packs — once Method C ships. Until then, there is nothing to build for POS-driven e-invoicing in Austria.
:::

## Terminology

| Term | Description |
| --- | --- |
| **ebInterface** | Austria's national invoice XML, versions 4.3, 5 and 6. |
| **e-Rechnung.gv.at** | The Austrian government e-invoice portal, reached through the USP. |
| **USP** | *Unternehmensserviceportal*, the Austrian business service portal. |
| **Peppol** | The network the 2030 EU cross-border obligation runs on. |

## Related pages

- [Set up and test e-invoicing (Austria)](./setup.md) — prerequisites, Portal enablement, and the end-to-end sandbox example.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept across all markets.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — required before POS-driven e-invoicing (Method C).
- [Appendix: AT (RKSV)](../appendix-at-rksv.md) — Austria fiscalization (RKSV) details.
