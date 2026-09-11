---
slug: /poscreators/middleware-doc/portugal/go-to-market/fiskaltrust-certificate
title: 'Route 1: Using the fiskaltrust certificate'
---

# Route 1: Using the fiskaltrust certificate

On this route your POS system integrates with the **fiskaltrust.Middleware for Cloud** (fiskaltrust.CloudCashBox), which is certified by the AT under **certificate number 3535**. Your POS acts as the front end of a certified program: it collects the business case and sends it to the Middleware, and the Middleware creates the fiscal document. You do not go through a certification procedure yourself.

This is the fastest way into the Portuguese market and the right choice whenever the [certified scope](../certification/certification.md#certified-document-types) covers your use case.

## What you get

- A certified invoicing program listed in the AT register, operated and maintained by fiskaltrust.
- Document numbering in series registered with the AT, including ATCUD codes, without any configuration on your side.
- Signing, QR code, SAF-T (PT) export, and the Portuguese validation rules, all applied automatically.
- The certified document rendering (PDF, digital receipt, ESC-POS) through the receipt service and the `/issue` endpoint.
- Updates to the program when the regulation changes, without a new certification on your side.

The Certification chapter lists the components that are [always provided by the fiskaltrust.Middleware](../certification/certification.md#always-provided-by-the-fiskaltrustmiddleware) and those that fiskaltrust additionally [provides as operator of the certified program](../certification/certification.md#provided-by-fiskaltrust-as-operator-of-the-certified-program) on this route.

## What you build

Your integration consists of the same steps as in every other fiskaltrust market, described in [Integration Steps](../../../getting-started/middleware-integration.md) and the [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) chapter, with the Portuguese specifics from this appendix:

1. **Send every business case through the [PosSystem API](../../possystem-api/introduction.md).** Use the receipt cases listed under [Certified document types](../certification/certification.md#certified-document-types): POS receipt for simplified invoices, invoice cases for invoices, the refund flag for credit notes, payment transfer for receipts, and the working-document cases for pro forma, budget, and table check.
2. **Hand out the certified document.** Give the customer the document rendered by fiskaltrust: the PDF or digital receipt behind the link in the QR code signature item, or the ESC-POS stream from the `/issue` endpoint (see [Delivery](../../experience-middleware/delivery.md)). If your POS displays or prints any of the returned values (document number, ATCUD, certificate line, QR code, mandatory texts), reproduce them exactly as returned. See [Receipt Printing](../receipt-printing/receipt-printing.md).
3. **Handle the document flow.** Refunds, voids, copies, and payments reference the original document through `cbPreviousReceiptReference`. Working documents carry no payment and are invoiced by reference.
4. **Show validation errors to the operator.** The Middleware rejects requests that would produce a non-compliant document and returns the reason in the response. Surface it and let the operator correct the input; do not retry with altered fiscal data.
5. **Provide the master data the document needs.** Article descriptions of at least three characters, VAT rate and exemption reason per line, the operator in `cbUser`, and the customer with a valid NIF and country when the customer wants to be identified.

## What you must not build

The following are part of the certified program and must stay with the Middleware. Building them in the POS would take the document outside the certificate:

- Own document numbers, series, or ATCUD codes.
- Own signatures, hashes, or QR codes.
- Own SAF-T (PT) export.
- Own layout of the fiscal document. The conditions for POS-rendered layouts are being clarified; see [Certified document layout](../certification/certification.md#certified-document-layout). Contact fiskaltrust before going live if you need this.
- Own handling of voids or corrections that bypasses the Middleware (editing or deleting issued documents).

## Onboarding steps

1. **Register in the fiskaltrust portal** for the sandbox and, when ready, for production, as described in [Portal Registration](../../../getting-started/portal-registration.md).
2. **Integrate against the sandbox.** Sandbox queues emit the placeholder certificate number `9999`; sandbox documents are never valid invoices. Use the [certified document types](../certification/certification.md#certified-document-types) and the [Receipt Printing](../receipt-printing/receipt-printing.md) checklist to verify one sample of every document type you issue.
3. **Run through the [Integration Checklist](../../../getting-started/integration-checklist.md)** and the Portuguese specifics: initial-operation receipt, every document type, a refund, a void, a copy, and a SAF-T (PT) export via the journal endpoint.
4. **Go live.** Production queues emit certificate number `3535`. Series are registered with the AT by fiskaltrust when the queue is set up; no action is needed on your side.

## Boundaries of this route

- **Cloud only.** The certificate covers the Middleware as operated by fiskaltrust. If you need a self-hosted or on-device installation (e.g. the Android launcher), see [Route 2](./route-2-own-certificate.md).
- **Certified scope only.** Document types and features outside the certified scope, such as transport documents, foreign currency, or the Azores and Madeira tax regions, are rejected by the Middleware. See [Boundaries of the certification](../certification/certification.md#boundaries-of-the-certification).
- **Certified rendering.** The document handed to the customer is the one rendered by fiskaltrust.

For the obligations that remain with your customers, the merchants, see [What this means for PosOperators](../certification/certification.md#what-this-means-for-posoperators).
