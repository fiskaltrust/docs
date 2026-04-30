---
slug: /poscreators/middleware-doc/general/migration/v0-to-possystemapi
title: Migrating from v0 to PosSystem API (v2)
---

# Migrating from v0 to PosSystem API (v2)

:::info summary

After reading this guide, you will understand the differences between the legacy `ifPOS.v0` interface and the new PosSystem API (v2), and be able to migrate your integration to the v2 stack.

:::

## Why migrate?

The `ifPOS.v0` interface is the original, synchronous fiskaltrust.Middleware API used primarily in Austria (AT) and France (FR). While it remains functional, **it will not receive new features**. All current and future development — including e-invoicing support and upcoming compliance features — is available exclusively through the **PosSystem API (v2)**.

Migrating to v2 gives you:

- Access to e-invoicing features and all future compliance capabilities
- A modern, standard HTTP/REST API that works with any programming language or framework
- PIN-based pairing for simpler, more secure authentication setup
- Active support and ongoing development

## Prerequisites

Before starting the migration, ensure you have:

- Access to the **fiskaltrust.Portal** to reconfigure CashBoxes
- **Launcher 2.0** (minimum version `2.0.0-rc.25`) — the PosSystem API requires Launcher 2.0
- Familiarity with the [Local PosSystem API Helper setup guide](../../../../posdealers/technical-operations/middleware/helper-possystemapi.md)

:::caution Market availability

The PosSystem API via Launcher 2.0 has market-specific constraints:

- **Austria (AT):** Launcher 2.0 is not enabled by default. Contact fiskaltrust support to enable it for your account.
- **France (FR):** Launcher 2.0 is not yet supported. French customers should contact fiskaltrust for the current roadmap before planning a migration.

:::

## Architecture overview

The following table summarises the key architectural differences between the two integration approaches:

| Aspect                  | v0 (legacy)                                                       | v2 — PosSystem API                                               |
|-------------------------|-------------------------------------------------------------------|------------------------------------------------------------------|
| **Protocol**            | WCF (SOAP) or REST `/v0/`                                         | HTTP REST `/possystemapi/`                                       |
| **Communication style** | Synchronous (blocking)                                            | Modern REST (JSON)                                               |
| **Middleware component**| Queue package directly                                            | LocalPosSystemApi Helper in front of the Queue                   |
| **Launcher**            | Launcher 1.x                                                      | Launcher 2.0 (min. `2.0.0-rc.25`)                               |
| **Authentication**      | CashboxID + AccessToken (per request / in service binding)        | CashboxID + AccessToken in HTTP headers, PIN pairing via Portal  |
| **Client libraries**    | .NET `ifPOS.v0` NuGet package, WCF proxies, or REST HTTP calls    | Any HTTP client; official devkit available                       |
| **New feature support** | None — no new features planned                                    | All new features (e-invoicing, etc.)                             |

**v0 data flow:**

```
POS System → WCF or REST (/v0/) → fiskaltrust Queue
```

**v2 data flow:**

```
POS System → HTTP REST (/possystemapi/) → LocalPosSystemApi Helper → fiskaltrust Queue
```

## Cloud CashBox: base URL change

If your integration targets a **cloud CashBox** (i.e. your POS system calls the fiskaltrust cloud endpoint rather than a locally-running Middleware), the base URL changes as part of the migration:

| Environment | v0 base URL                                              | v2 base URL                                          |
|-------------|----------------------------------------------------------|------------------------------------------------------|
| Sandbox     | `https://signaturcloud-sandbox.fiskaltrust.fr` (FR)      | `https://possystem-api-sandbox.fiskaltrust.eu/v2`    |
| Sandbox     | `https://signaturcloud-sandbox.fiskaltrust.at` (AT)      | `https://possystem-api-sandbox.fiskaltrust.eu/v2`    |
| Sandbox     | `https://signaturcloud-sandbox.fiskaltrust.de` (DE)      | `https://possystem-api-sandbox.fiskaltrust.eu/v2`    |
| Production  | `https://signaturcloud.fiskaltrust.fr` (FR)              | `https://possystem-api.fiskaltrust.eu/v2`            |
| Production  | `https://signaturcloud.fiskaltrust.at` (AT)              | `https://possystem-api.fiskaltrust.eu/v2`            |
| Production  | `https://signaturcloud.fiskaltrust.de` (DE)              | `https://possystem-api.fiskaltrust.eu/v2`            |

