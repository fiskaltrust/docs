---
slug: /poscreators/middleware-doc/greece/go-to-market/fiskaltrust-licence
title: 'Route 1: Using the fiskaltrust.Middleware for Cloud'
---

# Route 1: Using the fiskaltrust.Middleware for Cloud

On this route your POS system integrates with the **fiskaltrust.Middleware for Cloud**, which transmits the documents to myDATA under the AADE provider licence it operates under (currently Viva's licence, provider ID **126**; see [Licensing](../licensing/licensing.md)). Your POS acts as the front end of a licensed provider platform: it collects the business case and the terminal data and sends them to the Middleware, and the Middleware creates the myDATA document. You do not go through a licensing procedure yourself.

This is the fastest way into the Greek market and the right choice whenever the [supported document types](../licensing/licensing.md#supported-document-types) cover your use case.

## What you get

- A provider platform that is registered with AADE, operated and maintained by fiskaltrust, with the provider credentials for myDATA.
- Document numbering per queue, with duplicate handling against myDATA, without any configuration on your side.
- The mapping to myDATA invoice types, classifications, VAT and exemption categories, payment methods and special taxes, applied automatically.
- MARK, UID, authentication code, unique document identifier, QR code and provider footer returned as signature items, plus the complete myDATA XML for audit.
- The digital receipt rendered by fiskaltrust behind the QR code, and the ESC-POS stream through the `/issue` endpoint.
- Updates when the myDATA API or the AADE rules change, without a new procedure on your side.

## What you build

Your integration consists of the same steps as in every other fiskaltrust market, described in [Integration Steps](../../../getting-started/middleware-integration.md) and the [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) chapter, with the Greek specifics from this appendix:

1. **Send every business case through the [PosSystem API](../../possystem-api/introduction.md).** Use the receipt cases listed under [Supported document types](../licensing/licensing.md#supported-document-types): the POS receipt for retail receipts, the invoice cases for invoices, the refund flag for credit documents, payment transfer for POS payment receipts, the order case for restaurant order slips and the delivery-note case with transport information for delivery notes.
2. **Choose the right charge item cases.** The type of service (goods, service, on behalf of third parties, own consumption) and the VAT nibble decide the myDATA type and classification; a 0 % line needs the nature-of-VAT value. Special taxes (fees, withholding, stamp duty) are charge items with the exact Greek description. See [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md).
3. **Connect the payment terminal.** Hand over the terminal response for every card payment in `ftPayItemCaseData` (payment signature, AADE transaction ID, tip), so that the Middleware transmits it with the document and the receipt carries it. See [Type of Payment: ftPayItemCase](../reference-tables/type-of-payment-ftpayitemcase.md).
4. **Provide the master data the document needs.** The customer with VAT number and country for invoices, the table number in `cbArea` for orders, transport details in `ftReceiptCaseData` for delivery notes.
5. **Hand out the document.** Print or display MARK, UID, authentication code, unique document identifier, QR code and the provider footer exactly as returned, or hand out the digital receipt behind the QR code. See [Receipt Printing](../receipt-printing/receipt-printing.md).
6. **Handle the document flow.** Refunds and credit notes reference the original document; orders are cancelled through the void flag with a reference and the table number; payments on invoices are reported through the pay case.
7. **Handle outages.** Issue receipts with the loss-of-connection notice while the Middleware is unreachable and send them afterwards with the late-signing flag; recover handwritten receipts with the handwritten flag and their own series.
8. **Show validation errors to the operator.** The Middleware and myDATA reject requests that would produce a non-compliant document and return the reason in the response. Surface it and let the operator correct the input; do not retry with altered fiscal data.

## What you must not build

The following are part of the provider platform and must stay with the Middleware:

- Own transmission to myDATA or own provider credentials.
- Own MARK, UID, authentication code or QR code, or own texts in place of the returned provider footer.
- Own document series or numbers (except the series of handwritten documents).
- Own handling of corrections that bypasses the Middleware (editing or deleting issued documents).

## Onboarding steps

1. **Register in the fiskaltrust portal** for the sandbox and, when ready, for production, as described in [Portal Registration](../../../getting-started/portal-registration.md). The Greek contracts are available in the portal. The account master data must contain the merchant's VAT number.
2. **Integrate against the sandbox.** Create the CashBox from the Greek sandbox template offered in the portal (currently *Viva-Fiscal-Sandbox*). Sandbox queues transmit to the myDATA test environment and return the raw myDATA request and response in `ftStateData`. Verify one sample of every document type you issue, a refund, an order and its cancellation, a card payment with terminal data, a late-signing receipt and a handwritten receipt.
3. **Run through the [Integration Checklist](../../../getting-started/integration-checklist.md)** and the Greek specifics: initial-operation receipt, every document type, the receipt layout against the [Receipt Printing](../receipt-printing/receipt-printing.md) checklist.
4. **Go live.** Production queues transmit to the productive myDATA environment. The merchant's provider statement to AADE and the onboarding steps AADE expects from the merchant are being clarified; ask fiskaltrust before the first productive document.

## Boundaries of this route

- **Cloud only.** The provider credentials are part of the fiskaltrust cloud deployment; self-hosted or on-device installations are not available for Greece.
- **Supported scope only.** Receipt cases and features outside the supported scope, such as table checks, pro forma documents, voids of receipts, document-level discounts, B2G invoicing or foreign currency, are rejected by the Middleware. See [Boundaries](../licensing/licensing.md#boundaries).
- **Licence of the licensee.** The provider footer on your receipts names the licensee under whose licence the Middleware operates, not fiskaltrust and not you. If this matters for your product, discuss the setup with fiskaltrust before you start.

For the obligations that remain with your customers, the merchants, see [What this means for PosOperators](../licensing/licensing.md#what-this-means-for-posoperators).
