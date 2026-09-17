---
slug: /poscreators/middleware-doc/austria/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test eInvoicing (Austria)

This page covers the prerequisites, the one-time identity settings in the fiskaltrust.Portal, and the per-call PosSystem API flow that produces and delivers an eInvoice — with a sandbox walkthrough. For scope and regulatory status, see the [Overview](./overview.md).

:::note How eInvoicing is "enabled" in Austria
There is **no "enable eInvoicing" switch and no output-format setting** on the fiskaltrust.Middleware. You configure your **identity once** in the Portal (company master data, plus a Peppol participant ID for Peppol sending), and then request the **format and delivery channel per call** on the PosSystem API `/issue` endpoint. The Middleware's Austrian locale is already set from fiscalization.
:::

:::caution Sandbox only today (Austria)
EN 16931 output and Peppol sending are currently available on the **sandbox** only — not yet production-enabled (InStore App B2B delivery is in preview). Treat production go-live as *target state* and confirm the roadmap with your fiskaltrust partner manager.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Austria via `/sign`. |
| fiskaltrust.Middleware country configuration | Set to the **Austrian locale** (already done for fiscalization). The eInvoice **format is chosen per `/issue` call**, not by this configuration. |
| Identity settings in the Portal | Company master data (name, address, VAT ID, country) and — for Peppol sending — the sender's **Peppol participant ID**. |
| PosSystem API (v2) | eInvoicing is exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Sandbox validation | Run one document end to end against a sandbox fiskaltrust.Middleware before the first live document. |

## Configure your identity in the Portal (one-time)

This is the only Portal-side step. It sets the master data used to build the document and the identity used to route it:

- **Company master data** — legal name, address, VAT ID, country.
- **Peppol participant ID** — the sender's Peppol ID, required to **send** over Peppol.

:::caution Portal steps to be confirmed
The exact fiskaltrust.Portal screens for these settings are still being verified and will be documented here. In Austria the API path is currently **sandbox only**.
:::

## Produce and deliver an eInvoice (per call)

Everything about the eInvoice — that it is produced, in which format, and where it goes — is decided **per call** on the PosSystem API. Run the walkthrough against the sandbox at `https://possystem-api-sandbox.fiskaltrust.eu/v2`. The API is request/response and **idempotent — there is no status webhook**; `x-operation-id` is the idempotency key that makes retries safe. Every request carries:

```
x-cashbox-id: <sandbox fiskaltrust.Middleware ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Sign (`/sign`)** — fiscalize the invoice

Call `/sign` as you do today, with the buyer's master data, using the **B2B invoice** receipt case. The response fiscalizes the receipt and returns the `ftQueueID` / `ftQueueItemID` you need next.

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/sign
{
  "ftReceiptCase": 35184372092930,
  "cbReceiptReference": "AT-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-09-01T10:00:00Z",
  "cbCustomer": {
    "CustomerVATId": "ATU12345678",
    "CustomerName": "Beispiel GmbH",
    "CustomerStreet": "Beispielstraße 1",
    "CustomerZip": "1010",
    "CustomerCity": "Wien",
    "CustomerCountry": "AT"
  },
  "cbChargeItems": [
    { "Quantity": 1, "Description": "Consulting services", "Amount": 1200.00, "VATRate": 20, "ftChargeItemCase": 35184372088851 }
  ],
  "cbPayItems": [
    { "Description": "Bank transfer", "Amount": 1200.00, "ftPayItemCase": 35184372088842 }
  ]
}
```

> **Try it:** [developer.fiskaltrust.eu → AT → /sign → B2BInvoice](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=sign&businesscase=SignRequestReceipt_B2BInvoice_1).

**Step 2 — Register at `/issue`**

Register the fiscalized receipt with the **original `/sign` request and its response** (`ReceiptRequest` + `ReceiptResponse`). The `ftQueueID` / `ftQueueItemID` come from the `/sign` response.

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/issue
{
  "ReceiptRequest":  { "...": "the /sign request from Step 1" },
  "ReceiptResponse": { "...": "the /sign response from Step 1" }
}
```
```json
// response
{ "ftQueueID": "a1b2…", "ftQueueItemID": "c3d4…",
  "DocumentURL": "https://<receipt-api>/a1b2…/c3d4…" }
```

> **Try it:** [developer.fiskaltrust.eu → AT → /issue register](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=issue).

**Step 3 — Get or send the eInvoice** — `PUT /v2/issue/{queueId}/{queueItemId}`

Choose the format and channel here, per call:

*Download the structured document:*
```json
{ "Action": "download", "Format": "application/xml" }
```
*Send it over Peppol:*
```json
{ "Action": "send",
  "Target": { "Scheme": "peppol", "Address": "<buyer Peppol ID>",
              "Attach": "application/xml", "Send": true } }
```
*…or email a copy instead:*
```json
{ "Action": "send",
  "Target": { "Scheme": "email", "Address": "buyer@example.com",
              "Attach": "application/pdf", "Send": true } }
```

`Action` accepts `download`, `send`, `print`, `link`, `accept`; `Target.Scheme` is `email`, `sms`, `whatsapp`, or `peppol`. In Austria today, EN 16931 download and Peppol sending are **sandbox only** (national ebInterface output and the e-Rechnung.gv.at portal path are *target state*).

> **Try it:** [developer.fiskaltrust.eu → AT → update receipt (download / send)](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=issue-update).

**Step 4 — Check delivery**

```
GET /v2/issue/{queueId}/{queueItemId}/delivered   → 200 delivered / 204 not yet
```

`GET /v2/issue/{queueId}/{queueItemId}` (without `/delivered`) returns the **document content** in the format you request via the `Accept` header — it is content retrieval, not status. There is **no callback or webhook**.

> **Try it:** [developer.fiskaltrust.eu → AT → delivery status](https://developer.fiskaltrust.eu/#/pos-system/AT?endpoint=issue-delivered).

See the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for the full `/issue` schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
