---
slug: /poscreators/middleware-doc/general/migration/v0-to-possystemapi
title: Migrating from API v0 to PosSystem API (v2)
---

# Migrating from API v0 to PosSystem API (v2)

## Introduction

The legacy **v0 SignatureCloud API** (also referred to by its subdomain pattern `signaturcloud-sandbox.*`) and the original synchronous `ifPOS.v0` fiskaltrust.Middleware API — primarily used in Austria (AT) and France (FR) — remain functional but no longer receive new features. All current and future development, including e-invoicing support and upcoming compliance capabilities, is available exclusively through the **POSSystem API (v2)**, making migration strongly recommended.

Migrating to v2 gives you:

- **E-invoicing support** — Access to e-invoicing features and all future compliance capabilities.
- **Alignment with fiskaltrust Middleware v2** — the POSSystemAPI interface is designed to remain largely stable when the middleware transitions from v1.2 to v2, making this migration valuable preparation.
- **Long-term supportability** — v0 is considered deprecated; customers are encouraged to migrate as soon as possible.
- **Simpler authentication** — PIN-based pairing for simpler, more secure authentication setup.
- **Modern and flexible API design** — A modern, standard HTTP/REST API that works with any programming language or framework.

:::info

This guide is primarily targeted at PosCreators integrating **cloud cashboxes** in the **AT, FR, and DE** markets.

:::
 
## Prerequisites

Before starting the migration, ensure you have:

- An active **fiskaltrust account** (sandbox and/or production).
- Access to the **fiskaltrust.Portal** to reconfigure CashBoxes.
- An existing integration that successfully produces receipts against the v0 SignatureCloud API.
- Access to a **sandbox cashbox** for testing your migrated integration before going live.
- **Launcher 2.0** (minimum version `2.0.0-rc.25`) — the PosSystem API requires Launcher 2.0.

:::caution Market availability

The PosSystem API via Launcher 2.0 has market-specific constraints:

- **Austria (AT):** Launcher 2.0 is not enabled by default. Contact fiskaltrust support to enable it for your account.
- **France (FR):** Launcher 2.0 is not yet supported. French customers should contact fiskaltrust for the current roadmap before planning a migration.
- **Germany (DE):** TBD

:::

## Architecture Overview

The following table summarises the key architectural differences between the two integration approaches:

| Aspect                  | v0 (legacy)                                                       | v2 - PosSystem API                                               |
|-------------------------|-------------------------------------------------------------------|------------------------------------------------------------------|
| **Protocol**            | WCF (SOAP) or REST `/v0/`                                         | HTTP REST `/possystemapi/`                                       |
| **Communication style** | Synchronous (blocking)                                            | Modern REST (JSON)                                               |
| **Middleware component**| Queue package directly                                            | LocalPosSystemApi Helper in front of the Queue                   |
| **Launcher**            | Launcher 1.x                                                      | Launcher 2.0 (min. `2.0.0-rc.25`)                               |
| **Authentication**      | Cashbox ID + AccessToken (per request / in service binding)        | Cashbox ID + AccessToken in HTTP headers, PIN pairing via Portal  |
| **Client libraries**    | .NET `ifPOS.v0` NuGet package, WCF proxies, or REST HTTP calls    | Any HTTP client
| **New feature support** | None - no new features planned                                    | All new features (e-invoicing, etc.)                             |

- **v0 data flow:**

```
POS System → WCF or REST (/v0/) → fiskaltrust Queue
```

- **v2 data flow:**

```
POS System → HTTP REST (/possystemapi/) → LocalPosSystemApi Helper → fiskaltrust Queue
```

## Cloud CashBox (base URL change)

If your integration targets a **Cloud CashBox** (for example, your POS system calls the fiskaltrust cloud endpoint rather than a locally-running Middleware), the base URL changes as part of the migration:

