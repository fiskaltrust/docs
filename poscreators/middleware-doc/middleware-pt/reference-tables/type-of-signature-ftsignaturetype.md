---
slug: /poscreators/middleware-doc/portugal/reference-tables/ftsignaturetype
title: 'Type of Signature: ftSignatureType'
---

# Type of Signature: ftSignatureType

The `ftSignatureType` indicates the type and origin of the signature. The data type is `Int64` and can contain a country-specific code, a value following the ISO-3166-1-ALPHA-2 standard, converted from ASCII into hex and used as byte 8 and 7.

For definitions regarding national laws, refer to the appropriate appendix.

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

*Table 1. Type/Category (t) values of ftSignatureType for Portugal.*

#### gggg - global flags

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | Archiving required. <br />Signatures marked with this flag are known to be archived related to market specific bookkeeping requirements. In case of offline usage or pure open-source usage, receipts/artefacts having this flag need to be handled as bookkeeping/accounting-relevant item. | 1.3.45 |
| `0010` | Printing/Visualization is optional. | 1.3.45 |
| `0020` | Do not print/visualize. | 1.3.45 |
| `0040` | Printed receipt only. | 1.3.45 |
| `0080` | Digital receipt only. | 1.3.45 |

*Table 2. Global flag (gggg) values of ftSignatureType for Portugal.*

#### sss - SignatureCase

| **Value** | **Description** | **Caption** |
| --------- | --------------- | ----------- |
| `001` | **PosReceipt (QR code)**<br />QR code content according to *Portaria n.º 195/2020*. Format: QR code. The caption contains the URL of the digital receipt. Must be printed. | Digital receipt URL |
| `010` | **ATCUD**<br />`ATCUD: <validation code>-<number>`. Must be printed on every page. | *(empty)* |
| `012` | **Hash**<br />Full document hash. Flagged *Do not print*; kept for audit purposes. | `Hash` |
| `013` | **HashPrint**<br />Reserved for the four hash characters (positions 1, 11, 21, 31). Currently returned as part of `014`. | |
| `014` | **CertificationNo**<br />`<4 hash characters> - Processado por programa certificado n.º 3535/AT`. Must be printed exactly as returned. | `-----` |
| `015` | **ReferenceForCreditNote**<br />Reference to the source document: `Referencia: <document>` on invoices created from working documents, and `Razão: Devolução` with caption `Referencia <document>` on credit notes. Must be printed when returned. | *(empty)* or `Referencia <document>` |
| `016` | **PTAdditional**<br />Additional mandatory texts: `IVA incluido`, `Consumidor final`, `Origem: <document>`, `Este documento não serve de fatura` (working documents), `Cópia do documento original - FTM <series>/<number>` (manual documents). Must be printed when returned. | *(empty)* |
| `1 001` | **InitialOperationReceipt** (t = 1, flag `0001` archiving required)<br />Returned for the queue-start receipt. | `Initial-operation receipt` |
| `1 002` | **OutOfOperationReceipt** (t = 1, flag `0001` archiving required)<br />Returned for the queue-stop receipt. | `Out-of-operation receipt` |

*Table 3. SignatureCase (sss) values of ftSignatureType for Portugal.*

See [Receipt Printing](../receipt-printing/receipt-printing.md) for the print requirements of each signature item.
