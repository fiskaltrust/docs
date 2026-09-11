---
slug: /poscreators/middleware-doc/portugal/certification
title: Certification
---

# Certification of the fiskaltrust.Middleware (CloudCashBox)

In Portugal, invoices and other tax-relevant documents may only be issued by an invoicing program that has been certified by the Portuguese Tax and Customs Authority (*Autoridade Tributária e Aduaneira*, AT) in accordance with *Portaria n.º 363/2010* and *Despacho n.º 8632/2014*. The fiskaltrust.Middleware, operated by fiskaltrust as the **fiskaltrust.CloudCashBox**, has gone through this certification and is listed by the AT as a certified invoicing program (*programa de faturação certificado*).

:::info This chapter describes Route 1 of the Go-to-Market

Everything on this page (certificate number 3535, the certified scope, the document types, and the boundaries) applies when your POS system integrates with the **fiskaltrust.Middleware for Cloud (fiskaltrust.CloudCashBox)** under fiskaltrust's certificate. This is [Route 1](../go-to-market/route-1-fiskaltrust-certificate.md) of the [Go-to-Market](../go-to-market/go-to-market.md) chapter.

If you certify your own solution on top of the fiskaltrust.Middleware ([Route 2](../go-to-market/route-2-own-certificate.md)), you hold your own certificate and define your own scope. This page then only tells you what the Middleware brings into your procedure; it does not describe your certificate.

:::

The official list of certified programs is published by the AT and can be consulted here:

