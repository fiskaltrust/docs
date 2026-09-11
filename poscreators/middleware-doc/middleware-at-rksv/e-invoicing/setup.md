---
slug: /poscreators/middleware-doc/austria/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test eInvoicing (Austria)

This page covers the prerequisites for eInvoicing in the Austrian (AT) market, the delivery paths available today, and the expected POS-driven API shape once it ships. For scope and regulatory status, see the [Overview](./overview.md).

:::note What setup means in Austria
Today, Austrian eInvoicing is delivered through the **fiskaltrust.Portal** back office or the **InStore App** — configuration, not POS code. The POS-driven API path (`/sign` + `/issue`) described in the [generic overview](../../e-invoicing/overview.md) is **pending** for Austria; its expected shape is below.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Austria via `/sign` (receipts are already in the fiskaltrust.Portal). |
| fiskaltrust.Middleware country configuration | The fiskaltrust.Middleware's country configuration is set to the **Austrian locale**. |
| PosSystem API (v2) — for the API path | The POS-driven path will be exposed through the **PosSystem API (v2)** once it ships. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. Not required for the Portal / InStore App paths. |

## Enable eInvoicing in the Portal

:::caution Draft — Portal steps to be confirmed
The exact steps to enable eInvoicing in the fiskaltrust.Portal are being verified and will be documented here. Do not treat this section as final until the flow has been confirmed.
:::

## Delivery paths available today

### Portal back office

No API call is involved — this is a fiskaltrust.Portal workflow. It is useful to understand so you can explain it to a merchant, but it is **not part of your API integration**.

| Step | Portal-side action |
| --- | --- |
| 1. Receipt exists | The merchant's receipt is already in the fiskaltrust.Portal from your existing fiscalization integration. |
| 2. Attach the buyer | A Portal user adds the buyer's details. |
| 3. Generate and send | The Portal generates the eInvoice and transmits it, via the national portal or Peppol. |
| 4. Done | No status polling on your side — this is not part of your API integration. |

### InStore App

Configuration only — at most a minor change to the local fiskaltrust.Middleware helper config. **No endpoints or POS-side code.** See the [InStore App Setup guide](../../instore-app/Setup-guide/setup.md).

## When the POS-driven API ships

Once available, Austria is expected to follow the same shape as the other markets — an enrichment to `/sign` plus a delivery step on `/issue`, polled for status (no webhook). See the [eInvoicing — Overview](../../e-invoicing/overview.md) for the shared model.

:::caution Not yet available for Austria
The POS-driven API path is **not yet live for Austria**. This page will be updated with a runnable end-to-end example — with real case codes and a developer-platform link, like the other markets — once it ships. Confirm availability with your fiskaltrust contact before scoping a go-live date.
:::

## Related pages

- [Overview](./overview.md) — scope and regulatory status.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