| Environment | v0 base URL                                              | v2 base URL                                          |
|-------------|----------------------------------------------------------|------------------------------------------------------|
| Sandbox     | `https://signaturcloud-sandbox.fiskaltrust.fr` (FR)      | `https://possystem-api-sandbox.fiskaltrust.eu/v2`    |
| Sandbox     | `https://signaturcloud-sandbox.fiskaltrust.at` (AT)      | `https://possystem-api-sandbox.fiskaltrust.eu/v2`    |
| Sandbox     | `https://signaturcloud-sandbox.fiskaltrust.de` (DE)      | `https://possystem-api-sandbox.fiskaltrust.eu/v2`    |
| Production  | `https://signaturcloud.fiskaltrust.fr` (FR)              | `https://possystem-api.fiskaltrust.eu/v2`            |
| Production  | `https://signaturcloud.fiskaltrust.at` (AT)              | `https://possystem-api.fiskaltrust.eu/v2`            |
| Production  | `https://signaturcloud.fiskaltrust.de` (DE)              | `https://possystem-api.fiskaltrust.eu/v2`            |

:::info

The v2 cloud endpoint uses a single, market-agnostic base URL for all markets (AT, FR, DE), with the actual market determined by values such as the `ftCashBoxID`, `ftReceiptCase` and your **CashBox and queue configuration**, not by the URL or host.

:::

Replace all occurrences of the per-market v0 base URL in your integration with the single new URL above. Make sure to append `/v2` to the path.

The path structure changes accordingly:

| Operation | v0 path                                    | v2 path                  |
|-----------|--------------------------------------------|--------------------------|
| Sign      | `/[json|xml]/v0/sign`                       | `/api/v2/sign`           |
| Echo      | `/[json|xml]/v0/echo`                       | `/api/v2/echo`           |
| Journal   | `/[json|xml]/v0/journal`                    | `/api/v2/journal`        |

### Case Values

The integer values used for `ftReceiptCase`, `ftChargeItemCase`, and `ftPayItemCase` differ between the v0 and v2 interfaces. Updating these values is the most substantial part of the migration. You must remap all case values in your requests.

:::info Development Plataform

