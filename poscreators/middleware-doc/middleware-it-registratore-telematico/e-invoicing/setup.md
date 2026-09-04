---
slug: /poscreators/middleware-doc/italy/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test e-invoicing (Italy)

This page covers the prerequisites for e-invoicing in the Italian (IT) market, how to enable it in the fiskaltrust Portal, and how to validate the flow against a sandbox before production. For scope, regulatory status, and the delivery flow, see the [Overview](./overview.md).

:::note What setup means in Italy
E-invoicing rides on calls you already make. Setup is about **configuration** — the CashBox's Italian locale and FatturaPA output — plus one added `/issue` submission step to SDI. The Middleware applies the XAdES signature; there is **no new connection or credential**.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + CashBox | An active account with a configured CashBox. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Italy via `/sign`. |
| CashBox country configuration | The CashBox's country configuration is set to the **Italian locale**. |
| PosSystem API (v2) | E-invoicing features are exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Buyer routing | The buyer's **`CodiceDestinatario`** is on file, or plan the **PEC fallback** path for an unknown buyer. |
| Existing arrangement | Ask what the merchant already uses — in Italy this is almost always a **displacement**, not a first-time integration. |

## Enable e-invoicing in the Portal

E-invoicing is enabled by **configuration**: FatturaPA output and the CashBox's Italian locale. No new integration is required on the POS side.

<!-- TODO (to verify before publish): document the actual Portal flow to enable e-invoicing for IT.
     Open questions to confirm with the Portal team / product:
       - Where the FatturaPA output and Italian locale are set (CashBox config vs. product flag).
       - Whether e-invoicing is on by default once the CashBox locale is Italian.
       - The exact delivery-target parameter on /issue and SDI routing (direct / CodiceDestinatario / PEC).
     Do not publish invented steps here. -->

:::caution Draft — Portal steps to be confirmed
The exact steps to enable e-invoicing in the fiskaltrust Portal (FatturaPA output, Italian locale) are being verified and will be documented here. Do not treat this section as final until the flow has been confirmed.
:::

## Sandbox validation

Validate the end-to-end flow against a sandbox-scoped CashBox — using non-production `x-cashbox-id` and `x-cashbox-accesstoken` credentials — before enabling it on a production CashBox. **Run one document through the sandbox end to end before the first live document.**

1. Provision a **sandbox CashBox** in the fiskaltrust Portal — this yields the `x-cashbox-id` and `x-cashbox-accesstoken` used on every request. See [Portal registration](../../../getting-started/portal-registration.md).
2. Confirm your integration against the [Integration checklist](../../../getting-started/integration-checklist.md).
3. Run one invoice through the full flow below: `/sign` → `/issue` → poll until **cleared by SDI** → confirm the archive in `/journal`.

:::note The Middleware handles the XAdES signature
FatturaPA requires an XAdES signature. This is applied by the Middleware on `/sign` — you do not sign the document yourself. Validate that SDI accepts the cleared document in the sandbox before going live.
:::

:::caution Draft — sandbox specifics to be confirmed
E-invoicing-specific sandbox provisioning (and any starter guide or sample keys) is being verified. Confirm the exact provisioning path and any e-invoicing sample collection before publishing.
:::

### End-to-end example

:::caution Illustrative — endpoint names pending final sign-off
The **flow below is confirmed**, but the exact delivery-target parameter on `/issue`, the SDI routing behaviour (direct / `CodiceDestinatario` / PEC), and the Italy-specific case codes are pending final sign-off with product. Treat every value marked `TBC` as a placeholder — confirm before building against it.
:::

The API is request/response and **idempotent — there is no status webhook**. Each call returns its result synchronously in the response body; a retry reuses the same `x-operation-id` and returns the original result. Every request carries the standard headers (base URL comes from your sandbox provisioning; see the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for full schemas):

```
x-cashbox-id: <sandbox CashBox ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Sign (`/sign`)**

Call `/sign` as you do today, including the buyer's master data. The response now **also carries the FatturaPA document** with the XAdES signature applied.

```json
// POST {POS_SYSTEM_API}/sign
{
  "cbReceiptReference": "IT-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-05-15T10:00:00.000Z",
  "ftReceiptCase": "<B2B e-invoice case — IT value TBC>",
  "cbCustomer": {
    "CustomerVATId": "IT12345678901",
    "CustomerName": "Esempio S.r.l.",
    "CustomerStreet": "Via Roma 1",
    "CustomerZip": "00100",
    "CustomerCity": "Roma",
    "CustomerCountry": "IT"
  },
  "cbChargeItems": [
    {
      "Quantity": 1,
      "Description": "Consulting services",
      "Amount": 1220.00,
      "VATRate": 22.0,
      "ftChargeItemCase": "<standard-rate case — IT value TBC>"
    }
  ],
  "cbPayItems": [
    {
      "Quantity": 1,
      "Description": "Bank transfer",
      "Amount": 1220.00,
      "ftPayItemCase": "<non-cash case — IT value TBC>"
    }
  ]
}
```

The FatturaPA output and XAdES signature are produced by the Middleware per the CashBox configuration — see [Enable e-invoicing in the Portal](#enable-e-invoicing-in-the-portal).

**Step 2 — Issue for delivery (`/issue`)**

Call `/issue` with the SDI delivery target — the one new parameter. Provide the buyer's `CodiceDestinatario`, or fall back to PEC for an unknown buyer.

```json
// POST {POS_SYSTEM_API}/issue
{
  "cbReceiptReference": "IT-EINV-SANDBOX-0001",
  "ftReceiptCase": "<same B2B e-invoice case as Step 1>",
  "ftReceiptCaseData": {
    "IT": {
      "<delivery-target-field — TBC>": "sdi",
      "<codice-destinatario-field — TBC>": "<7-char CodiceDestinatario, or PEC fallback>"
    }
  }
}
```

**Step 3 — Poll for status**

Call `/issue` status until it reports **cleared by SDI**. Replay with the same `x-operation-id` to re-check — the API returns the same result. There is **no callback or status webhook**.

**Step 4 — Archive**

No separate call. The e-invoice archive copy sits in `/journal` alongside your existing records.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
