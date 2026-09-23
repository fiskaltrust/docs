---
slug: /poscreators/middleware-doc/greece/go-to-market
title: Go-to-Market
---

# Go-to-Market in Greece

Greece is one of the most tightly regulated markets in Europe when it comes to **real-time reporting**. Every receipt and invoice must be transmitted to the **myDATA** platform of the tax authority AADE and receive a registration number (**MARK**) before it is handed to the customer. A business has two lawful ways to do this for retail documents: a **certified fiscal device** (ΦΗΜ: fiscal cash registers, fiscal signing devices and fiscal printers, which are certified by AADE and interconnected with myDATA and the payment terminals) or a **licensed electronic invoicing provider** (ΥΠΑΗΕΣ). Alongside this, myDATA is the reporting layer for every business: an entity that issues documents from its own ERP transmits them to myDATA itself, through the **ERP API**, with its own credentials.

The fiskaltrust.Middleware implements the provider route today, and the ERP API is planned. Which of the two a document travels on is the first decision a PosCreator makes for the Greek market, because it determines what appears on the receipt, which obligations fall on the merchant, and what is available today.

## The two routes

Both routes use the fiskaltrust.Middleware and the same PosSystem API. What differs is **whose credentials the document is transmitted under**.

| | **Route 1: through fiskaltrust as licensed provider** | **Route 2: through the myDATA ERP API** |
| --- | --- | --- |
| Transmission | fiskaltrust transmits with the provider credentials of the AADE licence the fiskaltrust.Middleware for Cloud operates under (currently Viva's licence, provider ID **126**; see [Licensing](../licensing/licensing.md)) | fiskaltrust transmits with the **merchant's own myDATA credentials** (`aade-user-id` and subscription key from the myDATA REST portal) |
| Who is registered with AADE | The licensee; fiskaltrust operates the platform | The merchant, as a business reporting from its own ERP |
| On the document | Provider footer with the legal name, web address and licence identifier | No provider footer |
| Merchant obligations | The merchant declares the provider to AADE within ten days (*Α.1112/2025*, art. 6) | No provider statement; the merchant manages its own myDATA credentials |
| Cancellation | Only order slips (8.6) and delivery notes (9.3); the generic cancellation call is closed to providers | AADE's generic `CancelInvoice` is open to ERP users |
| Retail receipts | Covered: a document issued through a licensed provider replaces the fiscal device | Being clarified — the retail obligation (ΦΗΜ or provider) is not lifted by reporting through the ERP API |
| Availability in the Middleware | **Live** | **Planned**, not available today |
| Choose it when | You need a working Greek retail flow now, with the digital receipt and the terminal interconnection as implemented | The merchant already reports to myDATA from its own ERP, or wants documents registered under its own credentials |

- [Route 1: Using the fiskaltrust.Middleware for Cloud](./route-1-fiskaltrust-licence.md)
- [Route 2: Transmitting through the myDATA ERP API](./route-2-erp-api.md)

:::info There is no route to your own provider licence through fiskaltrust

An AADE provider licence (ΥΠΑΗΕΣ, *Α.1035/2020*) is granted to the company that operates the platform and is applied for with AADE directly. fiskaltrust does **not** offer a route in which a PosCreator is brought to market under its own provider licence on top of the fiskaltrust.Middleware. Greece therefore differs from Portugal, where a partner can certify its own solution: here the decision is between transmitting through a licensed provider and transmitting under the merchant's own myDATA credentials.

:::

## Key factors for the Greek market

Whichever route you take, these are the factors that shape a POS product for Greece. The [terminology](../terminology/terminology.md) chapter explains the vocabulary.

**Provider, fiscal device or own reporting.** Retail documents must be issued either through a ΦΗΜ or through a licensed provider (*Α.1035/2020*); reporting from an own ERP through the myDATA ERP API is the third channel, and whether it can carry retail on its own is being clarified. The provider route means there is no hardware, but every document depends on an online call to myDATA and on the provider's licence. Using a provider does not free the merchant from obligations: the merchant has to declare the provider to AADE within ten days of starting (*Α.1112/2025*, art. 6) and remains responsible for the documents.

**Real-time transmission.** Every document is transmitted to myDATA at the moment it is issued; myDATA returns MARK, UID and authentication code synchronously, and the receipt must show them together with the QR code. The response time of myDATA is therefore part of the checkout time. The Middleware transmits synchronously and returns the identifiers in the same response.

**Offline handling.** AADE distinguishes two failures: loss of connection between the business and the provider (*transmission failure 1*), and loss of connection between the provider and myDATA (*transmission failure 2*). In the first case the POS issues the receipt with a notice and sends it afterwards with the *late signing* flag; the Middleware transmits it with `transmissionFailure = 1`. The retransmission of documents that myDATA could not accept because it was unavailable (failure 2) is handled by fiskaltrust; the exact retransmission procedure is being finalised.

**Interconnection with the payment terminal.** Since *Α.1155/2023* (amended by *Α.1160/2025*) the cash register and the card terminal must be interconnected. The terminal receives the amount from the POS, and the payment signature (*Υπογραφή Πληρωμής*), the unique payment ID (*Μοναδική Ταυτότητα Πληρωμής*) and the tip are printed on the receipt and transmitted to myDATA (*Α.1138/2020* as amended by *Α.1048/2024*). The Middleware transmits these values when they are handed over in `ftPayItemCaseData`; the interconnection itself is implemented today with Viva terminals (cloud REST API, App2App and the implicit flow). Other acquirers are being clarified.

**Digital receipt and QR code.** The QR code on the receipt links to the digital document. The Middleware returns it as signature item and renders the digital receipt at `https://receipts.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}`; myDATA additionally returns its own QR URL.

**Restaurant orders.** In hospitality, an order slip (8.6) is issued before the receipt. Order slips are not fiscal documents, must be turned into a receipt or invoice within 24 hours, and a provider must block further issuing for a merchant with older open orders (*Α.1112/2025*). The Middleware issues and cancels orders; the monitoring of open orders is being implemented.

**Invoices and e-invoicing.** B2B invoices (1.x, 2.x) are transmitted through the same channel as receipts and need the customer's VAT number. B2G invoices (to the public sector) require an additional licence and transmission through the national interoperability centre; this is not part of the current scope. Mandatory electronic B2B invoicing is being rolled out in Greece in stages; the current dates and the exact obligations for your customers should be confirmed with fiskaltrust before you plan the release.

**e-Delivery.** Delivery notes (9.3) are transmitted to myDATA as digital delivery notes with the transport details (phase A). Phase B, the tracking of the goods movement through AADE's Digital Shipping Note API and inbound documents for the recipient, is being designed.

**Merchant onboarding.** A Greek merchant must be identified by VAT number (and branch) in the fiskaltrust.Portal before the first document. AADE additionally expects the merchant to declare its internet service provider details and to authorise the provider through gov.gr; how these steps are collected in the fiskaltrust onboarding journey is being clarified.

**Timelines and deadlines**

| Obligation | Deadline | Source |
| ---------- | -------- | ------ |
| Declare the provider to AADE after starting to issue documents through a provider | Within 10 days | *Α.1112/2025*, art. 6 |
| Turn a restaurant order slip (8.6) into a fiscal document | Within 24 hours | *Α.1112/2025* |
| Retransmit documents issued during a connection loss | Without delay after the connection is restored, with `transmissionFailure` set | *Α.1138/2020*, *Α.1155/2023* |
| Print the provider's legal name, web address and licence identifier on every receipt | Since the footer change requested in August 2026 | *Α.1112/2025*, art. 7 par. 5 |
| myDATA provider API version implemented by the Middleware | 2.0.2 (published by AADE in June 2026) | myDATA API documentation for providers |

## What is the same on both routes

Whichever route you take, the fiskaltrust.Middleware does the fiscal heavy lifting: it validates the request against the Greek rules, maps it to the myDATA invoice type and classifications, numbers the document in the queue's series, transmits it to myDATA, and returns MARK, UID, authentication code, QR code and the full myDATA XML. The [reference tables](../reference-tables/reference-tables.md) describe these mechanisms; they do not differ between the routes.

What differs is **whose credentials the document is transmitted under**, and what follows from that: whether a provider footer is printed, whether the merchant has to declare a provider to AADE, which cancellation calls are open, and which obligations of a licensed provider (open-order monitoring, statements, provider-side data access) apply at all.

## Frequently asked questions

**Can I start on Route 1 and move to Route 2 later?**
That is the intention: the API integration is the same, and the switch changes the credentials the queue transmits with, not your requests. Documents already issued stay registered in myDATA as they were transmitted. Route 2 is not available yet, so plan the move rather than the start.

**Can I become a licensed provider myself through fiskaltrust?**
No. A provider licence is obtained from AADE by the company that operates the platform; fiskaltrust does not take partners through that procedure. If your goal is to avoid a provider on the document, the ERP route is the path to discuss.

**Can I run the Middleware on my own infrastructure?**
Not in Greece today. The provider credentials are part of the fiskaltrust cloud deployment, and the ERP route is not available yet.

**Does Route 1 restrict how my POS looks?**
No. The licence covers the document and its transmission, not your user interface. Your POS can look and behave as you like; the identifiers and the provider footer on the receipt are the ones returned by the Middleware.

**Do I need a fiscal device (ΦΗΜ) in addition?**
No. Documents issued through a licensed provider replace the fiscal device. Merchants who still operate a ΦΗΜ for other reasons must not issue the same document twice.

**Can a receipt or invoice be cancelled after it was issued?**
Not on the provider route. The myDATA API for providers allows cancellation only of restaurant order slips (8.6) and delivery notes (9.3), so a wrong receipt or invoice is corrected with a credit document (11.4, 5.1 or 5.2) that references the original MARK. AADE's generic cancellation call is open to ERP users, which is one of the differences of Route 2.

**Who does the merchant deal with?**
On both routes the merchant is the taxpayer and remains responsible for the documents and for keeping the records. On the provider route the merchant additionally declares the provider to AADE; on the ERP route the merchant owns the myDATA credentials the documents are transmitted with. See [What this means for PosOperators](../licensing/licensing.md#what-this-means-for-posoperators).

**Where do I get help?**
Contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) for the commercial setup in Greece.
