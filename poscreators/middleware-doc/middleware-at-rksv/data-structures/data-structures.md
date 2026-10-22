---
slug: /poscreators/middleware-doc/austria/data-structures
title: Data Structures
description: Austria-specific behaviour of the receipt request, receipt response, ftState and ftStateData, charge items, pay items and signature entries in the Middleware data structures, including the RKSV machine-readable code (QR code).
tags: [Austria, RKSV, Data Structures, Middleware]
---

# Data Structures

This chapter expands on the data structures described in [Data Structures](../../general/data-structures/data-structures.md) in the General Part, with the specifics of the Austrian market. Fields that are not mentioned here behave as described in the General Part.

The behaviour described on this page is that of the Austrian Queue in fiskaltrust.Middleware 1.2, which processes requests with the v0 case values. Requests sent through the PosSystem API (v2) are translated to these values before they reach the Queue, see the [Migration Guide (v0 to v2)](../../possystem-api/migration-guide.md). Where Middleware 1.3 behaves differently, this is noted.

## Receipt Request

The Austrian Queue does not add fields to the Receipt Request, but the following fields decide how a receipt is signed and counted.

| **Field Name**     | **Description** |
|--------------------|-----------------|
| `ftReceiptCase`    | Selects the type of receipt, see ["Basic receipts"](../cash-register-integration/cash-register-integration.md#basic-receipts) and ["Operational receipts"](../cash-register-integration/cash-register-integration.md#operational-receipts). The training and void flags change the machine-readable code, see [Machine-readable code](#machine-readable-code-qr-code). Late signing and handwritten receipts are closed by a zero receipt, which returns the range of receipts covered, see [Signature entries returned by the Queue](#signature-entries-returned-by-the-queue). |
| `cbReceiptMoment`  | Decides when a monthly or annual receipt is due and determines the time range covered by late signing and handwritten receipts. For a late signing or handwritten receipt, send the moment of the original transaction. The date and time in the machine-readable code are the processing time instead (`ftReceiptMoment`). |
| `cbChargeItems`    | Decide the amounts of the RKSV tax sets and the Umsatzzähler, see [Charge Items Entry](#charge-items-entry). |
| `cbPayItems`       | Together with the charge items, decide whether the receipt is signed, see [Pay Items Entry](#pay-items-entry). |

*Table 1. Receipt Request fields relevant for signing (AT - RKSVO)*

## Receipt Response

The following fields of the Receipt Response have Austria-specific content.

| **Field Name**            | **Description** |
|---------------------------|-----------------|
| `ftCashBoxIdentification` | The cash register identification number (Kassenidentifikationsnummer) in accordance with the RKSV. It is the CashBoxIdentification configured for the Queue in the fiskaltrust.Portal, which does not allow the characters `_`, `/` and `\`. It is part of the machine-readable code and of the RKSV-DEP, and it identifies the cash register in FinanzOnline. |
| `ftReceiptIdentification` | Starts with `ft`, the receipt counter of the Queue in hexadecimal and `#`. This receipt counter is not the same as `ftQueueRow` and can differ from it. For a signed receipt, the Queue appends its RKSV cash receipt counter, for example `ft1A3#42`; this complete value is the receipt number (Belegnummer) in the machine-readable code. For a receipt that is not signed, nothing is appended, for example `ft1A4#`. |

*Table 2. Receipt Response fields with Austria-specific content (AT - RKSVO)*

The Austrian Queue does not return `ftReceiptHeader`, `ftChargeItems`, `ftChargeLines`, `ftPayItems`, `ftPayLines` or `ftReceiptFooter`.

### ftState and ftStateData

The Austrian Queue returns `ftState` with every response. Its value starts with the Austrian country code `0x4154`, and the flags below are combined with OR. Through the PosSystem API (v2), the value also carries the version `2000`: a Queue without any flag set returns `0x4154_2000_0000_0000`, and a due monthly receipt returns `0x4154_2000_0000_0010`.

| **Flag** | **Meaning** | **Cleared by** |
|----------|-------------|----------------|
| `0x01` | The Queue has not been started yet, or it has been stopped. | Start receipt. A Queue stopped with a stop receipt cannot be started again. |
| `0x02` | The signature creation device failed for at least one receipt. | Zero receipt |
| `0x04` | The signature creation device has been failing for more than 48 hours; a FinanzOnline notification has been created. | Zero receipt |
| `0x08` | Late signing or handwritten receipts have been sent and are not yet closed. | Zero receipt |
| `0x10` | A monthly receipt is due. | Monthly receipt |
| `0x20` | An annual receipt is due. | Annual receipt |
| `0x40` | A message is pending (Middleware 1.2 only). | Zero receipt, which returns the message |
| `0x80` | The receipt was signed by a backup SCU. Middleware 1.2 sets this flag as soon as it tries a backup SCU, Middleware 1.3 only after a backup SCU has signed. | Set per response |

*Table 3. ftState flags of the Austrian Queue (AT - RKSVO)*

The Austrian Queue does not fill `ftStateData`, so the field is not included in the response. Only in the sandbox does it contain debugging information about the signing decision (through the PosSystem API (v2) under an `"AT"` key), which must not be relied on.

## Charge Items Entry

The charge items decide the amounts that the Queue adds up per RKSV tax set (normal, discounted-1, discounted-2, zero and special) for the signature, and the amount added to the Umsatzzähler.

The tax set is taken from the VAT part of `ftChargeItemCase`. Only when `ftChargeItemCase` does not specify a VAT type does the Queue fall back to `VATRate`: 20 is counted as normal, 10 as discounted-1, 13 as discounted-2, 0 as zero, and any other rate as special. Not own sales, including collections on account of a third party, and obligations without RKSV requirement are recorded in the zero tax set.

| **Field Name**     | **Description** |
|--------------------|-----------------|
| `Amount`           | Gross amount of the line; added to the tax set selected by `ftChargeItemCase`. |
| `ftChargeItemCase` | Selects the RKSV tax set through its VAT type. |
| `VATRate`          | Used to select the tax set only if `ftChargeItemCase` does not specify a VAT type. |
| `Description`      | The Austrian Queue does not use or validate its content, and it is not part of the machine-readable code. |

*Table 4. Charge Items Entry fields relevant for signing (AT - RKSVO)*

## Pay Items Entry

The Austrian Queue does not add fields to the Pay Items Entry. The `ftPayItemCase` of each pay item decides whether it counts as a cash payment: unknown payment types, cash in national or foreign currency, crossed cheques, debit and credit cards, vouchers, online payments and customer cards do; all other payment types, such as receivables, transfers and cash book entries, do not. Together with the types of service in the charge items, this decides whether the receipt is signed and counted.

## Signature Entry

The fields of a signature entry are described in [SignatureItem](../../general/data-structures/data-structures.md#signatureitem) in the General Part; the Austrian Queue returns the following entries.

### Signature entries returned by the Queue

| **Returned for** | **Caption** | **Data** | **Format** | **Type** |
|------------------|-------------|----------|------------|----------|
| Signed receipt | `www.fiskaltrust.at` | Machine-readable code, see below | QR code | Signature according to RKSV |
| Receipt that could not be signed because the signature creation device failed | `Sicherheitseinrichtung ausgefallen` | Machine-readable code, with the signature value the RKSV prescribes for a failed signature creation device | QR code | Signature according to RKSV |
| Every receipt while the Queue is in signature creation device failure mode (Middleware 1.2 only) | `Sicherheitseinrichtung ausgefallen` | `Sicherheitseinrichtung ausgefallen` | Text | Signature according to RKSV |
| Start receipt / stop receipt (Schlussbeleg) | `Startbeleg` / `Stopbeleg` | `Startbeleg` / `Stopbeleg` | Text | Archiving required |
| Monthly receipt / annual receipt | `Monatsbeleg #<month>` / `Jahresbeleg` | Current value of the Umsatzzähler | Text | Archiving required |
| Zero receipt that closes a period of late signing or handwritten receipts, or a failure of the signature creation device | `Mobil-Nacherfassung` (handwritten receipts), `Ausfall-Nacherfassung` (late signing receipts) or `Sammelbeleg` | Range of receipts covered (`von <first ftReceiptIdentification> bis <ftReceiptIdentification of the zero receipt>`) | Text | Archiving required |
| Zero receipt, while FinanzOnline notifications are pending | Description of the notification | Notification data, to execute the FinanzOnline notification manually, for example in offline or pure open-source setups | AZTEC (2D code) | FinanzOnline notification; other pending messages are returned with the type unknown |
| Response while a message is pending (Middleware 1.2 only) | `fiskaltrust-Meldung anstehend` | `Null-Beleg erstellen` - send a zero receipt to retrieve the message | Text | Information |

*Table 5. Signature entries returned by the Austrian Queue (AT - RKSVO)*

The receipts listed here are described in ["Receipt for special functions"](../cash-register-integration/cash-register-integration.md#receipt-for-special-functions).

### Machine-readable code (QR code)

The Middleware returns the machine-readable code ready to encode in one signature item. You do not need to assemble it yourself. The signature item has:

- `ftSignatureFormat` `0x03` (QR code)
- `ftSignatureType` `0x4154000000000001` (AT RKSV)
- `Caption` `www.fiskaltrust.at`
- `Data`: the complete machine-readable code according to the RKSV

Encode the content of `Data` unchanged as a QR code and print it on the receipt. If the signature creation device has failed, the Middleware returns the same kind of signature item with the caption `Sicherheitseinrichtung ausgefallen`; print it in the same way, exactly as returned.

The `Data` of the RKSV signature contains the machine-readable code required by the RKSV. Its fields are separated by `_`:

```
_R1-<ZDA>_<Kassen-ID>_<Belegnummer>_<Beleg-Datum-Uhrzeit>_<Betrag-Satz-Normal>_<Betrag-Satz-Ermaessigt-1>_<Betrag-Satz-Ermaessigt-2>_<Betrag-Satz-Null>_<Betrag-Satz-Besonders>_<Stand-Umsatz-Zaehler-AES256-ICM>_<Zertifikat-Seriennummer>_<Sig-Voriger-Beleg>_<Signaturwert>
```

| **Field** | **Content** |
|-----------|-------------|
| `R1-<ZDA>` | Algorithm identifier and the short name of the certification service provider (ZDA; the current RKSV uses VDA, see [Terminology](../terminology/terminology.md)) that issued the certificate of the signature creation device. |
| `Kassen-ID` | `ftCashBoxIdentification`. |
| `Belegnummer` | `ftReceiptIdentification`, for example `ft1A3#42`. |
| `Beleg-Datum-Uhrzeit` | `ftReceiptMoment` (the processing time) in Austrian local time, format `yyyy-MM-ddTHH:mm:ss`. |
| `Betrag-Satz-…` | The gross amounts per tax set, see [Charge Items Entry](#charge-items-entry), with a decimal comma (for example `0,00`). |
| `Stand-Umsatz-Zaehler-AES256-ICM` | The Umsatzzähler, encrypted with the AES key. For training receipts it is replaced by the Base64-encoded text `TRA`, for void receipts by `STO`. |
| `Zertifikat-Seriennummer` | Serial number of the signature certificate. |
| `Sig-Voriger-Beleg` | Chaining value: Base64 of the first 8 bytes of the SHA-256 hash of the previous receipt's signed data. |
| `Signaturwert` | The Base64-encoded signature value. |

*Table 6. Fields of the machine-readable code (AT - RKSVO)*

:::note Middleware 1.3

Middleware 1.3 formats `Beleg-Datum-Uhrzeit` in the local time of the host the Queue runs on instead of converting it to Austrian time.

:::
