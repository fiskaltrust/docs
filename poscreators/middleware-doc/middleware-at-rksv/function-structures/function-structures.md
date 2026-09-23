---
slug: /poscreators/middleware-doc/austria/function-structures
title: Function Structures
---

# Function Structures

This page describes the Austria-specific behaviour of the functions covered in ["Function Structures"](../../general/function-structures/function-structures.md) of the General Part. The code samples and the timestamp format are described there and are not repeated here; the protocols are described in [Communication](../communication/communication.md) and the terms used on this page in [Terminology](../terminology/terminology.md).

The behaviour described is that of Middleware 1.2, the version used by Austrian customers. Where the 1.3 preview of the Austrian Middleware behaves differently, this is noted.

## iPOS Interface

### Echo Function

`string Echo(string message)` returns the transferred message unchanged. Use it to check that the Queue can be reached.

In the hosted fiskaltrust.SignatureCloud, calling Echo with an empty or `null` message additionally makes the service discard the Queue instance it holds in memory, so that the Queue is started again with the current CashBox configuration - for example after the configuration has been rebuilt in the fiskaltrust.Portal. A locally installed Middleware has no such special case and returns the message unchanged.

### Sign Function

`ReceiptResponse Sign(ReceiptRequest data)` processes a receipt according to the RKSV and returns the data that has to be printed on the receipt.

