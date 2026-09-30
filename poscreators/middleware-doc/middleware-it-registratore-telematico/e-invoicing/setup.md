---
slug: /poscreators/middleware-doc/italy/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test eInvoicing (Italy)

This page covers the prerequisites for eInvoicing in the Italian (IT) market, how to enable it in the fiskaltrust.Portal, and how to validate the flow against a sandbox before production. For scope, regulatory status, and the delivery flow, see the [Overview](./overview.md).

:::note What setup means in Italy
eInvoicing rides on calls you already make. Setup is about **configuration** — FatturaPA output and the fiskaltrust.Middleware's Italian locale. The FatturaPA is **generated as part of `/sign`** and returned **unsigned** in the response; `POST /issue` sends it to the **fiskaltrust SDI service**, which transmits it to SDI. There is **no new connection or credential**.
:::

:::info What fiskaltrust supports today
- **B2C and B2B:** the FatturaPA is generated as part of `/sign` and transmitted to SDI through `/issue`.
- **B2G is not supported:** the fiskaltrust SDI service is not certified for B2G.
- **Sending only:** receiving eInvoices from SDI is not supported.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + fiskaltrust.Middleware | An active account with a configured fiskaltrust.Middleware. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in Italy via `/sign`. |
| fiskaltrust.Middleware country configuration | The fiskaltrust.Middleware's country configuration is set to the **Italian locale**. |
| PosSystem API (v2) | eInvoicing features are exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Merchant master data | The merchant has connected their fiskaltrust account to their AdE account, with **regime fiscale** and **sede**. The seller on every FatturaPA comes from this connection, never from the receipt. See [FatturaPA mapping](./fatturapa-mapping.md#data-sources). |
| Invoice number | Your POS sends the invoice number from the merchant's own progressive series as `numero` in `ftReceiptCaseData`. It is **required**. |
| Buyer routing | The buyer's **`CodiceDestinatario`** is on file, or plan the **PEC fallback** for an unknown buyer. Both are sent in `ftReceiptCaseData`. |
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
3. Run one invoice through the full flow below: `/sign` (generation) → `/issue` (transmission to SDI) → poll until **cleared by SDI**.

:::note The FatturaPA is returned unsigned
The FatturaPA XML is returned unsigned by `/sign`. `POST /issue` sends it to the fiskaltrust SDI service, which transmits it to SDI and completes the transmission data (`DatiTrasmissione`, the file name). See [Transmission to SDI through `/issue`](./fatturapa-mapping.md#transmission-to-sdi-through-issue).
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

Call `/sign` as you do today, with the buyer's master data, using the **B2B invoice** receipt case. Add the invoice number and the SDI routing in `ftReceiptCaseData`. The response carries the fiscalized receipt and, in the `einvoice-fattura-pa` signature, the FatturaPA XML. See [FatturaPA mapping](./fatturapa-mapping.md) for how each field is mapped and which validation rules apply.

```json
// POST https://possystem-api-sandbox.fiskaltrust.eu/v2/sign
{
  "ftReceiptCase": 35184372092930,
  "cbReceiptReference": "IT-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-05-15T10:00:00Z",
  "cbCustomer": "{\"CustomerVATId\":\"IT12345678903\",\"CustomerName\":\"Esempio S.r.l.\",\"CustomerStreet\":\"Via Roma 1\",\"CustomerZip\":\"00100\",\"CustomerCity\":\"Roma\",\"CustomerCountry\":\"IT\"}",
  "cbChargeItems": [
    { "Quantity": 1, "Description": "Consulting services", "Amount": 1220.00, "VATRate": 22, "ftChargeItemCase": 35184372088851 }
  ],
  "cbPayItems": [
    { "Description": "Bank transfer", "Amount": 1220.00, "ftPayItemCase": 35184372088842 }
  ],
  "ftReceiptCaseData": {
    "IT": {
      "einvoicing": {
        "numero": "2026/00001",
        "codiceDestinatario": "ABCDEFG"
      }
    }
  }
}
```

> **Try it:** [developer.fiskaltrust.eu → IT → sign → B2BInvoice](https://developer.fiskaltrust.eu/#/pos-system/IT?endpoint=sign&businesscase=SignRequestReceipt_B2BInvoice_1). The FatturaPA output is produced per the fiskaltrust.Middleware's configuration — see [Enable eInvoicing in the Portal](#enable-einvoicing-in-the-portal).

**Step 2 — Issue (`/issue`)** — transmits the FatturaPA to SDI

To transmit the FatturaPA generated in Step 1 to SDI, call `/issue` with the **original `/sign` request and its response** (`ReceiptRequest` + `ReceiptResponse`). The SDI recipient is part of the generated document: the `codiceDestinatario` (or `pec`) you sent in `ftReceiptCaseData` in Step 1. The response returns the `ftQueueID` / `ftQueueItemID` used by the delivery and status calls.

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

**Step 4 — Check clearance status**

Poll `GET /issue/{queueId}/{queueItemId}` for the status until it reports **cleared by SDI**. There is **no callback or webhook**.

See the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for the full `/issue` request/response schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [FatturaPA mapping](./fatturapa-mapping.md) — how a receipt maps to FatturaPA, and the validation rules a receipt must pass.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
