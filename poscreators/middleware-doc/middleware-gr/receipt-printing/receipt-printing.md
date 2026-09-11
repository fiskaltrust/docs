---
slug: /poscreators/middleware-doc/greece/receipt-printing
title: Receipt Printing
---

# Receipt Printing

In Greece the receipt or invoice handed to the customer must carry the identifiers that myDATA assigned to the document and the identification of the licensed provider that issued it. The Middleware transmits the document, receives these identifiers and returns everything that must appear on the document in the `ftSignatures` of the response. The fiskaltrust.Middleware for Experience renders this into the digital receipt behind the QR code (`https://receipts.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}`, the `receipts-sandbox` host in the sandbox, or a partner-specific receipt host configured for the queue) and into the ESC-POS stream of the `/issue` endpoint.

This page describes which elements the document must contain and which signature items carry them, so that PosCreators who print the document themselves know what to print and which values they must never alter. The requirements follow law 4308/2014 (art. 12 to 15, content of invoices and retail receipts), *Α.1138/2020* (myDATA), *Α.1155/2023* and *Α.1048/2024* (terminal interconnection and payment data) and *Α.1112/2025* (provider footer). See [Licensing](../licensing/licensing.md) for the licence under which the documents are issued.

:::tip Use the digital receipt

The QR code signature item carries the URL of the digital receipt rendered by fiskaltrust. This rendering contains all the elements listed below, including the provider footer, the EFTPOS data of card payments and the informational notice of order slips. Handing out this document, or the ESC-POS stream from `/issue`, is the simplest way to be complete.

:::

## Mandatory content of a document

Every fiscal document (retail receipts 11.x, invoices 1.x and 2.x, credit documents 5.x and 11.4, POS receipts 8.4 and 8.5, delivery notes 9.3) contains the following elements. The Middleware transmits what it received in the request, so the data you send is the data in myDATA.

