---
slug: /poscreators/middleware-doc/germany/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test eInvoicing (Germany)

This page covers the prerequisites for eInvoicing in the German (DE) market, how to enable it in the fiskaltrust.Portal, and how to validate the flow against a sandbox before production. For scope, regulatory status, and the delivery flow, see the [Overview](./overview.md).

:::note What setup means in Germany
eInvoicing rides on calls you already make. Setup is about **configuration** — the output format and the fiskaltrust.Middleware's German locale. Delivery via `/issue` is **optional**. There is **no new connection or credential**.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Germany via `/sign`. |
| fiskaltrust.Middleware country configuration | The fiskaltrust.Middleware's country configuration is set to the **German locale**. |
| PosSystem API (v2) | eInvoicing features are exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Default output format | Decide the default: **XRechnung** for B2G and network-capable B2B buyers, **ZUGFeRD** for direct delivery. |
| Leitweg-ID (B2G only) | For public-sector buyers, the buyer's **Leitweg-ID** is required in the invoice data. |

## Enable eInvoicing in the Portal

eInvoicing is enabled by **configuration**: the output format (XRechnung / ZUGFeRD) and the fiskaltrust.Middleware's German locale. No new integration is required on the POS side.

:::caution Draft — Portal steps to be confirmed
The exact steps to enable eInvoicing in the fiskaltrust.Portal (output-format configuration, German locale) are being verified and will be documented here. Do not treat this section as final until the flow has been confirmed.
:::

## Sandbox validation

Validate the end-to-end flow against a sandbox-scoped fiskaltrust.Middleware — using non-production `x-cashbox-id` and `x-cashbox-accesstoken` credentials — before enabling it on a production fiskaltrust.Middleware. **Run one document through the sandbox end to end before the first live document.**

1. Provision a **sandbox fiskaltrust.Middleware** in the fiskaltrust.Portal — this yields the `x-cashbox-id` and `x-cashbox-accesstoken` used on every request. See [Portal registration](../../../getting-started/portal-registration.md).
2. Confirm your integration against the [Integration checklist](../../../getting-started/integration-checklist.md).
3. Run one invoice through the full flow below: `/sign` → (optionally) `/issue` → poll for delivery status.

:::caution Validate against the XRechnung specification
Validate test documents against the **XRechnung specification**, not only EN 16931 — XRechnung adds **200+ national rules** of its own. A document can be EN 16931-valid and still fail XRechnung validation.
:::

:::caution Draft — sandbox specifics to be confirmed
eInvoicing-specific sandbox provisioning (and any starter guide or sample keys) is being verified. Confirm the exact provisioning path and any eInvoicing sample collection before publishing.
:::

### End-to-end example

:::caution Illustrative — endpoint names pending final sign-off
The **flow below is confirmed**, but the exact delivery-target parameter on `/issue` and the Germany-specific case codes are pending final sign-off with product. Treat every value marked `TBC` as a placeholder — confirm before building against it.
:::

The API is request/response and **idempotent — there is no status webhook**. Each call returns its result synchronously in the response body; a retry reuses the same `x-operation-id` and returns the original result. Every request carries the standard headers (base URL comes from your sandbox provisioning; see the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for full schemas):

```
x-cashbox-id: <sandbox fiskaltrust.Middleware ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Sign (`/sign`)**

Call `/sign` as you do today, including the buyer's master data. The response now **also carries the EN 16931 document** (XRechnung or ZUGFeRD, per your fiskaltrust.Middleware configuration).

```json
// POST {POS_SYSTEM_API}/sign
{
  "cbReceiptReference": "DE-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2027-01-01T10:00:00.000Z",
  "ftReceiptCase": "<B2B eInvoice case — DE value TBC>",
  "cbCustomer": {
    "CustomerVATId": "DE123456789",
    "CustomerName": "Beispiel GmbH",
    "CustomerStreet": "Beispielstraße 1",
    "CustomerZip": "10115",
    "CustomerCity": "Berlin",
    "CustomerCountry": "DE"
  },
  "cbChargeItems": [
    {
      "Quantity": 1,
      "Description": "Consulting services",
      "Amount": 1190.00,
      "VATRate": 19.0,
      "ftChargeItemCase": "<standard-rate case — DE value TBC>"
    }
  ],
  "cbPayItems": [
    {
      "Quantity": 1,
      "Description": "Bank transfer",
      "Amount": 1190.00,
      "ftPayItemCase": "<non-cash case — DE value TBC>"
    }
  ]
}
```

The output format (XRechnung / ZUGFeRD) comes from the fiskaltrust.Middleware configuration, not this payload — see [Enable eInvoicing in the Portal](#enable-eInvoicing-in-the-portal). For B2G buyers, include the buyer's **Leitweg-ID** in the invoice data.

**Step 2 — Issue for delivery (`/issue`)**

Call `/issue` with the network delivery target — the one new parameter. This routes the document to the buyer over Peppol.

```json
// POST {POS_SYSTEM_API}/issue
{
  "cbReceiptReference": "DE-EINV-SANDBOX-0001",
  "ftReceiptCase": "<same B2B eInvoice case as Step 1>",
  "ftReceiptCaseData": {
    "DE": {
      "<delivery-target-field — TBC>": "peppol"
    }
  }
}
```

**Step 3 — Poll for status**

Call `/issue` status until it reports **delivered**. Replay with the same `x-operation-id` to re-check — the API returns the same result. There is **no callback or status webhook**.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
