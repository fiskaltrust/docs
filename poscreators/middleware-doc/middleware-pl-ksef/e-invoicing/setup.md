---
slug: /poscreators/middleware-doc/poland/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test e-invoicing (Poland)

This page covers the expected prerequisites for e-invoicing in the Polish (PL) market, what you can test today, and the target end-to-end flow. For scope, regulatory status, and the delivery flow, see the [Overview](./overview.md).

:::warning Adapter not yet shipped
The fiskaltrust Poland adapter is **not yet available**, so there is no fiskaltrust setup to perform yet. Today you can test **directly against the government KSeF demo environment**. This page describes the target setup and the testing options available now. Confirm the adapter's status with your fiskaltrust contact before promising a date to a merchant.
:::

## Prerequisites (expected)

Once the adapter ships, the prerequisites are expected to match the other markets:

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + CashBox | An active account with a configured CashBox. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes with fiskaltrust via `/sign` in another market. |
| CashBox country configuration | The CashBox's country configuration set to the **Polish locale** (once available). |
| PosSystem API (v2) | E-invoicing features are exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Turnover tier | Confirm the merchant's turnover tier — both waves of the mandate have already passed. |
| Payment process | Confirm the merchant's payment process can carry the **KSeF number** into transfer titles (mandatory from August 2026). |

## Enable e-invoicing in the Portal

<!-- TODO (to verify before publish): document the actual Portal flow to enable e-invoicing for PL,
     once the fiskaltrust Poland adapter has shipped. Do not publish invented steps here. -->

:::caution Not available yet
There are no fiskaltrust Portal steps to document until the Poland adapter ships. This section will be completed once the flow is confirmed.
:::

## What you can test today

Ahead of the fiskaltrust adapter, the government's own demo environment is live.

| Resource | Status |
| --- | --- |
| **KSeF government demo** | Available now, for testing directly against KSeF. |
| **fiskaltrust sandbox** | Not yet available — check with your fiskaltrust contact before promising a date to a partner. |

Until the fiskaltrust sandbox is available, end-to-end validation through the PosSystem API (the flow below) cannot be run against Poland. Use the KSeF government demo to familiarize yourself with clearance and the KSeF number.

### End-to-end example

:::caution Target state — not yet available via fiskaltrust
The flow below is the **expected** shape once the fiskaltrust Poland adapter ships — the same `/sign` → `/issue` pattern as the other markets. It **cannot be run against Poland through fiskaltrust yet**. Endpoint and parameter names, and PL case codes, are pending — every value marked `TBC` is a placeholder.
:::

The API is request/response and **idempotent — there is no status webhook**. Each call returns its result synchronously in the response body; a retry reuses the same `x-operation-id` and returns the original result. Every request carries the standard headers (see the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for full schemas):

```
x-cashbox-id: <sandbox CashBox ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Sign (`/sign`)**

Call `/sign` as you do today, including the buyer's master data. The response would **also carry the KSeF FA(3) document**.

```json
// POST {POS_SYSTEM_API}/sign
{
  "cbReceiptReference": "PL-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-09-01T10:00:00.000Z",
  "ftReceiptCase": "<B2B e-invoice case — PL value TBC>",
  "cbCustomer": {
    "CustomerVATId": "PL1234567890",
    "CustomerName": "Przykład Sp. z o.o.",
    "CustomerStreet": "ul. Przykładowa 1",
    "CustomerZip": "00-001",
    "CustomerCity": "Warszawa",
    "CustomerCountry": "PL"
  },
  "cbChargeItems": [
    {
      "Quantity": 1,
      "Description": "Consulting services",
      "Amount": 1230.00,
      "VATRate": 23.0,
      "ftChargeItemCase": "<standard-rate case — PL value TBC>"
    }
  ],
  "cbPayItems": [
    {
      "Quantity": 1,
      "Description": "Bank transfer",
      "Amount": 1230.00,
      "ftPayItemCase": "<non-cash case — PL value TBC>"
    }
  ]
}
```

**Step 2 — Issue for delivery (`/issue`)**

Call `/issue` with the KSeF delivery target — the one new parameter. The response would return the **KSeF clearance number**.

```json
// POST {POS_SYSTEM_API}/issue
{
  "cbReceiptReference": "PL-EINV-SANDBOX-0001",
  "ftReceiptCase": "<same B2B e-invoice case as Step 1>",
  "ftReceiptCaseData": {
    "PL": {
      "<delivery-target-field — TBC>": "ksef"
    }
  }
}
```

**Step 3 — Poll for status**

Call `/issue` status until KSeF returns the **clearance number**. Replay with the same `x-operation-id` to re-check — the API returns the same result. There is **no callback or status webhook**.

**Step 4 — Archive**

No separate call. The e-invoice archive copy would sit in `/journal` alongside your existing records.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
