---
slug: /poscreators/middleware-doc/austria/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test e-invoicing (Austria)

This page covers the prerequisites for e-invoicing in the Austrian (AT) market, how to enable it in the fiskaltrust Portal, and how to validate the flow against a sandbox before production. For scope, regulatory status, and the delivery paths, see the [Overview](./overview.md).

:::note What setup means in Austria today
The paths available now — **Portal back office (Method A)** and **InStore App (Method B)** — require **no POS code**. Setup is therefore about **access and configuration**, not building against an API. The POS-driven API path (**Method C**) is not yet available; when it ships, its setup steps will be added here.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + CashBox | An active account with a configured CashBox. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS is already fiscalizing receipts via `/sign` (receipts must exist in the Portal for Method A). |
| PosSystem API (v2) — for Method C only | E-invoicing features are exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. Not required for Methods A and B. |

## Enable e-invoicing in the Portal

<!-- TODO (to verify before publish): document the actual Portal flow to enable e-invoicing.
     Open questions to confirm with the Portal team:
       - Where in the Portal e-invoicing is enabled (account level vs. per-CashBox).
       - Whether it requires a product/subscription flag or is on by default.
       - What the merchant sees vs. what the PosCreator/PosDealer configures.
     Do not publish invented steps here. -->

:::caution Draft — Portal steps to be confirmed
The exact steps to enable e-invoicing in the fiskaltrust Portal are being verified and will be documented here. Do not treat this section as final until the flow has been confirmed.
:::

## Sandbox validation

Validate the end-to-end flow against a sandbox-scoped CashBox — using non-production `x-cashbox-id` and `x-cashbox-accesstoken` credentials — before enabling it on a production CashBox.

1. Provision a **sandbox CashBox** in the fiskaltrust Portal — this yields the `x-cashbox-id` and `x-cashbox-accesstoken` used on every request. See [Portal registration](../../../getting-started/portal-registration.md).
2. Confirm your integration against the [Integration checklist](../../../getting-started/integration-checklist.md).
3. Fiscalize a test receipt via `/sign` so it exists in the Portal, then follow the [Method A workflow](./overview.md#method-a-the-portal-workflow-today) to generate and transmit the e-invoice.

:::caution Draft — sandbox specifics to be confirmed
E-invoicing-specific sandbox provisioning (and any starter guide or sample keys) is being verified. Confirm the exact provisioning path and any e-invoicing sample collection before publishing.
:::

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the three delivery paths.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — required before POS-driven e-invoicing (Method C).
