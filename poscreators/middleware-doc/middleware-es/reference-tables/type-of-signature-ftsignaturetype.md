---
slug: /poscreators/middleware-doc/spain/reference-tables/ftsignaturetype
title: 'Type of Signature: ftSignatureType'
---

# Type of Signature: ftSignatureType

The `ftSignatureType` indicates the type and origin of the signature. The data type is `Int64` and can contain a country-specific code, a value following the ISO-3166-1-ALPHA-2 standard, converted from ASCII into hex and used as byte 8 and 7.

For definitions regarding national laws, please refer to the appropriate appendix.

## Format

_CCCC_vlll_gggg_tsss

#### v - version
version 2

#### t - Type/Category

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0` | Uncategorized, Normal use (notification) | 1.3.45 |
| `1` | Information (notification), low priority | 1.3.45 |
| `2` | Alert (notification), high priority | 1.3.45 |
| `3` | Failure (notification), high priority | 1.3.45 |

*Table 1. Signature type/category values (t) for Spain.*

#### gggg - global flags

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
|  `0001` | Archiving required.<br />Signatures marked with this flag are known to be archived related to market specific bookkeeping requirements. In case of offline usage or pure open-source usage, receipts/artefacts having this flag need to be handled as bookkeeping/accounting-relevant item. | 1.3.45 |
|  `0010` | Printing/Visualization is optional. | 1.3.45 |
|  `0020` | Do not print/visualize. | 1.3.45 |
|  `0040` | Printed receipt only. | 1.3.45 |
|  `0080` | Digital receipt only. | 1.3.45 |

*Table 2. Global flag values (gggg) for Spain.*

#### sss - SignatureCase

| **Value** | **Description** | **Caption** | **Middleware Version** |
| --------- | --------------- | ----------- | ---------------------- |
| `000` | **Text items without a dedicated case**<br />Returned with the country code `ES` for the **TBAI identifier** (`TBAI-<NIF>-<ddMMyy>-<13 characters>-<CRC>`, TicketBAI queues) and without country code for the **VERI\*FACTU legend** (`Factura verificable en la Sede electrónica de la AEAT`, format text with position *before header*). Both must be printed. Messages of the provincial web service are returned with the *Information* category (`t` = `1`) and caption `Codigo <code>`. | *(empty)* / `Codigo <code>` | 1.3.45 |
| `001` | **Url (QR code)**<br />VERI\*FACTU: the AEAT verification URL (`…/wlpl/TIKE-CONT/ValidarQR?nif=…&numserie=…&fecha=…&importe=…`), format QR code with position *before header*. TicketBAI: the TicketBAI verification URL (`…/QRTBAI/?id=…&s=…&nf=…&i=…&cr=…`), format QR code. Must be printed as QR code. | `QR tributario:` (VERI\*FACTU) / `[www.fiskaltrust.es]` (TicketBAI) | 1.3.45 |
| `002` | **NIF**<br />The issuer NIF (*IDEmisorFactura*) of the transmitted VERI\*FACTU record; on cancellations the caption is `IDEmisorFacturaAnulada`. Part of the issuer data on the document. | `IDEmisorFactura` | 1.3.45 |
| `003` | **Signature**<br />The Base64 signature value of the XAdES signature of the TicketBAI file. Format Base64, flagged *Do not print* (`0020`). Used for the chaining of the next invoice and kept for audit. | `Signature` | 1.3.45 |
| `004` | **Huella**<br />The SHA-256 hash (*huella*) of the VERI\*FACTU record, 64 upper-case hex characters. Chained into the next record. Not required on the document. | `Huella` | 1.3.45 |
| `1 001` | **InitialOperationReceipt** (t = 1, flag `0001` archiving required)<br />Returned for the queue-start receipt (`4001`). | `Initial-operation receipt` | 1.3.45 |
| `1 002` | **OutOfOperationReceipt** (t = 1, flag `0001` archiving required)<br />Returned for the queue-stop receipt (`4002`). | `Out-of-operation receipt` | 1.3.45 |

*Table 3. SignatureCase values (sss) for Spain.*

Validation errors and rejections by the tax authority are returned as a single signature item with caption `FAILURE`, the *Failure* category (`t` = `3`) and the error text as data; the response then carries the error state (see [Service Status: ftState](service-status-ftstate.md)). Sandbox queues additionally return a text item with caption `S A N D B O X`. See [Receipt Printing](../receipt-printing/receipt-printing.md) for the print rules of every item.