Note that the v2 cloud endpoint is a **single, market-agnostic URL** — the market is determined by the `ftReceiptCase` value and your CashBox configuration, not the host.

The path structure changes accordingly:

| Operation | v0 path                                    | v2 path                  |
|-----------|--------------------------------------------|--------------------------|
| Sign      | `/[json|xml]/v0/sign`                       | `/api/v2/sign`           |
| Echo      | `/[json|xml]/v0/echo`                       | `/api/v2/echo`           |
| Journal   | `/[json|xml]/v0/journal`                    | `/api/v2/journal`        |

## Configuration steps

The portal-side configuration requires adding a **LocalPosSystemApi Helper** to your CashBox and rebuilding it with Launcher 2.0. Rather than duplicating those steps here, follow the [Local PosSystem API Helper guide](../../../../posdealers/technical-operations/middleware/helper-possystemapi.md), which covers:

1. Adding a `fiskaltrust.Middleware.Helper.LocalPosSystemApi` Helper in the Portal
2. Configuring the Helper URL
3. Assigning the Helper to the relevant CashBox
4. Rebuilding the CashBox configuration
5. Downloading and running Launcher 2.0

## API changes

### Method mapping

The three core operations map directly from v0 to v2, but the calling convention changes from a .NET WCF/REST client to standard HTTP POST requests:

