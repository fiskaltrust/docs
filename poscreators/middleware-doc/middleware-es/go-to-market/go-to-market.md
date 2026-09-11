---
slug: /poscreators/middleware-doc/spain/go-to-market
title: Go-to-Market
---

# Go-to-Market in Spain

Spain is not one fiscal market but two. In the **common territory** the invoicing software of a business must comply with the *Reglamento de los sistemas informáticos de facturación* (*Real Decreto 1007/2023*, technical specification *Orden HAC/1177/2024*), commonly called **VERI\*FACTU**: every invoice record is hashed, chained, marked with a QR code and, in the VERI\*FACTU mode, transmitted to the tax authority AEAT at the moment of issue. In the **Basque Country** the three provincial tax authorities of Araba/Álava, Bizkaia and Gipuzkoa run **TicketBAI**: every invoice is preceded by a signed XML file that is transmitted to the province, and the document carries a TBAI identifier and QR code. **Navarre** has announced its own regime (*NaTicket*) without a confirmed date and is outside both systems today.

The software producer, not the merchant, carries the compliance obligation: in the common territory through a signed **declaración responsable**, in the Basque Country through the **registration** of the software with a provincial tax authority. With the fiskaltrust.Middleware there are two ways to meet these obligations. Choosing the route is the first decision a PosCreator makes for the Spanish market, because it determines what has to be built, who signs towards the tax authorities, and how the product can be deployed.

## The two routes

