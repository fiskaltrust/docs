---
slug: /poscreators/middleware-doc/spain/go-to-market/fiskaltrust-declaration
title: "Integrating under fiskaltrust's declaration and registration"
---

# Integrating under fiskaltrust's declaration and registration

Your POS integrates with the **fiskaltrust.Middleware**, which fiskaltrust has declared towards the AEAT (VERI\*FACTU) and registered with the Basque tax authorities (TicketBAI); see [Declaration and Registration](../declaration/declaration.md). Your POS collects the business case and sends it to the fiskaltrust.Middleware; the fiskaltrust.Middleware creates, secures and transmits the fiscal record and returns what has to be printed.

## What the fiskaltrust.Middleware takes care of

- The declared and registered invoicing system for VERI\*FACTU and for the three Basque provinces, operated and maintained by fiskaltrust.
- Document numbering in two sequences per queue (simplified and complete invoices), without any configuration on your side.
- The VERI\*FACTU record with its hash chain and the signed TicketBAI file with its chaining, generated and transmitted automatically.
- The QR code, the VERI\*FACTU legend, the TBAI identifier and the response of the authority, returned as signature items.
- The certificates of your merchants, held in the fiskaltrust cloud; your POS never touches them.
- Updates when the AEAT or provincial specifications change, without any action on your side.

## What you build

Your integration consists of the same steps as in every other fiskaltrust market, described in [Integration Steps](../../../getting-started/middleware-integration.md) and the [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) chapter, with the following Spanish specifics:

1. **Send every business case through the [PosSystem API](../../possystem-api/introduction.md).** Use the receipt cases listed under [Supported document types](../declaration/declaration.md#supported-document-types): the POS receipt for simplified invoices, the invoice cases for complete invoices, the void flag for cancellations and the refund flag for returns.
2. **Choose the right charge item cases.** The VAT nibble must match the rate (21 %, 10 %, 4 %, 0 %), 0 % lines need the nature-of-VAT value that identifies the exemption or not-subject reason, and only the supported types of service may be used. See [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md).
3. **Provide the recipient of an invoice.** Pass the recipient of a complete invoice in `cbCustomer` with name, street, postcode and, for Spanish customers, a NIF in a valid format; foreign customers are identified by VAT ID, tax ID or passport.
4. **Hand out the document.** Print or display the series and number, the QR code, the VERI\*FACTU legend or the TBAI identifier exactly as returned. See [Receipt Printing](../receipt-printing/receipt-printing.md).
5. **Handle the document flow.** Cancellations and refunds reference the original document through `cbPreviousReceiptReference` and repeat its lines; partial refunds mark the returned lines with the charge-item refund flag.
6. **Handle outages.** Your POS cannot issue a numbered invoice while the fiskaltrust.Middleware is unreachable; see [What you need to know](./go-to-market.md#what-you-need-to-know).
7. **Show validation errors to the operator.** The fiskaltrust.Middleware and the tax authority reject requests that would produce a non-compliant record and return the reason in the response. Surface it and let the operator correct the input; do not retry with altered fiscal data.
8. **Show the software identification on request (TicketBAI).** The developer, the software name and the version of the fiskaltrust.Middleware must be displayable on one screen of the POS (*verificación in situ*). A fiskaltrust.Middleware endpoint that returns these values is being prepared; until then, ask fiskaltrust for them.

## What you must not build

The following stays with the fiskaltrust.Middleware:

- Own document numbers or series.
- Own hashes, signatures, QR codes, TBAI identifiers or legends.
- Own transmission to the AEAT or to the provincial web services, or own handling of the merchant's certificates.
- Own handling of corrections that bypasses the fiskaltrust.Middleware (editing or deleting issued documents).

## Onboarding steps

1. **Register in the fiskaltrust.Portal** for the sandbox and, when ready, for production, as described in [Portal Registration](../../../getting-started/portal-registration.md). Spain uses its own portal (`portal.fiskaltrust.es`, sandbox `portal-sandbox.fiskaltrust.es`).
2. **Integrate against the sandbox.** Create one queue per system you want to support (VERI\*FACTU, TicketBAI Araba, Bizkaia or Gipuzkoa). Sandbox queues transmit to the test environments of the tax authorities with fiskaltrust's test certificates. Verify one sample of every document type you issue: a simplified invoice, a complete invoice with a Spanish and with a foreign customer, a 0 % line with an exemption reason, a void, a full and a partial refund.
3. **Run through the [Integration Checklist](../../../getting-started/integration-checklist.md)** and the Spanish specifics: initial-operation receipt, every document type, the document layout against the [Receipt Printing](../receipt-printing/receipt-printing.md) checklist, the outage procedure, and the on-site verification screen.
4. **Go live.** Production queues transmit to the productive endpoints. The merchant uploads its certificate in the fiskaltrust.Portal before the first document; for TicketBAI the certificate must be registered with the province (device certificates through Izenpe).

For the scope of the fiskaltrust.Middleware and the requests it rejects, see [Boundaries](../declaration/declaration.md#boundaries). For the obligations that remain with your customers, see [What this means for PosOperators](../declaration/declaration.md#what-this-means-for-posoperators).
