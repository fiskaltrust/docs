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

:::caution Market availability for local setups

The PosSystem API via Launcher 2.0 has market-specific constraints:

- **Austria (AT):** Launcher 2.0 is not enabled by default. Contact fiskaltrust support to enable it for your account.
- **France (FR):** Launcher 2.0 is not yet supported. The workaround is setting 2 cashboxes, one with the queue and one with the POSSystemAPI helper without a queue. French customers should contact fiskaltrust for more instructions if needed.
- **Germany (DE):** TBD

:::

## Cloud CashBox (base URL change)

If your integration targets a **Cloud CashBox** (for example, your POS system calls the fiskaltrust cloud endpoint rather than a locally-running Middleware), the base URL changes as part of the migration:

| Environment | v0 base URL | v2 base URL |
| ----------- | ----------- | ----------- |
| Sandbox | `https://signaturcloud-sandbox.fiskaltrust.fr` (FR) | `https://possystem-api-sandbox.fiskaltrust.eu/v2`|
| Sandbox | `https://signaturcloud-sandbox.fiskaltrust.at` (AT) | `https://possystem-api-sandbox.fiskaltrust.eu/v2`|
| Sandbox | `https://signaturcloud-sandbox.fiskaltrust.de` (DE) | `https://possystem-api-sandbox.fiskaltrust.eu/v2`|
| Production | `https://signaturcloud.fiskaltrust.fr` (FR) | `https://possystem-api.fiskaltrust.eu/v2` |
| Production | `https://signaturcloud.fiskaltrust.at` (AT) | `https://possystem-api.fiskaltrust.eu/v2` |
| Production | `https://signaturcloud.fiskaltrust.de` (DE) | `https://possystem-api.fiskaltrust.eu/v2` |

:::info

The v2 cloud endpoint uses a single, market-agnostic base URL for all markets (AT, FR, DE), with the actual market determined by values such as the `ftCashBoxID`, `ftReceiptCase` and your **CashBox and queue configuration**, not by the URL or host.

:::

Replace all occurrences of the per-market v0 base URL in your integration with the single new URL above. Make sure to append `/v2` to the path.

The path structure changes accordingly:

- Sign - **v0 path:** `/[json|xml]/sign`; **v2 path:** `/sign`
- Echo - **v0 path:** `/[json|xml]/echo`; **v2 path:** `/echo`
- Journal - **v0 path:** `/[json|xml]/journal`; **v2 path:** `/journal`

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
5. If you don't find some values used in your integration in the table below, it seams that you just have to change the v0 with the v2 value.
6. **Important:** You'll see, in certain cases, for the same value in v0, you now need to specify a more precise value. For example, with invoices, there was only one code in v0, but now there are several possible values. Your POS system must therefore integrate whether the invoice is issued for B2C, B2B, B2G, etc.

#### ftReceiptCase

<details>
<summary>Austria (AT)</summary>

**Fixed Mappings**

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4154_2000_0000_0000` | `0x4154_0000_0000_0000` | Unknown receipt type, threated the same way as a point-of-sale receipt type |
| `0x4154_2000_0000_0001` | `0x4154_0000_0000_0001` | Point-of-sale receipt type |
| `0x4154_2000_0000_0003` | `0x4154_0000_0000_0007` | Point-of-sale receipt type without fiskalisation obligation or with exemption |
| `0x4154_2000_0000_0004` | `0x4154_0000_0000_000F` | E-commerce receipt type |
| `0x4154_2000_0000_0005` | `0x4154_0000_0000_0009` | Delivery note receipt type |
| `0x4154_2000_0000_1000` | `0x4154_0000_0000_0008` | Unknown invoice type |
| `0x4154_2000_0000_1001` | `0x4154_0000_0000_0008` | B2C invoice type |
| `0x4154_2000_0000_1002` | `0x4154_0000_0000_0008` | B2B invoice type |
| `0x4154_2000_0000_1003` | `0x4154_0000_0000_0008` | B2G invoice type |
| `0x4154_2000_0000_2000` | `0x4154_0000_0000_0002` | Zero receipt dailyoperation type |
| `0x4154_2000_0000_2001` | `0x4154_0000_0000_0002` | (reserved) dailyoperation type |
| `0x4154_2000_0000_2010` | `0x4154_0000_0000_0002` | Shift closing dailyoperation type |
| `0x4154_2000_0000_2011` | `0x4154_0000_0000_0002` | Daily closing dailyoperation type |
| `0x4154_2000_0000_2012` | `0x4154_0000_0000_0005` | Monthly closing dailyoperation type |
| `0x4154_2000_0000_2013` | `0x4154_0000_0000_0006` | Yearly closing dailyoperation type |
| `0x4154_2000_0000_3000` | `0x4154_0000_0000_000D` | Unknown/unspecified protocol type |
| `0x4154_2000_0000_3001` | `0x4154_0000_0000_000D` | Technical event protocol type |
| `0x4154_2000_0000_3002` | `0x4154_0000_0000_000D` | Audit event / accounting event protocol type |
| `0x4154_2000_0000_3003` | `0x4154_0000_0000_000E` | Internal usage / material consumption protocol type |
| `0x4154_2000_0000_3004` | `0x4154_0000_0000_000D` | Order protocol type |
| `0x4154_2000_0000_3005` | `0x4154_0000_0000_000D` | Pay protocol type |
| `0x4154_2000_0000_3010` | `0x4154_0000_0000_000D` | Copy receipt / re-print existing receipt protocol type => no implementation in v0 |
| `0x4154_2000_0000_3011` | `0x4154_0000_0000_000D` | Archive receipt / archive all previouse data protocol type => no implementation in v0 |
| `0x4154_2000_0000_4001` | `0x4154_0000_0000_0003` | Start-receipt lifecycle type |
| `0x4154_2000_0000_4002` | `0x4154_0000_0000_0004` | Stop-receipt lifecycle type |
| `0x4154_2000_0000_4011` | `0x4154_0000_0000_0002` | Start-scu-switch lifecycle type => no implementation in v0, using zeroreceipt |
| `0x4154_2000_0000_4012` | `0x4154_0000_0000_0002` | Stop-scu-switch lifecycle type => no implementation in v0, using zeroreceipt |
| `0x4154_2000_0000_4021` | `0x4154_0000_0000_0002` | Start-migration lifecycle type => no implementation in v0, using zeroreceipt |
| `0x4154_2000_0000_4022` | `0x4154_0000_0000_0002` | Stop-migration lifecycle type => no implementation in v0, using zeroreceipt |

**Dynamics Mappings**

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4154_2000_0000_0002` | `0x4154_0000_0000_000A` | Payment transfer receipt type ; conditional. ChargeItems == [] && cash(PayItems) > 0 , pay-in to drawer/till |
| `0x4154_2000_0000_0002` | `0x4154_0000_0000_000B` | Payment transfer receipt type ; conditional. ChargeItems == [] && cash(PayItems) < 0 , pay-out from drawer/till |
| `0x4154_2000_0000_0002` | `0x4154_0000_0000_000C` | Payment transfer receipt type |
| `0x4154_2ooo_o8oo_0000` | `0x4154_0000_0000_0010` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4154_2ooo_o8oo_0001` | `0x4154_0000_0000_0010` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4154_2ooo_o8oo_0002` | `0x4154_0000_0000_0010` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4154_2ooo_o8oo_0003` | `0x4154_0000_0000_0010` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4154_2oo0_oo1o_2ooo` | `0xoooo_oooo_oooo_oooo` | Request additional SCU information / RKSV signing certificate information (type2) |
| `0x4154_2oo0_oo2o_2ooo` | `0xoooo_oooo_oooo_oooo` | Request download of SCU journal / no implementation in v0 (type2) |
| `0x4154_2oo0_oo4o_2ooo` | `0xoooo_oooo_oooo_oooo` | Request bypoass of SCU SCU journal / no implementation in v0 (type2) |
| `0x4154_2oo0_oo8o_2ooo` | `0xoooo_oooo_oooo_oooo` | Request execute SCU self-test / no implementation in v0 (type2) |
| `0x4154_2oo0_o1oo_2ooo` | `0xoooo_oooo_oooo_oooo` | Request masterdata update / no implementation in v0 (type2) |
| `0x4154_2oo0_oo1o_4ooo` | `0xoooo_oooo_oooo_oooo` | Queue registration/de-registration only (no initial provision/no final de-provistion) of SCU / no implementation in v0 (type4) |
| `0x4154_2ooo_ooo1_oooo` | `0xoooo_oooo_ooo1_oooo` | v2 process late signing => v0 general failed receipt (type0,1) |
| `0x4154_2ooo_ooo2_oooo` | `0xoooo_oooo_ooo2_oooo` | v2 training mode => v0 general training receipt (type0,1,3) |
| `0x4154_2ooo_ooo4_oooo` | `0xoooo_oooo_ooo4_oooo` | v2 IsVoid => v0 general void receipt (type0,1) |
| `0x4154_2ooo_ooo8_oooo` | `0xoooo_oooo_ooo8_oooo` | v2 handwritten mode => v0 general handwritten receipt (type0,1) |
| `0x4154_2ooo_oo1o_oooo` | `0xoooo_oooo_oo1o_oooo` | v2 IssurIsSmallBusiness => v0 Germany small business, sales tax relief (type0,1) |
| `0x4154_2ooo_oo2o_oooo` | `0xoooo_oooo_oo2o_oooo` | v2 ReceiverIsBusiness => v0 Germany receiver is a company (type0,1) |
| `0x4154_2ooo_oo4o_oooo` | `0xoooo_oooo_oo4o_oooo` | v2 ReceiverIsKnown => v0 Germany receiver is known (type0,1) |
| `0x4154_2ooo_oo8o_oooo` | `0xoooo_oooo_oo8o_oooo` | v2 IsSaleInForeignCountry => v0 Germany no action required, handled as indirect translations (type0,1) |
| `0x4154_2ooo_o1oo_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsReturn/IsRefund => v0 no action required, <br/>optional verify cbPreviouseReceiptReference set; <br/>optional verify ChargeItem(Amount) == (-1)xcbPreviouseReceiptReference(ChargeItem(Amount)); <br/>optional verify ChargeItem(Quantity) == (-1)xcbPreviouseReceiptReference(ChargeItem(Quantity));  (type0,1) |
| `0x4154_2ooo_o8oo_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Group by Position-Number => v0 not supported |
| `0x4154_2ooo_8ooo_oooo` | `0xoooo_8ooo_oooo_oooo` | v2 ReceiptRequest => v0 general receipt request |

</details>

