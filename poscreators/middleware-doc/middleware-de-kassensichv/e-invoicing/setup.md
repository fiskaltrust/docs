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

*Table 1. Prerequisites for eInvoicing in Germany.*

## Invoice types

The invoice type is set by the **receipt case** of the `/sign` request. fiskaltrust does not derive it from `cbCustomer`: neither `CustomerType` nor the buyer's country nor the presence of a VAT ID changes the invoice type.

| Invoice type | `ftReceiptCase` (PosSystem API v2) | `cbCustomer` |
| --- | --- | --- |
| B2C invoice | `0x2000_0000_1001` | Optional. |
| B2B invoice | `0x2000_0000_1002` | Required, with a non-empty `CustomerName`. |
| B2G invoice | `0x2000_0000_1003` | Required, with a non-empty `CustomerName`. |

*Table 2. Invoice types and whether they require buyer data.*

The eInvoice XML is generated for the invoice receipt case, whatever the buyer's country. There is no separate case or flag for German, EU or non-EU buyers. For the full list of receipt cases, see [ftReceiptCase](../../possystem-api/migration-guide.md#ftreceiptcase).

:::caution Draft — B2G to be confirmed
The handling of B2G invoices (`0x2000_0000_1003`) in Germany, including how the buyer's Leitweg-ID is passed, is being verified and will be documented here.
:::

## Buyer data (`cbCustomer`)

The buyer of an eInvoice is sent in [`cbCustomer`](../../general/data-structures/data-structures.md#cbcustomer). Apart from `CustomerName` for B2B and B2G invoices, every field is optional. A field that is missing, `null` or an empty string is ignored, so on a B2C invoice you can send `cbCustomer` with only the fields you have.

| Field | Required | Used in the eInvoice | Format and notes |
| --- | --- | --- | --- |
| `CustomerName` | B2B and B2G | Yes — buyer name | Name or company name of the buyer. |
| `CustomerStreet` | No | Yes — buyer address | Street and house number. |
| `CustomerZip` | No | Yes — buyer address | Postal code. |
| `CustomerCity` | No | Yes — buyer address | City. |
| `CustomerCountry` | No | Yes — buyer address | **ISO 3166-1 alpha-2** code, for example `DE`, `AT`, `FR`. |
| `CustomerVATId` | No | Yes — buyer VAT identifier | VAT ID of the buyer, for example `DE123456789`. fiskaltrust does not validate it, for German, EU or non-EU buyers alike. |
| `CustomerId` | No | No | The buyer's customer number in your POS system. It is not an identity document number (ID card, passport). |
| `CustomerType` | No | No | Not evaluated for eInvoicing. The invoice type comes from the receipt case, see [Invoice types](#invoice-types). |

*Table 3. Fields of `cbCustomer` read for eInvoicing in Germany.*

Customer data is also exported to the DSFinV-K, see [Customer data `cbCustomer`](../data-structures/data-structures.md#customer-data-cbcustomer).

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

> **Try it:** [developer.fiskaltrust.eu → DE → issue](https://developer.fiskaltrust.eu/#/pos-system/DE?endpoint=issue).

**Step 3 — Deliver to a channel** — optional

Deliver the document with `PUT /issue/{queueId}/{queueItemId}`, choosing a delivery method: `IssueUpdateSend` (email/SMS), `IssueUpdatePrint`, `IssueUpdateDownload`, `IssueUpdateUpload`, or `IssueUpdateLink`. Peppol delivery uses one of the upload/send methods — confirm the exact one for Peppol with product.

**Step 4 — Check delivery status**

Poll `GET /issue/{queueId}/{queueItemId}` for the status until it reports **delivered**. There is **no callback or webhook**.

See the [POS System API reference](https://docs.fiskaltrust.eu/apis/pos-system-api) for the full `/issue` request/response schemas.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level eInvoicing and eDelivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — eInvoicing is a PosSystem API (v2) feature.
