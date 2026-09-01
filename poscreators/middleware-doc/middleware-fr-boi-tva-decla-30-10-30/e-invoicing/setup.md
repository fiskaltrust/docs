---
slug: /poscreators/middleware-doc/france/e-invoicing/setup
title: "Setup & testing"
---

# Set up and test e-invoicing (France)

This page covers the prerequisites for e-invoicing in the French (FR) market, how to enable it in the fiskaltrust Portal, and how to validate the flow against a sandbox before production. For scope, regulatory status, and the delivery flow, see the [Overview](./overview.md).

:::note What setup means in France
E-invoicing rides on calls you already make. Setup is about **configuration** — the output format and the CashBox's French locale — plus one added `/issue` delivery step. There is **no new connection or credential**.
:::

## Prerequisites

| Requirement | Detail |
| --- | --- |
| fiskaltrust account + CashBox | An active account with a configured CashBox. See [Portal registration](../../../getting-started/portal-registration.md). |
| Existing fiscalization integration | Your POS already fiscalizes in France via `/sign`. |
| CashBox country configuration | The CashBox's country configuration is set to the **French locale**. |
| PosSystem API (v2) | E-invoicing features are exposed through the **PosSystem API (v2)**. If you are on the v0 interface, plan your [migration](../../possystem-api/migration-guide.md) first. |
| Merchant's Plateforme Agréée | Confirm the merchant **has, or is choosing, a Plateforme Agréée** — nothing else matters until this is settled. |
| Default output format | Decide the default: **UBL or CII** for platform routing, **Factur-X** as a bridge where needed. |

## Enable e-invoicing in the Portal

E-invoicing is enabled by **configuration**: the output format (UBL / CII / Factur-X) and the CashBox's French locale. No new integration is required on the POS side.

<!-- TODO (to verify before publish): document the actual Portal flow to enable e-invoicing for FR.
     Open questions to confirm with the Portal team / product:
       - Where the output format and French locale are set (CashBox config vs. product flag).
       - Whether e-invoicing is on by default once the CashBox locale is French.
       - The exact delivery-target parameter on /issue and PDP routing behaviour.
     Do not publish invented steps here. -->

:::caution Draft — Portal steps to be confirmed
The exact steps to enable e-invoicing in the fiskaltrust Portal (output-format configuration, French locale) are being verified and will be documented here. Do not treat this section as final until the flow has been confirmed.
:::

## Sandbox validation

Validate the end-to-end flow against a sandbox-scoped CashBox — using non-production `x-cashbox-id` and `x-cashbox-accesstoken` credentials — before enabling it on a production CashBox. **Run one document through the sandbox end to end before the first live document.**

1. Provision a **sandbox CashBox** in the fiskaltrust Portal — this yields the `x-cashbox-id` and `x-cashbox-accesstoken` used on every request. See [Portal registration](../../../getting-started/portal-registration.md).
2. Confirm your integration against the [Integration checklist](../../../getting-started/integration-checklist.md).
3. Run one invoice through the full flow below: `/sign` → `/issue` → poll for status → confirm the archive in `/journal`.

:::caution Draft — sandbox specifics to be confirmed
E-invoicing-specific sandbox provisioning (and any starter guide or sample keys) is being verified. Confirm the exact provisioning path and any e-invoicing sample collection before publishing.
:::

### End-to-end example

:::caution Illustrative — endpoint names pending final sign-off
The **flow below is confirmed**, but the exact delivery-target parameter on `/issue`, the France-specific case codes, and the PDP routing behaviour are pending final sign-off with product. Treat every value marked `TBC` as a placeholder — confirm before building against it.
:::

The API is request/response and **idempotent — there is no status webhook**. Each call returns its result synchronously in the response body; a retry reuses the same `x-operation-id` and returns the original result. Every request carries the standard headers (base URL comes from your sandbox provisioning; see the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for full schemas):

```
x-cashbox-id: <sandbox CashBox ID>
x-cashbox-accesstoken: <sandbox access token>
x-possystem-id: <registered POS system ID>
x-operation-id: <fresh UUID per operation>
```

**Step 1 — Sign (`/sign`)**

Call `/sign` as you do today, including the buyer's master data. The response now **also carries the EN 16931 document** (UBL, CII, or Factur-X, per your CashBox configuration).

```json
// POST {POS_SYSTEM_API}/sign
{
  "cbReceiptReference": "FR-EINV-SANDBOX-0001",
  "cbReceiptMoment": "2026-09-01T10:00:00.000Z",
  "ftReceiptCase": "<B2B e-invoice case — FR value TBC>",
  "cbCustomer": {
    "CustomerVATId": "FR12345678901",
    "CustomerName": "Exemple SARL",
    "CustomerStreet": "1 Rue de l'Exemple",
    "CustomerZip": "75001",
    "CustomerCity": "Paris",
    "CustomerCountry": "FR"
  },
  "cbChargeItems": [
    {
      "Quantity": 1,
      "Description": "Consulting services",
      "Amount": 1200.00,
      "VATRate": 20.0,
      "ftChargeItemCase": "<standard-rate case — FR value TBC>"
    }
  ],
  "cbPayItems": [
    {
      "Quantity": 1,
      "Description": "Bank transfer",
      "Amount": 1200.00,
      "ftPayItemCase": "<non-cash case — FR value TBC>"
    }
  ],
  "ftReceiptCaseData": {
    "FR": {
      "buyerSIRET": "<14-digit SIRET — TBC>"
    }
  }
}
```

The output format (UBL / CII / Factur-X) comes from the CashBox configuration, not this payload — see [Enable e-invoicing in the Portal](#enable-e-invoicing-in-the-portal).

**Step 2 — Issue for delivery (`/issue`)**

Call `/issue` with the network delivery target — the one new parameter. This routes the document to the merchant's Plateforme Agréée.

```json
// POST {POS_SYSTEM_API}/issue
{
  "cbReceiptReference": "FR-EINV-SANDBOX-0001",
  "ftReceiptCase": "<same B2B e-invoice case as Step 1>",
  "ftReceiptCaseData": {
    "FR": {
      "<delivery-target-field — TBC>": "<network transport to Plateforme Agréée>"
    }
  }
}
```

**Step 3 — Poll for status**

Call `/issue` status until it reports **delivered**. Replay with the same `x-operation-id` to re-check — the API returns the same result. There is **no callback or status webhook**.

**Step 4 — Archive**

No separate call. The e-invoice archive copy sits in `/journal` alongside your existing records.

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and the integration flow.
- [Delivery (`/issue` Endpoint)](../../experience-middleware/delivery.md) — the product-level e-invoicing and e-Delivery concept.
- [Migrating from API v0 to PosSystem API (v2)](../../possystem-api/migration-guide.md) — e-invoicing is a PosSystem API (v2) feature.