<details>
<summary>France (FR)</summary>

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4652_2000_0000_0000` | `0x4652_0000_0000_0000` | Unknown receipt type, threated the same way as a point-of-sale receipt type |
| `0x4652_2ooo_o8oo_0000` | `0x4652_0000_0000_000E` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4652_2ooo_o8oo_0001` | `0x4652_0000_0000_000E` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4652_2ooo_o8oo_0002` | `0x4652_0000_0000_000E` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4652_2ooo_o8oo_0003` | `0x4652_0000_0000_000E` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4652_2000_0000_0001` | `0x4652_0000_0000_0001` | Point-of-sale receipt type |
| `0x4652_2000_0000_0002` | `0x4652_0000_0000_000A` | Payment transfer receipt type ; conditional. ChargeItems == [] && cash(PayItems) > 0 , pay-in to drawer/till |
| `0x4652_2000_0000_0002` | `0x4652_0000_0000_000B` | Payment transfer receipt type ; conditional. ChargeItems == [] && cash(PayItems) < 0 , pay-out from drawer/till |
| `0x4652_2000_0000_0002` | `0x4652_0000_0000_000C` | Payment transfer receipt type |
| `0x4652_2000_0000_0003` | `0x4652_0000_0000_000E` | Point-of-sale receipt type without fiskalisation obligation or with exemption => v0 France handles it in Foreign sales and chaines it into Bill |
| `0x4652_2000_0000_0004` | `0x4652_0000_0000_000E` | E-commerce receipt type => v0 France handles it in Foreign sales and chaines it into Bill |
| `0x4652_2000_0000_0005` | `0x4652_0000_0000_0009` | Delivery note receipt type |
| `0x4652_2000_0000_0006` | `0x4652_0000_0000_0008` | Bill receipt type |
| `0x4652_2000_0000_0007` | `0x4652_0000_0000_0008` | Proforma invoice receipt type |
| `0x4652_2000_0000_1000` | `0x4652_0000_0000_0003` | Unknown invoice type |
| `0x4652_2000_0000_1001` | `0x4652_0000_0000_0003` | B2C invoice type |
| `0x4652_2000_0000_1002` | `0x4652_0000_0000_0003` | B2B invoice type |
| `0x4652_2000_0000_1003` | `0x4652_0000_0000_0003` | B2G invoice type |
| `0x4652_2000_0000_2000` | `0x4652_0000_0000_000F` | Zero receipt dailyoperation type |
| `0x4652_2000_0000_2001` | `0x4652_0000_0000_000F` | (reserved) dailyoperation type |
| `0x4652_2000_0000_2010` | `0x4652_0000_0000_0004` | Shift closing dailyoperation type |
| `0x4652_2000_0000_2011` | `0x4652_0000_0000_0005` | Daily closing dailyoperation type |
| `0x4652_2000_0000_2012` | `0x4652_0000_0000_0006` | Monthly closing dailyoperation type |
| `0x4652_2000_0000_2013` | `0x4652_0000_0000_0007` | Yearly closing dailyoperation type |
| `0x4652_2000_0000_3000` | `0x4652_0000_0000_0014` | Unknown/unspecified protocol type |
| `0x4652_2000_0000_3001` | `0x4652_0000_0000_0012` | Technical event protocol type |
| `0x4652_2000_0000_3002` | `0x4652_0000_0000_0013` | Audit event / accounting event protocol type |
| `0x4652_2000_0000_3003` | `0x4652_0000_0000_000D` | Internal usage / material consumption protocol type |
| `0x4652_2000_0000_3004` | `0x4652_0000_0000_0008` | Order protocol type |
| `0x4652_2000_0000_3005` | `0x4652_0000_0000_0002` | Pay protocol type => v0 france payment prove |
| `0x4652_2000_0000_3010` | `0x4652_0000_0000_0016` | Copy receipt / re-print existing receipt protocol type |
| `0x4652_2000_0000_3011` | `0x4652_0000_0000_0015` | Archive receipt / archive all previouse data protocol type |
| `0x4652_2000_0000_4001` | `0x4652_0000_0000_0010` | Start-receipt lifecycle type |
| `0x4652_2000_0000_4002` | `0x4652_0000_0000_0011` | Stop-receipt lifecycle type |
| `0x4652_2000_0000_4011` | `0x4652_0000_0000_000F` | Start-scu-switch lifecycle type => no implementation in v0, using zeroreceipt |
| `0x4652_2000_0000_4012` | `0x4652_0000_0000_000F` | Stop-scu-switch lifecycle type => no implementation in v0, using zeroreceipt |
| `0x4652_2000_0000_4021` | `0x4652_0000_0000_000F` | Start-migration lifecycle type => no implementation in v0, using zeroreceipt |
| `0x4652_2000_0000_4022` | `0x4652_0000_0000_000F` | Stop-migration lifecycle type => no implementation in v0, using zeroreceipt |
| `0x4652_2oo0_oo1o_2ooo` | `0xoooo_oooo_oooo_oooo` | Request additional SCU information / signing certificate information (type2) |
| `0x4652_2oo0_oo2o_2ooo` | `0xoooo_oooo_oooo_oooo` | Request download of SCU journal / no implementation in v0 (type2) |
| `0x4652_2oo0_oo4o_2ooo` | `0xoooo_oooo_oooo_oooo` | Request bypoass of SCU SCU journal / no implementation in v0 (type2) |
| `0x4652_2oo0_oo8o_2ooo` | `0xoooo_oooo_oooo_oooo` | Request execute SCU self-test / no implementation in v0 (type2) |
| `0x4652_2oo0_o1oo_2ooo` | `0xoooo_oooo_oooo_oooo` | Request masterdata update / no implementation in v0 (type2) |
| `0x4652_2oo0_oo1o_4ooo` | `0xoooo_oooo_oooo_oooo` | Client registration/de-registration only (no initial provision/no final de-provistion) of SCU / no implementation in v0 (type4) |
| `0x4652_2ooo_ooo1_oooo` | `0xoooo_oooo_ooo1_oooo` | v2 process late signing => v0 general failed receipt (type0,1) |
| `0x4652_2ooo_ooo2_oooo` | `0xoooo_oooo_ooo2_oooo` | v2 training mode => v0 general training receipt (type0,1,3) |
| `0x4652_2ooo_ooo4_oooo` | `0xoooo_oooo_ooo4_oooo` | v2 IsVoid => v0 general void receipt (type0,1) |
| `0x4652_2ooo_ooo8_oooo` | `0xoooo_oooo_oooo_oooo` | v2 handwritten mode => v0 general handwritten receipt, no implementation in v0 (type0,1) |
| `0x4652_2ooo_oo1o_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IssurIsSmallBusiness => v0 general small business, sales tax relief, no implementation in v0 France (type0,1) |
| `0x4652_2ooo_oo2o_oooo` | `0xoooo_oooo_oooo_oooo` | v2 ReceiverIsBusiness => v0 general receiver is a company, no implementation in v0 France (type0,1) |
| `0x4652_2ooo_oo4o_oooo` | `0xoooo_oooo_oooo_oooo` | v2 ReceiverIsKnown => v0 general receiver is known, no implementation in v0 France (type0,1) |
| `0x4652_2ooo_oo8o_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsSaleInForeignCountry => v0 general no action required, handled as indirect translations (type0,1) |
| `0x4652_2ooo_o1oo_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsReturn/IsRefund => v0 no action required, <br/>optional verify cbPreviouseReceiptReference set; <br/>optional verify ChargeItem(Amount) == (-1)xcbPreviouseReceiptReference(ChargeItem(Amount)); <br/>optional verify ChargeItem(Quantity) == (-1)xcbPreviouseReceiptReference(ChargeItem(Quantity)); (type0,1), no implementation in v0 |
| `0x4652_2ooo_o8oo_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Group by Position-Number => v0 not supported |
| `0x4652_2ooo_8ooo_oooo` | `0xoooo_8ooo_oooo_oooo` | v2 ReceiptRequest => v0 general receipt request |

</details>

<details>
<summary>Germany (DE)</summary>

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4445_2000_0000_0000` | `0x4445_0000_0000_0000` | Unknown receipt type, threated the same way as a point-of-sale receipt type |
| `0x4445_2ooo_o8oo_0000` | `0x4445_0000_0000_0015` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4445_2ooo_o8oo_0001` | `0x4445_0000_0000_0015` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4445_2ooo_o8oo_0002` | `0x4445_0000_0000_0015` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4445_2ooo_o8oo_0003` | `0x4445_0000_0000_0015` | IsSaleInForeignCountry flag recognized in any point-of-sale receipt type, v0 makes no difference between unknown, pos, pos with exemption |
| `0x4445_2ooo_o1oo_0003` | `0x4445_0000_0000_0016` | German "AVBelegstorno/Kassenbeleg-V1" which should not be used with TSE (technical saftey device), pos with exemption |
| `0x4445_2000_0000_0001` | `0x4445_0000_0000_0001` | Point-of-sale receipt type |
| `0x4445_2000_0000_0002` | `0x4445_0000_0000_0011` | Payment transfer receipt type |
| `0x4445_2000_0000_0003` | `0x4445_0000_0000_0015` | Point-of-sale receipt type without fiskalisation obligation or with exemption => v0 Germany handles it in Foreign sales |
| `0x4445_2000_0000_0004` | `0x4445_0000_0000_0015` | E-commerce receipt type => v0 Germany handles it in Foreign sales |
| `0x4445_2000_0000_0005` | `0x4445_0000_0000_000F` | Delivery note receipt type |
| `0x4445_2000_0000_1000` | `0x4445_0000_0000_000E` | Unknown invoice type |
| `0x4445_2000_0000_1001` | `0x4445_0000_0000_000D` | B2C invoice type |
| `0x4445_2000_0000_1002` | `0x4445_0000_0000_000C` | B2B invoice type |
| `0x4445_2000_0000_1003` | `0x4445_0000_0000_000E` | B2G invoice type |
| `0x4445_2000_0000_2000` | `0x4445_0001_0000_0002` | Zero receipt dailyoperation type |
| `0x4445_2000_0000_2001` | `0x4445_0001_0000_0002` | (reserved) dailyoperation type |
| `0x4445_2000_0000_2010` | `0x4445_0001_0000_0002` | Shift closing dailyoperation type |
| `0x4445_2000_0000_2011` | `0x4445_0001_0000_0007` | Daily closing dailyoperation type |
| `0x4445_2000_0000_2012` | `0x4445_0001_0000_0005` | Monthly closing dailyoperation type |
| `0x4445_2000_0000_2013` | `0x4445_0001_0000_0006` | Yearly closing dailyoperation type |
| `0x4445_2000_0000_3000` | `0x4445_0000_0000_0013` | Unknown/unspecified protocol type => v0 German "AVSonstige/Kassenbeleg-V1" requires ChargeItems != [] && PayItems != [] |
| `0x4445_2000_0000_3000` | `0x4445_0000_0000_0013` | Unknown/unspecified protocol type => v0 German "SonstigerVorgang" requires ChargeItems == [] |
| `0x4445_2000_0000_3001` | `0x4445_0000_0000_0014` | Technical event protocol type |
| `0x4445_2011_0000_3001` | `0x4445_0000_0000_0008` | German "Start-Transaction" |
| `0x4445_2021_0000_3001` | `0x4445_0000_0000_0009` | German "Update-Transaction" |
| `0x4445_2031_0000_3001` | `0x4445_0000_0000_000A` | German "Delta-Transaction" |
| `0x4445_2041_0000_3001` | `0x4445_0000_0000_000B` | German "Fail-Transaction" to close single open transaction |
| `0x4445_2040_0000_3001` | `0x4445_0001_0000_000B` | German "Fail-Transaction" to close multiple open transactions |
| `0x4445_2000_0000_3002` | `0x4445_0000_0000_0014` | Audit event / accounting event protocol type |
| `0x4445_2000_0000_3003` | `0x4445_0000_0000_0012` | Internal usage / material consumption protocol type |
| `0x4445_2000_0000_3004` | `0x4445_0000_0000_0010` | Order protocol type => v0 German "Bestellung-V1" requires ChargeItems != [] && PayItems == [] |
| `0x4445_2000_0000_3004` | `0x4445_0000_0000_0010` | Order protocol type => v0 German "AVBestellung/Kassenbeleg-V1" requires PayItems != [] |
| `0x4445_2000_0000_3005` | `0x4445_0000_0000_0010` | Pay protocol type => v0 German "AVBestellung/Kassenbeleg-V1" requires PayItems != [] |
| `0x4445_2000_0000_3010` | `0x4445_0000_0000_0014` | Copy receipt / re-print existing receipt protocol type |
| `0x4445_2000_0000_3011` | `0x4445_0000_0000_0014` | Archive receipt / archive all previouse data protocol type |
| `0x4445_2000_0000_4001` | `0x4445_0001_0000_0003` | Start-receipt lifecycle type |
| `0x4445_2000_0000_4002` | `0x4445_0001_0000_0004` | Stop-receipt lifecycle type |
| `0x4445_2000_0000_4011` | `0x4445_0001_0000_0010` | Start-scu-switch lifecycle type |
| `0x4445_2000_0000_4012` | `0x4445_0001_0000_0011` | Stop-scu-switch lifecycle type |
| `0x4445_2000_0000_4021` | `0x4445_0001_0000_0010` | Start-migration lifecycle type |
| `0x4445_2000_0000_4022` | `0x4445_0001_0000_0011` | Stop-migration lifecycle type |
| `0x4445_2oo0_oo1o_2ooo` | `0xoooo_ooo1_oo8o_oooo` | Request additional SCU information / TSE (type2) |
| `0x4445_2oo0_oo2o_2ooo` | `0xoooo_ooo1_o2oo_oooo` | Request download of SCU journal / force TSE-TAR file download (type2) |
| `0x4445_2oo0_oo4o_2ooo` | `0xoooo_ooo1_o4oo_oooo` | Request bypoass of SCU SCU journal / bypass TSE-TAR file download (type2) |
| `0x4445_2oo0_oo8o_2ooo` | `0xoooo_ooo1_o1oo_oooo` | Request execute SCU self-test / execute TSE self-test (type2) |
| `0x4445_2oo0_o1oo_2ooo` | `0xoooo_ooo1_o8oo_oooo` | Request masterdata update (type2) |
| `0x4445_2oo0_oo1o_4ooo` | `0xoooo_ooo1_o1oo_oooo` | Client registration/de-registration only (no initial provision/no final de-provistion) of SCU / ClientId registration/de-registration only for TSE (type4) |
| `0x4445_2oo0_oooo_0ooo` | `0xoooo_ooo1_oooo_oooo` | Implicit flow for receipt type |
| `0x4445_2oo0_oooo_1ooo` | `0xoooo_ooo1_oooo_oooo` | Implicit flow for invoice type |
| `0x4445_2oo0_oooo_3ooo` | `0xoooo_ooo1_oooo_oooo` | Implicit flow for log type |
| `0x4445_2ooo_oooo_0ooo` | `0xoooo_ooo0_oooo_oooo` | Explicit flow for receipt type , no effect , information only |
| `0x4445_2ooo_oooo_1ooo` | `0xoooo_ooo0_oooo_oooo` | Explicit flow for invoice type , no effect , information only |
| `0x4445_2ooo_oooo_3ooo` | `0xoooo_ooo0_oooo_oooo` | Explicit flow for log type , no effect , information only |
| `0x4445_2ooo_ooo1_oooo` | `0xoooo_oooo_ooo1_oooo` | v2 process late signing => v0 general failed receipt (type0,1) |
| `0x4445_2ooo_ooo2_oooo` | `0xoooo_oooo_ooo2_oooo` | v2 training mode => v0 general training receipt (type0,1,3) |
| `0x4445_2ooo_ooo4_oooo` | `0xoooo_oooo_ooo4_oooo` | v2 IsVoid => v0 general void receipt (type0,1) |
| `0x4445_2ooo_ooo8_oooo` | `0xoooo_oooo_ooo8_oooo` | v2 handwritten mode => v0 general handwritten receipt (type0,1) |
| `0x4445_2ooo_oo1o_oooo` | `0xoooo_oooo_oo1o_oooo` | v2 IssurIsSmallBusiness => v0 Germany small business, sales tax relief (type0,1) |
| `0x4445_2ooo_oo2o_oooo` | `0xoooo_oooo_oo2o_oooo` | v2 ReceiverIsBusiness => v0 Germany receiver is a company (type0,1) |
| `0x4445_2ooo_oo4o_oooo` | `0xoooo_oooo_oo4o_oooo` | v2 ReceiverIsKnown => v0 Germany receiver is known (type0,1) |
| `0x4445_2ooo_oo8o_oooo` | `0xoooo_oooo_oo8o_oooo` | v2 IsSaleInForeignCountry => v0 Germany no action required, handled as indirect translations (type0,1) |
| `0x4445_2ooo_o1oo_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsReturn/IsRefund => v0 no action required, <br/>optional verify cbPreviouseReceiptReference set; <br/>optional verify ChargeItem(Amount) == (-1)xcbPreviouseReceiptReference(ChargeItem(Amount)); <br/>optional verify ChargeItem(Quantity) == (-1)xcbPreviouseReceiptReference(ChargeItem(Quantity)); (type0,1) |
| `0x4445_2ooo_o8oo_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Group by Position-Number => v0 not supported |
| `0x4445_2ooo_8ooo_oooo` | `0xoooo_8ooo_oooo_oooo` | v2 ReceiptRequest => v0 general receipt request |

</details>

#### ftChargeItemCase

<details>
<summary>Austria (AT)</summary>

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4154_2000_0000_0000` | `0x4154_0000_0000_0000` | Unknown chargeitem type, unknown type of service, unknown type of vat, future logic may detect vat-type from vat-rate |
| `0x4154_2000_oooo_oo01` | `0x4154_0000_0000_0001` | Unknown type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo02` | `0x4154_0000_0000_0002` | Unknown type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo03` | `0x4154_0000_0000_0003` | Unknown type of service, normal type of vat |
| `0x4154_2000_oooo_oo04` | `0x4154_0000_0000_0004` | Unknown type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo05` | `0x4154_0000_0000_0005` | Unknown type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_oo06` | `0x4154_0000_0000_0005` | Unknown type of service, parking type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_oo07` | `0x4154_0000_0000_0005` | Unknown type of service, zero type of vat |
| `0x4154_2000_oooo_oo08` | `0x4154_0000_0000_0005` | Unknown type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_5oo8` | `0x4154_0000_0000_0006` | Not taxable type of vat, reverse charge => v0 specific implementation |
| `0x4154_2000_oooo_oo11` | `0x4154_0000_0000_0008` | Supply of goods type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo12` | `0x4154_0000_0000_0009` | Supply of goods type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo13` | `0x4154_0000_0000_000A` | Supply of goods type of service, normal type of vat |
| `0x4154_2000_oooo_oo14` | `0x4154_0000_0000_000B` | Supply of goods type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo15` | `0x4154_0000_0000_000C` | Supply of goods type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_oo16` | `0x4154_0000_0000_000C` | Supply of goods type of service, parking type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_oo17` | `0x4154_0000_0000_000C` | Supply of goods type of service, zero type of vat |
| `0x4154_2000_oooo_oo18` | `0x4154_0000_0000_000C` | Supply of goods type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_oo21` | `0x4154_0000_0000_000D` | Supply of service type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo22` | `0x4154_0000_0000_000E` | Supply of service type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo23` | `0x4154_0000_0000_000F` | Supply of service type of service, normal type of vat |
| `0x4154_2000_oooo_oo24` | `0x4154_0000_0000_0010` | Supply of service type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo25` | `0x4154_0000_0000_0011` | Supply of service type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_oo26` | `0x4154_0000_0000_0011` | Supply of service type of service, parking type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_oo27` | `0x4154_0000_0000_0011` | Supply of service type of service, zero type of vat |
| `0x4154_2000_oooo_oo28` | `0x4154_0000_0000_0011` | Supply of service type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4154_2000_oooo_oo31` | `0x4154_0000_0000_0001` | Tip to owner type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo32` | `0x4154_0000_0000_0002` | Tip to owner type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo33` | `0x4154_0000_0000_0003` | Tip to owner type of service, normal type of vat |
| `0x4154_2000_oooo_oo34` | `0x4154_0000_0000_0004` | Tip to owner type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo35` | `0x4154_0000_0000_0005` | Tip to owner type of service, superreduced2 type of vat |
| `0x4154_2000_oooo_oo36` | `0x4154_0000_0000_0005` | Tip to owner type of service, parking type of vat |
| `0x4154_2000_oooo_oo37` | `0x4154_0000_0000_0005` | Tip to owner type of service, zero type of vat |
| `0x4154_2000_oooo_oo38` | `0x4154_0000_0000_0005` | Tip to employee type of service, not taxable type of vat |
| `0x4154_2000_oooo_oo41` | `0x4154_0000_0000_0001` | Single-use voucher type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo42` | `0x4154_0000_0000_0002` | Single-use voucher type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo43` | `0x4154_0000_0000_0003` | Single-use voucher type of service, normal type of vat |
| `0x4154_2000_oooo_oo44` | `0x4154_0000_0000_0004` | Single-use voucher type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo45` | `0x4154_0000_0000_0005` | Single-use voucher type of service, superreduced2 type of vat |
| `0x4154_2000_oooo_oo46` | `0x4154_0000_0000_0005` | Single-use voucher type of service, parking type of vat |
| `0x4154_2000_oooo_oo47` | `0x4154_0000_0000_0005` | Single-use voucher type of service, zero type of vat |
| `0x4154_2000_oooo_oo48` | `0x4154_0000_0000_0021` | Multi-use voucher type of service, not taxable type of vat |
| `0x4154_2000_oooo_oo51` | `0x4154_0000_0000_0012` | Catalog service type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo52` | `0x4154_0000_0000_0013` | Catalog service type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo53` | `0x4154_0000_0000_0014` | Catalog service type of service, normal type of vat |
| `0x4154_2000_oooo_oo54` | `0x4154_0000_0000_0015` | Catalog service type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo55` | `0x4154_0000_0000_0016` | Catalog service type of service, superreduced2 type of vat |
| `0x4154_2000_oooo_oo56` | `0x4154_0000_0000_0016` | Catalog service type of service, parking type of vat |
| `0x4154_2000_oooo_oo57` | `0x4154_0000_0000_0016` | Catalog service type of service, zero type of vat |
| `0x4154_2000_oooo_oo58` | `0x4154_0000_0000_0016` | Catalog service type of service, not taxable type of vat |
| `0x4154_2000_oooo_oo61` | `0x4154_0000_0000_0007` | Agency business type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo62` | `0x4154_0000_0000_0007` | Agency business type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo63` | `0x4154_0000_0000_0007` | Agency business type of service, normal type of vat |
| `0x4154_2000_oooo_oo64` | `0x4154_0000_0000_0007` | Agency business type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo65` | `0x4154_0000_0000_0007` | Agency business type of service, superreduced2 type of vat |
| `0x4154_2000_oooo_oo66` | `0x4154_0000_0000_0007` | Agency business type of service, parking type of vat |
| `0x4154_2000_oooo_oo67` | `0x4154_0000_0000_0007` | Agency business type of service, zero type of vat |
| `0x4154_2000_oooo_oo68` | `0x4154_0000_0000_0021` | Receiveable of thired party type of service, not taxable type of vat |
| `0x4154_2000_oooo_oo71` | `0x4154_0000_0000_0017` | Own consumption type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo72` | `0x4154_0000_0000_0018` | Own consumption type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo73` | `0x4154_0000_0000_0019` | Own consumption type of service, normal type of vat |
| `0x4154_2000_oooo_oo74` | `0x4154_0000_0000_001A` | Own consumption type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo75` | `0x4154_0000_0000_001B` | Own consumption type of service, superreduced2 type of vat |
| `0x4154_2000_oooo_oo76` | `0x4154_0000_0000_001B` | Own consumption type of service, parking type of vat |
| `0x4154_2000_oooo_oo77` | `0x4154_0000_0000_001B` | Own consumption type of service, zero type of vat |
| `0x4154_2000_oooo_oo78` | `0x4154_0000_0000_001B` | Own consumption type of service, not taxable type of vat |
| `0x4154_2000_oooo_oo81` | `0x4154_0000_0000_0001` | Grant (unreal) type of service, discounted1 type of vat |
| `0x4154_2000_oooo_oo82` | `0x4154_0000_0000_0002` | Grant (unreal) type of service, discounted2 type of vat |
| `0x4154_2000_oooo_oo83` | `0x4154_0000_0000_0003` | Grant (unreal) type of service, normal type of vat |
| `0x4154_2000_oooo_oo84` | `0x4154_0000_0000_0004` | Grant (unreal) type of service, superreduced1 type of vat |
| `0x4154_2000_oooo_oo85` | `0x4154_0000_0000_0005` | Grant (unreal) type of service, superreduced2 type of vat |
| `0x4154_2000_oooo_oo86` | `0x4154_0000_0000_0005` | Grant (unreal) type of service, parking type of vat |
| `0x4154_2000_oooo_oo87` | `0x4154_0000_0000_0005` | Grant (unreal) type of service, zero type of vat |
| `0x4154_2000_oooo_oo88` | `0x4154_0000_0000_0005` | Grant (real) type of service, not taxable type of vat |
| `0x4154_2000_oooo_oo98` | `0x4154_0000_0000_0022` | Receiveable type of service, not taxable type of vat |
| `0x4154_2000_oooo_ooA8` | `0x4154_0000_0000_0023` | Cash transfer type of service, not taxable type of vat |
| `0x4154_2000_ooo8_oo00` | `0x4154_0000_0000_0020` | Downpayment, unknown type of service, unknown type of vat |
| `0x4154_2000_ooo8_oo01` | `0x4154_0000_0000_001C` | Downpayment, unknown type of service, discounted1 type of vat |
| `0x4154_2000_ooo8_oo02` | `0x4154_0000_0000_001D` | Downpayment, unknown type of service, discounted2 type of vat |
| `0x4154_2000_ooo8_oo03` | `0x4154_0000_0000_001E` | Downpayment, unknown type of service, normal type of vat |
| `0x4154_2000_ooo8_oo04` | `0x4154_0000_0000_001F` | Downpayment, unknown type of service, superreduced1 type of vat |
| `0x4154_2000_ooo8_oo05` | `0x4154_0000_0000_0020` | Downpayment, unknown type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4154_2000_ooo8_oo06` | `0x4154_0000_0000_0020` | Downpayment, unknown type of service, parking type of vat => not defined in v0, goto zero |
| `0x4154_2000_ooo8_oo07` | `0x4154_0000_0000_0020` | Downpayment, unknown type of service, zero type of vat |
| `0x4154_2000_ooo8_oo08` | `0x4154_0000_0000_0020` | Downpayment, unknown type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4154_2000_ooo8_oo11` | `0x4154_0000_0000_001C` | Downpayment, supply of goods type of service, discounted1 type of vat |
| `0x4154_2000_ooo8_oo12` | `0x4154_0000_0000_001D` | Downpayment, supply of goods type of service, discounted2 type of vat |
| `0x4154_2000_ooo8_oo13` | `0x4154_0000_0000_001E` | Downpayment, supply of goods type of service, normal type of vat |
| `0x4154_2000_ooo8_oo14` | `0x4154_0000_0000_001F` | Downpayment, supply of goods type of service, superreduced1 type of vat |
| `0x4154_2000_ooo8_oo15` | `0x4154_0000_0000_0020` | Downpayment, supply of goods type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4154_2000_ooo8_oo16` | `0x4154_0000_0000_0020` | Downpayment, supply of goods type of service, parking type of vat => not defined in v0, goto zero |
| `0x4154_2000_ooo8_oo17` | `0x4154_0000_0000_0020` | Downpayment, supply of goods type of service, zero type of vat |
| `0x4154_2000_ooo8_oo18` | `0x4154_0000_0000_0020` | Downpayment, supply of goods type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4154_2000_ooo8_oo21` | `0x4154_0000_0000_001C` | Downpayment, supply of service type of service, discounted1 type of vat |
| `0x4154_2000_ooo8_oo22` | `0x4154_0000_0000_001D` | Downpayment, supply of service type of service, discounted2 type of vat |
| `0x4154_2000_ooo8_oo23` | `0x4154_0000_0000_001E` | Downpayment, supply of service type of service, normal type of vat |
| `0x4154_2000_ooo8_oo24` | `0x4154_0000_0000_001F` | Downpayment, supply of service type of service, superreduced1 type of vat |
| `0x4154_2000_ooo8_oo25` | `0x4154_0000_0000_0020` | Downpayment, supply of service type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4154_2000_ooo8_oo26` | `0x4154_0000_0000_0020` | Downpayment, supply of service type of service, parking type of vat => not defined in v0, goto zero |
| `0x4154_2000_ooo8_oo27` | `0x4154_0000_0000_0020` | Downpayment, supply of service type of service, zero type of vat |
| `0x4154_2000_ooo8_oo28` | `0x4154_0000_0000_0020` | Downpayment, supply of service type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4154_2ooo_ooo1_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsVoid => v0 general void => no implementation in v0 |
| `0x4154_2ooo_ooo2_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsReturn/Refund => v0 general refund => no implementation in v0 |
| `0x4154_2ooo_ooo4_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Discount => v0 general discount => no implementation in v0 |
| `0x4154_2ooo_oo10_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Returnable => v0 general returnable => no implementation in v0 |
| `0x4154_2ooo_oo20_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Take Away => v0 take away => no implementation in v0 |

