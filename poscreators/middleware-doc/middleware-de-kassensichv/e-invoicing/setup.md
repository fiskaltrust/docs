---
slug: /poscreators/middleware-doc/germany/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test eInvoicing (Germany)

This page covers the prerequisites, the one-time identity settings in the fiskaltrust.Portal, and the per-call PosSystem API flow that produces and delivers an eInvoice — with a sandbox walkthrough. For scope and regulatory status, see the [Overview](./overview.md).

:::note How eInvoicing is "enabled" in Germany
There is **no "enable eInvoicing" switch and no output-format setting** on the fiskaltrust.Middleware. You configure your **identity once** in the Portal (company master data, plus a Peppol participant ID for Peppol sending), and then request the **format and delivery channel per call** on the PosSystem API `/issue` endpoint. The Middleware's German locale is already set from fiscalization.
:::

:::caution Sandbox only today (Germany)
EN 16931 / ZUGFeRD output and Peppol sending are currently available on the **sandbox** only — not yet production-enabled. Treat production go-live as *target state* and confirm the roadmap with your fiskaltrust partner manager.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Germany via `/sign`. |
| fiskaltrust.Middleware country configuration | Set to the **German locale** (already done for fiscalization). The eInvoice **format is chosen per `/issue` call**, not by this configuration. |
| Identity settings in the Portal | Company master data (name, address, VAT ID, country) and — for Peppol sending — the sender's **Peppol participant ID**. |
| PosSystem API (v2) | eInvoicing is exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Default format to request | Decide what the POS will request on `/issue`: **`en16931`** (validate against XRechnung) for B2G and network-capable B2B buyers, **`zugferd`** for direct delivery. This is a per-call parameter, not a Middleware setting. |
| Leitweg-ID (B2G only) | For public-sector buyers, the buyer's **Leitweg-ID** is required in the invoice data. |
| Sandbox validation | Run one document end to end against a sandbox fiskaltrust.Middleware before the first live document. |

## Configure your identity in the Portal (one-time)

This is the only Portal-side step. It sets the master data used to build the document and the identity used to route it:

- **Company master data** — legal name, address, VAT ID, country.
- **Peppol participant ID** — the sender's Peppol ID, required to **send** over Peppol.

## Produce and deliver an eInvoice (per call)

Everything about the eInvoice — that it is produced, in which format, and where it goes — is decided **per call** on the PosSystem API. Run the walkthrough against the sandbox at `https://possystem-api-sandbox.fiskaltrust.eu/v2`. The API is request/response and **idempotent — there is no status webhook**; `x-operation-id` is the idempotency key that makes retries safe. Every request carries:

```
x-cashbox-id: <sandbox fiskaltrust.Middleware ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

:::caution Validate against the XRechnung specification
Validate test documents against the **XRechnung specification**, not only EN 16931 — XRechnung adds **200+ national rules** of its own. A document can be EN 16931-valid and still fail XRechnung validation.
:::

**Step 1 — Sign (`/sign`)** — fiscalize the invoice

Call `/sign` as you do today, with the buyer's master data, using the **B2B invoice** receipt case. The response fiscalizes the receipt and returns the `ftQueueID` / `ftQueueItemID` you need next.

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

> **Try it:** [developer.fiskaltrust.eu → DE → /sign → B2BInvoice](https://developer.fiskaltrust.eu/#/pos-system/DE?endpoint=sign&businesscase=SignRequestReceipt_B2BInvoice_1). For B2G buyers, include the buyer's **Leitweg-ID**.

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

> **Try it:** [developer.fiskaltrust.eu → DE → /issue register](https://developer.fiskaltrust.eu/#/pos-system/DE?endpoint=issue).

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

`Action` accepts `download`, `send`, `print`, `link`, `accept`; `Target.Scheme` is `email`, `sms`, `whatsapp`, or `peppol`. In Germany today, EN 16931 / ZUGFeRD download and Peppol sending are **sandbox only**.

> **Try it:** [developer.fiskaltrust.eu → DE → update receipt (download / send)](https://developer.fiskaltrust.eu/#/pos-system/DE?endpoint=issue-update).

**Step 4 — Check delivery**

```
GET /v2/issue/{queueId}/{queueItemId}/delivered   → 200 delivered / 204 not yet
```

`GET /v2/issue/{queueId}/{queueItemId}` (without `/delivered`) returns the **document content** in the format you request via the `Accept` header — it is content retrieval, not status. There is **no callback or webhook**.

> **Try it:** [developer.fiskaltrust.eu → DE → delivery status](https://developer.fiskaltrust.eu/#/pos-system/DE?endpoint=issue-delivered).

See the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for the full `/issue` schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and eDelivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
