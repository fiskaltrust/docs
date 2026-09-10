---
slug: /poscreators/middleware-doc/portugal/certification
title: Certification
---

# Certification of the fiskaltrust.Middleware (CloudCashBox)

In Portugal, invoices and other tax-relevant documents may only be issued by an invoicing program that has been certified by the Portuguese Tax and Customs Authority (*Autoridade Tributária e Aduaneira*, AT) in accordance with *Portaria n.º 363/2010* and *Despacho n.º 8632/2014*. The fiskaltrust.Middleware, operated by fiskaltrust as the **fiskaltrust.CloudCashBox**, has gone through this certification and is listed by the AT as a certified invoicing program (*programa de faturação certificado*).

The official list of certified programs is published by the AT and can be consulted here:

**[Consulta de programas certificados (Modelo 24) – Portal das Finanças](https://www.portaldasfinancas.gov.pt/pt/consultaProgCertificadosM24.action)**

The fiskaltrust.CloudCashBox is certified under **certificate number 3535**. The entry is registered by *FISKALTRUST CONSULTING GMBH - Sucursal em Portugal* (NIF 980833310). The product is identified in the SAF-T (PT) header as `fiskaltrust.CloudCashBox/FISKALTRUST CONSULTING GMBH - Sucursal em Portugal`, product version `2.0`.

:::info Where the certificate number appears

The certificate number assigned by the AT (`3535`) is part of every fiscal document the Middleware produces:

- in the mandatory print line `<4 hash characters> - Processado por programa certificado n.º 3535/AT` (returned as a signature item),
- in field `R` of the QR code (`R:3535`, *Portaria n.º 195/2020*), and
- in the `SoftwareCertificateNumber` element of the SAF-T (PT) header.

PosCreators must print these values exactly as returned by the Middleware and must not replace them with their own values.

:::

## What has been certified

The certification covers the fiskaltrust.Middleware as a **cloud-hosted invoicing program** (*aplicação de faturação*). It does not cover accounting functionality. In the AT's terminology, the certified program is the one that creates, numbers, signs, and exports the documents. With the fiskaltrust.CloudCashBox, all of this happens inside the Middleware:

- **Document creation and numbering.** Documents are numbered in series that fiskaltrust registers with the AT through the AT series webservice. Each document carries the *ATCUD* (validation code of the series plus the sequential number). PosCreators cannot choose or alter series or numbers; they are managed by the Middleware.
- **Digital signature (hash chain).** Every document is signed with an RSA private key held by fiskaltrust, chained to the previous document of the same series. The four characters extracted from the hash and the certificate line are returned as signature items and must be printed.
- **QR code.** The Middleware generates the mandatory QR code content according to *Portaria n.º 195/2020*, including ATCUD, totals per VAT rate, hash extract, and certificate number.
- **SAF-T (PT) export.** The Middleware produces the SAF-T (PT) audit file in structure 1.04_01 (*Portaria n.º 302/2016*) containing all documents, customers, products, tax table, and working documents. It is exported through the journal endpoint with the Portuguese SAF-T journal type `0x5054000000000001` (see [Type of Journal: ftJournalType](../reference-tables/type-of-journal-ftjournaltype.md)).
- **Validation rules.** The Middleware enforces the AT's business rules before signing (see [Boundaries](#boundaries-of-the-certification)), so that non-compliant requests are rejected instead of being turned into invalid fiscal documents.
- **Document copies and voids.** Reprints are marked as copies (*Duplicado*), voided documents are exported with status `A` and their copies are marked *Documento anulado*.
- **Digital receipt.** The rendered receipt (HTML/PDF) available through the receipt service contains all mandatory elements listed above.

The certification was carried out with the fiskaltrust.CloudCashBox environment operated by fiskaltrust in the Microsoft Azure cloud. POS systems that integrate through the [PosSystem API](../../possystem-api/introduction.md) act as the front end of this certified program; the fiscal document itself is created and secured by the Middleware.

:::caution Scope of the certificate

The certificate applies to the fiskaltrust.Middleware as operated by fiskaltrust (CloudCashBox). Self-hosted or on-device installations of the Middleware (e.g. the Android launcher) are not covered by this certificate. PosCreators who need such a deployment must go through their own certification.

:::

## Certified document types

The following SAF-T (PT) document types were part of the certification and are issued by the Middleware. The table shows how they map to the `ftReceiptCase` values described in [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md).

| SAF-T type | Portuguese name | `ftReceiptCase` (txcc) | Notes |
| ---------- | --------------- | ---------------------- | ----- |
| `FS` | Fatura simplificada (art. 40 CIVA) | `0x0001` POS receipt (`0x0000` is treated the same) | Must contain a payment (`cbPayItems`). Net amount limited to 100 EUR. |
| `FT` | Fatura (art. 36 CIVA) | `0x1000`, `0x1001`, `0x1002`, `0x1003` | All invoice types are issued as `FT`. Can be issued without payment; payments are booked later with `RG`. |
| `NC` | Nota de crédito | `0x0001` or `0x1xxx` with flag `0x0100` (IsRefund), or a partial refund referencing the original | Must reference the original document via `cbPreviousReceiptReference`. Customer, articles, prices, and discounts must match the original; quantities and amounts must not exceed what is left to refund. |
| `RG` | Recibo | `0x0002` Payment transfer | Must reference the invoice it settles. Partial payments are allowed; the total must not exceed the open amount of the invoice. |
| `PF` | Fatura pró-forma | `0x0007` Pro forma | Working document. Must not contain payment items. Can be invoiced later by referencing it. |
| `OR` | Orçamento | `0x0007` with the Portuguese local flag `0x002` (i.e. `0x5054_2002_0000_0007`) | Working document (budget). Same rules as `PF`. |
| `CM` | Consulta de mesa | `0x0006` Table check | Working document. Must not contain payment items. Only the last table check of a chain may be invoiced. |
| `FT` (manual series) | Recolha de documentos manuais | `0x1xxx` with flag `0x0008` (Handwritten) | Recovery of documents issued on pre-printed forms during an outage. Only supported for invoices; the manual series and number are mandatory and may be collected only once. |

In addition, the following operations were part of the certification but do not create a fiscal document of their own:

| Operation | `ftReceiptCase` | Result |
| --------- | --------------- | ------ |
| Void | Any of the above with flag `0x0004` (IsVoid) | The referenced document is set to status `A` (*anulado*). Documents that were already invoiced (working documents) or refunded cannot be voided. |
| Copy / reprint | `0x3010` | Returns a copy of an existing document marked as *Duplicado*. |
| Protocol / audit log | `0x3000`, `0x3001`, `0x3002` | Used for audit entries, e.g. article master data changes. |
| Initial / out-of-operation | `0x4001`, `0x4002` | Queue lifecycle. |

The receipt-case values `0x0006` and `0x0007` and the local flag for budgets are Portugal-specific extensions of the general tagging scheme.

## Boundaries of the certification

The certificate covers the functionality described above and nothing beyond it. The Middleware actively rejects requests that fall outside this scope. The most important boundaries are:

**Document types that are not issued**

- Invoice-receipts (`FR`), debit notes (`ND`), receipts under the cash VAT regime (`RC`), self-billing documents, and summary documents (`R`) are not issued.
- Transport documents under the *Regime de Bens em Circulação* (`GR`, `GT`, `GA`, `GC`, `GD`) are not issued. The delivery-note receipt case (`0x0005`) has no fiscal effect in Portugal, and requests carrying the `HasTransportInformation` flag are rejected.
- Documents from other systems are not integrated (no import of third-party documents into the SAF-T).

**Amounts, currency, and tax**

- Only `EUR` is supported. Documents in a foreign currency are rejected.
- Only the mainland Portuguese tax region (`PT`) is supported. The Azores (`PT-AC`) and Madeira (`PT-MA`) rates are not available.
- Only the reduced, intermediate, and normal VAT rates plus VAT-exempt items are supported. Exempt items (0 %) must carry a supported exemption reason via the nature-of-VAT segment of the `ftChargeItemCase`; unknown exemption codes are rejected.
- Simplified invoices (`FS`) are limited to a net amount of 100 EUR. Individual cash payments are limited to 3 000 EUR.
- Negative quantities, negative amounts, and positive discount lines are not allowed except where they result from a refund. A discount must not exceed the amount of the article it belongs to.

**Data quality rules**

- `cbUser` is mandatory and must be at least three characters long; it is exported as the user who issued the document.
- Article descriptions must be at least three characters long and representable in Windows-1252 encoding. Leading and trailing whitespace is trimmed.
- A `cbCustomer` with a `CustomerVATId` must carry a valid Portuguese NIF and a `CustomerCountry`. Without a NIF, the document is issued to *Consumidor final* (NIF `999999990`).
- `cbReceiptMoment` must be UTC, must not be in the future, must be within ten minutes of the server time, and must not be earlier than the previous document of the same series.
- Item positions must start at 1 and increase without gaps; lines are exported in this order.

**Operational boundaries**

- Series, ATCUD, and the signing key are managed exclusively by fiskaltrust. There is no way for a PosCreator or merchant to configure series or to sign documents locally.
- Daily, monthly, and yearly closing receipts as well as the zero receipt have no fiscal function in Portugal and are accepted as no-ops.
- Training mode is only available on queues where it has been explicitly enabled; the sandbox environment must not be used for productive documents.
- The PDF rendered by fiskaltrust is not signed with a qualified electronic signature or seal. Under the current transitional rule, plain PDF invoices are accepted until 31 December 2026; from 1 January 2027 a qualified signature or seal is required for PDF invoices sent electronically to customers. B2G invoicing (CIUS-PT / EDI) is not part of the certified scope.
- Down payments, multi-use vouchers, and payments under the cash VAT regime are not covered.

Requests that violate one of these rules are not signed. The response carries the error state `EEEE_EEEE` (see [Service Status: ftState](../reference-tables/service-status-ftstate.md)) and the validation code and message in the `ftSignatures`, so the POS can show the reason to the operator and correct the request.