**[Consulta de programas certificados (Modelo 24) – Portal das Finanças](https://www.portaldasfinancas.gov.pt/pt/consultaProgCertificadosM24.action)**

The fiskaltrust.CloudCashBox is certified under **certificate number 3535**. The entry is registered by *FISKALTRUST CONSULTING GMBH - Sucursal em Portugal* (NIF 980833310). The product is identified in the SAF-T (PT) header as `fiskaltrust.CloudCashBox/FISKALTRUST CONSULTING GMBH - Sucursal em Portugal`, product version `2.0`.

:::info Where the certificate number appears

The certificate number assigned by the AT (`3535`) is part of every fiscal document the Middleware produces:

- in the mandatory print line `<4 hash characters> - Processado por programa certificado n.º 3535/AT` (returned as a signature item),
- in field `R` of the QR code (`R:3535`, *Portaria n.º 195/2020*), and
- in the `SoftwareCertificateNumber` element of the SAF-T (PT) header.

PosCreators must print these values exactly as returned by the Middleware and must not replace them with their own values. See [Receipt Printing](../receipt-printing/receipt-printing.md) for all mandatory elements of the printed document.

:::

## What has been certified

The certification covers the fiskaltrust.Middleware as a **cloud-hosted invoicing program** (*aplicação de faturação*). It does not cover accounting functionality. In the AT's terminology, the certified program is the one that creates, numbers, signs, and exports the documents. With the fiskaltrust.CloudCashBox, all of this happens inside the Middleware:

- **Document creation and numbering.** Documents are numbered in series that fiskaltrust registers with the AT through the AT series webservice. Each document carries the *ATCUD* (validation code of the series plus the sequential number). PosCreators cannot choose or alter series or numbers; they are managed by the Middleware.
- **Digital signature (hash chain).** Every document is signed with an RSA private key held by fiskaltrust, chained to the previous document of the same series. The four characters extracted from the hash and the certificate line are returned as signature items and must be printed.
- **QR code.** The Middleware generates the mandatory QR code content according to *Portaria n.º 195/2020*, including ATCUD, totals per VAT rate, hash extract, and certificate number.
- **SAF-T (PT) export.** The Middleware produces the SAF-T (PT) audit file in structure 1.04_01 (*Portaria n.º 302/2016*) containing all documents, customers, products, tax table, and working documents. It is exported through the journal endpoint with the Portuguese SAF-T journal type `0x5054200000000001` (see [Type of Journal: ftJournalType](../reference-tables/type-of-journal-ftjournaltype.md)).
- **Validation rules.** The Middleware enforces the AT's business rules before signing (see [Boundaries](#boundaries-of-the-certification)), so that non-compliant requests are rejected instead of being turned into invalid fiscal documents.
- **Document copies and voids.** Reprints are marked as copies (*Duplicado*), voided documents are exported with status `A` and their copies are marked *Documento anulado*.
- **Document layout.** The rendering of the document (PDF, digital receipt, ESC-POS) produced by the fiskaltrust.Middleware for Experience is part of the certified program; see [Certified document layout](#certified-document-layout) and [Receipt options, configuration, and extension points](#receipt-options-configuration-and-extension-points).

The certification was carried out with the fiskaltrust.CloudCashBox environment operated by fiskaltrust in the Microsoft Azure cloud. POS systems that integrate through the [PosSystem API](../../possystem-api/introduction.md) act as the front end of this certified program; the fiscal document itself is created and secured by the Middleware.

:::caution Scope of the certificate

The certificate applies to the fiskaltrust.Middleware as operated by fiskaltrust (CloudCashBox). Self-hosted or on-device installations of the Middleware (e.g. the Android launcher) are not covered by this certificate. PosCreators who need such a deployment must go through their own certification, see [Route 2: Certifying your own solution](../go-to-market/route-2-own-certificate.md).

:::

### Always provided by the fiskaltrust.Middleware

The following components are part of the fiskaltrust.Middleware itself. They are provided on **both** routes of the [Go-to-Market](../go-to-market/go-to-market.md), whether the program runs as the fiskaltrust.CloudCashBox under certificate 3535 or as part of a partner's own certified solution. A PosCreator never has to build them, and on Route 2 they enter the partner's procedure as they are:

| Component | What the Middleware does |
| --------- | ------------------------ |
| **Validation** | Every request is checked against the Portuguese business rules before anything is signed (see [Boundaries](#boundaries-of-the-certification)); non-compliant requests are rejected with a validation code and message. |
| **Numbering and series** | Documents are numbered sequentially per series and document type, the chronology of the series is enforced, and the ATCUD validation code of the series is applied to every document. |
| **Signature and hash chain** | Each document is signed with the RSA key of the program and chained to the previous document of its series; the four hash characters and the certificate line are returned as signature items. |
| **QR code** | The QR code content according to *Portaria n.º 195/2020* (ATCUD, totals per VAT rate, hash extract, certificate number) is generated for every document. |
| **Mandatory texts** | All texts the AT requires on the document (*IVA incluído*, *Duplicado*, *Documento anulado*, working-document notices, references, manual-series notice) are returned as signature items with format and position. |
| **Customer data** | The customer NIF is validated; a customer without NIF becomes *Consumidor final* (NIF `999999990`), a missing country or address becomes *Desconhecido*. The customer master file of the SAF-T (PT) is built from the requests, and the customer of a credit note or receipt is checked against the original document. |
| **Product master data** | The product table of the SAF-T (PT) is derived from the charge items (unique product code per article, trimmed and validated descriptions). No separate product master has to be maintained. |
| **Tax table and exemption reasons** | The SAF-T tax table with the supported VAT rates and exemption codes is generated; only valid exemption reasons are accepted. |
| **Users** | The operator passed in `cbUser` is validated and exported as the user who issued the document. |
| **Document lifecycle** | Voids, credit notes, partial credit notes, receipts, copies, working documents that were invoiced, and the recovery of manual documents are validated against the referenced original and tracked in the document status. |
| **SAF-T (PT)** | The complete audit file in structure 1.04_01 (header, master files, source documents, working documents, payments) is produced on request through the journal endpoint. |
| **Audit log** | Protocol receipts create the audit entries the AT expects for master-data changes. |
| **Sandbox behaviour** | Sandbox queues emit the placeholder certificate number `9999` so that test documents can never be mistaken for valid invoices. |

### Provided by fiskaltrust as operator of the certified program

On Route 1 fiskaltrust is, in addition, the **producer and operator** of the certified program. The following components are provided and operated by fiskaltrust for the fiskaltrust.CloudCashBox; PosCreators do not have to build, configure, or defend them towards the AT. On Route 2 these are the partner's responsibility (see the [division of responsibilities](../go-to-market/route-2-own-certificate.md#division-of-responsibilities)):

| Component | What fiskaltrust does on Route 1 |
| --------- | -------------------------------- |
| **Registration with the AT** | fiskaltrust is listed in the AT register as the producer of the program (Modelo 24), holds certificate 3535, and is the contact for the AT in all questions concerning the program. |
| **Series registration** | Document series are created for every queue and registered with the AT through the series webservice; the ATCUD validation codes are obtained without any action by the PosCreator or the merchant. |
| **Signing key** | The RSA key pair is generated and held by fiskaltrust; the public key is declared to the AT, the private key never leaves the fiskaltrust cloud. |
| **Program identification** | The SAF-T (PT) header carries fiskaltrust as producer, the product identification, and certificate number 3535; the certificate line and the QR code carry the same number. |
| **Document rendering** | The certified layout is rendered by fiskaltrust (PDF, digital receipt, ESC-POS); the print format is protected against changes by the merchant or the POS. |
| **Operations** | Hosting in the fiskaltrust cloud, backups and continuity, system time, availability, and the protection of the database. |
| **Regulatory maintenance** | Adaptation of the program when the regulation changes, and the dialogue with the AT when a change requires a new review. |

What remains with the PosCreator is described under [What this means for PosCreators](#what-this-means-for-poscreators); what remains with the merchant under [What this means for PosOperators](#what-this-means-for-posoperators).

### Certified document layout

In Portugal the certification does not stop at the data. The AT reviews the documents as they are handed to the customer, and the layout is part of the certified program. For the fiskaltrust.CloudCashBox this means:

- The Middleware returns, together with the signed data, the **print instructions** for every mandatory element (hash extract and certificate line, ATCUD, QR code content, *IVA incluído*, references, working-document notice) as signature items with a defined format and position.
- The **fiskaltrust.Middleware for Experience** renders these into the document: as PDF and HTML digital receipt through the receipt service (`https://receipts.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}`) and as ESC-POS print stream through the `/issue` endpoint. Every sample reviewed by the AT during the certification, and every layout correction the AT requested (designation of working documents, ATCUD and QR code on working documents, *IVA incluído*, *Documento anulado* on voided copies, the multi-page rule), was produced and resolved in this rendering.
- The **print format is maintained by fiskaltrust**. Neither the merchant nor the POS system can change the layout, the mandatory texts, or their position. This is a requirement of the AT (*print format protection*) and part of what was audited.
- The rendering also tracks **delivery**: when and how a document was handed out, and whether a print is the original or a copy (*Duplicado*).

A document layout rendered by other software, for example by the POS system itself from the data returned by the Middleware, has not been reviewed by the AT and is therefore **not covered by certificate 3535**. PosCreators should hand out the document produced by the Middleware (PDF, digital receipt link, or ESC-POS stream).

:::note Layouts rendered by the POS system

The conditions under which a POS system may render the document itself from the Middleware's print instructions, and whether this requires a certification of the POS system, are currently being clarified. Until fiskaltrust publishes these conditions, a self-rendered layout is outside the certified scope. PosCreators who require their own layout should contact fiskaltrust before going live. The [Receipt Printing](../receipt-printing/receipt-printing.md) chapter describes what the certified rendering contains.

:::

## Receipt options, configuration, and extension points

The certified document is rendered by the fiskaltrust receipt service from the signed request and response pair. Every rendering of a document is addressed by the same URL, which the Middleware returns as the caption of the QR code signature item:

```
https://receipts.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}            (production, certificate 3535)
https://receipts-sandbox.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}    (sandbox, placeholder 9999)
```

This section lists the output formats that are available for the document, what a PosOperator or PosCreator can configure without leaving the certified layout, which fields of the request are reflected on the document, and how the document is handed over through the `/issue` endpoint of the [PosSystem API](../../possystem-api/introduction.md).

### Rendering options

Both formats are produced from the same data and the same certified layout; they differ only in the medium. Select the format with a path suffix, with the `format` query parameter, or with the HTTP `Accept` header.

| Format | How to request it | Use it for | Notes |
| ------ | ----------------- | ---------- | ----- |
| **Digital receipt** | URL without suffix | The customer opens the link behind the QR code on a phone or a browser; the POS shows it on a customer display. | Interactive: download as PDF, send by e-mail, share with partner apps. Rendered with the Portuguese layout, labels, and the *Original* / *Duplicado* / *Documento anulado* markers. |
| **PDF** | `/pdf`, `?format=pdf`, or `Accept: application/pdf` | Sending the document by e-mail, archiving, the merchant copy, printing on an office printer. | Same content and layout as the digital receipt, rendered server-side. An A4 multi-page invoice layout exists and is currently enabled per POS system by fiskaltrust; contact fiskaltrust if you need it. |

### Original, duplicate, and voided renderings

The receipt service tracks how a document was delivered and adapts the rendering accordingly, so that the AT's rules on copies are met without any logic in the POS:

- The first rendering carries the marker **Original**.
- Once the POS has reported the document as printed or as accepted by the customer through the `/issue` endpoint (see below), every further rendering carries **Duplicado**.
- Appending `?copy=true` to either URL forces the **Duplicado** marker, e.g. for the merchant copy that is printed together with the original.
- A copy request sent to the Middleware (`ftReceiptCase` `0x3010`) has a URL of its own but renders the content of the referenced original with the **Duplicado** marker.
- After a void (`IsVoid` flag `0x0004`) has been issued, the rendering of the original document carries **Documento anulado** and keeps its ATCUD, QR code, and certificate line.

### What can be configured

The certified layout itself is fixed. Within it, the following elements are taken from the queue's receipt settings and can be adapted per outlet without affecting the certificate:

| Element | Source | How to change it |
| ------- | ------ | ---------------- |
| Merchant header: name, street, postal code, city, NIF | Outlet master data of the PosOperator in the fiskaltrust.Portal | Edit the outlet in the portal; the receipt service picks the data up for every queue of the outlet. |
| Logo | Image uploaded on the outlet in the fiskaltrust.Portal (*Select Image File*) | Upload or replace the image on the outlet. Width and height of the logo can be set in the receipt settings (`logowidth`, `logoheight`). |
| Website link on the logo | Receipt settings `website` | The logo links to this URL on the digital receipt. |
| Footer text | Receipt settings `footertext` | Free text printed after the last mandatory element, e.g. a thank-you line or return conditions. Line breaks are preserved. This is the place for the footer the AT requires after the mandatory elements; it must not look like one of them. |
| Feedback and sharing on the digital receipt | Receipt settings `showFeedback`, `shareButtonAppIds`, `enableConsumerApp` | Digital receipt only; these features do not appear on the PDF. |

Receipt settings other than the master data are stored per queue through the receipt settings endpoint of the receipt service, authenticated with the same `cashboxid` and `accesstoken` headers as the PosSystem API:

```
POST https://receipts.fiskaltrust.eu/v1/configuration/{ftQueueID}/receiptsettings
{
  "footertext": "Obrigado pela sua visita\nTrocas até 30 dias com este documento",
  "website": "https://www.example.pt",
  "logowidth": "200"
}
```

:::caution Custom templates

The receipt settings also accept a custom HTML template (`layout_html`). A custom template replaces the certified layout and is therefore outside certificate 3535 for Portuguese documents unless it has been reviewed and released by fiskaltrust. Do not set it on Portuguese queues without prior agreement.

:::

### Extension points in the request

The POS influences the content of the document only through the request it sends to the Middleware. Besides the fiscal fields, the following optional fields are rendered on the document. They are meant for information that belongs to the transaction; none of them may be used to replace or imitate a mandatory element.

| Field | Where it appears | Typical use |
| ----- | ---------------- | ----------- |
| `cbCustomer` (name, street, zip, city, country, `CustomerVATId`) | Customer block | Identified customer. Without `CustomerVATId` the document shows *Consumidor final*. |
| `cbUser` | Operator line | The operator who issued the document. Either a plain string or an object `{ "UserId": "...", "UserDisplayName": "...", "UserEmail": "..." }`; the display name is printed, the user ID is exported to the SAF-T. |
| `ftReceiptCaseData.cbReceiptLines` (array of strings) | Below the customer block, before the footer | Document-level free text: table number, order reference, delivery information, loyalty balance. |
| `ftChargeItemCaseData.cbChargeItemLines` (array of strings) | Below the article description | Line-level details: serial number, size, deposit information, promotion text. |
| `ftPayItemCaseData.cbPayItemLines` (array of strings) | *Dados da transação* block after the payments | Card payment details returned by the terminal (masked PAN, authorisation code, terminal ID). |
| `ReceiptTag` in `ftReceiptCaseData`, `ftChargeItemCaseData`, or `ftPayItemCaseData` | Not printed | Links the document to a pre-printed give-away QR label, see [Digital Receipt Implementation](../../digital-receipt/implementation/digital-receipt-implementation.md). |
| `ftReceiptCaseData.PT.Series` and `.Number` | Manual-document notice | Only with the `Handwritten` flag, see [Copies, voids, and manual documents](../receipt-printing/receipt-printing.md#copies-voids-and-manual-documents). |

Everything else on the document, in particular the document type, number, ATCUD, hash characters, certificate line, QR code, cash box identification (`ftCashBoxIdentification`), VAT summary, and the mandatory texts, is derived from the signed response and cannot be influenced by the request.

### Handing the document over with the issue endpoint

After `/sign`, the POS hands the signed request and response pair to `/issue`. The receipt service stores the pair, makes the URL above resolvable, and offers the following actions on `PUT /v2/issue/{ftQueueID}/{ftQueueItemID}`:

| `Action` | Effect |
| -------- | ------ |
| `print` | Records that the document was printed physically. Further renderings are marked *Duplicado*. |
| `accept` | Records that the customer accepted the digital receipt (e.g. scanned the QR code). Further renderings are marked *Duplicado*. |
| `send` with `Target.Scheme` `email`, `sms`, or `peppol` and `Target.Address` | Sends the document to the given address: by e-mail with the PDF attached, by SMS with the link, or as e-invoice through the Peppol network (Peppol is not part of the certified scope). |
| `link` with `Target.Alias` or `Target.Scheme` + `Target.Address` | Binds the document to a give-away QR label or another alias. |
| `download` with `Format` | Returns the document (e.g. `Format`: `pdf`) through the POS connection instead of the public URL. |

`GET /v2/issue/{ftQueueID}/{ftQueueItemID}` returns the delivery state (`None`, `Submitted`, `Printed` with the delivery method). The [Delivery](../../experience-middleware/delivery.md) chapter describes the delivery concept; the request and response models are in the PosSystem API reference.

### Samples

The following documents were rendered by the receipt service in the sandbox environment; they therefore carry the placeholder certificate number `9999` instead of `3535`. Production documents are identical apart from the number.

![Sample document rendered by the receipt service in the sandbox](https://receipts-sandbox.fiskaltrust.eu/1def4d45-ae9f-4562-a548-b8f5e84b88fb/f186b146-9bf7-44c6-86e8-fb3322e87e22/png)

*Figure 1. Sample document as rendered in the sandbox. Open the [digital receipt](https://receipts-sandbox.fiskaltrust.eu/1def4d45-ae9f-4562-a548-b8f5e84b88fb/f186b146-9bf7-44c6-86e8-fb3322e87e22) or the [PDF](https://receipts-sandbox.fiskaltrust.eu/1def4d45-ae9f-4562-a548-b8f5e84b88fb/f186b146-9bf7-44c6-86e8-fb3322e87e22/pdf) of the same document.*

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

## What this means for PosCreators

- **You integrate a certified program; you do not become one.** Your POS sends the business case to the fiskaltrust.CloudCashBox through the [PosSystem API](../../possystem-api/introduction.md). The Middleware numbers, signs, and exports the document under certificate 3535. Your software must not create, number, or sign fiscal documents itself.
- **Use the certified document.** Hand the customer the document rendered by fiskaltrust: the PDF or digital receipt reachable through the link in the QR code signature item, or the ESC-POS stream from the `/issue` endpoint. A layout drawn by your own software is not covered by the certificate (see [Certified document layout](#certified-document-layout)).
- **Print what you receive, unchanged.** If you display or print any returned element (document number, ATCUD, certificate line, QR code, mandatory texts), reproduce it exactly as returned. Never replace the certificate number, the hash characters, or the document number with your own values.
- **Send complete and valid requests.** The Middleware rejects requests that would produce a non-compliant document (see [Boundaries](#boundaries-of-the-certification)). Show the returned error to the operator and correct the request; do not retry with altered fiscal data.
- **Respect the document flow.** Refunds, voids, copies, and payments reference the original document via `cbPreviousReceiptReference`. Working documents (pro forma, budget, table check) carry no payment and are invoiced by reference. Series and ATCUD are assigned by the Middleware; there is no way to choose them.
- **Sandbox is not production.** Sandbox queues emit the placeholder certificate number `9999` and sandbox documents are never valid invoices. Use the sandbox for integration tests only; productive documents must be created on a production queue.
- **Self-hosted deployments need their own certification.** Running the Middleware on your own infrastructure or on a device (e.g. the Android launcher) is outside certificate 3535.

## What this means for PosOperators

- **You remain the taxpayer.** The fiskaltrust.CloudCashBox is the certified invoicing program you use; the documents are issued in your name, with your NIF, and you are responsible for handing them to your customers and for keeping them for the statutory retention period.
- **Series are registered for you.** fiskaltrust registers the document series with the AT and obtains the ATCUD validation codes on your behalf. You cannot create manual series or numbers; the recovery of handwritten documents issued during an outage is done through the Middleware's manual series.
- **SAF-T (PT) is your monthly obligation.** The Middleware produces the SAF-T (PT) file for your queue; submitting it to the AT within the legal deadline remains your responsibility (or your accountant's).
- **Corrections go through the program.** A wrong document is voided or credited through the POS, which creates the corresponding void or credit note; documents cannot be edited or deleted. A reprint is always marked as a copy.
- **The certificate number on your documents is 3535.** Documents that show `9999` were created in the sandbox and are not valid invoices.
- **Electronic delivery.** Documents you send as PDF are accepted as electronic invoices until 31 December 2026. From 1 January 2027 a qualified electronic signature or seal is required for PDF invoices sent electronically; fiskaltrust does not currently apply one.
- **Limits you will encounter.** Simplified invoices are limited to 100 EUR net, cash payments to 3 000 EUR per payment, only EUR is supported, and only the mainland tax region is available. Ask your POS provider to issue an invoice (FT) when a simplified invoice is not permitted.