| | **Route 1: fiskaltrust's declaration and registration** | **Route 2: own declaration and registration** |
| --- | --- | --- |
| Declared SIF (common territory) | fiskaltrust.Middleware, declared by fiskaltrust consulting GmbH (see [Declaration and Registration](../declaration/declaration.md)); your POS declares itself as a component | Your product, declared by you as producer |
| TicketBAI software (Basque Country) | fiskaltrust.Middleware, registered by fiskaltrust with its licence codes | Your product, registered by you with your own licence code |
| Who talks to the tax authorities | fiskaltrust; you provide the component supplement | You, supported by fiskaltrust |
| What you build | The POS front end that sends business cases through the PosSystem API and prints the returned QR code, legend and identifiers | The POS plus everything the authorities expect from the producer: the declaration and *memoria descriptiva*, the on-site verification screen, the software identification in the records, the layout, the certificate handling |
| What you must not build | Own numbering, hashing, signing, transmission, QR codes or texts | Nothing is excluded, but everything you add is declared by you |
| Deployment | fiskaltrust cloud only | Cloud, self-hosted or on-device, as far as your declaration covers it |
| Functional scope | The supported scope of the Middleware (see [Supported document types](../declaration/declaration.md#supported-document-types)) | Extendable, e.g. corrective invoices, No VERI\*FACTU mode, own layout |
| Time to market | Integration, component supplement and onboarding | Integration plus your own declaration and, for the Basque Country, the registration procedure |
| Choose it when | You want the fastest and lowest-risk entry and the supported scope covers your use case | You need a deployment or functionality outside the supported scope, or you want to be the declared producer yourself |

- [Route 1: Using fiskaltrust's declaration and registration](./route-1-fiskaltrust-declaration.md)
- [Route 2: Declaring and registering your own solution](./route-2-own-declaration.md)

:::note Route 2 is open for a first partner

fiskaltrust has prepared and submitted the declaration and the registration for its own Middleware but has not yet accompanied a partner through a declaration or a TicketBAI registration of their own solution. We are looking for partners who want to take Route 2; contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu).

:::

## Key factors for the Spanish market

Whichever route you take, these are the factors that shape a POS product for Spain.

**Two territories, one API.** Which system applies depends on where the merchant's establishment is taxed, not on the location of the head office: a company from Madrid with a shop in Bilbao issues the Bilbao invoices under TicketBAI (Bizkaia) and the Madrid invoices under VERI\*FACTU. In the fiskaltrust.Middleware this is a property of the queue: a queue is set up either for VERI\*FACTU or for TicketBAI of one province (Araba, Bizkaia or Gipuzkoa), and the choice cannot be changed afterwards. The requests your POS sends are the same in both cases; only the returned signature items differ.

**SIF requirements and the declaración responsable.** *Real Decreto 1007/2023* requires every invoicing system to guarantee integrity, conservation, accessibility, legibility, traceability and inalterability of the invoice records (art. 29.2.j *Ley General Tributaria*). *Orden HAC/1177/2024* specifies the record format, the hash, the chaining, the QR code, the event log and the content of the producer's declaration. There is no approval and no register: the producer declares compliance, hands the declaration to the merchant and shows it to the AEAT on request. Every version of the system needs its own declaration. The Middleware provides the record generation, hash chain, transmission and export; the POS is a declared component on top of it.

**Hash chain and QR code.** Every VERI\*FACTU record carries a SHA-256 *huella* over the identifying fields of the invoice and the hash of the previous record. The document shows a QR code with the AEAT verification URL (issuer NIF, series and number, date, total) and the legend *Factura verificable en la Sede electrónica de la AEAT*. In TicketBAI the file is signed with XAdES, chained to the previous invoice through its signature value, and the document shows the TBAI identifier and the provincial QR code. All of this is generated by the Middleware and returned as signature items.

**VERI\*FACTU mode versus No VERI\*FACTU.** The regulation allows two modes: transmitting every record to the AEAT in real time (*sistema VERI\*FACTU*, *remisión voluntaria*), or keeping signed records locally and producing an event log (*No VERI\*FACTU*). The Middleware operates in VERI\*FACTU mode only: every record is transmitted synchronously through the AEAT web service, and the response decides whether the document is issued. The response time of the AEAT is therefore part of the checkout time. No VERI\*FACTU mode is not offered.

**Offline handling.** Because numbering, hashing and transmission happen in the fiskaltrust cloud, a POS that cannot reach the Middleware cannot issue a numbered invoice. The AEAT's answer to fiskaltrust's question was that, in exceptional situations, a provisional receipt may be handed to the customer and must be **replaced** by the official VERI\*FACTU invoice as soon as the system is available again, agreeing with the customer how the invoice will be delivered. VERI\*FACTU itself tolerates records that are transmitted later. The Middleware does not yet apply Spanish-specific processing to the late-signing flag; the recommended procedure for outages is being defined with the Spanish market team.

**TicketBAI per province.** TicketBAI is one regulation with three implementations. Araba and Gipuzkoa receive the signed file through their TicketBAI web services (with separate *Zuzendu* services for corrections); Bizkaia receives it wrapped in the *LROE modelo 240* message of the **Batuz** system, which also covers the merchant's ledger of economic operations. Each province has its own signature policy, its own test environment with its own registration procedure, and its own QR verification address. The software registration is needed in one province only. The Middleware implements all three provinces as separate SCU types; the differences are hidden from the POS.

**Certificates.** Both systems authenticate with qualified electronic certificates of the merchant: for VERI\*FACTU a company seal or legal-representative certificate (validated against the Spanish trusted list), for TicketBAI additionally a device certificate issued by Izenpe, the Basque certification authority. Certificates are uploaded to the fiskaltrust.Portal and stored in the fiskaltrust cloud; the POS never handles them. Whether fiskaltrust can transmit on behalf of merchants as *colaborador social* or through a power of attorney registered with the AEAT, so that merchants do not need their own certificate, is being clarified.

**Corrections.** Issued invoices cannot be edited or deleted. VERI\*FACTU knows a cancellation record (*registro de anulación*) and corrective invoices (*facturas rectificativas*, `R1` to `R5`); TicketBAI knows a cancellation file and rectifying invoices. The Middleware transmits cancellations to the AEAT, validates refunds against the original document and transmits them as records with negative amounts. Corrective invoice types and TicketBAI cancellations are not emitted yet; see [Boundaries](../declaration/declaration.md#boundaries).

**Merchant onboarding.** A Spanish merchant needs a NIF, a qualified certificate and a fiskaltrust.Portal account in the Spanish portal (`portal.fiskaltrust.es`, sandbox `portal-sandbox.fiskaltrust.es`). The target journey is that the PosDealer invites the merchant, the merchant registers, signs the POS operator contract and uploads the certificate, and the configuration for the applicable regime is rolled out to the POS. Which steps are already available in the portal, and how the certificate upload is integrated into the rollout, is being finalised.

**Adjacent obligations.** **SII** (*Suministro Inmediato de Información*) is the real-time VAT ledger of large companies (turnover above 6 million EUR, VAT groups, monthly refund register, and voluntary participants); a merchant in SII is exempt from VERI\*FACTU. The Middleware does not support SII; fiskaltrust is evaluating the demand. **B2G e-invoicing** (Facturae through FACe) is not part of the scope. The **mandatory B2B e-invoice** of the *Ley Crea y Crece* (Ley 18/2022) has been regulated by *Real Decreto 238/2026* of 25 March 2026; it will apply twelve months after its technical implementing order for businesses with a turnover above 8 million EUR and twenty-four months after it for all others. It complements, but does not replace, the VERI\*FACTU record.

**Timelines and deadlines**

| Obligation | Date | Source |
| ---------- | ---- | ------ |
| Producers and marketers of invoicing systems must offer compliant systems | Since 29 July 2025 (nine months after *Orden HAC/1177/2024* entered into force) | *Real Decreto 1007/2023*, disp. final cuarta; *Orden HAC/1177/2024* |
| Merchants subject to corporate income tax must use a compliant system | 1 January 2027 | *Real Decreto-ley 15/2025*, art. 3 (postponement from 1 January 2026) |
| All other merchants (self-employed, other taxpayers) must use a compliant system | 1 July 2027 | *Real Decreto-ley 15/2025*, art. 3 (postponement from 1 July 2026) |
| TicketBAI in Araba, Bizkaia and Gipuzkoa | In force; the phased introduction by sector has been completed in all three provinces | Provincial regulations (e.g. Bizkaia *Orden Foral 1482/2020*) |
| Mandatory B2B e-invoice (Ley Crea y Crece) | 12 months (turnover above 8 million EUR) or 24 months (others) after the implementing order; dates not fixed yet | *Real Decreto 238/2026* |
| Navarre (*NaTicket*) | Announced, no confirmed date | Hacienda Foral de Navarra |

The primary texts are published in the *Boletín Oficial del Estado*: [Real Decreto 1007/2023](https://www.boe.es/buscar/act.php?id=BOE-A-2023-24840), [Orden HAC/1177/2024](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2024-22138), [Real Decreto-ley 15/2025](https://www.boe.es/diario_boe/txt.php?id=BOE-A-2025-24446) and [Real Decreto 238/2026](https://www.boe.es/buscar/act.php?id=BOE-A-2026-7295). Confirm the dates that apply to your customers with fiskaltrust before you plan the release; the AEAT has postponed the merchant deadlines once already.

## What is the same on both routes

Whichever route you take, the fiskaltrust.Middleware does the fiscal heavy lifting: it validates the request against the Spanish rules, numbers the document in its sequence, generates the VERI\*FACTU record with its hash chain or the signed TicketBAI file with its chaining, transmits it to the AEAT or to the province, and returns the QR code, the legend, the TBAI identifier and the hash. The [Declaration and Registration](../declaration/declaration.md#what-fiskaltrust-takes-care-of) chapter lists these components; they do not differ between the routes.

What differs is **who is the declared producer**, and therefore who signs the declaración responsable, who is listed in the Basque register with which licence code, whose identification appears in the records, and who has to answer to the tax authorities for everything around the Middleware: the printed document, the on-site verification screen, the certificate handling and the operation of the system.

## Frequently asked questions

**Can I start on Route 1 and move to Route 2 later?**
Yes. The API integration is the same. Moving to Route 2 adds your own declaration, your own TicketBAI registration and, if you self-host, the deployment work. Documents already issued under fiskaltrust's declaration remain valid.

**Do I have to sign anything on Route 1?**
Yes. Your POS is a component of the invoicing system. You complete and sign the PosCreator supplement to fiskaltrust's declaración responsable for your product and make it available to your merchants. You do not register anything with the Basque provinces on Route 1.

**Can I run the Middleware on my own infrastructure under fiskaltrust's declaration?**
No. fiskaltrust's declaration and registration describe the Middleware as hosted in the fiskaltrust cloud, and the certificates and licence codes are part of that deployment. A self-hosted or on-device installation is a different system and needs your own declaration (Route 2).

**Does Route 1 restrict how my POS looks?**
No. The declaration covers the invoice record and the mandatory elements of the document, not your user interface. Your POS can look and behave as you like; the QR code, the legend and the identifiers on the document are the ones returned by the Middleware.

**Can an invoice be cancelled after it was issued?**
In the common territory a cancellation record is transmitted to the AEAT when you send the document again with the void flag. For TicketBAI queues the cancellation file is not available yet. A wrong document is otherwise corrected with a refund that references the original.

**Which merchants need TicketBAI?**
Merchants with an establishment in Araba, Bizkaia or Gipuzkoa, for the invoices issued from that establishment. Merchants in the rest of Spain except Navarre use VERI\*FACTU. Merchants in SII are exempt from VERI\*FACTU and are not supported today.

**Who does the merchant deal with?**
On both routes the merchant is the taxpayer and remains responsible for the documents, for the certificate and for keeping the records. See [What this means for PosOperators](../declaration/declaration.md#what-this-means-for-posoperators).

**Where do I get help?**
Contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) for the commercial setup in Spain.
