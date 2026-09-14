---
slug: /poscreators/middleware-doc/portugal/receipt-printing
title: Receipt Printing
---

# Receipt Printing

In Portugal, the printed or electronically delivered document **is** the fiscal document, and its layout is part of what the AT certified. The Middleware numbers and signs the document and returns everything that must appear on it, together with print instructions, in the `ftSignatures` of the response. The fiskaltrust.Middleware for Experience renders this into the certified document: a PDF or HTML digital receipt through the receipt service, or an ESC-POS print stream through the `/issue` endpoint.

This page describes what that certified rendering contains, so that PosCreators know which elements they will see on the document and which values they must never alter when displaying or reprinting them. The requirements follow *Portaria n.º 363/2010* (art. 6), *Despacho n.º 8632/2014*, and *Portaria n.º 195/2020* (QR code). They were verified during the [certification](../certification/certification.md) of the fiskaltrust.CloudCashBox and apply to every document type the Middleware issues.

:::tip Use the certified document

The QR code signature item carries in its `Caption` the URL of the digital receipt rendered by fiskaltrust (`https://receipts.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}`, or the `receipts-sandbox` host in the sandbox). This rendering contains all mandatory elements, including copy and void markers, and is the document covered by certificate 3535. Hand this document (or the ESC-POS stream from `/issue`) to the customer.

:::

:::caution Self-rendered layouts

