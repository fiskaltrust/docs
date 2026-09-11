---
slug: /poscreators/middleware-doc/spain/receipt-printing
title: Receipt Printing
---

# Receipt Printing

In Spain the printed or electronically delivered document is the invoice (*factura*) or simplified invoice (*factura simplificada*) of the merchant. Its content is regulated by the invoicing regulation (*Real Decreto 1619/2012*); the fiscal frameworks add the elements that link the document to the transmitted record: in the common territory the **QR code** and the **VERI\*FACTU legend** (*Real Decreto 1007/2023*, art. 20 and 21; *Orden HAC/1177/2024*), in the Basque Country the **TBAI identifier** and the **TicketBAI QR code** (Bizkaia *Orden Foral 1482/2020*, art. 6, annexes IV and V, and the equivalent orders of Araba and Gipuzkoa).

The Middleware numbers the document, generates and transmits the record and returns everything that must appear on the document in the `ftSignatures` of the response. The fiskaltrust.Middleware for Experience renders this into the digital receipt behind the QR code (`https://receipts.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}`, the `receipts-sandbox` host in the sandbox) and into the ESC-POS stream of the `/issue` endpoint. This page describes which elements the document must contain and which signature items carry them, so that PosCreators who print the document themselves know what to print and which values they must never alter.

:::tip Use the returned values

The QR code content, the legend, the TBAI identifier and the series and number are calculated by the Middleware from the transmitted record. Any deviation on the document (a different number, a self-generated QR code, a shortened legend) makes the document unverifiable. Print the `Data` of every visible signature item unchanged.

:::

## Mandatory content of a document

Every simplified invoice (`0x0001`) and complete invoice (`0x1xxx`) contains the following elements. The Middleware transmits what it received in the request, so the data you send is the data in the record.

