---
slug: /poscreators/middleware-doc/france/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test eInvoicing (France)

This page covers the prerequisites, the one-time identity settings in the fiskaltrust.Portal, and the per-call PosSystem API flow that produces and delivers an eInvoice — with a sandbox walkthrough. For scope and regulatory status, see the [Overview](./overview.md).

:::caution Target state — not yet available
The French eInvoicing path via the API is **not shipped yet** — the FR-distinct surface is still being designed. This page describes the **target** flow. Do not plan a go-live on it; confirm the roadmap with your fiskaltrust partner manager.
:::

:::note How eInvoicing is "enabled" in France
There is **no "enable eInvoicing" switch and no output-format setting** on the fiskaltrust.Middleware. You configure your **identity once** in the Portal (company master data, plus the routing details for the merchant's Plateforme Agréée), and then request the **format and delivery channel per call** on the PosSystem API `/issue` endpoint. The Middleware's French locale is already set from fiscalization.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in France via `/sign`. |
| fiskaltrust.Middleware country configuration | Set to the **French locale** (already done for fiscalization). The eInvoice **format is chosen per `/issue` call**, not by this configuration. |
| Identity settings in the Portal | Company master data (name, address, VAT ID, country, **SIRET**) and the merchant's Plateforme Agréée routing details. |
| Merchant's Plateforme Agréée | Confirm the merchant **has, or is choosing, a Plateforme Agréée** — nothing else matters until this is settled. |
| PosSystem API (v2) | eInvoicing is exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Default format to request | Decide what the POS will request on `/issue`: **`en16931`** (UBL / CII) for platform routing, **`zugferd`** (Factur-X) as a bridge where needed. This is a per-call parameter, not a Middleware setting. |
| Sandbox validation | Run one document end to end against a sandbox fiskaltrust.Middleware before the first live document. |

## Configure your identity in the Portal (one-time)

This is the only Portal-side step. It sets the master data used to build the document and the identity used to route it:

- **Company master data** — legal name, address, VAT ID, country, **SIRET**.
- **Plateforme Agréée routing** — the merchant's certified platform and the identifiers it needs.

:::caution Portal steps to be confirmed
The exact fiskaltrust.Portal screens for these settings are still being verified and will be documented here. The French API path is **not yet available** (target state).
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
// POST /v2/sign
{
  "ftReceiptCase": 35184372092930,
  "cbReceiptReference": "FR-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-09-01T10:00:00Z",
  "cbCustomer": {
    "CustomerVATId": "FR12345678901",
    "CustomerName": "Exemple SARL",
    "CustomerStreet": "1 Rue de l'Exemple",
    "CustomerZip": "75001", "CustomerCity": "Paris", "CustomerCountry": "FR"
  },
  "cbChargeItems": [
    { "Quantity": 1, "Description": "Consulting services", "Amount": 1200.00, "VATRate": 20, "ftChargeItemCase": 35184372088851 }
  ],
  "cbPayItems": [
    { "Description": "Bank transfer", "Amount": 1200.00, "ftPayItemCase": 35184372088842 }
  ]
}
```

> **Try it:** [developer.fiskaltrust.eu → FR → /sign → B2BInvoice](https://developer.fiskaltrust.eu/#/pos-system/FR?endpoint=sign&businesscase=SignRequestReceipt_B2BInvoice_1). For French buyers, include the **SIRET** in the buyer master data.

**Step 2 — Register at `/issue`**

Register the fiscalized receipt with the **original `/sign` request and its response** (`ReceiptRequest` + `ReceiptResponse`). The `ftQueueID` / `ftQueueItemID` come from the `/sign` response.

```json
// POST /v2/issue
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

> **Try it:** [developer.fiskaltrust.eu → FR → /issue register](https://developer.fiskaltrust.eu/#/pos-system/FR?endpoint=issue).

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

`Action` accepts `download`, `send`, `print`, `link`, `accept`; `Target.Scheme` is `email`, `sms`, `whatsapp`, or `peppol`. Delivery to the merchant's **Plateforme Agréée** is *target state* — confirm the exact routing with product when the FR path ships.

> **Try it:** [developer.fiskaltrust.eu → FR → update receipt (download / send)](https://developer.fiskaltrust.eu/#/pos-system/FR?endpoint=issue-update).

**Step 4 — Check delivery**

```
GET /v2/issue/{queueId}/{queueItemId}/delivered   → 200 delivered / 204 not yet
```

`GET /v2/issue/{queueId}/{queueItemId}` (without `/delivered`) returns the **document content** in the format you request via the `Accept` header — it is content retrieval, not status. There is **no callback or webhook**.

> **Try it:** [developer.fiskaltrust.eu → FR → delivery status](https://developer.fiskaltrust.eu/#/pos-system/FR?endpoint=issue-delivered).

See the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for the full `/issue` schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
