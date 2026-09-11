---
slug: /poscreators/middleware-doc/portugal/go-to-market/own-certificate
title: 'Route 2: Certifying your own solution'
---

# Route 2: Certifying your own solution

On this route you build your product on top of the fiskaltrust.Middleware and obtain **your own certificate** from the AT for the combined solution. You are listed in the AT register, you talk to the AT, and you are responsible for everything the AT audits around the Middleware: the rendered document, master-data and print-format protection, user management, and operational measures.

Choose this route when you need a self-hosted or on-device deployment, a document layout of your own, or functionality outside the [certified scope](../certification/certification.md#boundaries-of-the-certification) of the fiskaltrust.CloudCashBox, or when you want to hold the certificate yourself.

This page describes the procedure as fiskaltrust went through it for the CloudCashBox in 2025 and early 2026. The AT may adapt its tests over time; treat the lists below as what to expect, not as the definitive test plan for your procedure.

:::note We are looking for partners for this route

fiskaltrust has not yet accompanied a partner through a certification of their own solution on top of the fiskaltrust.Middleware. The procedure below is what we experienced with our own program; the division of responsibilities and the support described on this page are what we offer to a first partner. If you are considering this route, contact [sales@fiskaltrust.pt](mailto:sales@fiskaltrust.pt) early so we can plan the procedure together.

:::

:::info Plan the procedure with fiskaltrust

Several settings that are fixed in the fiskaltrust.CloudCashBox must be set up for your product before the first submission: the certificate number placeholder, the product identification and producer NIF in the SAF-T (PT) header, and the signing key pair whose public key you declare to the AT. Contact fiskaltrust before you register with the AT so these are in place.

:::

## Division of responsibilities

| Area | Provided by the fiskaltrust.Middleware | Provided by you |
| ---- | -------------------------------------- | --------------- |
| Document numbering | Series with ATCUD, sequential numbering per series, chronology check | Nothing; series are registered through the Middleware |
| Signature | RSA signature and hash chain per series, hash extract for printing | Safekeeping of the private key in your deployment |
| Document content | Validation of every request against the Portuguese business rules, all mandatory texts as signature items | Correct master data in the request: descriptions, VAT rates, exemption reasons, customer NIF and country, operator |
| Document layout | Print instructions per element (format, position); the certified rendering via `/issue` if you use it | Your layout, if you render the document yourself: every mandatory element, copy and void markers, multi-page rule, language |
| QR code | Content according to *Portaria n.º 195/2020* | Rendering on the document |
| SAF-T (PT) | Complete audit file in structure 1.04_01 via the journal endpoint | Export function accessible to the merchant, submission workflow |
| Corrections | Voids, credit notes, partial credit notes, copies, manual-document recovery, all with the required checks | UI that only offers these operations, never editing or deleting documents |
| Master data | Audit log entries via protocol receipts | Protection of articles, customers, VAT table, and exemption reasons against uncontrolled changes; users with fixed usernames |
| Operations | Cloud or self-hosted Middleware | Backup and continuity plan, protection of the database and of the print format, system time control |

## The certification procedure

The procedure has five phases. Phases 2 and 3 are usually repeated: each submission is answered with findings, and the next submission must contain the complete set of samples again.

### Phase 1: Registration (Modelo 24)

The producer registers the program with the AT through the *Modelo 24* declaration on the Portal das Finanças. The declaration identifies the producer (NIF), the program and its version, the type of application (invoicing, accounting, or both), and contains the **public key** of the RSA key pair used to sign documents. The private key must never leave your deployment; in the fiskaltrust.Middleware it is held by the Portuguese SCU.

After the registration the AT opens the procedure and asks for the initial documentation.

### Phase 2: Initial submission

The AT asks for a single package with:

1. A direct telephone contact for scheduling the compliance session.
2. The public key as a text file, identical to the one declared in Modelo 24.
3. A statement of the type of application and of the document types it issues (invoices, transport documents, working documents, receipts), and whether it is open source.
4. Sample documents in PDF, issued in **two different months**, each signed and showing the four hash characters and the certificate line with the placeholder number `9999`.
5. One SAF-T (PT) file in structure 1.04_01 containing all sample documents, with the hash control fields filled in, validated beforehand with the AT's SAF-T (PT) validation tool, which the AT provides in the software certification section of the Portal das Finanças (*Certificação de Software de Faturação*).
6. A cover letter that maps every requested sample to a file, or states *não aplicável* with a short justification when the program does not issue that document.

The requested samples, with the receipt case that produces each of them in the fiskaltrust.Middleware:

| # | Requested sample | How to produce it |
| - | ---------------- | ----------------- |
| 5.1 | Simplified invoice for a customer who provided a NIF | `0x0001` with `cbCustomer.CustomerVATId` |
| 5.2 | Cancelled invoice and its PDF showing the cancellation | `0x1001`, then the same request with the `IsVoid` flag |
| 5.3 | Document handed to the customer to check goods or services | `0x0007` pro forma, `0x0006` table check, or budget |
| 5.4 | Invoice based on 5.3 (must generate `OrderReferences`) | `0x1001` with `cbPreviousReceiptReference` to the working document |
| 5.5 | Credit note based on 5.4 (must generate `References`) | `0x1001` with the refund flag and `cbPreviousReceiptReference` |
| 5.6 | Invoice with four lines: reduced, exempt (with `TaxExemptionReason`), intermediate, standard rate | `0x1001` with four charge items and the exemption code in the nature-of-VAT segment |
| 5.7 | Document with a line discount of 8.8 % on 100 units and a global discount (`SettlementAmount`) | `0x0001` with discount charge items; global discounts are not supported by the Middleware, state so |
| 5.8 | Document in foreign currency | Not supported by the Middleware; state *não aplicável* |
| 5.9 | Document for a named customer without NIF with a total below 1 EUR, entered before 10:00 | `0x0001` with `CustomerName` and NIF `999999990` |
| 5.10 | Document for another named customer without NIF | `0x0001` |
| 5.11 | Two transport documents, one valued and one not | Not supported by the Middleware; state *não aplicável* |
| 5.12 | Budget or pro forma invoice | `0x0007` |
| 5.13 | One example of every other document type the program issues | e.g. receipt `0x0002`, table check `0x0006` |

Unit prices in the SAF-T must be net of VAT and reflect line discounts, with enough decimal places to avoid rounding differences.

### Phase 3: Working through the findings with the AT

An AT auditor is assigned to the procedure and answers with a report: errors found in the documents and the SAF-T, fiscal questions, and a list of tests to perform. The report fiskaltrust received contained 34 tests. In summary they cover:

- **Documentation questions**: whether the program is open source and how security is ensured in that case, whether it performs accounting, whether it is sold commercially, which sector it targets, and the measures against data loss (backup frequency, redundancy, continuity plan).
- **Document tests**: simplified invoice for a NIF-only customer, invoice cancelled by a different user than the issuer, working document and an invoice based on it two days later by yet another user, credit note with `References`, invoice with due date (`PaymentTerms`), invoice with five lines and two different exemption reasons, invoice-receipt, partial credit note correcting a price and returning a unit, a two-line document with quantities above one and a global discount, invoice with a recorded payment, foreign currency, a total below 1 EUR for a first-time customer without NIF, a document with 2 000 units at a very low unit price, a document entered before 10:00, a **two-page document**, a tax-only correction (`TaxBase`), serial numbers, excise documents, and receipts for the documents above.
- **Recovery tests**: integration of manual documents issued on pre-printed forms, re-entry of documents lost through a backup restore, and integration of documents from another system.
- **A new SAF-T (PT)** covering at least two months with consecutive numbering in every series.

For tests the program cannot perform, the answer is *não aplicável* with a one-line justification. The AT accepts this for optional features (foreign currency, transport documents, cash VAT regime, serial numbers), but every document the program does issue must pass. Submitted files must follow the naming convention the auditor asks for, typically the test number followed by the document number, and the SAF-T must be validated with signature validation before sending.

### Phase 4: Compliance session

The procedure ends with a live session with the AT, held remotely in our case. Prepare it with a **fresh database without transactions** and a manager account limited to what the demo needs. The agenda fiskaltrust was given:

- **Architecture and operations**: cloud or local operation, offline mode, multiple locations, operating system, database type and location, protection of the database and of the private key, programming language, backups and restore including checksums, target market, and how series are created and managed (automatically through the AT webservice or manually).
- **Header data and print format protection**: who can change them, and how the merchant is prevented from doing so.
- **Users**: create two users, show that usernames cannot be changed, are at least three characters long, and that a user involved in a transaction cannot be deleted.
- **Articles and customers**: mandatory fields, descriptions of at least three characters, NIF validation, no changes or deletions after a sale, only deactivation and creation.
- **VAT and exemption reasons**: no free editing of the VAT table, only valid exemption reasons.
- **Transactions**: simplified invoices with and without customer, with NIF, with line and total discounts; invoices over more than one page; invoices with several VAT rates and two exemption reasons; void with copy of the voided document; copies after master-data changes; credit notes, partial credit notes, credit notes on voided documents (must be refused); the 1 000 EUR and 100 EUR limits for simplified invoices; cash payments above 3 000 EUR (must be refused); working documents chained to invoices and payments; system-time control; training mode; manual invoices; recovery after data loss; and a SAF-T export for a full year available to all users.

The auditor follows the SAF-T of the session document by document, so every document created in the demo must appear correctly in the export.

### Phase 5: Certificate and rollout

When the session is passed, the AT issues the certificate number and lists the program on the [Portal das Finanças](https://www.portaldasfinancas.gov.pt/pt/consultaProgCertificadosM24.action). From then on the number replaces the `9999` placeholder in the certificate line, the QR code, and the SAF-T header of every production document; test and training environments keep the placeholder.

Significant changes to the program, such as new document types, a new layout engine, or a new deployment model, may require a new procedure. Discuss planned changes with the AT before releasing them.

## What the AT found in our procedure

The following findings cost us submission rounds. Check them before your first submission:

- Working documents must show the correct designation (*Consulta de mesa* for table checks, *Orçamento* for budgets), the ATCUD, the QR code, and *IVA incluído*.
- A voided document must keep its ATCUD and QR code and state *Documento anulado* on every reprint.
- A working document that has been invoiced must have status `F` with the invoicing user as `SourceID`, and must not be voidable afterwards. An invoice must not reference a voided working document.
- Line numbers in the SAF-T must follow the printed order without gaps.
- The customer of a credit note must be the customer of the referenced invoice; a receipt must not be issued for a voided or fully credited invoice or for a different customer.
- Leading and trailing whitespace in article and customer names must be trimmed, otherwise duplicates appear in the master files.
- Without a NIF the customer is *Consumidor final* with NIF `999999990`; without a country the SAF-T and the QR code carry *Desconhecido*.
- Simplified invoices are limited to 100 EUR net; individual cash payments to 3 000 EUR.
- Totals must reconcile: sum of lines against `NetTotal`, calculated tax against `TaxPayable`, `NetTotal` plus `TaxPayable` against `GrossTotal`, and the sum of payments against the document total. Voided documents are excluded from the working-document totals.
- Documents for domestic operations must be in Portuguese; a bilingual layout is allowed, a foreign-language-only layout is not.
- Multi-page documents must repeat type, number, ATCUD, and page count on every page and carry the transported amounts.

The fiskaltrust.Middleware enforces most of these rules today (see [Boundaries of the certification](../certification/certification.md#boundaries-of-the-certification)), so on this route they mainly concern the parts you build yourself: the layout and the user interface.

## Effort

Our own procedure took several submission rounds over about a year, from the first registration to the certificate, including the time needed to implement the findings. A partner that reuses the Middleware's validation, signing, and SAF-T export starts from a much better position, but should still plan for at least two submission rounds and the compliance session. As no partner has taken this route yet, there is no reference value for the effort on the partner's side. fiskaltrust supports partners on this route with the documentation of the Middleware's behaviour, sample requests for every test, and the experience from its own procedure; contact [sales@fiskaltrust.pt](mailto:sales@fiskaltrust.pt).