The authoritative source for v2 case values and their mapping to v0 cases is the **fiskaltrust** [Development Platform](https://developer.fiskaltrust.eu/). It provides market-specific business case examples (AT, FR, DE) with the correct v2 `ftReceiptCase`, `ftChargeItemCase`, and `ftPayItemCase` values for each scenario. Use these examples as your reference when updating your integration.

:::

A systematic approach to updating case values:

1. List every `ftReceiptCase`, `ftChargeItemCase`, and `ftPayItemCase` value currently used in your integration.
2. For each value, find the corresponding business case in the [Development Platform](https://developer.fiskaltrust.eu/) for your market.
3. Replace the v0 value with the v2 value shown in the platform example.
4. Repeat for all receipt types (including special receipts such as Start-Receipt, Stop-Receipt, daily/shift closings, and Zero-Receipts).

#### ftReceiptCase

<details>
<summary>Austria (AT)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Cash sales / POS receipt | `0x4154000000000001` | TODO |
| Zero receipt | `0x4154000000000002` | TODO |
| Initial operation / start receipt | `0x4154000000000003` | TODO |
| Out of operation / stop receipt | `0x4154000000000004` | TODO |
| Monthly closing | `0x4154000000000005` | TODO |
| Yearly closing | `0x4154000000000006` | TODO |

</details>

<details>
<summary>France (FR)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Cash sales / POS receipt | `0x4652000000000001` | TODO |
| Zero receipt | `0x465200000000000F` | TODO |
| Initial operation / start receipt | `0x4652000000000010` | TODO |
| Out of operation / stop receipt | `0x4652000000000011` | TODO |
| Daily closing | `0x4652000000000005` | TODO |
| Monthly closing | `0x4652000000000006` | TODO |
| Yearly closing | `0x4652000000000007` | TODO |
| Archives / fiscal period archive | `0x4652000000000015` | TODO |

</details>

<details>
<summary>Germany (DE)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Cash sales / POS receipt | `0x4445000100000001` | TODO |
| Zero receipt | `0x4445000000000002` | TODO |
| Initial operation / start receipt | `0x4445000000000003` | TODO |
| Out of operation / stop receipt | `0x4445000000000004` | TODO |
| Daily closing | `0x4445000000000007` | TODO |
| Start-transaction receipt | `0x4445000000000008` | TODO |
| Update-transaction receipt | `0x4445000000000009` | TODO |
| Fail-transaction receipt (single) | `0x444500000000000B` | TODO |
| Initiate SCU switch | `0x4445000000000017` | TODO |
| Finish SCU switch | `0x4445000000000018` | TODO |

</details>

#### ftChargeItemCase

<details>
<summary>Austria (AT)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Unknown type of service/product — normal rate | `0x4154000000000003` | TODO |
| Unknown type of service/product — discounted-1 | `0x4154000000000001` | TODO |
| Unknown type of service/product — discounted-2 | `0x4154000000000002` | TODO |

</details>

<details>
<summary>France (FR)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Unknown type of service/product — normal rate | `0x4652000000000003` | TODO |
| Unknown type of service/product — discounted-1 | `0x4652000000000001` | TODO |
| Unknown type of service/product — discounted-2 | `0x4652000000000002` | TODO |

</details>

<details>
<summary>Germany (DE)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Unknown type of service/product — normal rate | `0x4445000000000001` | TODO |
| Unknown type of service/product — discounted-1 | `0x4445000000000002` | TODO |

</details>

#### ftPayItemCase

<details>
<summary>Austria (AT)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Cash payment — national currency | `0x4154000000000001` | TODO |
| Cash payment — foreign currency | `0x4154000000000002` | TODO |
| Crossed cheque | `0x4154000000000003` | TODO |
| Debit card payment | `0x4154000000000004` | TODO |
| Credit card payment | `0x4154000000000005` | TODO |
| Online payment | `0x4154000000000007` | TODO |
| Customer card payment | `0x4154000000000008` | TODO |
| SEPA transfer | `0x415400000000000C` | TODO |
| Internal material consumption | `0x4154000000000011` | TODO |

</details>

<details>
<summary>France (FR)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Cash payment — national currency | `0x4652000000000001` | TODO |
| Cash payment — foreign currency | `0x4652000000000002` | TODO |
| Crossed cheque | `0x4652000000000003` | TODO |
| Debit card payment | `0x4652000000000004` | TODO |
| Credit card payment | `0x4652000000000005` | TODO |
| Online payment | `0x4652000000000007` | TODO |
| Customer card payment | `0x4652000000000008` | TODO |
| SEPA transfer | `0x465200000000000C` | TODO |
| Internal material consumption | `0x4652000000000011` | TODO |

</details>

<details>
<summary>Germany (DE)</summary>

| Business Case | v0 Value | POSSystemAPI v2 Value |
|---------------|----------|-----------------------|
| Cash payment — national currency | `0x4445000000000001` | TODO |
| Cash payment — foreign currency | `0x4445000000000002` | TODO |
| Crossed cheque | `0x4445000000000003` | TODO |
| Debit card payment | `0x4445000000000004` | TODO |
| Credit card payment | `0x4445000000000005` | TODO |
| Online payment | `0x4445000000000006` | TODO |
| Customer card payment | `0x4445000000000007` | TODO |
| SEPA transfer | `0x4445000000000008` | TODO |
| Internal material consumption | `0x444500000000000A` | TODO |

</details>

Key differences highlighted:
1. The base URL changes.
2. All case numeric values must be remapped.
3. `ftReceiptCaseData` is now an object keyed by market code instead of a raw string.

#### ftReceiptCaseData Format

The `ftReceiptCaseData` field changes from a **JSON-encoded string** in v0 to a **market-keyed JSON object** in v2.

- **v0 format**: the entire value is a JSON string embedded as a string field.

```json
{
  "ftReceiptCase": "...",
  "ftReceiptCaseData": "{\"Code\":\"20\", \"Message\":\"Archivage fiscal de période\", \"Information\":\"\"}"
}
```

- **v2 format**: the value is a plain JSON object with a market key (`"FR"`, `"AT"`, `"DE"`) whose value is a JSON-encoded string.

```json
{
  "ftReceiptCase": "...",
  "ftReceiptCaseData": {
    "FR": "{\"Code\": \"20\", \"Message\": \"Archivage fiscal de période\", \"Information\": \"\"}"
  }
}
```

Key points:
- The outer field is now a **JSON object**, not a string.
- The inner value (per market key) remains a **JSON-encoded string** of the market-specific payload.
- Use the two-letter ISO market code as the key (`"FR"`, `"AT"`, `"DE"`).

##### Examples by Market

**Austria (AT)**

```json
"ftReceiptCaseData": {
  "AT": "{\"Code\": \"20\", \"Message\": \"Jahresbeleg\", \"Information\": \"\"}"
}
```

**France (FR)**

```json
"ftReceiptCaseData": {
  "FR": "{\"Code\": \"20\", \"Message\": \"Archivage fiscal de période\", \"Information\": \"\"}"
}
```

**Germany (DE)**

```json
"ftReceiptCaseData": {
  "DE": "{\"Code\": \"20\", \"Message\": \"Jahresabschluss\", \"Information\": \"\"}"
}
```

**Multi-market (combined)**

```json
"ftReceiptCaseData": {
  "AT": "{\"Code\": \"20\", \"Message\": \"Jahresbeleg\", \"Information\": \"\"}",
  "FR": "{\"Code\": \"20\", \"Message\": \"Archivage fiscal de période\", \"Information\": \"\"}"
}
```

:::warning

If `ftReceiptCaseData` is not needed for a particular receipt, pass an empty object (`{}`) or omit the field entirely. Do not pass a bare empty string (`""`) as the top-level value — that was valid in v0 but is no longer accepted at the outer level in v2.

The inner string value for a given market key may be an empty string (`""`) when no additional case data is required for that market.

:::

#### ReceiptRequest

The v2 `ReceiptRequest` is a superset of the v0 model. Most existing fields are directly reusable. The key differences are:

| Field                       | v0                                  | v2                                                    |
|-----------------------------|-------------------------------------|-------------------------------------------------------|
| `cbReceiptReference`        | Optional in some flows              | **Required** — must be a unique string per request    |
| `Currency`                  | Not present                         | Added — ISO 4217 currency code (default: `EUR`)       |
| `DecimalPrecisionMultiplier`| Not present                         | Added — controls integer vs. floating-point amounts (default: `1`, i.e. floating-point) |
| `ftPosSystemID`             | Optional                            | Recommended — identifies your POS software           |

All other fields (`ftCashBoxID`, `cbTerminalID`, `cbReceiptMoment`, `cbChargeItems`, `cbPayItems`, `ftReceiptCase`, etc.) carry over unchanged.

#### ReceiptResponse

The `ReceiptResponse` structure is largely compatible. Verify that your receipt printing logic correctly handles:

- `ftSignatures` — format and type values are unchanged; ensure all entries are printed as required by national regulations.
- `ftState` — error flag interpretation is unchanged; check your error-handling code still covers all states.

#### Timestamps

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

## Local CashBox

:::note Sandbox/admin access only

Local cashbox migration requires additional configuration steps that are currently only supported in sandbox environments under guidance from the fiskaltrust team.

:::

The portal-side configuration requires adding a **LocalPosSystemApi Helper** to your CashBox and rebuilding it with Launcher 2.0. Rather than duplicating those steps here, follow the [How to Configure the Local PosSystem API Helper with Launcher 2.0](../../../../posdealers/technical-operations/middleware/helper-possystemapi.md) guide, which covers:

1. Adding a `fiskaltrust.Middleware.Helper.LocalPosSystemApi` Helper in the Portal.
2. Configuring the Helper URL.
3. Assigning the Helper to the relevant CashBox.
4. Rebuilding the CashBox configuration.
5. Downloading and running Launcher 2.0.

### API changes

#### Method mapping

The three core operations map directly from v0 to v2, but the calling convention changes from a .NET WCF/REST client to standard HTTP POST requests:

| v0 call                                          | v2 HTTP endpoint                  | Notes                                                                 |
|--------------------------------------------------|-----------------------------------|-----------------------------------------------------------------------|
| `proxy.Echo("message")`                          | `POST /api/v2/echo`               | Request body: `{"message": "..."}` — response mirrors the same structure: `{"message": "..."}` |
| `proxy.Sign(receiptRequest)`                     | `POST /api/v2/sign`               | Request body is the JSON-serialised `ReceiptRequest`; response is `ReceiptResponse` |
| `proxy.Journal(ftJournalType, from, to)`         | `POST /api/v2/journal`            | Request body carries `ftJournalType`, `from`, and `to` as ISO 8601 date-time strings (see [Timestamps](#timestamps)) |

##### Authentication

All v2 requests must include the following HTTP headers:

```
cashboxid:   <your CashBox GUID>
accesstoken: <your Access Token>
```

Both values are available on the CashBox page in the fiskaltrust.Portal. On first use, you also need to **pair** the client via the PIN displayed in the Portal. For more information, see how to [Test the PosSystem API Helper](../../../../posdealers/technical-operations/middleware/helper-possystemapi.md#test-the-possystem-api-helper).

##### Echo example

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
