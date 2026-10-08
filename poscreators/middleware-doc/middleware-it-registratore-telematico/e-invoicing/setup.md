---
slug: /poscreators/middleware-doc/italy/e-invoicing/setup
title: "Setup & testing"
description: Prerequisites, Portal activation and sandbox validation for eInvoicing in Italy, with an end-to-end FatturaPA example.
tags: [eInvoicing, FatturaPA, Configuration, POS System API, Italy]
---

# Set up and test eInvoicing (Italy)

This page covers the prerequisites for eInvoicing in the Italian (IT) market, how to enable it in the fiskaltrust.Portal, and how to validate the flow against a sandbox before production. For the supported scope (B2C and B2B, sending only), see [What fiskaltrust supports](./overview.md#what-fiskaltrust-supports); for regulatory status and the delivery flow, see the [Overview](./overview.md).

:::note What setup means in Italy
eInvoicing rides on calls you already make. Setup is about **configuration** — FatturaPA output and the fiskaltrust.Middleware's Italian locale. The FatturaPA is **generated as part of `/sign`** and returned **unsigned** in the response; `POST /issue` sends it to the **fiskaltrust SDI service**, which transmits it to SDI. There is **no new connection or credential**.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Italy via `/sign`. |
| fiskaltrust.Middleware country configuration | The fiskaltrust.Middleware's country configuration is set to the **Italian locale**. |
| PosSystem API (v2) | eInvoicing features are exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Merchant master data | The merchant has connected their fiskaltrust account to their AdE account, with **regime fiscale** and **sede**. The seller on every FatturaPA comes from this connection, never from the receipt. See [FatturaPA mapping](./fatturapa-mapping.md#data-sources). |
| Buyer routing | For B2B, the buyer's SDI **codice destinatario** or **PEC** is on file. It is sent in `cbCustomer.CustomerEndpointId` as `0205:<codice destinatario>` or `0202:<pec>`. See [SDI routing](./fatturapa-mapping.md#sdi-routing). |
| Existing arrangement | Ask what the merchant already uses — in Italy this is almost always a **displacement**, not a first-time integration. |

## Enable eInvoicing in the Portal

eInvoicing is enabled by **configuration**: FatturaPA output and the fiskaltrust.Middleware's Italian locale. No new integration is required on the POS side.

:::caution Draft — Portal steps to be confirmed
The exact steps to enable eInvoicing in the fiskaltrust.Portal (FatturaPA output, Italian locale) are being verified and will be documented here. Do not treat this section as final until the flow has been confirmed.
:::

## Sandbox validation

Validate the end-to-end flow against a sandbox-scoped fiskaltrust.Middleware — using non-production `x-cashbox-id` and `x-cashbox-accesstoken` credentials — before enabling it on a production fiskaltrust.Middleware. **Run one document through the sandbox end to end before the first live document.**

1. Provision a **sandbox fiskaltrust.Middleware** in the fiskaltrust.Portal — this yields the `x-cashbox-id` and `x-cashbox-accesstoken` used on every request. See [Portal registration](../../../getting-started/portal-registration.md).
2. Confirm your integration against the [Integration checklist](../../../getting-started/integration-checklist.md).
3. Run one invoice through the full flow below: `/sign` (generation) → `/issue` (transmission to SDI) → check the delivery status.

:::note The FatturaPA is returned unsigned
The FatturaPA XML is returned unsigned by `/sign`. `POST /issue` sends it to the fiskaltrust SDI service, which transmits it to SDI and completes the transmission data (`DatiTrasmissione`, the file name). See [Transmission data](./fatturapa-mapping.md#transmission-data).
:::

### End-to-end example

Run it against the sandbox at `https://possystem-api-sandbox.fiskaltrust.eu/v2`. The API is request/response and **idempotent — there is no status webhook**; the `x-operation-id` header is the idempotency key that makes retries safe. Every request carries the standard headers:

```
x-cashbox-id: <sandbox fiskaltrust.Middleware ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Sign (`/sign`)** — generates the FatturaPA

Call `/sign` as you do today, with the buyer's master data, using the **B2B invoice** receipt case. You do not send an invoice number: the fiskaltrust eInvoicing service assigns it from the merchant's progressive series (see [Invoice numbers](./fatturapa-mapping.md#invoice-numbers)). The response carries the fiscalized receipt and, in the `einvoice-fattura-pa` signature, the FatturaPA XML. See [FatturaPA mapping](./fatturapa-mapping.md) for how each field is mapped and which validation rules apply.

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/sign
{
  "ftReceiptCase": 35184372092930,
  "cbReceiptReference": "IT-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-05-15T10:00:00Z",
  "cbCustomer": {
    "CustomerVATId": "IT12345678903",
    "CustomerName": "Esempio S.r.l.",
    "CustomerStreet": "Via Roma 1",
    "CustomerZip": "00100",
    "CustomerCity": "Roma",
    "CustomerCountrySubentity": "RM",
    "CustomerCountry": "IT",
    "CustomerEndpointId": "0205:ABCDEFG"
  },
  "cbChargeItems": [
    { "Quantity": 1, "Description": "Consulting services", "Amount": 1220.00, "VATRate": 22, "ftChargeItemCase": 35184372088851 }
  ],
  "cbPayItems": [
    { "Description": "Bank transfer", "Amount": 1220.00, "ftPayItemCase": 35184372088842 }
  ]
}
```

> **Try it:** [developer.fiskaltrust.eu → IT → sign → B2BInvoice](https://developer.fiskaltrust.eu/#/pos-system/IT?endpoint=sign&businesscase=SignRequestReceipt_B2BInvoice_1). The FatturaPA output is produced per the fiskaltrust.Middleware's configuration — see [Enable eInvoicing in the Portal](#enable-einvoicing-in-the-portal).

**Step 2 — Issue (`/issue`)** — transmits the FatturaPA to SDI

To transmit the FatturaPA generated in Step 1 to SDI, call `/issue` with the **original `/sign` request and its response** (`ReceiptRequest` + `ReceiptResponse`). The SDI recipient is the `CodiceDestinatario` (or the PEC address) in the generated document. The response returns the `ftQueueID` / `ftQueueItemID` used by the delivery and status calls.

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/issue
{
  "ReceiptRequest":  { "...": "the /sign request from Step 1" },
  "ReceiptResponse": { "...": "the /sign response from Step 1" }
}
```

> **Try it:** [developer.fiskaltrust.eu → IT → issue](https://developer.fiskaltrust.eu/#/pos-system/IT?endpoint=issue).

**Step 3 — Deliver to other channels** — optional

In addition to SDI, deliver the document with `PUT /issue/{queueId}/{queueItemId}`, choosing a delivery method: `IssueUpdateSend` (email/SMS), `IssueUpdatePrint`, `IssueUpdateDownload`, `IssueUpdateUpload`, or `IssueUpdateLink`.

**Step 4 — Check the delivery status**

Check whether the document was delivered with `GET /issue/{queueId}/{queueItemId}/delivered`: it returns `200` when the document was delivered and `204` while it is still pending. To wait for the delivery instead of polling, call `GET /BlockIssueRequest/{queueId}/{queueItemId}/WhileDelivered`. There is **no callback or webhook**.

`GET /issue/{queueId}/{queueItemId}` without `/delivered` is not a status call: it returns the issued document itself, in the format requested with the `Accept` header.

:::note SDI outcome
The SDI outcome of a transmission (for example the *ricevuta di consegna* or a *notifica di scarto*) is currently not returned by the POS System API. In the sandbox, `/delivered` stays at `204`.
:::

See the [POS System API reference](https://docs.fiskaltrust.eu/apis/pos-system-api) for the full `/issue` request/response schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [FatturaPA mapping](./fatturapa-mapping.md) — how a receipt maps to FatturaPA, and the validation rules a receipt must pass.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
