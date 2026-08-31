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

### End-to-end example (expected Method C shape)

:::caution Illustrative — pending Austria availability
Method C (POS-driven API) is **not yet available for Austria**. The flow below shows the **expected shape** — the same `/sign` → `/issue` pattern already used in other markets — so you can see how an e-invoice will move through the API. The Austrian `ftReceiptCase` / `ftChargeItemCase` values, the delivery-target field, and other specifics (marked `TBC`) are confirmed when Method C ships. These are **not runnable Austria sandbox calls yet**.
:::

The API is request/response and **idempotent — there is no status webhook**. Each call returns its result synchronously in the response body; a retry reuses the same `x-operation-id` and returns the original result. Every request carries the standard headers (base URL comes from your sandbox provisioning; see the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for full schemas):

```
x-cashbox-id: <sandbox CashBox ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Create and fiscalize the invoice (`/sign`)**

Submit the B2B invoice with the buyer's master data. The Middleware fiscalizes it and returns the signed result.

```json
// POST {POS_SYSTEM_API}/sign
{
  "cbReceiptReference": "AT-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-01-01T10:00:00.000Z",
  "ftReceiptCase": "<B2B e-invoice case — AT value TBC>",
  "cbCustomer": {
    "CustomerVATId": "ATU12345678",
    "CustomerName": "Beispiel GmbH",
    "CustomerStreet": "Beispielstrasse 1",
    "CustomerZip": "1010",
    "CustomerCity": "Wien",
    "CustomerCountry": "AT"
  },
  "cbChargeItems": [
    {
      "Quantity": 1,
      "Description": "Consulting services",
      "Amount": 1200.00,
      "VATRate": 20.0,
      "ftChargeItemCase": "<standard-rate case — AT value TBC>"
    }
  ],
  "cbPayItems": [
    {
      "Quantity": 1,
      "Description": "Bank transfer",
      "Amount": 1200.00,
      "ftPayItemCase": "<non-cash case — AT value TBC>"
    }
  ]
}
```

The response returns the fiscalization result (signature data, journal reference) — no webhook, the outcome is in the response body.

**Step 2 — Issue and deliver the e-invoice (`/issue`)**

Hand the signed invoice to a delivery target. For Austria that is Peppol or the national portal (e-Rechnung.gv.at via the USP).

```json
// POST {POS_SYSTEM_API}/issue
{
  "cbReceiptReference": "AT-EINV-SANDBOX-0001",
  "ftReceiptCase": "<same B2B e-invoice case as Step 1>",
  "ftReceiptCaseData": {
    "AT": {
      "<delivery-target-field — TBC>": "<peppol | national-portal>"
    }
  }
}
```

The `/issue` response returns the **delivery state** (for example accepted, queued, or a transport identifier). To re-check it, replay the call with the same `x-operation-id` — the API returns the same result. There is no callback or status webhook.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the three delivery paths.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — required before POS-driven e-invoicing (Method C).
