---
slug: /poscreators/middleware-doc/poland/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test eInvoicing (Poland)

This page covers the prerequisites, the one-time identity settings in the fiskaltrust.Portal, and the per-call PosSystem API flow that produces and delivers an eInvoice — with a sandbox walkthrough. For scope and regulatory status, see the [Overview](./overview.md).

:::caution Poland eInvoicing is in preview
The Poland eInvoicing path is in **preview** — the **KSeF adapter is not yet shipped**, and invoice receipt cases are currently **stored, not fiscalized/cleared**. This page describes the **target** flow. Confirm production availability and the exact KSeF clearance behaviour with your fiskaltrust contact before going live.
:::

:::note How eInvoicing is "enabled" in Poland
There is **no "enable eInvoicing" switch and no output-format setting** on the fiskaltrust.Middleware. You configure your **identity once** in the Portal (company master data, plus KSeF routing), and then request the **format and delivery channel per call** on the PosSystem API `/issue` endpoint. The Middleware's Polish locale is already set from fiscalization.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Poland via `/sign`. |
| fiskaltrust.Middleware country configuration | Set to the **Polish locale** (already done for fiscalization). The eInvoice **format is chosen per `/issue` call**, not by this configuration. |
| Identity settings in the Portal | Company master data (name, address, VAT ID, country) and KSeF routing details. |
| PosSystem API (v2) | eInvoicing is exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Currency | Poland is **not a euro market** — every request must set `"Currency": "PLN"` (at the top level and on each charge and pay item). |
| Payment process | Confirm the merchant's payment process can carry the **KSeF number** into transfer titles (mandatory from August 2026). |
| Sandbox validation | Run one document end to end against a sandbox fiskaltrust.Middleware before the first live document. |

## Configure your identity in the Portal (one-time)

This is the only Portal-side step. It sets the master data used to build the document and the identity used to route it:

- **Company master data** — legal name, address, VAT ID, country.
- **KSeF routing** — the identifiers KSeF submission requires.

:::caution Portal steps to be confirmed
The exact fiskaltrust.Portal screens for these settings are still being verified and will be documented here. The KSeF adapter is **not yet shipped** (preview).
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

Call `/sign` as you do today, with the buyer's master data, using the **B2B invoice** receipt case. Poland is not a euro market, so set `"Currency": "PLN"` explicitly. The response fiscalizes the receipt and returns the `ftQueueID` / `ftQueueItemID` you need next.

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

> **Try it:** [developer.fiskaltrust.eu → PL → /sign → B2BInvoice](https://developer.fiskaltrust.eu/#/pos-system/PL?endpoint=sign&businesscase=SignRequestReceipt_B2BInvoice_1).

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

> **Try it:** [developer.fiskaltrust.eu → PL → /issue register](https://developer.fiskaltrust.eu/#/pos-system/PL?endpoint=issue).

**Step 3 — Get or send the eInvoice** — `PUT /v2/issue/{queueId}/{queueItemId}`

Choose the format and channel here, per call:

*Download the structured document:*
```json
{ "Action": "download", "Format": "application/xml" }
```
*…or email a copy:*
```json
{ "Action": "send",
  "Target": { "Scheme": "email", "Address": "buyer@example.com",
              "Attach": "application/pdf", "Send": true } }
```

`Action` accepts `download`, `send`, `print`, `link`, `accept`; `Target.Scheme` is `email`, `sms`, `whatsapp`, or `peppol`. Submission to KSeF is *target state* — the adapter is not yet shipped; confirm the exact routing with product when the PL path ships.

> **Try it:** [developer.fiskaltrust.eu → PL → update receipt (download / send)](https://developer.fiskaltrust.eu/#/pos-system/PL?endpoint=issue-update).

**Step 4 — Check delivery**

```
GET /v2/issue/{queueId}/{queueItemId}/delivered   → 200 delivered / 204 not yet
```

**The KSeF clearance number is not yet exposed through the PosSystem API** — that is target state; poll `/delivered` for delivery only. `GET /v2/issue/{queueId}/{queueItemId}` (without `/delivered`) returns the **document content**, not status. There is **no callback or webhook**.

> **Try it:** [developer.fiskaltrust.eu → PL → delivery status](https://developer.fiskaltrust.eu/#/pos-system/PL?endpoint=issue-delivered).

See the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for the full `/issue` schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