| Element | Source | Notes |
| ------- | ------ | ----- |
| Issuer | Master data | Name or company name, NIF and address of the issuer, as configured for the queue in the fiskaltrust.Portal. The NIF is also returned as signature item `IDEmisorFactura`. |
| Document type | Derived from `ftReceiptCase` | *Factura simplificada* for POS receipts, *Factura* for invoices. Do not print other designations such as *ticket* or *recibo* on fiscal documents. |
| Series and number | `ftReceiptIdentification` | The part after the `#`, e.g. `ft2A#fktAbCdEfGhIjK0000-17` (series, hyphen, sequential number). Print it unchanged; it is the *NumSerieFactura* of the record and part of the QR code. |
| Date (and time) | `cbReceiptMoment` | In Spanish local time (the Middleware converts UTC to Europe/Madrid for the record). TicketBAI records carry date and time of issue. |
| Customer | `cbCustomer` | On complete invoices: name, address and NIF (or foreign identification) of the recipient. Simplified invoices carry no recipient. The recipient is transmitted in TicketBAI files but not yet in VERI\*FACTU records (see [Supported document types](../declaration/declaration.md#supported-document-types)). |
| Line items | `cbChargeItems` | Description, quantity, unit price without VAT, VAT rate and line total. TicketBAI transmits description (max. 250 characters), quantity, net unit price and line total per line. |
| Discounts | `cbChargeItems` | Line discounts as separate charge items with negative amounts; a discount must not exceed its article. Print them as negative lines or as a reduction of the article. |
| VAT breakdown | Request | One line per VAT rate with base (*Base*), rate and VAT amount (*Cuota*); for 0 % lines the exemption or not-subject reason. Total with VAT. Simplified invoices may show *IVA incluido* with the rate instead of the breakdown. |
| Payments | `cbPayItems` | Payment method and amount; use the Spanish designations (*Efectivo*, *Tarjeta*, *Transferencia bancaria*, …). |
| QR code (VERI\*FACTU) | Signature item `Url` (`sss` = `001`) | Caption `QR tributario:`, data the AEAT verification URL. Render the data as a QR code between 30 and 40 mm; print the caption above it. |
| VERI\*FACTU legend | Text signature item | `Factura verificable en la Sede electrónica de la AEAT`. Print it next to the QR code. |
| TBAI identifier (TicketBAI) | Text signature item with empty caption | `TBAI-<NIF>-<ddMMyy>-<13 characters>-<CRC>`, 39 characters. Print it in one line above the QR code (two lines on 57 mm paper). |
| QR code (TicketBAI) | Signature item `Url` (`sss` = `001`) | Caption `[www.fiskaltrust.es]`, data the verification URL (`…/QRTBAI/?id=…&s=…&nf=…&i=…&cr=…`). Render as QR code of 30 × 30 mm (57 mm paper) or 40 × 40 mm (80 mm paper and A4), error correction level M, with 6 mm free space on all sides, at the bottom of the document or at the right edge of an A4 invoice. |
| Reference to the original | `cbPreviousReceiptReference` | On voids and refunds: series and number of the original document. |

Additional layout rules:

- **Language.** The mandatory designations are Spanish (Basque is optional in the Basque Country). A bilingual layout is allowed.
- **Non-fiscal documents carry no fiscal elements.** Delivery notes, pro forma invoices, table checks and other documents that are not invoices are stored by the Middleware without record, QR code or TBAI identifier. Do not print a TicketBAI code or an AEAT QR code on them, and mark them clearly as non-fiscal documents. Other QR codes on a fiscal document must not be confused with the fiscal QR code.
- **Sandbox documents** point to the verification pages of the test environments, carry an additional `S A N D B O X` signature item and are never valid invoices.

## Signature items returned by the Middleware

The Middleware returns the following Spain-specific signature items. The `ftSignatureType` values are listed in the [Type of Signature: ftSignatureType](../reference-tables/type-of-signature-ftsignaturetype.md) reference table; the market-specific part is the last three hex digits (`sss`).

**VERI\*FACTU queues**

| Signature type (sss) | Caption | Data | Format | Print |
| -------------------- | ------- | ---- | ------ | ----- |
| `001` Url | `QR tributario:` | AEAT verification URL with `nif`, `numserie`, `fecha` and `importe` | QR code, position *before header* | **Mandatory** as QR code with its caption. |
| `000` (no country code) | *(empty)* | `Factura verificable en la Sede electrónica de la AEAT` | Text, position *before header* | **Mandatory**. |
| `002` NIF | `IDEmisorFactura` (`IDEmisorFacturaAnulada` on cancellations) | Issuer NIF | Text | Print as part of the issuer data. |
| `004` Huella | `Huella` | SHA-256 hash of the record (64 hex characters) | Text | Optional. Not required on the document; keep it for audit. |
| `1 001` InitialOperationReceipt | `Initial-operation receipt` | `Queue-ID: <id>` | Text | Lifecycle receipt; keep with the bookkeeping records. |
| `1 002` OutOfOperationReceipt | `Out-of-operation receipt` | `Queue-ID: <id>` | Text | Lifecycle receipt; keep with the bookkeeping records. |

**TicketBAI queues**

| Signature type (sss) | Caption | Data | Format | Print |
| -------------------- | ------- | ---- | ------ | ----- |
| `000` (country `ES`) | *(empty)* | TBAI identifier `TBAI-…` | Text | **Mandatory**, directly above the QR code. |
| `001` Url | `[www.fiskaltrust.es]` | Verification URL with `id`, `s`, `nf`, `i` and `cr` | QR code | **Mandatory** as QR code. |
| `003` Signature | `Signature` | Base64 signature value of the XAdES signature | Base64, flagged *Do not print* | Not printed. Kept for the chaining and for audit. |
| `000` (Information) | `Codigo <code>` | Message of the provincial web service (for example a non-blocking warning) | Text | Optional; informational. |
| `1 001` / `1 002` | `Initial-operation receipt` / `Out-of-operation receipt` | `Queue-ID: <id>` | Text | Lifecycle receipts; keep with the bookkeeping records. |

The recommended print order is: issuer, document type, series and number, date and time, customer, line items, VAT breakdown and total, payments, then the fiscal block (VERI\*FACTU: caption, QR code and legend; TicketBAI: TBAI identifier and QR code) and the footer. A signature item whose `ftSignatureType` carries the *Do not print* flag (`0x0020`) must not be visualised.

## Voids, refunds and copies

- **Cancellation (VERI\*FACTU).** Send the document again with the void flag (`0x0004`) and `cbPreviousReceiptReference`. The Middleware transmits a *registro de anulación* and returns the hash and the issuer NIF (`IDEmisorFacturaAnulada`); no new QR code is returned. If you print a confirmation, mark it as *Anulación* and reference the cancelled series and number.
- **Refund.** Send the refund with the refund flag (`0x0100`), `cbPreviousReceiptReference` and the returned lines with negative quantities and amounts (all lines for a full refund, the affected lines with the charge-item refund flag for a partial refund). The response carries a new series and number and a new QR code; print the document like an invoice and reference the original.
- **Copy of an existing document.** Send `ftReceiptCase` `0x3010`; no transmission takes place. Reprint the original content and signature items unchanged and mark the print as a copy (*Copia*).
- **TicketBAI.** Cancellations are not yet available on TicketBAI queues; see [Boundaries](../declaration/declaration.md#boundaries).

## Checklist for PosCreators

Before going live, verify one printed sample of every document type against this list:

1. Issuer data with NIF, document type (*Factura simplificada* / *Factura*), series and number as returned in `ftReceiptIdentification`.
2. Date and time in Spanish local time.
3. Customer data on complete invoices.
4. Line items with net unit price and VAT rate; VAT breakdown per rate with base and VAT amount; exemption or not-subject reason on 0 % lines.
5. VERI\*FACTU: caption `QR tributario:`, QR code rendered from the `Data` of the `Url` signature item and readable, legend printed unchanged.
6. TicketBAI: TBAI identifier printed unchanged above the QR code; QR code rendered from the `Data`, readable, with the required size and margins.
7. Reference to the original document on voids and refunds.
8. Non-fiscal documents clearly marked and without fiscal elements.
9. Signature items flagged *Do not print* are not visualised.
10. Sandbox documents are never handed to customers.