</details>

<details>
<summary>France (FR)</summary>

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4652_2000_0000_0000` | `0x4652_0000_0000_0000` | Unknown chargeitem type, unknown type of service, unknown type of vat, future logic may detect vat-type from vat-rate |
| `0x4652_2000_oooo_oo01` | `0x4652_0000_0000_0001` | Unknown type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo02` | `0x4652_0000_0000_0002` | Unknown type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo03` | `0x4652_0000_0000_0003` | Unknown type of service, normal type of vat |
| `0x4652_2000_oooo_oo04` | `0x4652_0000_0000_0004` | Unknown type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo05` | `0x4652_0000_0000_0005` | Unknown type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_oo06` | `0x4652_0000_0000_0005` | Unknown type of service, parking type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_oo07` | `0x4652_0000_0000_0005` | Unknown type of service, zero type of vat |
| `0x4652_2000_oooo_oo08` | `0x4652_0000_0000_0005` | Unknown type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_5oo8` | `0x4652_0000_0000_0006` | Not taxable type of vat, reverse charge => v0 specific implementation |
| `0x4652_2000_oooo_oo11` | `0x4652_0000_0000_0008` | Supply of goods type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo12` | `0x4652_0000_0000_0009` | Supply of goods type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo13` | `0x4652_0000_0000_000A` | Supply of goods type of service, normal type of vat |
| `0x4652_2000_oooo_oo14` | `0x4652_0000_0000_000B` | Supply of goods type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo15` | `0x4652_0000_0000_000C` | Supply of goods type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_oo16` | `0x4652_0000_0000_000C` | Supply of goods type of service, parking type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_oo17` | `0x4652_0000_0000_000C` | Supply of goods type of service, zero type of vat |
| `0x4652_2000_oooo_oo18` | `0x4652_0000_0000_000C` | Supply of goods type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_oo21` | `0x4652_0000_0000_000D` | Supply of service type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo22` | `0x4652_0000_0000_000E` | Supply of service type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo23` | `0x4652_0000_0000_000F` | Supply of service type of service, normal type of vat |
| `0x4652_2000_oooo_oo24` | `0x4652_0000_0000_0010` | Supply of service type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo25` | `0x4652_0000_0000_0011` | Supply of service type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_oo26` | `0x4652_0000_0000_0011` | Supply of service type of service, parking type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_oo27` | `0x4652_0000_0000_0011` | Supply of service type of service, zero type of vat |
| `0x4652_2000_oooo_oo28` | `0x4652_0000_0000_0011` | Supply of service type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4652_2000_oooo_oo31` | `0x4652_0000_0000_0001` | Tip to owner type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo32` | `0x4652_0000_0000_0002` | Tip to owner type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo33` | `0x4652_0000_0000_0003` | Tip to owner type of service, normal type of vat |
| `0x4652_2000_oooo_oo34` | `0x4652_0000_0000_0004` | Tip to owner type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo35` | `0x4652_0000_0000_0005` | Tip to owner type of service, superreduced2 type of vat |
| `0x4652_2000_oooo_oo36` | `0x4652_0000_0000_0005` | Tip to owner type of service, parking type of vat |
| `0x4652_2000_oooo_oo37` | `0x4652_0000_0000_0005` | Tip to owner type of service, zero type of vat |
| `0x4652_2000_oooo_oo38` | `0x4652_0000_0000_0005` | Tip to employee type of service, not taxable type of vat |
| `0x4652_2000_oooo_oo41` | `0x4652_0000_0000_0001` | Single-use voucher type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo42` | `0x4652_0000_0000_0002` | Single-use voucher type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo43` | `0x4652_0000_0000_0003` | Single-use voucher type of service, normal type of vat |
| `0x4652_2000_oooo_oo44` | `0x4652_0000_0000_0004` | Single-use voucher type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo45` | `0x4652_0000_0000_0005` | Single-use voucher type of service, superreduced2 type of vat |
| `0x4652_2000_oooo_oo46` | `0x4652_0000_0000_0005` | Single-use voucher type of service, parking type of vat |
| `0x4652_2000_oooo_oo47` | `0x4652_0000_0000_0005` | Single-use voucher type of service, zero type of vat |
| `0x4652_2000_oooo_oo48` | `0x4652_0000_0000_0021` | Multi-use voucher type of service, not taxable type of vat |
| `0x4652_2000_oooo_oo51` | `0x4652_0000_0000_0012` | Catalog service type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo52` | `0x4652_0000_0000_0013` | Catalog service type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo53` | `0x4652_0000_0000_0014` | Catalog service type of service, normal type of vat |
| `0x4652_2000_oooo_oo54` | `0x4652_0000_0000_0015` | Catalog service type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo55` | `0x4652_0000_0000_0016` | Catalog service type of service, superreduced2 type of vat |
| `0x4652_2000_oooo_oo56` | `0x4652_0000_0000_0016` | Catalog service type of service, parking type of vat |
| `0x4652_2000_oooo_oo57` | `0x4652_0000_0000_0016` | Catalog service type of service, zero type of vat |
| `0x4652_2000_oooo_oo58` | `0x4652_0000_0000_0016` | Catalog service type of service, not taxable type of vat |
| `0x4652_2000_oooo_oo61` | `0x4652_0000_0000_0007` | Agency business type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo62` | `0x4652_0000_0000_0007` | Agency business type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo63` | `0x4652_0000_0000_0007` | Agency business type of service, normal type of vat |
| `0x4652_2000_oooo_oo64` | `0x4652_0000_0000_0007` | Agency business type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo65` | `0x4652_0000_0000_0007` | Agency business type of service, superreduced2 type of vat |
| `0x4652_2000_oooo_oo66` | `0x4652_0000_0000_0007` | Agency business type of service, parking type of vat |
| `0x4652_2000_oooo_oo67` | `0x4652_0000_0000_0007` | Agency business type of service, zero type of vat |
| `0x4652_2000_oooo_oo68` | `0x4652_0000_0000_0021` | Receiveable of thired party type of service, not taxable type of vat |
| `0x4652_2000_oooo_oo71` | `0x4652_0000_0000_0017` | Own consumption type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo72` | `0x4652_0000_0000_0018` | Own consumption type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo73` | `0x4652_0000_0000_0019` | Own consumption type of service, normal type of vat |
| `0x4652_2000_oooo_oo74` | `0x4652_0000_0000_001A` | Own consumption type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo75` | `0x4652_0000_0000_001B` | Own consumption type of service, superreduced2 type of vat |
| `0x4652_2000_oooo_oo76` | `0x4652_0000_0000_001B` | Own consumption type of service, parking type of vat |
| `0x4652_2000_oooo_oo77` | `0x4652_0000_0000_001B` | Own consumption type of service, zero type of vat |
| `0x4652_2000_oooo_oo78` | `0x4652_0000_0000_001B` | Own consumption type of service, not taxable type of vat |
| `0x4652_2000_oooo_oo81` | `0x4652_0000_0000_0001` | Grant (unreal) type of service, discounted1 type of vat |
| `0x4652_2000_oooo_oo82` | `0x4652_0000_0000_0002` | Grant (unreal) type of service, discounted2 type of vat |
| `0x4652_2000_oooo_oo83` | `0x4652_0000_0000_0003` | Grant (unreal) type of service, normal type of vat |
| `0x4652_2000_oooo_oo84` | `0x4652_0000_0000_0004` | Grant (unreal) type of service, superreduced1 type of vat |
| `0x4652_2000_oooo_oo85` | `0x4652_0000_0000_0005` | Grant (unreal) type of service, superreduced2 type of vat |
| `0x4652_2000_oooo_oo86` | `0x4652_0000_0000_0005` | Grant (unreal) type of service, parking type of vat |
| `0x4652_2000_oooo_oo87` | `0x4652_0000_0000_0005` | Grant (unreal) type of service, zero type of vat |
| `0x4652_2000_oooo_oo88` | `0x4652_0000_0000_0005` | Grant (real) type of service, not taxable type of vat |
| `0x4652_2000_oooo_oo98` | `0x4652_0000_0000_0022` | Receiveable type of service, not taxable type of vat |
| `0x4652_2000_oooo_ooA8` | `0x4652_0000_0000_0022` | Cash transfer type of service, not taxable type of vat |
| `0x4652_2000_ooo8_oo00` | `0x4652_0000_0000_0020` | Downpayment, unknown type of service, unknown type of vat |
| `0x4652_2000_ooo8_oo01` | `0x4652_0000_0000_001C` | Downpayment, unknown type of service, discounted1 type of vat |
| `0x4652_2000_ooo8_oo02` | `0x4652_0000_0000_001D` | Downpayment, unknown type of service, discounted2 type of vat |
| `0x4652_2000_ooo8_oo03` | `0x4652_0000_0000_001E` | Downpayment, unknown type of service, normal type of vat |
| `0x4652_2000_ooo8_oo04` | `0x4652_0000_0000_001F` | Downpayment, unknown type of service, superreduced1 type of vat |
| `0x4652_2000_ooo8_oo05` | `0x4652_0000_0000_0020` | Downpayment, unknown type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4652_2000_ooo8_oo06` | `0x4652_0000_0000_0020` | Downpayment, unknown type of service, parking type of vat => not defined in v0, goto zero |
| `0x4652_2000_ooo8_oo07` | `0x4652_0000_0000_0020` | Downpayment, unknown type of service, zero type of vat |
| `0x4652_2000_ooo8_oo08` | `0x4652_0000_0000_0020` | Downpayment, unknown type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4652_2000_ooo8_oo11` | `0x4652_0000_0000_001C` | Downpayment, supply of goods type of service, discounted1 type of vat |
| `0x4652_2000_ooo8_oo12` | `0x4652_0000_0000_001D` | Downpayment, supply of goods type of service, discounted2 type of vat |
| `0x4652_2000_ooo8_oo13` | `0x4652_0000_0000_001E` | Downpayment, supply of goods type of service, normal type of vat |
| `0x4652_2000_ooo8_oo14` | `0x4652_0000_0000_001F` | Downpayment, supply of goods type of service, superreduced1 type of vat |
| `0x4652_2000_ooo8_oo15` | `0x4652_0000_0000_0020` | Downpayment, supply of goods type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4652_2000_ooo8_oo16` | `0x4652_0000_0000_0020` | Downpayment, supply of goods type of service, parking type of vat => not defined in v0, goto zero |
| `0x4652_2000_ooo8_oo17` | `0x4652_0000_0000_0020` | Downpayment, supply of goods type of service, zero type of vat |
| `0x4652_2000_ooo8_oo18` | `0x4652_0000_0000_0020` | Downpayment, supply of goods type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4652_2000_ooo8_oo21` | `0x4652_0000_0000_001C` | Downpayment, supply of service type of service, discounted1 type of vat |
| `0x4652_2000_ooo8_oo22` | `0x4652_0000_0000_001D` | Downpayment, supply of service type of service, discounted2 type of vat |
| `0x4652_2000_ooo8_oo23` | `0x4652_0000_0000_001E` | Downpayment, supply of service type of service, normal type of vat |
| `0x4652_2000_ooo8_oo24` | `0x4652_0000_0000_001F` | Downpayment, supply of service type of service, superreduced1 type of vat |
| `0x4652_2000_ooo8_oo25` | `0x4652_0000_0000_0020` | Downpayment, supply of service type of service, superreduced2 type of vat => not defined in v0, goto zero |
| `0x4652_2000_ooo8_oo26` | `0x4652_0000_0000_0020` | Downpayment, supply of service type of service, parking type of vat => not defined in v0, goto zero |
| `0x4652_2000_ooo8_oo27` | `0x4652_0000_0000_0020` | Downpayment, supply of service type of service, zero type of vat |
| `0x4652_2000_ooo8_oo28` | `0x4652_0000_0000_0020` | Downpayment, supply of service type of service, not taxable type of vat => not defined in v0, goto zero |
| `0x4652_2ooo_ooo1_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsVoid => v0 general void => no implementation in v0 |
| `0x4652_2ooo_ooo2_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsReturn/Refund => v0 general refund => no implementation in v0 |
| `0x4652_2ooo_ooo4_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Discount => v0 general discount => no implementation in v0 |
| `0x4652_2ooo_oo10_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Returnable => v0 general returnable => no implementation in v0 |
| `0x4652_2ooo_oo20_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Take Away => v0 take away => no implementation in v0 |

</details>

<details>
<summary>Germany (DE)</summary>

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4445_2000_0000_0000` | `0x4445_0000_0000_0000` | Unknown chargeitem type, unknown type of service, unknown type of vat, future logic may detect vat-type from vat-rate |
| `0x4445_2000_oooo_oo01` | `0x4445_0000_0000_0002` | Unknown type of service, discounted1 type of vat |
| `0x4445_2000_oooo_oo02` | `0x4445_0000_0000_0007` | Unknown type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo03` | `0x4445_0000_0000_0001` | Unknown type of service, normal type of vat |
| `0x4445_2000_oooo_oo04` | `0x4445_0000_0000_0003` | Unknown type of service, superreduced1 type of vat |
| `0x4445_2000_oooo_oo05` | `0x4445_0000_0000_0004` | Unknown type of service, superreduced2 type of vat |
| `0x4445_2000_oooo_oo06` | `0x4445_0000_0000_0007` | Unknown type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo07` | `0x4445_0000_0000_0006` | Unknown type of service, zero type of vat |
| `0x4445_2000_oooo_oo08` | `0x4445_0000_0000_0005` | Unknown type of service, not taxable type of vat |
| `0x4445_2000_oooo_oo11` | `0x4445_0000_0000_0012` | Supply of goods type of service, discounted1 type of vat |
| `0x4445_2000_oooo_oo12` | `0x4445_0000_0000_0017` | Supply of goods type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo13` | `0x4445_0000_0000_0011` | Supply of goods type of service, normal type of vat |
| `0x4445_2000_oooo_oo14` | `0x4445_0000_0000_0013` | Supply of goods type of service, superreduced1 type of vat |
| `0x4445_2000_oooo_oo15` | `0x4445_0000_0000_0014` | Supply of goods type of service, superreduced2 type of vat |
| `0x4445_2000_oooo_oo16` | `0x4445_0000_0000_0017` | Supply of goods type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo17` | `0x4445_0000_0000_0016` | Supply of goods type of service, zero type of vat |
| `0x4445_2000_oooo_oo18` | `0x4445_0000_0000_0015` | Supply of goods type of service, not taxable type of vat |
| `0x4445_2000_oooo_oo21` | `0x4445_0000_0000_001A` | Supply of service type of service, discounted1 type of vat |
| `0x4445_2000_oooo_oo22` | `0x4445_0000_0000_001F` | Supply of service type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo23` | `0x4445_0000_0000_0019` | Supply of service type of service, normal type of vat |
| `0x4445_2000_oooo_oo24` | `0x4445_0000_0000_001B` | Supply of service type of service, superreduced1 type of vat |
| `0x4445_2000_oooo_oo25` | `0x4445_0000_0000_001C` | Supply of service type of service, superreduced2 type of vat |
| `0x4445_2000_oooo_oo26` | `0x4445_0000_0000_001F` | Supply of service type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo27` | `0x4445_0000_0000_001E` | Supply of service type of service, zero type of vat |
| `0x4445_2000_oooo_oo28` | `0x4445_0000_0000_001D` | Supply of service type of service, not taxable type of vat |
| `0x4445_2000_oo1o_ooo1` | `0x4445_0000_0000_0022` | Returnable type of service, discounted1 type of vat |
| `0x4445_2000_oo1o_ooo2` | `0x4445_0000_0000_0027` | Returnable type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oo1o_ooo3` | `0x4445_0000_0000_0021` | Returnable type of service, normal type of vat |
| `0x4445_2000_oo1o_ooo4` | `0x4445_0000_0000_0023` | Returnable type of service, superreduced1 type of vat |
| `0x4445_2000_oo1o_ooo5` | `0x4445_0000_0000_0024` | Returnable type of service, superreduced2 type of vat |
| `0x4445_2000_oo1o_ooo6` | `0x4445_0000_0000_0027` | Returnable type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oo1o_ooo7` | `0x4445_0000_0000_0026` | Returnable type of service, zero type of vat |
| `0x4445_2000_oo1o_ooo8` | `0x4445_0000_0000_0025` | Returnable type of service, not taxable type of vat |
| `0x4445_2000_oo12_ooo1` | `0x4445_0000_0000_002A` | Returnable refund type of service, discounted1 type of vat |
| `0x4445_2000_oo12_ooo2` | `0x4445_0000_0000_002F` | Returnable refund type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oo12_ooo3` | `0x4445_0000_0000_0029` | Returnable refund type of service, normal type of vat |
| `0x4445_2000_oo12_ooo4` | `0x4445_0000_0000_002B` | Returnable refund type of service, superreduced1 type of vat |
| `0x4445_2000_oo12_ooo5` | `0x4445_0000_0000_002C` | Returnable refund type of service, superreduced2 type of vat |
| `0x4445_2000_oo12_ooo6` | `0x4445_0000_0000_0027` | Returnable refund type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oo12_ooo7` | `0x4445_0000_0000_002E` | Returnable refund type of service, zero type of vat |
| `0x4445_2000_oo12_ooo8` | `0x4445_0000_0000_002D` | Returnable refund type of service, not taxable type of vat |
| `0x4445_2000_ooo4_ooo1` | `0x4445_0000_0000_0032` | Discount (amount < 0) type of service, discounted1 type of vat |
| `0x4445_2000_ooo4_ooo2` | `0x4445_0000_0000_0037` | Discount (amount < 0) type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_ooo4_ooo3` | `0x4445_0000_0000_0031` | Discount (amount < 0) type of service, normal type of vat |
| `0x4445_2000_ooo4_ooo4` | `0x4445_0000_0000_0033` | Discount (amount < 0) type of service, superreduced1 type of vat |
| `0x4445_2000_ooo4_ooo5` | `0x4445_0000_0000_0034` | Discount (amount < 0) type of service, superreduced2 type of vat |
| `0x4445_2000_ooo4_ooo6` | `0x4445_0000_0000_0037` | Discount (amount < 0) type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_ooo4_ooo7` | `0x4445_0000_0000_0036` | Discount (amount < 0) type of service, zero type of vat |
| `0x4445_2000_ooo4_ooo8` | `0x4445_0000_0000_0035` | Discount (amount < 0) type of service, not taxable type of vat |
| `0x4445_2000_ooo4_ooo1` | `0x4445_0000_0000_003A` | Discount (amount > 0) type of service, discounted1 type of vat |
| `0x4445_2000_ooo4_ooo2` | `0x4445_0000_0000_003F` | Discount (amount > 0) type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_ooo4_ooo3` | `0x4445_0000_0000_0039` | Discount (amount > 0) type of service, normal type of vat |
| `0x4445_2000_ooo4_ooo4` | `0x4445_0000_0000_003B` | Discount (amount > 0) type of service, superreduced1 type of vat |
| `0x4445_2000_ooo4_ooo5` | `0x4445_0000_0000_003C` | Discount (amount > 0) type of service, superreduced2 type of vat |
| `0x4445_2000_ooo4_ooo6` | `0x4445_0000_0000_0037` | Discount (amount > 0) type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_ooo4_ooo7` | `0x4445_0000_0000_003E` | Discount (amount > 0) type of service, zero type of vat |
| `0x4445_2000_ooo4_ooo8` | `0x4445_0000_0000_003D` | Discount (amount > 0) type of service, not taxable type of vat |
| `0x4445_2000_oooo_oo81` | `0x4445_0000_0000_0042` | Grant (unreal) type of service, discounted1 type of vat |
| `0x4445_2000_oooo_oo82` | `0x4445_0000_0000_0047` | Grant (unreal) type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo83` | `0x4445_0000_0000_0041` | Grant (unreal) type of service, normal type of vat |
| `0x4445_2000_oooo_oo84` | `0x4445_0000_0000_0043` | Grant (unreal) type of service, superreduced1 type of vat |
| `0x4445_2000_oooo_oo85` | `0x4445_0000_0000_0044` | Grant (unreal) type of service, superreduced2 type of vat |
| `0x4445_2000_oooo_oo86` | `0x4445_0000_0000_0047` | Grant (unreal) type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo87` | `0x4445_0000_0000_0046` | Grant (unreal) type of service, zero type of vat |
| `0x4445_2000_oooo_oo88` | `0x4445_0000_0000_0049` | Grant (real) type of service, not taxable type of vat => _0045 will not be reachable from v2 |
| `0x4445_2000_oooo_oo31` | `0x4445_0000_0000_0052` | Tip to owner type of service, discounted1 type of vat |
| `0x4445_2000_oooo_oo32` | `0x4445_0000_0000_0057` | Tip to owner type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo33` | `0x4445_0000_0000_0051` | Tip to owner type of service, normal type of vat |
| `0x4445_2000_oooo_oo34` | `0x4445_0000_0000_0053` | Tip to owner type of service, superreduced1 type of vat |
| `0x4445_2000_oooo_oo35` | `0x4445_0000_0000_0054` | Tip to owner type of service, superreduced2 type of vat |
| `0x4445_2000_oooo_oo36` | `0x4445_0000_0000_0057` | Tip to owner type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo37` | `0x4445_0000_0000_0056` | Tip to owner type of service, zero type of vat |
| `0x4445_2000_oooo_oo38` | `0x4445_0000_0000_0059` | Tip to employee type of service, not taxable type of vat => _0055 will not be reachable from v2 |
| `0x4445_2000_oooo_oo41` | `0x4445_0000_0000_0062` | Single-use voucher (amount > 0) type of service, discounted1 type of vat |
| `0x4445_2000_oooo_oo42` | `0x4445_0000_0000_0067` | Single-use voucher (amount > 0) type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo43` | `0x4445_0000_0000_0061` | Single-use voucher (amount > 0) type of service, normal type of vat |
| `0x4445_2000_oooo_oo44` | `0x4445_0000_0000_0063` | Single-use voucher (amount > 0) type of service, superreduced1 type of vat |
| `0x4445_2000_oooo_oo45` | `0x4445_0000_0000_0064` | Single-use voucher (amount > 0) type of service, superreduced2 type of vat |
| `0x4445_2000_oooo_oo46` | `0x4445_0000_0000_0067` | Single-use voucher (amount > 0) type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo47` | `0x4445_0000_0000_0066` | Single-use voucher (amount > 0) type of service, zero type of vat |
| `0x4445_2000_oooo_oo48` | `0x4445_0000_0000_0060` | Multi-use voucher (amount > 0) type of service, not taxable type of vat |
| `0x4445_2000_oooo_oo41` | `0x4445_0000_0000_006A` | Single-use voucher (amount > 0) type of service, discounted1 type of vat |
| `0x4445_2000_oooo_oo42` | `0x4445_0000_0000_006F` | Single-use voucher (amount < 0) type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo43` | `0x4445_0000_0000_0069` | Single-use voucher (amount < 0) type of service, normal type of vat |
| `0x4445_2000_oooo_oo44` | `0x4445_0000_0000_006B` | Single-use voucher (amount < 0) type of service, superreduced1 type of vat |
| `0x4445_2000_oooo_oo45` | `0x4445_0000_0000_006C` | Single-use voucher (amount < 0) type of service, superreduced2 type of vat |
| `0x4445_2000_oooo_oo46` | `0x4445_0000_0000_006F` | Single-use voucher (amount < 0) type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo47` | `0x4445_0000_0000_006E` | Single-use voucher (amount < 0) type of service, zero type of vat |
| `0x4445_2000_oooo_oo48` | `0x4445_0000_0000_0068` | Multi-use voucher (amount < 0) type of service, not taxable type of vat |
| `0x4445_2000_oooo_oo91` | `0x4445_0000_0000_0072` | Receiveable (amount > 0), discounted1 type of vat |
| `0x4445_2000_oooo_oo92` | `0x4445_0000_0000_0077` | Receiveable (amount > 0), discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo93` | `0x4445_0000_0000_0071` | Receiveable (amount > 0), normal type of vat |
| `0x4445_2000_oooo_oo94` | `0x4445_0000_0000_0073` | Receiveable (amount > 0), superreduced1 type of vat |
| `0x4445_2000_oooo_oo95` | `0x4445_0000_0000_0074` | Receiveable (amount > 0), superreduced2 type of vat |
| `0x4445_2000_oooo_oo96` | `0x4445_0000_0000_0077` | Receiveable (amount > 0), parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo97` | `0x4445_0000_0000_0076` | Receiveable (amount > 0), zero type of vat |
| `0x4445_2000_oooo_oo98` | `0x4445_0000_0000_0075` | Receiveable (amount > 0), not taxable type of vat |
| `0x4445_2000_oooo_oo91` | `0x4445_0000_0000_007A` | Receiveable (amount < 0), discounted1 type of vat |
| `0x4445_2000_oooo_oo92` | `0x4445_0000_0000_007F` | Receiveable (amount < 0), discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo93` | `0x4445_0000_0000_0079` | Receiveable (amount < 0), normal type of vat |
| `0x4445_2000_oooo_oo94` | `0x4445_0000_0000_007B` | Receiveable (amount < 0), superreduced1 type of vat |
| `0x4445_2000_oooo_oo95` | `0x4445_0000_0000_007C` | Receiveable (amount < 0), superreduced2 type of vat |
| `0x4445_2000_oooo_oo96` | `0x4445_0000_0000_007F` | Receiveable (amount < 0), parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_oooo_oo97` | `0x4445_0000_0000_007E` | Receiveable (amount < 0), zero type of vat |
| `0x4445_2000_oooo_oo98` | `0x4445_0000_0000_007D` | Receiveable (amount < 0), not taxable type of vat |
| `0x4445_2000_ooo8_ooo1` | `0x4445_0000_0000_0082` | Downpayment (amount < 0) type of service, discounted1 type of vat |
| `0x4445_2000_ooo8_ooo2` | `0x4445_0000_0000_0087` | Downpayment (amount < 0) type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_ooo8_ooo3` | `0x4445_0000_0000_0081` | Downpayment (amount < 0) type of service, normal type of vat |
| `0x4445_2000_ooo8_ooo4` | `0x4445_0000_0000_0083` | Downpayment (amount < 0) type of service, superreduced1 type of vat |
| `0x4445_2000_ooo8_ooo5` | `0x4445_0000_0000_0084` | Downpayment (amount < 0) type of service, superreduced2 type of vat |
| `0x4445_2000_ooo8_ooo6` | `0x4445_0000_0000_0087` | Downpayment (amount < 0) type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_ooo8_ooo7` | `0x4445_0000_0000_0086` | Downpayment (amount < 0) type of service, zero type of vat |
| `0x4445_2000_ooo8_ooo8` | `0x4445_0000_0000_0085` | Downpayment (amount < 0) type of service, not taxable type of vat |
| `0x4445_2000_ooo8_ooo1` | `0x4445_0000_0000_008A` | Downpayment (amount > 0) type of service, discounted1 type of vat |
| `0x4445_2000_ooo8_ooo2` | `0x4445_0000_0000_008F` | Downpayment (amount > 0) type of service, discounted2 type of vat => not defined in v0, goto unknown |
| `0x4445_2000_ooo8_ooo3` | `0x4445_0000_0000_0089` | Downpayment (amount > 0) type of service, normal type of vat |
| `0x4445_2000_ooo8_ooo4` | `0x4445_0000_0000_008B` | Downpayment (amount > 0) type of service, superreduced1 type of vat |
| `0x4445_2000_ooo8_ooo5` | `0x4445_0000_0000_008C` | Downpayment (amount > 0) type of service, superreduced2 type of vat |
| `0x4445_2000_ooo8_ooo6` | `0x4445_0000_0000_0087` | Downpayment (amount > 0) type of service, parking type of vat => not defined in v0, goto unknown |
| `0x4445_2000_ooo8_ooo7` | `0x4445_0000_0000_008E` | Downpayment (amount > 0) type of service, zero type of vat |
| `0x4445_2000_ooo8_ooo8` | `0x4445_0000_0000_008D` | Downpayment (amount > 0) type of service, not taxable type of vat |
| `0x4445_2000_oooo_ooA8` | `0x4445_0000_0000_0097 X TODO different cash transfers` | Cash transfer type of service, not taxable type of vat |
| `0x4445_2000_oooo_5oo8` | `0x4445_0000_0000_00A1` | Not taxable type of vat, reverse charge => v0 specific implementation |
| `0x4445_2000_oooo_oo61` | `0x4445_0000_0000_00A2` | Agency business type of service, discounted1 type of vat |
| `0x4445_2000_oooo_oo62` | `0x4445_0000_0000_00A2` | Agency business type of service, discounted2 type of vat |
| `0x4445_2000_oooo_oo63` | `0x4445_0000_0000_00A2` | Agency business type of service, normal type of vat |
| `0x4445_2000_oooo_oo64` | `0x4445_0000_0000_00A2` | Agency business type of service, superreduced1 type of vat |
| `0x4445_2000_oooo_oo65` | `0x4445_0000_0000_00A2` | Agency business type of service, superreduced2 type of vat |
| `0x4445_2000_oooo_oo66` | `0x4445_0000_0000_00A2` | Agency business type of service, parking type of vat |
| `0x4445_2000_oooo_oo67` | `0x4445_0000_0000_00A2` | Agency business type of service, zero type of vat |
| `0x4445_2000_oooo_oo51` | `0x4445_0000_0000_0002` | Catalog service type of service, discounted1 type of vat => not defined in v0, use unknown |
| `0x4445_2000_oooo_oo52` | `0x4445_0000_0000_0007` | Catalog service type of service, discounted2 type of vat => not defined in v0, use unknown |
| `0x4445_2000_oooo_oo53` | `0x4445_0000_0000_0001` | Catalog service type of service, normal type of vat => not defined in v0, use unknown |
| `0x4445_2000_oooo_oo54` | `0x4445_0000_0000_0003` | Catalog service type of service, superreduced1 type of vat => not defined in v0, use unknown |
| `0x4445_2000_oooo_oo55` | `0x4445_0000_0000_0004` | Catalog service type of service, superreduced2 type of vat => not defined in v0, use unknown |
| `0x4445_2000_oooo_oo56` | `0x4445_0000_0000_0007` | Catalog service type of service, parking type of vat => not defined in v0, use unknown |
| `0x4445_2000_oooo_oo57` | `0x4445_0000_0000_0006` | Catalog service type of service, zero type of vat => not defined in v0, use unknown |
| `0x4445_2000_oooo_oo58` | `0x4445_0000_0000_0005` | Catalog service type of service, not taxable type of vat => not defined in v0, use unknown |
| `0x4445_2000_oooo_oo71` | `0x4445_0000_0000_0042` | Own consumption type of service, discounted1 type of vat => not defined in v0, use grant |
| `0x4445_2000_oooo_oo72` | `0x4445_0000_0000_0047` | Own consumption type of service, discounted2 type of vat => not defined in v0, use grant |
| `0x4445_2000_oooo_oo73` | `0x4445_0000_0000_0041` | Own consumption type of service, normal type of vat => not defined in v0, use grant |
| `0x4445_2000_oooo_oo74` | `0x4445_0000_0000_0043` | Own consumption type of service, superreduced1 type of vat => not defined in v0, use grant |
| `0x4445_2000_oooo_oo75` | `0x4445_0000_0000_0044` | Own consumption type of service, superreduced2 type of vat => not defined in v0, use grant |
| `0x4445_2000_oooo_oo76` | `0x4445_0000_0000_0047` | Own consumption type of service, parking type of vat => not defined in v0, use grant |
| `0x4445_2000_oooo_oo77` | `0x4445_0000_0000_0046` | Own consumption type of service, zero type of vat => not defined in v0, use grant |
| `0x4445_2000_oooo_oo78` | `0x4445_0000_0000_0045` | Own consumption type of service, not taxable type of vat => not defined in v0, use grant |
| `0x4445_2ooo_oo2o_oooo` | `0xoooo_oooo_ooo1_oooo` | v2 Take Away |
| `0x4445_2ooo_ooo1_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsVoid => v0 general void => no implementation in v0 |
| `0x4445_2ooo_ooo2_oooo` | `0xoooo_oooo_oooo_oooo` | v2 IsReturn/Refund => v0 general refund => no implementation in v0 |
| `0x4445_2ooo_ooo4_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Discount => v0 general discount => no implementation in v0 |
| `0x4445_2ooo_oo10_oooo` | `0xoooo_oooo_oooo_oooo` | v2 Returnable => v0 general returnable => no implementation in v0 |