- **Request:** the Queue must be configured for the Austrian market, and `cbReceiptCase` must carry the Austrian country code `0x4154` in its highest bytes (`0x4154_0000_0000_xxxx`). The available receipt cases are listed in the reference table ["Type of Receipt: ftReceiptCase"](../reference-tables/reference-tables-v0.md#type-of-receipt-ftreceiptcase); how to use them is described in [Receipt Case Definitions](../receipt-case-definitions/receipt-case-definitions.md).
- **Response:** the Austria-specific fields of the Receipt Response, such as `ftCashBoxIdentification`, `ftReceiptIdentification` and the signature entries, are described in [Data Structures](../data-structures/data-structures.md#receipt-response).
- **Errors:** if the request cannot be processed, the call fails with an error (SOAP fault or HTTP error response) instead of returning a Receipt Response. The state of the Queue and the SCU is reported in `ftState`, see the reference table ["Service Status: ftState"](../reference-tables/reference-tables-v0.md#service-status-ftstate); how to handle a failed signature creation device is described in [Signature Creation Device Failure](../cash-register-integration/cash-register-integration.md#signature-creation-device-failure).

### Journal Function

`Stream Journal(long ftJournalType, long from, long to)` returns the requested journal as a stream. `from` and `to` are [.NET Ticks](../../general/function-structures/function-structures.md#timestamps) in UTC. For serial or TCP connections, the journal call of the stream helper is described in [Communication](../communication/communication.md#serial-stream-or-tcp-stream-helper).

The following values of `ftJournalType` are specific to the Austrian market:

| **Value**            | **Description**                                                                                                                                                                 |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `0x4154000000000000` | Status information of the Queue as JSON, containing `QueueATList` and `SignaturCreationUnitATList`. In the 1.3 preview, only `QueueATList` is returned. |
| `0x4154000000000001` | RKSV-DEP export (DEP-7), see [RKSV-DEP Export](#rksv-dep-export).                                                                                                                |

*Table 1. Austria-specific values of ftJournalType (AT - RKSVO).*

Any other value starting with `0x4154` returns the same status information as `0x4154000000000000`. The values are also listed in the reference table ["Type of Journal: ftJournalType"](../reference-tables/reference-tables-v0.md#type-of-journal-ftjournaltype).

If the journal cannot be created, the call fails with an error (SOAP fault or HTTP error response). In the 1.3 preview, a failed RKSV-DEP export is only logged and the returned stream is empty, so an empty export has to be treated as a failure.

## RKSV-DEP Export

The `ftJournalType` `0x4154000000000001` returns the data collection log according to §7 RKSV (RKSV-DEP, also called DEP-7, see [Terminology](../terminology/terminology.md)). It is required to provide the data at the cash register in case of an inspection, for example by the tax authority.

The export contains all receipts recorded in the data collection log between `from` and `to`. In Middleware 1.2, `to = 0` exports up to the latest entry. The export is a JSON document with the following structure:

| **Field**                | **Description**                                                                                  |
|--------------------------|--------------------------------------------------------------------------------------------------|
| `Belege-Gruppe`          | List of receipt groups.                                                                          |
| `Kassen-ID`              | Cash register identification number (`ftCashBoxIdentification`).                                |
| `Signaturzertifikat`     | Base64-encoded signature certificate of the signature creation device used for the receipts.     |
| `Zertifizierungsstellen` | Certificates of the certification authorities. The Middleware exports an empty list.             |
| `Belege-kompakt`         | The signed receipts in JWS compact serialization, in order of the receipt number.                |

*Table 2. Structure of the RKSV-DEP export (AT - RKSVO).*

If more than one signature creation device signed receipts in the requested period, the receipts are exported in one group without a certificate, followed by one group per used certificate without receipts.

The retention period and how the PosOperator creates and stores exports are described in [Data Collection Log](../cash-register-integration/cash-register-integration.md#data-collection-log).

### Monthly backup file

After a monthly receipt has been processed, the Queue additionally writes a backup of the RKSV-DEP to its service folder. The backup covers the period since the previous monthly receipt. It is enabled by default and can be disabled in the Queue configuration (`atmonthlyexport`; `EnableMonthlyExport` in the 1.3 preview).

The file name is composed as follows:

`{ftQueueATId}_{yyyyMMddhhmmssfff}_{CashBoxIdentification}_{LastSettlementMonth:00}_rksv_dep.json`

- `ftQueueATId` is the ID of the Queue.
- `yyyyMMddhhmmssfff` is the local time at which the file was created. `hh` is the hour on a 12-hour clock, without an AM/PM marker.
- `CashBoxIdentification` is the cash register identification number (`Kassen-ID`), not the ID of the CashBox.
- `LastSettlementMonth` is the monthly receipt counter of the Queue, with two digits.

The file name is not returned to the POS system.

## IATSSCD Interface

The IATSSCD interface is the internal interface between the Queue and the SCU. The Queue calls it for every receipt it signs, and each Austrian SCU package implements it for the signature creation device (SSCD) it drives - see [Operation Modes](../operation-modes/operation-modes.md). POS systems use the iPOS interface described above and do not call IATSSCD.

| **v0 member**                | **v1 member**                                      | **Returns**                                                                                                                         | **Use by the Queue**                                                                                     |
|------------------------------|----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| `string ZDA()`               | `Task<ZdaResponse> ZdaAsync()`                     | Short name of the certificate service provider (ZDA; the current RKSV uses VDA, see [Terminology](../terminology/terminology.md)). | Second field of the machine-readable code (`_R1-<ZDA>_…`).                                               |
| `byte[] Certificate()`       | `Task<CertificateResponse> CertificateAsync()`     | Signature certificate of the signature creation device.                                                                            | Certificate serial number in the machine-readable code; `Signaturzertifikat` in the RKSV-DEP export.     |
| `byte[] Sign(byte[] data)`   | `Task<SignResponse> SignAsync(SignRequest)`        | Signature over the transferred data (`SignRequest.Data` → `SignResponse.SignedData`).                                              | Signs the JWS header and payload of each receipt.                                                        |
| `string Echo(string message)`| `Task<EchoResponse> EchoAsync(EchoRequest)`        | The test message (communication test).                                                                                              | Connectivity check; Middleware 1.2 calls it when it connects to an SCU.                                  |

*Table 3. Members of the IATSSCD interface (AT - RKSVO).*

The v0 interface additionally provides a `Begin…`/`End…` pair for each member. The v1 interface extends v0. Middleware 1.2 uses the [v0 interface](https://github.com/fiskaltrust/middleware-interface-dotnet/blob/master/src/fiskaltrust.ifPOS/v0/at/IATSSCD.cs); the 1.3 preview uses the [v1 interface](https://github.com/fiskaltrust/middleware-interface-dotnet/blob/master/src/fiskaltrust.ifPOS/v1/at/IATSSCD.cs) and calls its v0 members.
