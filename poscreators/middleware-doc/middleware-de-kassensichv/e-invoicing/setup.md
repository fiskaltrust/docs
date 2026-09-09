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

### End-to-end example

Run it against the sandbox at `https://possystem-api-sandbox.fiskaltrust.eu/v2`. The API is request/response and **idempotent — there is no status webhook**; a retry reuses the same `x-operation-id` and returns the original result. Every request carries the standard headers:

```
x-cashbox-id: <sandbox fiskaltrust.Middleware ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Sign (`/sign`)** — produces the eInvoice

Call `/sign` as you do today, with the buyer's master data, using the **B2B invoice** receipt case. The response carries the fiscalized receipt and the EN 16931 document (XRechnung or ZUGFeRD, per your fiskaltrust.Middleware configuration).

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/sign
{
  "ftReceiptCase": 35184372092930,
  "cbReceiptReference": "DE-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2027-01-01T10:00:00Z",
  "cbCustomer": {
    "CustomerVATId": "DE123456789",
    "CustomerName": "Beispiel GmbH",
    "CustomerStreet": "Beispielstraße 1",
    "CustomerZip": "10115",
    "CustomerCity": "Berlin",
    "CustomerCountry": "DE"
  },
  "cbChargeItems": [
    { "Quantity": 1, "Description": "Consulting services", "Amount": 1190.00, "VATRate": 19, "ftChargeItemCase": 35184372088851 }
  ],
  "cbPayItems": [
    { "Description": "Bank transfer", "Amount": 1190.00, "ftPayItemCase": 35184372088842 }
  ]
}
```

> **Try it:** [developer.fiskaltrust.eu → DE → sign → B2BInvoice](https://developer.fiskaltrust.eu/#/pos-system/DE?endpoint=sign&businesscase=SignRequestReceipt_B2BInvoice_1). The output format (XRechnung / ZUGFeRD) comes from the fiskaltrust.Middleware configuration, not this payload — see [Enable eInvoicing in the Portal](#enable-einvoicing-in-the-portal). For B2G buyers, include the buyer's **Leitweg-ID**.

**Step 2 — Issue (`/issue`)** — optional, register for delivery

To make the receipt available for delivery, call `/issue` with the **original `/sign` request and its response** (`ReceiptRequest` + `ReceiptResponse`). The response returns the `ftQueueID` / `ftQueueItemID` used by the delivery and status calls.

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/issue
{
  "ReceiptRequest":  { "...": "the /sign request from Step 1" },
  "ReceiptResponse": { "...": "the /sign response from Step 1" }
}
```

**Step 3 — Deliver to a channel** — optional

Deliver the document with `PUT /issue/{ftQueueID}/{ftQueueItemID}`, choosing a delivery method: `IssueUpdateSend` (email/SMS), `IssueUpdatePrint`, `IssueUpdateDownload`, `IssueUpdateUpload`, or `IssueUpdateLink`. Peppol delivery uses one of the upload/send methods — confirm the exact one for Peppol with product.

**Step 4 — Check delivery status**

Poll `GET /issue/{ftQueueID}/{ftQueueItemID}/delivered` to check whether the document was delivered. There is **no callback or webhook**.

See the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for the full `/issue` request/response schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