A layout drawn by the POS system itself from the returned data has not been reviewed by the AT and is not covered by the certificate. The conditions for such layouts are being clarified; see [Certified document layout](../certification/certification.md#certified-document-layout). Until they are published, treat the rules below as a description of the certified rendering, not as a licence to build your own. PosCreators who require their own layout should contact fiskaltrust before going live.

:::

## Mandatory content of a document

Every fiscal document (FS, FT, NC, RG, PF, OR, CM) contains the following elements. Values are exactly the same as those exported to the SAF-T (PT); the Middleware renders and exports what it received in the request, so the data you send is the data on the document.

| Element | Source | Notes |
| ------- | ------ | ----- |
| Issuer header | POS master data | Company name, address, and NIF of the issuer. |
| Document type designation | Document identifier | Print the Portuguese designation of the type contained in `ftReceiptIdentification`: *Fatura* (FT), *Fatura simplificada* (FS), *Nota de crédito* (NC), *Recibo* (RG), *Fatura pró-forma* (PF), *Orçamento* (OR), *Consulta de mesa* (CM). |
| Document number | `ftReceiptIdentification` | The part after the `#`, e.g. `FS ft20257d14/12` (type code, series, sequential number). Print it unchanged. |
| ATCUD | Signature item `ATCUD` | `ATCUD: <validation code>-<number>`. Must be printed on every page. |
| Date and time | `cbReceiptMoment` | Format `YYYY-MM-DD HH:MM`, in Portuguese local time. |
| Operator | `cbUser` | The user who issued the document. |
| Customer | `cbCustomer` | Name, address, and NIF when provided. Without a NIF the Middleware returns the text *Consumidor final*, which must be printed instead. |
| Original / copy marker | POS | *Original* on the first print, *Duplicado* (or *2.ª via*) on every reprint. A copy must reproduce the original exactly, whatever has changed in master data since. |
| Void marker | POS | A voided document, when printed, must visibly state *Documento anulado* and still show its ATCUD and QR code. |
| Line items | `cbChargeItems` | Quantity, description, unit price **without VAT**, VAT rate, line discount, line total. For 0 % lines the exemption reason (code and text) must be printed. |
| Discounts | `cbChargeItems` | Line discounts per line; document totals of discounts. Amounts are printed as absolute values, never negative. |
| Document total | Request | Total with VAT. Credit notes show absolute values as well. |
| VAT summary | Request | One line per VAT rate: designation (*Isento*, *Reduzida*, *Intermédia*, *Normal*), percentage, taxable base, VAT amount, gross amount. |
| `IVA incluído` | Signature item `PTAdditional` | Returned when prices are gross; must be printed. |
| Payments | `cbPayItems` | Payment method and amount. Simplified invoices always contain a payment; working documents never do. |
| Reference to source document | Signature items `ReferenceForCreditNote` / `PTAdditional` | *Referencia:* or *Origem:* followed by the referenced document number, and *Razão: Devolução* on credit notes. Must be printed whenever returned. |
| Working-document notice | Signature item `PTAdditional` | *Este documento não serve de fatura* on PF, OR, and CM. Must be printed. |
| Manual-document notice | Signature item `PTAdditional` | `Cópia do documento original - FTM <series>/<number>` on recovered handwritten invoices. |
| Hash and certificate line | Signature item `CertificationNo` | `<4 hash characters> - Processado por programa certificado n.º 3535/AT`. The four characters are positions 1, 11, 21, and 31 of the document hash. Print exactly as returned. |
| QR code | Signature item `PosReceipt` (format QR code) | Render the `Data` as a QR code, readable within the body of the document. |

Additional layout rules:

- **Language.** Documents for domestic operations must be in Portuguese. A bilingual layout is allowed; a layout exclusively in a foreign language is not.
- **No negative amounts.** Quantities, prices, discounts, and totals are printed as absolute values, also on credit notes and returns.
- **Footer.** None of the mandatory elements may be the last item on the document; print a footer (e.g. a thank-you line) after them. Free text is allowed as long as it cannot be mistaken for a mandatory element.
- **Multi-page documents.** Every page must show the document type, the document number, the ATCUD, and `Página n de N`. The first and middle pages end with `A transportar: <amount>`, the following pages start with `Transportado: <amount>`. Totals and the VAT summary appear on the last page only.
- **Simplified invoice.** In addition to the elements above, a simplified invoice shows the customer NIF only if provided. It may not exceed a net amount of 100 EUR (see [Certification](../certification/certification.md#boundaries-of-the-certification)).

## Signature items returned by the Middleware

The Middleware returns the following Portugal-specific signature items. The `ftSignatureType` values are listed in the [Type of Signature: ftSignatureType](../reference-tables/type-of-signature-ftsignaturetype.md) reference table.

| Signature type (sss) | Caption | Data | Format | Print |
| -------------------- | ------- | ---- | ------ | ----- |
| `001` PosReceipt | URL of the digital receipt | QR code content (*Portaria n.º 195/2020*) | QR code | **Mandatory** as QR code. The caption may be printed as a link. |
| `010` ATCUD | *(empty)* | `ATCUD: AAJFJNK6JJ-12` | Text | **Mandatory** on every page. |
| `012` Hash | `Hash` | Full document hash | Text, flagged *Do not print* | Not printed. Kept for audit; the four print characters are in `014`. |
| `014` CertificationNo | `-----` | `Rsur - Processado por programa certificado n.º 3535/AT` | Text | **Mandatory**. |
| `015` ReferenceForCreditNote | *(empty)* or `Referencia <document>` | `Referencia: <document>` / `Razão: Devolução` | Text | **Mandatory** when returned (invoices from working documents, credit notes). |
| `016` PTAdditional | *(empty)* | `IVA incluido`, `Consumidor final`, `Origem: <document>`, `Este documento não serve de fatura`, `Cópia do documento original - FTM <series>/<number>` | Text | **Mandatory** when returned. |
| `1 001` InitialOperationReceipt | `Initial-operation receipt` | `Queue-ID: <id>` | Text | Lifecycle receipt; keep with the bookkeeping records. |
| `1 002` OutOfOperationReceipt | `Out-of-operation receipt` | `Queue-ID: <id>` | Text | Lifecycle receipt; keep with the bookkeeping records. |

The recommended print order is: header, document type and number, date/time, operator, customer, line items, totals and VAT summary, payments, then all returned text signature items in the order returned, the QR code, and the footer. A signature item whose `ftSignatureType` carries the *Do not print* flag (`0x0020`) must not be visualized.

## Copies, voids, and manual documents

- **Copy of an existing document.** Send `ftReceiptCase` `0x3010` with `cbPreviousReceiptReference` set to the original. Print the original content unchanged and mark the document *Duplicado*. Copies are supported for FS, FT, RG, PF, OR, and CM.
- **Void.** A void (`IsVoid` flag `0x0004`) does not create a new document number. If the voided document is printed again, it must state *Documento anulado* and still contain the original ATCUD, QR code, and certificate line.
- **Credit notes.** The credit note references the original document (*Referencia* / *Razão: Devolução*). All amounts are printed as absolute values; only the document type *Nota de crédito* indicates the direction.
- **Recovered handwritten documents.** An invoice sent with the `Handwritten` flag (`0x0008`) is issued in the dedicated manual series and carries the `Cópia do documento original - FTM <series>/<number>` notice, which must be printed together with the regular elements.

## Checklist for PosCreators

Before going live, verify one printed sample of every document type against this list:

1. Document type designation and number as returned in `ftReceiptIdentification`.
2. ATCUD on every page.
3. Hash characters and certificate line exactly as returned.
4. QR code rendered from the `Data` of the QR signature item and readable.
5. `IVA incluído`, `Consumidor final`, references, and the working-document notice printed whenever returned.
6. Exemption reason printed for every 0 % line.
7. No negative values anywhere; VAT summary per rate present.
8. *Original* / *Duplicado* / *Documento anulado* markers implemented.
9. Multi-page rule (*A transportar* / *Transportado*, page numbers) implemented.
10. Footer after the last mandatory element.
