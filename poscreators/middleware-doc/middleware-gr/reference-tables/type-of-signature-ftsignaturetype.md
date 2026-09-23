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
| `001` | **PosReceipt**<br />The QR code of the document: the URL of the digital receipt rendered by fiskaltrust (`https://receipts.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}`, sandbox: `receipts-sandbox`). Format QR code. Mandatory on the printed document. | `[www.fiskaltrust.gr]` |
| `003` | **InitialOperationReceipt / OutOfOperationReceipt**<br />Returned on the queue lifecycle receipts (`4001`, `4002`) with the queue ID. | `Initial-operation receipt` / `Out-of-operation receipt` |
| `010` | **MyDataXML**<br />The full XML payload submitted to AADE myDATA, enriched with MARK, UID and authentication code, returned for reference/audit. Flagged *Do not print* (`0020`). | `mydata-xml` |
| `011` | **ProviderSignature**<br />The provider footer of the licensed eInvoicing provider the document was issued under. Returned as two items: the legal name of the licensee as caption with empty data, and the provider web address as caption with the licence identifier as data. Both must be printed at the bottom of the document. See [Licensing](../licensing/licensing.md#where-the-licence-appears-on-documents). | `VIVABANK ΑΝΩΝΥΜΗ ΤΡΑΠΕΖΙΚΗ ΕΤΑΙΡΕΙΑ` / `www.viva.com` |
| `012` | **UniqueDocumentIdentifier**<br />The human-readable document identifier, in the format `AFM \| Date \| Branch \| Type \| Series \| Serial` (date as `dd/MM/yyyy`). | `Μοναδικός αριθμός παραστατικού` |
| `013` | **Uid**<br />The `invoiceUid` — myDATA's unique hash identifier for the submitted document. | `invoiceUid` |
| `014` | **Mark**<br />The `invoiceMark` (MARK) — the unique registration number AADE assigns once the document is accepted. The queue commits the document number only when this item is present. | `invoiceMark` |
| `015` | **AuthenticationCode**<br />The authentication code returned by myDATA, allowing third parties to verify the document was registered by AADE. | `authenticationCode` |
| `016` | **TransmissionFailure**<br />Returned when the document was sent with the late-signing flag (`0001`) and transmitted with `transmissionFailure = 1` (loss of connection between the entity and the provider). Data: `Απώλεια Διασύνδεσης Οντότητας - Παρόχου`. Must be printed. | `Transmission Failure_1` |
| `017` | **MultipleConnectedMarks**<br />The comma-separated MARKs of the referenced documents, e.g. on a retail credit receipt (11.4) or a cancelled order (8.6). | *(empty)* |
| `018` | **OrderReceiptSignature**<br />Informational notice attached to an Order (8.6) slip, marking it as informational only and not a valid fiscal receipt (Greek and English text). Must be printed. | *(empty)* |
| `019` | **GenericMyDataInfo**<br />Further elements of the myDATA response that have no dedicated type, e.g. on the payment-method (`3005`) and cancellation calls. Flagged *Do not print* on document responses. | name of the myDATA element |
| `01A` | **QRCode**<br />The `qrUrl` returned by myDATA for the document. Flagged *Do not print* (`0020`); the QR code to print is item `001`. | `qrUrl` |
| `01B` | **HandwrittenSignature**<br />Link for a receipt recovered with the handwritten flag (`0008`). Format link, flagged *Do not print*. | *(empty)* |

*Table 3. ftSignatureType SignatureCase (sss) values.*

*Table 3. Greece-specific SignatureCase codes (sss) of the ftSignatureType field.*

The types `010`, `016`, `017`, `018`, `01A` and `01B` are returned since Middleware version 1.3.83. See [Receipt Printing](../receipt-printing/receipt-printing.md) for the print rules of every item.
