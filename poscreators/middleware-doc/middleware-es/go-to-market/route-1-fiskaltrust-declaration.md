---
slug: /poscreators/middleware-doc/spain/go-to-market/fiskaltrust-declaration
title: "Route 1: Using fiskaltrust's declaration and registration"
---

# Route 1: Using fiskaltrust's declaration and registration

On this route your POS system integrates with the **fiskaltrust.Middleware for Cloud**. The Middleware is the *Sistema Informático de Facturación* that fiskaltrust has declared towards the AEAT in its declaración responsable, and the *software garante* that fiskaltrust has registered with the Basque tax authorities (see [Declaration and Registration](../declaration/declaration.md)). Your POS acts as the front end of this system: it collects the business case and sends it to the Middleware, and the Middleware creates the fiscal record. You do not register anything with the tax authorities yourself; you declare your POS as a component of the system.

This is the fastest way into the Spanish market and the right choice whenever the [supported document types](../declaration/declaration.md#supported-document-types) cover your use case.

## What you get

- A declared and registered invoicing system, operated and maintained by fiskaltrust, for the common territory (VERI\*FACTU) and for the three Basque provinces (TicketBAI).
- Document numbering in two sequences per queue (simplified and complete invoices), without any configuration on your side.
- The VERI\*FACTU record with its hash chain and the signed TicketBAI file with its chaining, generated and transmitted automatically.
- The QR code, the VERI\*FACTU legend, the hash, the TBAI identifier and the response of the authority returned as signature items.
- The certificates of your merchants held in the fiskaltrust cloud; your POS never touches them.
- Updates when the AEAT or provincial specifications change, without a new declaration on your side for the Middleware.

## What you build

Your integration consists of the same steps as in every other fiskaltrust market, described in [Integration Steps](../../../getting-started/middleware-integration.md) and the [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) chapter, with the Spanish specifics from this appendix:

1. **Send every business case through the [PosSystem API](../../possystem-api/introduction.md).** Use the receipt cases listed under [Supported document types](../declaration/declaration.md#supported-document-types): the POS receipt for simplified invoices, the invoice cases for complete invoices, the void flag for cancellations and the refund flag for returns.
2. **Choose the right charge item cases.** The VAT nibble must match the rate (21 %, 10 %, 4 %, 0 %), 0 % lines need the nature-of-VAT value that identifies the exemption or not-subject reason, and only the supported types of service may be used. See [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md).
3. **Provide the recipient of an invoice.** Pass the recipient of a complete invoice in `cbCustomer` with name, street, postcode and, for Spanish customers, a NIF in a valid format; foreign customers are identified by VAT ID, tax ID or passport. The recipient is transmitted in TicketBAI files but not yet in VERI\*FACTU records.
4. **Hand out the document.** Print or display the series and number, the QR code, the VERI\*FACTU legend or the TBAI identifier exactly as returned, together with the mandatory content of a Spanish invoice. See [Receipt Printing](../receipt-printing/receipt-printing.md).
5. **Handle the document flow.** Cancellations and refunds reference the original document through `cbPreviousReceiptReference` and repeat its lines; partial refunds mark the returned lines with the charge-item refund flag.
6. **Handle outages.** Your POS cannot issue a numbered invoice while the Middleware is unreachable. Implement the provisional-receipt procedure described under [Key factors](./go-to-market.md#key-factors-for-the-spanish-market) and issue the official invoice as soon as the connection is back.
7. **Show validation errors to the operator.** The Middleware and the tax authority reject requests that would produce a non-compliant record and return the reason in the response. Surface it and let the operator correct the input; do not retry with altered fiscal data.
8. **Show the software identification on request.** TicketBAI requires that the developer, the software name and the version can be displayed on one screen of the POS (*verificación in situ*). Display the values of the [Declaration and Registration](../declaration/declaration.md#what-fiskaltrust-holds) chapter; a Middleware endpoint that returns them is being prepared.

## What you declare

*Orden HAC/1177/2024* requires a declaración responsable for every component of an invoicing system that is produced by a different producer. On this route:

- **fiskaltrust** has declared the fiskaltrust.Middleware (record generation, hash chain, transmission, storage, export).
- **You** declare your POS software as the upstream component: user interface, capture of the invoice data, secure transmission to the Middleware, reception of the returned data, and printing of the document with the data processed by the Middleware. fiskaltrust provides a supplement template for this purpose; it names your company, your product and version, and confirms that the data you transmit is complete, correct and cannot be altered on the way. You also describe how your POS behaves when the Middleware cannot be reached.

Sign the supplement for every version of your product, keep it together with fiskaltrust's declaration, and make both available to your merchants (for example as a download in your product). Ask [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) for the current template and for fiskaltrust's signed declaration. For the Basque provinces no additional registration of your POS is required on this route; the Middleware is the registered software.

## What you must not build

The following are part of the declared system and must stay with the Middleware. Building them in the POS would take the document outside fiskaltrust's declaration:

- Own document numbers or series.
- Own hashes, signatures, QR codes, TBAI identifiers or legends.
- Own transmission to the AEAT or to the provincial web services, or own handling of the merchant's certificates.
- Own handling of corrections that bypasses the Middleware (editing or deleting issued documents).

## Onboarding steps

1. **Register in the fiskaltrust portal** for the sandbox and, when ready, for production, as described in [Portal Registration](../../../getting-started/portal-registration.md). Spain uses its own portal (`portal.fiskaltrust.es`, sandbox `portal-sandbox.fiskaltrust.es`).
2. **Integrate against the sandbox.** Create one queue per regime you want to support (VERI\*FACTU, TicketBAI Araba, Bizkaia or Gipuzkoa). Sandbox queues transmit to the AEAT pre-production environment and to the test environments of the provinces, using fiskaltrust's test certificates and test licence codes. Verify one sample of every document type you issue: a simplified invoice, a complete invoice with a Spanish and with a foreign customer, a 0 % line with an exemption reason, a void, a full and a partial refund.
3. **Run through the [Integration Checklist](../../../getting-started/integration-checklist.md)** and the Spanish specifics: initial-operation receipt, every document type, the document layout against the [Receipt Printing](../receipt-printing/receipt-printing.md) checklist, the outage procedure, and the on-site verification screen.
4. **Sign your component supplement** to the declaración responsable (see [What you declare](#what-you-declare)).
5. **Go live.** Production queues transmit to the productive endpoints. The merchant uploads its certificate in the portal before the first document; for TicketBAI the certificate must be registered with the province (device certificates through Izenpe). Ask fiskaltrust for the current status of the TicketBAI registration before your first productive Basque document.

## Boundaries of this route

- **Cloud only.** The declaration and registration cover the Middleware as operated by fiskaltrust. If you need a self-hosted or on-device installation, see [Route 2](./route-2-own-declaration.md).
- **Supported scope only.** Document types and features outside the supported scope, such as corrective invoices, TicketBAI cancellations, vouchers, the equivalence surcharge, No VERI\*FACTU mode or SII, are rejected by the Middleware or not available. See [Boundaries](../declaration/declaration.md#boundaries).
- **fiskaltrust's identification.** The records name fiskaltrust as producer of the system and carry fiskaltrust's licence codes. If your product must appear as the declared or registered software, take Route 2.

For the obligations that remain with your customers, the merchants, see [What this means for PosOperators](../declaration/declaration.md#what-this-means-for-posoperators).
