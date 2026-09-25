---
slug: /poscreators/middleware-doc/austria/data-structures
title: Data Structures
description: Austria-specific fields of the receipt response, charge items, pay items and signature entries in the Middleware data structures.
tags: [Austria, RKSV, Data Structures, Middleware]
---

# Data Structures

This chapter expands on the data structures described in [Data Structures](../../general/data-structures/data-structures.md) in the General Part, with the specifics of the Austrian market. Fields that are not mentioned here behave as described in the General Part.

The behaviour described on this page is that of the Austrian Queue in fiskaltrust.Middleware 1.2, which processes requests with the v0 case values. Requests sent through the PosSystem API (v2) are translated to these values before they reach the Queue, see the [Migration Guide (v0 to v2)](../../possystem-api/migration-guide.md). Where Middleware 1.3 behaves differently, this is noted.

## Receipt Request

The Austrian Queue does not add fields to the Receipt Request, but the following fields decide how a receipt is signed and counted.

| **Field Name**     | **Description** |
|--------------------|-----------------|
| `ftCashBoxID`      | Must be the ID of the CashBox the Queue belongs to; otherwise the request is rejected. |
| `ftReceiptCase`    | Selects the type of receipt, including the special receipts described in ["Receipt for special functions"](../cash-register-integration/cash-register-integration.md#receipt-for-special-functions). Its flags mark training receipts, void receipts and receipts entered subsequently after a failure or from handwritten receipts; these change the signature, see [Machine-readable code](#machine-readable-code-qr-code). |
| `cbReceiptMoment`  | The moment of the business transaction. It decides when a monthly or annual receipt is due and determines the time range covered by subsequently entered receipts. For a subsequently entered receipt, send the moment of the original transaction. The date and time in the machine-readable code are the processing time instead (`ftReceiptMoment`). |
| `cbChargeItems`    | Decide the amounts of the RKSV tax sets and the Umsatzzähler, see [Charge Items Entry](#charge-items-entry). |
| `cbPayItems`       | Decide whether the receipt is a cash transaction that must be signed, see [Pay Items Entry](#pay-items-entry). |

*Table 1. Receipt Request fields relevant for signing (AT - RKSVO)*

## Receipt Response

The following fields of the Receipt Response have Austria-specific content.

| **Field Name**            | **Data Type**     | **Default Value** | **Nullable** | **Description** |
|---------------------------|-------------------|-------------------|--------------|-----------------|
| `ftCashBoxIdentification` | `string`          | -                 | false        | The cash register identification number (Kassenidentifikationsnummer) in accordance with the RKSV. It is the CashBoxIdentification configured for the Queue in the fiskaltrust.Portal, which requires it to be unique within the account and does not allow the characters `_`, `/` and `\`. It is part of the machine-readable code and of the RKSV-DEP, and it identifies the cash register in FinanzOnline. |
| `ftReceiptIdentification` | `string`          | -                 | false        | Starts, as in all markets, with `ft`, the row number of the Queue in hexadecimal and `#`. For a signed receipt, the Queue appends its cash receipt counter, for example `ft1A3#42`; this complete value is the receipt number (Belegnummer) in the machine-readable code. For a receipt that is not signed, nothing is appended, for example `ft1A4#`. |
| `ftSignatures`            | `SignatureItem[]` | `[]`              | false        | The signature entries to print on the receipt, see [Signature Entry](#signature-entry). |

*Table 2. Receipt Response fields with Austria-specific content (AT - RKSVO)*

The Austrian Queue does not return `ftReceiptHeader`, `ftChargeItems`, `ftChargeLines`, `ftPayItems`, `ftPayLines` or `ftReceiptFooter`. The POS system prints the receipt from its own data and adds the returned signature entries, see ["Receipt structure"](../cash-register-integration/cash-register-integration.md#receipt-structure).

## Charge Items Entry

The charge items decide the amounts that the Queue adds up per RKSV tax set (normal, discounted-1, discounted-2, zero and special) for the signature, and the amount added to the Umsatzzähler.

The tax set is taken from the VAT part of `ftChargeItemCase`. Only when `ftChargeItemCase` does not specify a VAT type does the Queue fall back to `VATRate`: 20 is counted as normal, 10 as discounted-1, 13 as discounted-2, 0 as zero, and any other rate as special. Some types of service, such as not own sales and obligations, are recorded in the zero tax set without increasing the Umsatzzähler.

| **Field Name**     | **Data Type**      | **Default Value** | **Nullable** | **Description** |
|--------------------|--------------------|-------------------|--------------|-----------------|
| `Amount`           | `number($decimal)` | 0                 | false        | Gross amount of the line; added to the tax set selected by `ftChargeItemCase`. |
| `ftChargeItemCase` | `integer($uint64)` | 0                 | false        | Selects the RKSV tax set through its VAT type. |
| `VATRate`          | `number($decimal)` | 0                 | false        | Used to select the tax set only if `ftChargeItemCase` does not specify a VAT type. |
| `Description`      | `string`           | -                 | false        | Customary description of the goods or type of the service. It is mandatory in the interface and required on the receipt by §132a para. 3 Z 4 BAO, see ["Charge Items Block"](../cash-register-integration/cash-register-integration.md#charge-items-block). The Queue does not validate its content. |

*Table 3. Charge Items Entry fields relevant for signing (AT - RKSVO)*

## Pay Items Entry

The Austrian Queue does not add fields to the Pay Items Entry. The `ftPayItemCase` of each pay item decides whether the receipt is a cash transaction (Barumsatz) under the RKSV and therefore has to be signed: cash, crossed cheques, card, voucher, online and customer card payments count as cash transactions; receivables and transfers do not.

## Signature Entry

The Austrian Queue returns the signature entries described in [SignatureItem](../../general/data-structures/data-structures.md#signatureitem) in the General Part; the fields and their data types are the same. A response can contain several signature entries, and the POS system must print each of them in the format given by `ftSignatureFormat`, see ["Signature Block"](../cash-register-integration/cash-register-integration.md#signature-block).

### Signature entries returned by the Queue

| **Returned for** | **Caption** | **Data** | **Format** | **Type** |
|------------------|-------------|----------|------------|----------|
| Signed receipt | `www.fiskaltrust.at` | Machine-readable code, see below | QR code | Signature according to RKSV |
| Receipt that could not be signed because the signature creation device failed | `Sicherheitseinrichtung ausgefallen` | Machine-readable code, with the signature value the RKSV prescribes for a failed signature creation device | QR code | Signature according to RKSV |
| Every receipt while the Queue is in signature creation device failure mode (Middleware 1.2 only) | `Sicherheitseinrichtung ausgefallen` | `Sicherheitseinrichtung ausgefallen` | Text | Signature according to RKSV |
| Start receipt / stop receipt | `Startbeleg` / `Stopbeleg` | `Startbeleg` / `Stopbeleg` | Text | Archiving required |
| Monthly receipt / annual receipt | `Monatsbeleg #<month>` / `Jahresbeleg` | Current value of the Umsatzzähler | Text | Archiving required |
| Zero receipt that closes a period of subsequently entered receipts or a failure | `Mobil-Nacherfassung` (handwritten receipts), `Ausfall-Nacherfassung` (receipts entered after a failure) or `Sammelbeleg` | Time range covered (`von … bis …`) | Text | Archiving required |
| FinanzOnline notification | Description of the notification | Notification data, to execute the FinanzOnline notification manually, for example in offline or pure open-source setups | AZTEC (2D code) | FinanzOnline notification |
| Response while a message is pending (Middleware 1.2 only) | `fiskaltrust-Meldung anstehend` | `Null-Beleg erstellen` - send a zero receipt to retrieve the message | Text | Information |

*Table 4. Signature entries returned by the Austrian Queue (AT - RKSVO)*

The receipts listed here are described in ["Receipt for special functions"](../cash-register-integration/cash-register-integration.md#receipt-for-special-functions).

### Machine-readable code (QR code)

The `Data` of the RKSV signature contains the machine-readable code required by the RKSV. Its fields are separated by `_`:

```
_R1-<ZDA>_<Kassen-ID>_<Belegnummer>_<Beleg-Datum-Uhrzeit>_<Betrag-Satz-Normal>_<Betrag-Satz-Ermaessigt-1>_<Betrag-Satz-Ermaessigt-2>_<Betrag-Satz-Null>_<Betrag-Satz-Besonders>_<Stand-Umsatz-Zaehler-AES256-ICM>_<Zertifikat-Seriennummer>_<Sig-Voriger-Beleg>_<Signaturwert>
```

| **Field** | **Content** |
|-----------|-------------|
| `R1-<ZDA>` | Algorithm identifier and the short name of the certificate service provider of the signature creation device. |
| `Kassen-ID` | `ftCashBoxIdentification`. |
| `Belegnummer` | `ftReceiptIdentification`, for example `ft1A3#42`. |
| `Beleg-Datum-Uhrzeit` | `ftReceiptMoment` (the processing time) in Austrian local time, format `yyyy-MM-ddTHH:mm:ss`. |
| `Betrag-Satz-…` | The gross amounts per tax set, see [Charge Items Entry](#charge-items-entry), with a decimal comma (for example `0,00`). |
| `Stand-Umsatz-Zaehler-AES256-ICM` | The Umsatzzähler, encrypted with the AES key. For training receipts it is replaced by the Base64-encoded text `TRA`, for void receipts by `STO`. |
| `Zertifikat-Seriennummer` | Serial number of the signature certificate. |
| `Sig-Voriger-Beleg` | Chaining value: Base64 of the first 8 bytes of the SHA-256 hash of the previous receipt's signed data. |
| `Signaturwert` | The Base64-encoded signature value. |

*Table 5. Fields of the machine-readable code (AT - RKSVO)*

:::note Middleware 1.3

Middleware 1.3 formats `Beleg-Datum-Uhrzeit` in the local time of the host the Queue runs on instead of converting it to Austrian time.

:::