</details>

#### ftPayItemCase

<details>
<summary>Austria (AT)</summary>

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4154_2000_0000_0000` | `0x4154_0000_0000_0000` | Unknown payitem type |
| `0x4154_2000_oooo_oo01` | `0x4154_0000_0000_0001` | Cash payment |
| `0x4154_2000_oo1o_oo01` | `0x4154_0000_0000_0002` | Cash payment, in foreign currency |
| `0x4154_2000_oooo_oo02` | `0x4154_0000_0000_0007` | Non-cash payment => v0 online payment, not rksv relevant payments |
| `0x4154_2000_oooo_oo03` | `0x4154_0000_0000_0003` | Crossed check payment |
| `0x4154_2000_oooo_oo04` | `0x4154_0000_0000_0004` | Debit card payment |
| `0x4154_2000_oooo_oo05` | `0x4154_0000_0000_0005` | Credit card payment |
| `0x4154_2000_oooo_oo06` | `0x4154_0000_0000_0006` | Voucher payment |
| `0x4154_2000_oooo_oo07` | `0x4154_0000_0000_0007` | Online payment |
| `0x4154_2000_oooo_oo08` | `0x4154_0000_0000_0008` | Loyality program, customer card payment |
| `0x4154_2000_oooo_oo09` | `0x4154_0000_0000_000B` | Accounts receiveable |
| `0x4154_2000_oooo_oo0A` | `0x4154_0000_0000_000C` | Sepa wire transfer |
| `0x4154_2000_oooo_oo0B` | `0x4154_0000_0000_000D` | Other wire/bank transer |
| `0x4154_2000_oooo_oo0C` | `0x4154_0000_0000_000E` | Transfer to cashbook, amount negativ => v0 cashbook expense |
| `0x4154_2000_oooo_oo0C` | `0x4154_0000_0000_000E` | Transfer to cashbook, amount positiv => v0 cashbook contribution |
| `0x4154_2000_oooo_oo0D` | `0x4154_0000_0000_0011` | Internal / material consumption |
| `0x4154_2000_oooo_oo0E` | `0x4154_0000_0000_000B` | Grant => v0 accounts receiveable |
| `0x4154_2000_oooo_oo0F` | `0x4154_0000_0000_0006` | Ticket restaurant => v0 voucher |
| `0x4154_2000_ooo8_oo09` | `0x4154_0000_0000_0010` | Accounts receiveable, downpayment flag => v0 levy / downpayment |
| `0x4154_2000_oo2o_oo01` | `0x4154_0000_0000_0012` | Cash payment, change flag => v0 change / tip |
| `0x4154_2000_oo4o_oo01` | `0x4154_0000_0040_0012` | Cash payment, tip flag => v0 change / tip |

</details>

<details>
<summary>France (FR)</summary>

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | ----------- |
| `0x4652_2000_0000_0000` | `0x4652_0000_0000_0000` | Unknown payitem type |
| `0x4652_2000_oooo_oo01` | `0x4652_0000_0000_0001` | Cash payment |
| `0x4652_2000_oo1o_oo01` | `0x4652_0000_0000_0002` | Cash payment, in foreign currency |
| `0x4652_2000_oooo_oo02` | `0x4652_0000_0000_0007` | Non-cash payment => v0 online payment, not rksv relevant payments |
| `0x4652_2000_oooo_oo03` | `0x4652_0000_0000_0003` | Crossed check payment |
| `0x4652_2000_oooo_oo04` | `0x4652_0000_0000_0004` | Debit card payment |
| `0x4652_2000_oooo_oo05` | `0x4652_0000_0000_0005` | Credit card payment |
| `0x4652_2000_oooo_oo06` | `0x4652_0000_0000_0006` | Voucher payment |
| `0x4652_2000_oooo_oo07` | `0x4652_0000_0000_0007` | Online payment |
| `0x4652_2000_oooo_oo08` | `0x4652_0000_0000_0008` | Loyality program, customer card payment |
| `0x4652_2000_oooo_oo09` | `0x4652_0000_0000_000B` | Accounts receiveable |
| `0x4652_2000_oooo_oo0A` | `0x4652_0000_0000_000C` | Sepa wire transfer |
| `0x4652_2000_oooo_oo0B` | `0x4652_0000_0000_000D` | Other wire/bank transer |
| `0x4652_2000_oooo_oo0C` | `0x4652_0000_0000_000E` | Transfer to cashbook, amount negativ => v0 cashbook expense |
| `0x4652_2000_oooo_oo0C` | `0x4652_0000_0000_000E` | Transfer to cashbook, amount positiv => v0 cashbook contribution |
| `0x4652_2000_oooo_oo0D` | `0x4652_0000_0000_0011` | Internal / material consumption |
| `0x4652_2000_oooo_oo0E` | `0x4652_0000_0000_000B` | Grant => v0 accounts receiveable |
| `0x4652_2000_oooo_oo0F` | `0x4652_0000_0000_0006` | Ticket restaurant => v0 voucher |
| `0x4652_2000_ooo8_oo09` | `0x4652_0000_0000_0010` | Accounts receiveable, downpayment flag => v0 levy / downpayment |
| `0x4652_2000_oo2o_oo01` | `0x4652_0000_0000_0012` | Cash payment, change flag => v0 change / tip |
| `0x4652_2000_oo4o_oo01` | `0x4652_0000_0040_0012` | Cash payment, tip flag => v0 change / tip |

</details>

<details>
<summary>Germany (DE)</summary>

| **v2 (in)** | **v0 (out)** | **Description** |
| ----------- | ------------ | --------------- |
| `0x4445_2000_0000_0000` | `0x4445_0000_0000_0000` | Unknown payitem type |
| `0x4445_2000_oooo_oo01` | `0x4445_0000_0000_0001` | Cash payment |
| `0x4445_2000_oo1o_oo01` | `0x4445_0000_0000_0002` | Cash payment, in foreign currency |
| `0x4445_2000_oooo_oo02` | `0x4445_0000_0000_0007` | Non-cash payment => v0 online payment, not rksv relevant payments |
| `0x4445_2000_oooo_oo03` | `0x4445_0000_0000_0003` | Crossed check payment |
| `0x4445_2000_oooo_oo04` | `0x4445_0000_0000_0004` | Debit card payment |
| `0x4445_2000_oooo_oo05` | `0x4445_0000_0000_0005` | Credit card payment |
| `0x4445_2000_oooo_oo06` | `0x4445_0000_0000_000D` | Voucher payment |
| `0x4445_2000_oooo_oo07` | `0x4445_0000_0000_0006` | Online payment |
| `0x4445_2000_oooo_oo08` | `0x4445_0000_0000_0007` | Loyality program, customer card payment |
| `0x4445_2000_oooo_oo09` | `0x4445_0000_0000_000E` | Accounts receiveable |
| `0x4445_2000_oooo_oo0A` | `0x4445_0000_0000_0008` | Sepa wire transfer |
| `0x4445_2000_oooo_oo0B` | `0x4445_0000_0000_0009` | Other wire/bank transer |
| `0x4445_2000_oooo_oo0C` | `0x4445_0000_0000_0012` | Transfer to ... [cashbook / vault / owner / employee], amount negativ, ??? MoneyGroup == "EmptyTill" => v0 cash transfer to empty till |
| `0x4445_2000_oooo_oo0C` | `0x4445_0000_0000_0013` | Transfer to ... [cashbook / vault / owner / employee], MoneyGroup == ??? "Owner" => v0 cash transfer to owner |
| `0x4445_2000_oooo_oo0C` | `0x4445_0000_0000_0014` | Transfer to ... [cashbook / vault / owner / employee], MoneyGroup == ??? "Till",  => v0 cash transfer from/to till |
| `0x4445_2000_oooo_oo0C` | `0x4445_0000_0000_0015` | Transfer to ... [cashbook / vault / owner / employee], MoneyGroup == ??? "Employee" => v0 cash transfer to employee |
| `0x4445_2000_oooo_oo0C` | `0x4445_0000_0000_0016` | Transfer to ... [cashbook / vault / owner / employee], MoneyGroup == ??? "Cashbook" => v0 cash transfer from/to cashbook |
| `0x4445_2000_oooo_oo0C` | `0x4445_0000_0000_0017` | Transfer to ... [cashbook / vault / owner / employee], MoneyGroup == ??? "CashDifference" => v0 cash difference in till |
| `0x4445_2000_oooo_oo0D` | `0x4445_0000_0000_000A` | Internal / material consumption |
| `0x4445_2000_oooo_oo0E` | `0x4445_0000_0000_0011` | Grant => v0 (real)grant |
| `0x4445_2000_oooo_oo0F` | `0x4445_0000_0000_0006` | Ticket restaurant => v0 voucher |
| `0x4445_2000_ooo8_oo09` | `0x4445_0000_0000_000F` | Accounts receiveable, downpayment flag => v0 downpayment |
| `0x4445_2000_oo2o_oo01` | `0x4445_0000_0000_000B` | Cash payment, change flag => v0 change |
| `0x4445_2000_oo3o_oo01` | `0x4445_0000_0000_000C` | Cash payment, in foreign currency, change flag => v0 change in foreign currency |
| `0x4445_2000_oo4o_oo01` | `0x4445_0000_0040_0012` | Cash payment, tip flag => v0 tip to employee |

</details>

Key differences highlighted:
1. The base URL changes.
2. All case numeric values must be remapped.
3. `ftReceiptCaseData` is now an object keyed by market code instead of a raw string.

:::info Important

For the `ftReceiptCaseFlag`, `ftChargeItemCaseFlag`, and `ftPayItemCaseFlag` fields, replace every lowercase letter `o` in flag values with the digit `0` (zero). Examples:
- `0x4154_2oo0_oo8o_2ooo` → `0x4154_2000_0080_2000`
- `0xoooo_oooo_oooo_oooo` → `0x0000_0000_0000_0000`

:::

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

| Field | v0 | v2 |
| ----- | -- | ---|
| `cbReceiptReference` | Optional in some flows | **Required** — must be a unique string per request |
| `Currency` | Not present | Added — ISO 4217 currency code (default: `EUR`) |
| `DecimalPrecisionMultiplier` | Not present | Added — controls integer vs. floating-point amounts (default: `1`, i.e. floating-point) |
| `ftPosSystemID` | Optional | Recommended — identifies your POS software |

All other fields (`ftCashBoxID`, `cbTerminalID`, `cbReceiptMoment`, `cbChargeItems`, `cbPayItems`, `ftReceiptCase`, etc.) carry over unchanged.

#### ReceiptResponse

The `ReceiptResponse` structure is largely compatible. Verify that your receipt printing logic correctly handles:

- `ftSignatures` — format and type values are unchanged; ensure all entries are printed as required by national regulations.
- `ftState` — error flag interpretation is unchanged; check your error-handling code still covers all states.

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

| v0 call  | v2 HTTP endpoint | Notes |
| -------- | ---------------- |------ |
| `proxy.Echo("message")` | `POST /v2/echo` | Request body: `{"message": "..."}` — response mirrors the same structure: `{"message": "..."}` |
| `proxy.Sign(receiptRequest)` | `POST /v2/sign` | Request body is the JSON-serialised `ReceiptRequest`; response is `ReceiptResponse` |
| `proxy.Journal(ftJournalType, from, to)` | `POST /v2/journal` | Request body carries `ftJournalType`, `from`, and `to` as ISO 8601 date-time strings (see [Timestamps](#timestamps)) |

##### Authentication

All v2 requests must include the following HTTP headers:

```
x-cashbox-id :   <your CashBox GUID>
x-cashbox-accesstoken : <your Access Token>
x-operation-id : a UUID randomly generated on your side
```

Both values are available on the CashBox page in the fiskaltrust.Portal. On first use, you also need to **pair** the client via the PIN displayed in the Portal. For more information, see how to [Test the PosSystem API Helper](../../../../posdealers/technical-operations/middleware/helper-possystemapi.md#test-the-possystem-api-helper).

##### Echo example

**Request:**

```json
POST /v2/echo
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