| Element | Source | Notes |
| ------- | ------ | ----- |
| Issuer | Master data | Company name, address, VAT number (ΑΦΜ) and branch of the issuer, as configured in the account and outlet master data of the fiskaltrust.Portal; further header data required by law 4308/2014 (e.g. tax office, activity) from the POS master data. |
| Document type and designation | Derived from `ftReceiptCase` | Print the Greek designation of the myDATA type, e.g. *Απόδειξη Λιανικής Πώλησης* (11.1), *Απόδειξη Παροχής Υπηρεσιών* (11.2), *Τιμολόγιο Πώλησης* (1.1), *Πιστωτικό Στοιχείο Λιανικής* (11.4). The type code is contained in the unique document identifier. |
| Series and number | `ftReceiptIdentification` | The part after the `#`, e.g. `ft2A#ftCashBox01-17` (series, sequential number). Print it unchanged. |
| Unique document identifier | Signature item `UniqueDocumentIdentifier` | Caption *Μοναδικός αριθμός παραστατικού*, data `AFM\|dd/MM/yyyy\|branch\|type\|series\|aa`. |
| Date and time | `cbReceiptMoment` | In Greek local time (the Middleware converts UTC to Europe/Athens for myDATA). |
| Customer | `cbCustomer` | Name, address, VAT number and country on invoices. Retail receipts carry no customer. |
| Line items | `cbChargeItems` | Quantity, description, unit, net value, VAT category and VAT amount per line; the exemption reason for 0 % lines. Special taxes (fees, withholding, stamp duty) with their Greek description. |
| Totals | Request | Net total, VAT total, withholding, fees, stamp duty, other taxes and gross total, as transmitted in the myDATA summary. |
| Payments | `cbPayItems` | Payment method and amount. For card payments through an interconnected terminal additionally the **payment signature**, the **AADE transaction ID** (unique payment ID), the **amount including tip** and the **tip**, for every terminal payment of the document. |
| MARK | Signature item `Mark` | Caption `invoiceMark`, data the registration number assigned by myDATA. |
| UID | Signature item `Uid` | Caption `invoiceUid`, data the myDATA hash identifier of the document. |
| Authentication code | Signature item `AuthenticationCode` | Caption `authenticationCode`, data the code that allows third parties to verify the registration. |
| QR code | Signature item `PosReceipt` (format QR code) | Caption `[www.fiskaltrust.gr]`, data the URL of the digital receipt. Render the data as a QR code. |
| Provider footer | Two signature items `ProviderSignature` | Legal name of the licensee, provider web address and licence identifier, in this order, each on its own line (see [Licensing](../licensing/licensing.md#where-the-licence-appears-on-documents)). |
| Loss-of-connection notice | Signature item `TransmissionFailure` | *Απώλεια Διασύνδεσης Οντότητας - Παρόχου*, returned on receipts sent with the late-signing flag. Must be printed. |
| Connected marks | Signature item `MultipleConnectedMarks` | The MARKs of the original documents on retail credit receipts (11.4). |
| Informational notice | Signature item `OrderReceiptSignature` | *ΤΟ ΠΑΡΟΝ ΕΙΝΑΙ ΠΛΗΡΟΦΟΡΙΑΚΟ ΣΤΟΙΧΕΙΟ ΚΑΙ ΔΕΝ ΑΠΟΤΕΛΕΙ ΝΟΜΙΜΗ ΦΟΡΟΛΟΓΙΚΗ ΑΠΟΔΕΙΞΗ/ΤΙΜΟΛΟΓΙΟ* (with English translation) on order slips (8.6). Must be printed. |
| Transport details | `ftReceiptCaseData` | Dispatch date and time, vehicle, loading and delivery address and purpose of movement on delivery notes (9.3) and on sale documents that are also delivery notes. |

Additional layout rules:

- **Language.** The mandatory designations and notices are Greek. A bilingual layout is allowed.
- **EFTPOS data.** The payment signature, the AADE transaction ID, the amount including tip and the tip amount are mandatory on every document paid through an interconnected terminal, for each terminal payment. The Middleware transmits them to myDATA from `ftPayItemCaseData`; the POS prints them from the terminal response it already holds. Further terminal data (terminal ID, authorisation ID, transaction time) may be printed but is not mandatory.
- **Order slips are not receipts.** An order slip (8.6) must show the informational notice and must not look like a fiscal receipt.
- **Handwritten receipts.** A receipt recovered with the handwritten flag is transmitted with the series and number of the paper document; the response carries a link signature item that is not printed.

## Signature items returned by the Middleware

The Middleware returns the following Greece-specific signature items. The `ftSignatureType` values are listed in the [Type of Signature: ftSignatureType](../reference-tables/type-of-signature-ftsignaturetype.md) reference table; the market-specific part is the last three hex digits (`sss`).

| Signature type (sss) | Caption | Data | Format | Print |
| -------------------- | ------- | ---- | ------ | ----- |
| `001` PosReceipt | `[www.fiskaltrust.gr]` | URL of the digital receipt | QR code | **Mandatory** as QR code. |
| `003` InitialOperationReceipt / OutOfOperationReceipt | `Initial-operation receipt` / `Out-of-operation receipt` | `Queue-ID: <id>` | Text | Lifecycle receipt; keep with the bookkeeping records. |
| `010` MyDataXML | `mydata-xml` | The complete myDATA XML of the document, including MARK, UID and authentication code | Text, flagged *Do not print* | Not printed. Keep for audit and for exports. |
| `011` ProviderSignature | `VIVABANK ΑΝΩΝΥΜΗ ΤΡΑΠΕΖΙΚΗ ΕΤΑΙΡΕΙΑ` (data empty), then `www.viva.com` | *(empty)*, then `2024_12_126VIVA_001_ Viva Fiscal_V1_23122024` | Text | **Mandatory**, both items, caption line followed by data line, at the bottom of the document. |
| `012` UniqueDocumentIdentifier | `Μοναδικός αριθμός παραστατικού` | `AFM\|dd/MM/yyyy\|branch\|type\|series\|aa` | Text | **Mandatory**. |
| `013` Uid | `invoiceUid` | myDATA UID | Text | **Mandatory**. |
| `014` Mark | `invoiceMark` | MARK | Text | **Mandatory**. |
| `015` AuthenticationCode | `authenticationCode` | Authentication code | Text | **Mandatory**. |
| `016` TransmissionFailure | `Transmission Failure_1` | `Απώλεια Διασύνδεσης Οντότητας - Παρόχου` | Text | **Mandatory** when returned. |
| `017` MultipleConnectedMarks | *(empty)* | Comma-separated MARKs of the referenced documents | Text | **Mandatory** when returned (retail credit receipts). |
| `018` OrderReceiptSignature | *(empty)* | Informational notice for order slips | Text | **Mandatory** on order slips. |
| `019` GenericMyDataInfo | Name of the myDATA response element | Further values returned by myDATA (e.g. on payment-method and cancellation calls) | Text, flagged *Do not print* on document responses | Not printed unless the flag is absent. |
| `01A` QRCode | `qrUrl` | The QR URL returned by myDATA | QR code, flagged *Do not print* | Not printed; the QR code of the document is item `001`. |
| `01B` HandwrittenSignature | *(empty)* | Link for the recovered handwritten document | Link, flagged *Do not print* | Not printed. |

The recommended print order is: header with issuer, document type, series and number, date and time, customer, line items, totals, payments with EFTPOS data, then the unique document identifier, MARK, UID and authentication code, the QR code, the notices returned as text signature items, and the provider footer as the last lines. A signature item whose `ftSignatureType` carries the *Do not print* flag (`0x0020`) must not be visualised.

## Refunds, cancellations and copies

- **Retail credit receipt (11.4).** Send the POS receipt with the refund flag (`0x0100`) and `cbPreviousReceiptReference` to the original receipt. The response carries the MARKs of the originals as connected marks, which are printed.
- **Credit note (5.1 / 5.2).** Send the invoice case with the refund flag; with a reference to the original invoice a correlated credit note is issued, without reference a non-correlated one. The original MARK is transmitted as correlated invoice.
- **Order cancellation (8.6).** Send the order with the void flag (`0x0004`), a reference to the original order and the table number in `cbArea`. The response is an order slip with the informational notice and the connected marks.
- **Delivery-note cancellation (9.3).** Send the delivery note with the void flag and a reference to the original; the Middleware cancels the referenced MARK and returns myDATA's response.
- **Copy of an existing document.** Send `ftReceiptCase` `0x3010`; no myDATA transmission takes place. Reprint the original content and signature items unchanged and mark the print as a copy.
- **Handwritten receipt.** Send the receipt with the handwritten flag (`0x0008`) and the series, number, merchant VAT number, hash algorithm and hash payload of the paper document in `ftReceiptCaseData.GR`. The transmitted document carries the paper series and number.

## Checklist for PosCreators

Before going live, verify one printed sample of every document type against this list:

1. Issuer data, document designation, series and number as returned in `ftReceiptIdentification`.
2. Unique document identifier, MARK, UID and authentication code exactly as returned.
3. QR code rendered from the data of the `PosReceipt` signature item and readable.
4. Provider footer: legal name, web address and licence identifier on three lines, unchanged.
5. Payment signature, AADE transaction ID, amount including tip and tip for every card payment.
6. Exemption reason printed for every 0 % line; special taxes with their Greek description.
7. Loss-of-connection notice, connected marks and order-slip notice printed whenever returned.
8. Order slips visibly marked as informational documents.
9. Signature items flagged *Do not print* are not visualised.
10. Sandbox receipts are never handed to customers.
