---
slug: /poscreators/middleware-doc/greece/reference-tables/ftsignaturetype
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

*Table 1. ftSignatureType type/category (t) values.*

#### gggg - global flags

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | Archiving required. <br />Signatures marked with this flag are known to be archived related to market specific bookkeeping requirements. In case of offline usage or pure open-source usage, receipts/artefacts having this flag need to be handled as bookkeeping/accounting-relevant item. | 1.3.45 |
| `0010` | Printing/Visualization is optional. | 1.3.45 |
| `0020` | Do not print/visualize. | 1.3.45 |
| `0040` | Printed receipt only. | 1.3.45 |
| `0080` | Digital receipt only. | 1.3.45 |

*Table 2. ftSignatureType global flags (gggg) values.*

#### sss - SignatureCase

| **Value** | **Description** | **Caption** |
| --------- | --------------- | ----------- |
| `001` | Primary compliance signature for a standard POS receipt/invoice. | |
| `010` | **MyDataXML**<br />The full XML payload submitted to AADE myDATA, returned for reference/audit. | |
| `011` | **ProviderSignature**<br />The e-invoice provider's signature attached to the transmitted document (e.g. the Viva Fiscal provider signature). | |
| `012` | **UniqueDocumentIdentifier**<br />The human-readable document identifier, in the format `AFM \| Date \| Branch \| Type \| Series \| Serial`. | |
| `013` | **Uid**<br />The `invoiceUid` — myDATA's unique hash identifier for the submitted document. | |
| `014` | **Mark**<br />The `invoiceMark` (MARK) — the unique registration number AADE assigns once the document is accepted. | [www.fiskaltrust.gr] |
| `015` | **AuthenticationCode**<br />The authentication code returned by myDATA, allowing third parties to verify the document was registered by AADE. | |
| `016` | **TransmissionFailure**<br />Marks that the document could not be transmitted to myDATA (e.g. a network or AADE API failure). | |
| `017` | **MultipleConnectedMarks**<br />Correlates a retail credit receipt (11.4) to the multiple original MARKs it refunds. | |
| `018` | **OrderReceiptSignature**<br />Informational signature attached to an Order (8.6) receipt, marking it as informational only and not a valid fiscal receipt. | |
| `019` | **GenericMyDataInfo**<br />General informational metadata about the myDATA submission. | |
| `01A` | **QRCode**<br />The QR code linking to the digital receipt/document, built from the configured `receiptBaseAddress` plus the queue and queue-item id. | |
| `01B` | **HandwrittenSignature**<br />Signature/marker for a handwritten (offline) receipt. | |

*Table 3. ftSignatureType SignatureCase (sss) values.*