| v0 call                                          | v2 HTTP endpoint                  | Notes                                                                 |
|--------------------------------------------------|-----------------------------------|-----------------------------------------------------------------------|
| `proxy.Echo("message")`                          | `POST /api/v2/echo`               | Request body: `{"message": "..."}` — response mirrors the same structure: `{"message": "..."}` |
| `proxy.Sign(receiptRequest)`                     | `POST /api/v2/sign`               | Request body is the JSON-serialised `ReceiptRequest`; response is `ReceiptResponse` |
| `proxy.Journal(ftJournalType, from, to)`         | `POST /api/v2/journal`            | Request body carries `ftJournalType`, `from`, and `to` as ISO 8601 date-time strings (see [Timestamps](#timestamps)) |

#### Authentication

All v2 requests must include the following HTTP headers:

```
cashboxid:   <your CashBox GUID>
accesstoken: <your Access Token>
```

Both values are available on the CashBox page in the fiskaltrust.Portal. On first use, you also need to **pair** the client via the PIN displayed in the Portal (see the [Helper setup guide](../../../../posdealers/technical-operations/middleware/helper-possystemapi.md#test-the-possystem-api-helper)).

#### Echo example

**Request:**

```json
POST /api/v2/echo
{
  "message": "test"
}
```

**Response:**

```json
{
  "message": "test"
}
```

### ReceiptRequest changes

The v2 `ReceiptRequest` is a superset of the v0 model. Most existing fields are directly reusable; the key differences are:

| Field                       | v0                                  | v2                                                    |
|-----------------------------|-------------------------------------|-------------------------------------------------------|
| `cbReceiptReference`        | Optional in some flows              | **Required** — must be a unique string per request    |
| `Currency`                  | Not present                         | Added — ISO 4217 currency code (default: `EUR`)       |
| `DecimalPrecisionMultiplier`| Not present                         | Added — controls integer vs. floating-point amounts (default: `1`, i.e. floating-point) |
| `ftPosSystemID`             | Optional                            | Recommended — identifies your POS software           |

All other fields (`ftCashBoxID`, `cbTerminalID`, `cbReceiptMoment`, `cbChargeItems`, `cbPayItems`, `ftReceiptCase`, etc.) carry over unchanged.

### Case value changes

The integer values used for `ftReceiptCase`, `ftChargeItemCase`, and `ftPayItemCase` differ between the v0 and v2 interfaces. **Updating these values is the most substantial part of the migration.** Each receipt and item type has a corresponding v2 value, and sending v0 values to the v2 endpoint will result in incorrect processing.

:::info Developer Portal

The authoritative source for v2 case values and their mapping to v0 cases is the **[fiskaltrust Developer Portal](https://developers.fiskaltrust.eu/#/pos-system)**. It provides market-specific business case examples (AT, FR, DE) with the correct v2 `ftReceiptCase`, `ftChargeItemCase`, and `ftPayItemCase` values for each scenario. Use these examples as your reference when updating your integration.

:::

A systematic approach to updating case values:

1. List every `ftReceiptCase`, `ftChargeItemCase`, and `ftPayItemCase` value currently used in your integration
2. For each value, find the corresponding business case in the Developer Portal for your market
3. Replace the v0 value with the v2 value shown in the portal example
4. Repeat for all receipt types (including special receipts such as Start-Receipt, Stop-Receipt, daily/shift closings, and Zero-Receipts)

### `ftReceiptCaseData` format change

The `ftReceiptCaseData` field changes from a **JSON-encoded string** in v0 to a **market-keyed JSON object** in v2.

**v0 format** — the entire value is a JSON string embedded as a string field:

```json
{
  "ftReceiptCase": "...",
  "ftReceiptCaseData": "{\"Code\":\"20\", \"Message\":\"Archivage fiscal de période\", \"Information\":\"\"}"
}
```

**v2 format** — the value is a plain JSON object with a market key (`"FR"`, `"AT"`, `"DE"`) whose value is a JSON-encoded string:

```json
{
  "ftReceiptCase": "...",
  "ftReceiptCaseData": {
    "FR": "{\"Code\": \"20\", \"Message\": \"Archivage fiscal de période\", \"Information\": \"\"}"
  }
}
```

Key points:
- The outer field is now a **JSON object**, not a string
- The inner value (per market key) remains a **JSON-encoded string** of the market-specific payload
- Use the two-letter ISO market code as the key (`"FR"`, `"AT"`, `"DE"`)
- If `ftReceiptCaseData` is not needed for a particular receipt type, the field can be omitted entirely

### ReceiptResponse changes

The `ReceiptResponse` structure is largely compatible. Verify that your receipt printing logic correctly handles:

- `ftSignatures` — format and type values are unchanged; ensure all entries are printed as required by national regulations
- `ftState` — error flag interpretation is unchanged; check your error-handling code still covers all states

### Timestamps

The v0 Journal call used **.NET Ticks** for the `from` and `to` parameters:

```
// v0 example
proxy.Journal(ftJournalType, 0, DateTime.UtcNow.Ticks);
```

The v2 Journal request uses **ISO 8601 UTC date-time strings** in the JSON body:

```json
{
  "ftJournalType": 8301034833876213761,
  "from": "2020-01-01T00:00:00Z",
  "to": "2024-12-31T23:59:59Z"
}
```

If you need to convert existing .NET Tick values, use the formulas from the [Function Structures reference](../function-structures/function-structures.md#timestamps).

## Testing the migration

The easiest way to validate your v2 integration is the **[fiskaltrust Developer Portal](https://developers.fiskaltrust.eu/)**, which provides an interactive interface for sending requests to a running Middleware instance.

For code samples and a full API reference, see the **[PosSystem API Development Kit](https://github.com/fiskaltrust/possystemapi-devkit)** on GitHub.

## Cutover considerations

:::caution No parallel operation

Running the v0 and v2 interfaces in parallel on the same CashBox is not recommended. Perform the migration as a **clean cutover** per CashBox: reconfigure the CashBox with the LocalPosSystemApi Helper, rebuild it, deploy the new Launcher 2.0 package, then switch your POS system to use the new v2 endpoint. Ensure any buffered or in-flight v0 receipts are processed and closed before switching.

:::

A recommended cutover sequence:

1. Complete all open transactions / close the current business day in the POS system
2. Reconfigure the CashBox in the Portal (add Helper, rebuild)
3. Deploy Launcher 2.0 to the POS terminal
4. Update the POS system to call the v2 endpoint
5. Send a test Echo request to confirm connectivity before going live
