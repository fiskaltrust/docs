---
slug: /poscreators/middleware-doc/poland/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test eInvoicing (Poland)

This page covers the prerequisites for eInvoicing in the Polish (PL) market, how to enable it in the fiskaltrust.Portal, and how to validate the flow against a sandbox before production. For scope, regulatory status, and the delivery flow, see the [Overview](./overview.md).

:::note What setup means in Poland
eInvoicing rides on calls you already make. Setup is about **configuration** — KSeF FA(3) output and the fiskaltrust.Middleware's Polish locale. Delivery via `/issue` to KSeF is **optional**. There is **no new connection or credential**.
:::

:::caution Poland eInvoicing is in preview
The Poland eInvoicing path is available in **preview** on the developer platform. Confirm production availability and the exact KSeF clearance behaviour with your fiskaltrust contact before going live.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Poland via `/sign`. |
| fiskaltrust.Middleware country configuration | The fiskaltrust.Middleware's country configuration is set to the **Polish locale**. |
| PosSystem API (v2) | eInvoicing features are exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Currency | Poland is **not a euro market** — every request must set `"Currency": "PLN"` (at the top level and on each charge and pay item). |
| Payment process | Confirm the merchant's payment process can carry the **KSeF number** into transfer titles (mandatory from August 2026). |

## Enable eInvoicing in the Portal

eInvoicing is enabled by **configuration**: KSeF FA(3) output and the fiskaltrust.Middleware's Polish locale. No new integration is required on the POS side.

:::caution Draft — Portal steps to be confirmed
The exact steps to enable eInvoicing in the fiskaltrust.Portal (KSeF FA(3) output, Polish locale) are being verified and will be documented here. Do not treat this section as final until the flow has been confirmed.
:::

## Sandbox validation

Validate the end-to-end flow against a sandbox-scoped fiskaltrust.Middleware — using non-production `x-cashbox-id` and `x-cashbox-accesstoken` credentials — before enabling it on a production fiskaltrust.Middleware. **Run one document through the sandbox end to end before the first live document.**

1. Provision a **sandbox fiskaltrust.Middleware** in the fiskaltrust.Portal — this yields the `x-cashbox-id` and `x-cashbox-accesstoken` used on every request. See [Portal registration](../../../getting-started/portal-registration.md).
2. Confirm your integration against the [Integration checklist](../../../getting-started/integration-checklist.md).
3. Run one invoice through the full flow below: `/sign` → (optionally) `/issue` → poll until **cleared by KSeF**.

### End-to-end example

Run it against the sandbox at `https://possystem-api-sandbox.fiskaltrust.eu/v2`. The API is request/response and **idempotent — there is no status webhook**; the `x-operation-id` header is the idempotency key that makes retries safe. Every request carries the standard headers:

```
x-cashbox-id: <sandbox fiskaltrust.Middleware ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Sign (`/sign`)** — produces the eInvoice

Call `/sign` as you do today, with the buyer's master data, using the **B2B invoice** receipt case. Poland is not a euro market, so set `"Currency": "PLN"` explicitly. The response carries the fiscalized receipt and the KSeF FA(3) document.

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/sign
{
  "ftReceiptCase": 35184372092930,
  "cbReceiptReference": "PL-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-09-01T10:00:00Z",
  "Currency": "PLN",
  "cbCustomer": {
    "CustomerVATId": "PL1234567890",
    "CustomerName": "Przykład Sp. z o.o.",
    "CustomerStreet": "ul. Przykładowa 1",
    "CustomerZip": "00-001",
    "CustomerCity": "Warszawa",
    "CustomerCountry": "PL"
  },
  "cbChargeItems": [
    { "Quantity": 1, "Description": "Consulting services", "Amount": 1230.00, "VATRate": 23, "ftChargeItemCase": 35184372088851, "Currency": "PLN" }
  ],
  "cbPayItems": [
    { "Description": "Bank transfer", "Amount": 1230.00, "ftPayItemCase": 35184372088842, "Currency": "PLN" }
  ]
}
```

> **Try it:** [developer.fiskaltrust.eu → PL → sign → B2BInvoice](https://developer.fiskaltrust.eu/#/pos-system/PL?endpoint=sign&businesscase=SignRequestReceipt_B2BInvoice_1). The KSeF FA(3) output comes from the fiskaltrust.Middleware configuration, not this payload — see [Enable eInvoicing in the Portal](#enable-einvoicing-in-the-portal).

**Step 2 — Issue (`/issue`)** — optional, register for delivery

To make the receipt available for delivery, call `/issue` with the **original `/sign` request and its response** (`ReceiptRequest` + `ReceiptResponse`). The response returns the `ftQueueID` / `ftQueueItemID` used by the delivery and status calls.

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/issue
{
  "ReceiptRequest":  { "...": "the /sign request from Step 1" },
  "ReceiptResponse": { "...": "the /sign response from Step 1" }
}
```

> **Try it:** [developer.fiskaltrust.eu → PL → issue](https://developer.fiskaltrust.eu/#/pos-system/PL?endpoint=issue).

**Step 3 — Deliver to a channel** — optional

Deliver the document with `PUT /issue/{queueId}/{queueItemId}`, choosing a delivery method: `IssueUpdateSend` (email/SMS), `IssueUpdatePrint`, `IssueUpdateDownload`, `IssueUpdateUpload`, or `IssueUpdateLink`. Submission to KSeF uses one of the upload/send methods — confirm the exact delivery target with product.

**Step 4 — Check clearance status**

Poll `GET /issue/{queueId}/{queueItemId}` for the status until KSeF returns the **clearance number**. There is **no callback or webhook**.

See the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for the full `/issue` request/response schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
