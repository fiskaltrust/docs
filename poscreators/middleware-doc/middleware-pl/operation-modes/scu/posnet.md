---
slug: /poscreators/middleware-doc/poland/scu/posnet
title: POSNET-Printer
---

# POSNET Printer

## Signature Creation Unit

### Support

**Status:** in development (preview) — tracked in [fiskaltrust/middleware#751](https://github.com/fiskaltrust/middleware/issues/751)

The _fiskaltrust.Middleware.SCU.PL.PosNet_ package connects the middleware with a **POSNET Online fiscal printer**. The printer is the certified register: it assigns the fiscal document numbers, owns the PTU (VAT) rate table and the daily (Z) reports, and transmits the fiscal data to the CRK. The SCU translates the middleware receipt into POSNET protocol commands and returns the register's identifiers on the response (see [Type of Signature: ftSignatureType](../../reference-tables/type-of-signature-ftsignaturetype.md)).

The SCU communicates with the printer over **TCP** using the POSNET Online protocol (framed, checksummed request/response exchange).

### Parameters

| Name | Description | Optional |
| ---- | ------------ |--------- |
| DeviceUrl | The address of the POSNET printer, e.g. `tcp://192.168.1.50:6666`. | mandatory |

Please pay attention to the case-sensitive use of the parameters.

:::info Preliminary

The parameter set is preliminary while the SCU is in development; timeout and connection-handling parameters will be documented with the first release.

:::

### Response handling — ambiguous outcomes

A POSNET command has three possible outcomes: **confirmed**, **confirmed with error** (an error code from the printer), or — when the connection or the printer times out — **ambiguous**: it is unknown whether the printer executed the command (and printed a fiscal document) or not.

The SCU never silently retries an ambiguous outcome, because a retry can produce duplicate fiscal printouts on the register. Instead the receipt fails with the register-unreachable state `0x504C_2001_EEEE_EEEE` (see [Service Status: ftState](../../reference-tables/service-status-ftstate.md)); the POS/operator must verify the device state (for example via a zero receipt) before sending the request again.

### Scope of the preview

The preview covers the POS sale receipt path (`0x0000`/`0x0001`/`0x0004`) and the register status read behind the zero receipt. Device fiscalization and one-time setup (header, VAT table) remain certified-technician (serwis) acts, and daily/periodic reports, returns and non-fiscal printouts are added iteratively — see [fiskaltrust/middleware#751](https://github.com/fiskaltrust/middleware/issues/751) for the current scope.

### Development without a device

For development and integration tests without a physical printer, the Polish sandbox provides a fake register with the same `IPLSSCD` behavior (used by the CloudCashbox sandbox and the developer sample) — no POSNET hardware is required to integrate against the Polish market.
