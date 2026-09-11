---
slug: /poscreators/middleware-doc/greece/go-to-market
title: Go-to-Market
---

# Go-to-Market in Greece

Greece is one of the most tightly regulated markets in Europe when it comes to **real-time reporting**. Every receipt and invoice must be transmitted to the **myDATA** platform of the tax authority AADE and receive a registration number (**MARK**) before it is handed to the customer. A business has two lawful ways to do this for retail documents: a **certified fiscal device** (ΦΗΜ: fiscal cash registers, fiscal signing devices and fiscal printers, which are certified by AADE and interconnected with myDATA and the payment terminals) or a **licensed electronic invoicing provider** (ΥΠΑΗΕΣ). The fiskaltrust.Middleware implements the provider route: a cloud POS that wants to issue documents without fiscal hardware has to work with a provider, and the documents it issues replace the fiscal device.

With the fiskaltrust.Middleware there are two ways to get there. Choosing the route is the first decision a PosCreator makes for the Greek market, because it determines what has to be built, who is registered with AADE, and how the product can be deployed.

## The two routes

| | **Route 1: fiskaltrust.Middleware for Cloud** | **Route 2: own provider licence** |
| --- | --- | --- |
| Licensed provider | The provider licence the fiskaltrust.Middleware for Cloud operates under (currently Viva's licence, provider ID **126**; see [Licensing](../licensing/licensing.md)) | You, licensed by AADE as ΥΠΑΗΕΣ, with your own provider ID |
| Registered with AADE | The licensee; fiskaltrust operates the platform | You |
| Who talks to AADE | fiskaltrust and the licensee | You, supported by fiskaltrust |
| What you build | The POS front end that sends business cases through the PosSystem API, connects the payment terminal and hands out the digital or printed receipt | The POS plus everything AADE audits around the provider platform: provider credentials and infrastructure, receipt rendering, merchant onboarding, statements, monitoring of offline cases and open orders |
| What you must not build | Own myDATA transmission, own MARK/QR handling, own provider texts | Nothing is excluded, but everything you add is audited |
| Deployment | fiskaltrust cloud only | Cloud, self-hosted or on-device, as your licence allows |
| Functional scope | The supported scope of the Middleware (see [Licensing](../licensing/licensing.md#supported-document-types)) | Extendable, e.g. B2G e-invoicing, Digital Shipping Note phase B, own rendering |
| Time to market | Integration and onboarding only | Integration plus the AADE licensing procedure |
| Choose it when | You want the fastest and lowest-risk entry and the supported scope covers your use case | You need a deployment or functionality outside the supported scope, or you want to hold the provider licence yourself |

- [Route 1: Using the fiskaltrust.Middleware for Cloud](./route-1-fiskaltrust-licence.md)
- [Route 2: Obtaining your own provider licence](./route-2-own-licence.md)

## Key factors for the Greek market

Whichever route you take, these are the factors that shape a POS product for Greece. The [terminology](../terminology/terminology.md) chapter explains the vocabulary.

**Licensed provider or fiscal device.** Retail documents must be issued either through a ΦΗΜ or through a licensed provider (*Α.1035/2020*). The provider route means there is no hardware, but every document depends on an online call to myDATA and on the provider's licence. Using a provider does not free the merchant from obligations: the merchant has to declare the provider to AADE within ten days of starting (*Α.1112/2025*, art. 6) and remains responsible for the documents.

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

What differs is **who holds the licence and the provider credentials**, and therefore who has to answer to AADE for everything around the Middleware: the provider texts on the receipt, the merchant statements, the handling of offline cases and open orders, data access for merchants and auditors, and the availability of the platform.

## Frequently asked questions

**Can I start on Route 1 and move to Route 2 later?**
Yes. The API integration is the same. Moving to Route 2 adds the licensing procedure with AADE and your own provider credentials; the provider texts on your receipts change to your licence. Documents already issued remain registered in myDATA under the licence they were issued with.

**Can I run the Middleware on my own infrastructure under the current licence?**
No. The provider credentials are part of the fiskaltrust cloud deployment. A self-hosted or on-device installation needs your own provider licence (Route 2).

**Does Route 1 restrict how my POS looks?**
No. The licence covers the document and its transmission, not your user interface. Your POS can look and behave as you like; the identifiers and the provider footer on the receipt are the ones returned by the Middleware.

**Do I need a fiscal device (ΦΗΜ) in addition?**
No. Documents issued through a licensed provider replace the fiscal device. Merchants who still operate a ΦΗΜ for other reasons must not issue the same document twice.

**Can a receipt or invoice be cancelled after it was issued?**
No. The myDATA API for providers allows cancellation only of restaurant order slips (8.6) and delivery notes (9.3). A wrong receipt or invoice is corrected with a credit document (11.4, 5.1 or 5.2) that references the original MARK.

**Who does the merchant deal with?**
On both routes the merchant is the taxpayer and remains responsible for the documents, for declaring the provider and for keeping the records. See [What this means for PosOperators](../licensing/licensing.md#what-this-means-for-posoperators).

**Where do I get help?**
Contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) for the commercial setup in Greece.
