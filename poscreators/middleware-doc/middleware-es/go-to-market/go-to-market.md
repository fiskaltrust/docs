---
slug: /poscreators/middleware-doc/spain/go-to-market
title: Go-to-Market
---

# Go-to-Market in Spain

Spain has two fiscal systems for invoicing software: **VERI\*FACTU** in the common territory (all of Spain except the Basque Country and Navarre, including the Canary Islands, Ceuta and Melilla) and **TicketBAI** in the three Basque provinces Araba/Álava, Bizkaia and Gipuzkoa. Both require that every invoice is recorded, secured and reported to the tax authority, and both put the compliance obligation on the producer of the invoicing software.

With fiskaltrust, **the fiskaltrust.Middleware takes care of this**. fiskaltrust has signed the *declaración responsable* for VERI\*FACTU and has registered the fiskaltrust.Middleware as TicketBAI software (see [Declaration and Registration](../declaration/declaration.md)). Your POS sends its business cases to the fiskaltrust.Middleware and prints what comes back. You do not sign a declaration, register software or implement fiscal logic yourself.

## Who does what

| Topic | Handled by |
| ----- | ---------- |
| Declaración responsable (VERI\*FACTU) | fiskaltrust |
| TicketBAI software registration and licence codes | fiskaltrust |
| Validation of every request against the Spanish rules | fiskaltrust.Middleware |
| Series and numbering | fiskaltrust.Middleware |
| VERI\*FACTU record with hash chain, signed TicketBAI file with chaining | fiskaltrust.Middleware |
| Transmission to the AEAT and to the provincial tax authorities | fiskaltrust.Middleware |
| QR code, VERI\*FACTU legend and TBAI identifier | fiskaltrust.Middleware generates them, your POS prints them |
| Storage and use of the merchant's certificates | fiskaltrust.Middleware; the merchant uploads the certificate in the fiskaltrust.Portal |
| Regulatory updates | fiskaltrust |
| Sending the business cases through the PosSystem API | Your POS |
| Printing or displaying the document | Your POS |
| Showing validation errors and handling outages | Your POS |

The steps on your side are described in [Integrating under fiskaltrust's declaration and registration](./fiskaltrust-declaration.md).

## What you need to know

**The merchant's territory decides the queue.** A merchant with an establishment in Araba, Bizkaia or Gipuzkoa issues the invoices of that establishment under TicketBAI of that province; all other establishments use VERI\*FACTU. In the fiskaltrust.Middleware this is a property of the queue: a queue is set up either for VERI\*FACTU or for TicketBAI of one province, and the choice cannot be changed afterwards. The requests your POS sends are the same in both cases; only the returned signature items differ. For the Canary Islands, Ceuta and Melilla the applied tax (IGIC or IPSI instead of VAT) is part of the queue configuration.

**Every document is transmitted in real time.** The fiskaltrust.Middleware transmits every record synchronously, and the response of the tax authority decides whether the document is issued. The response time of the authority is therefore part of the checkout time.

**No numbered invoice without the fiskaltrust.Middleware.** While your POS cannot reach the fiskaltrust.Middleware it cannot issue a numbered invoice. In exceptional situations a provisional receipt may be handed to the customer and must be replaced by the official invoice as soon as the connection is back. Contact fiskaltrust for the recommended procedure for outages.

**The merchant needs a certificate.** Transmission and signature use a qualified electronic certificate of the merchant (for TicketBAI additionally a device certificate issued by Izenpe). The merchant uploads it in the Spanish fiskaltrust.Portal (`portal.fiskaltrust.es`) during onboarding; your POS never handles it.

**Supported scope.** The fiskaltrust.Middleware issues simplified invoices, complete invoices, cancellations and refunds. Corrective invoice types, TicketBAI cancellations, vouchers, the equivalence surcharge and SII are not available yet. See [Supported document types](../declaration/declaration.md#supported-document-types) and [Boundaries](../declaration/declaration.md#boundaries).

## Deadlines

| Merchants | Must use a compliant invoicing system from |
| --------- | ------------------------------------------ |
| Subject to corporate income tax | 1 January 2027 |
| All others (self-employed, other taxpayers) | 1 July 2027 |
| With an establishment in Araba, Bizkaia or Gipuzkoa | TicketBAI is already in force |

The VERI\*FACTU dates were set by [Real Decreto-ley 15/2025](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2025-24446), which postponed the original deadlines by one year. Confirm the dates that apply to your customers with fiskaltrust before you plan the release.

## Frequently asked questions

**Do I have to sign or register anything?**
No. fiskaltrust's declaración responsable and TicketBAI registration cover the fiskaltrust.Middleware. You integrate your POS; there is nothing to sign or register on your side.

**Can I run the fiskaltrust.Middleware on my own infrastructure?**
No. In Spain the fiskaltrust.Middleware runs in the fiskaltrust cloud.

**Does this restrict how my POS looks?**
No. Your POS can look and behave as you like. The QR code, the legend and the identifiers on the document are the ones returned by the fiskaltrust.Middleware; see [Receipt Printing](../receipt-printing/receipt-printing.md).

**Where do I get help?**
Contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) for the commercial setup in Spain.
