---
slug: /poscreators/middleware-doc/portugal/go-to-market
title: Go-to-Market
---

# Go-to-Market in Portugal

In Portugal only a **certified invoicing program** may issue invoices and other fiscally relevant documents (*Portaria n.º 363/2010*). A POS system therefore cannot simply be installed and switched on; before the first document is issued, the software that creates, numbers, signs, and exports the documents must be listed in the AT's register of certified programs.

With the fiskaltrust.Middleware there are two ways to get there. Choosing the route is the first decision a PosCreator makes for the Portuguese market, because it determines what has to be built, who talks to the AT, and how the product can be deployed.

## The two routes

| | **Route 1: fiskaltrust certificate** | **Route 2: own certificate** |
| --- | --- | --- |
| Certified program | fiskaltrust.Middleware for Cloud (fiskaltrust.CloudCashBox), certificate **3535** | Your product, built on top of the fiskaltrust.Middleware, with your own certificate number |
| Listed in the AT register | fiskaltrust | You |
| Who talks to the AT | fiskaltrust | You, supported by fiskaltrust |
| What you build | The POS front end that sends business cases through the PosSystem API and hands out the certified document | The POS including the document layout, master-data protection, user management, and everything else the AT audits |
| What you must not build | Own numbering, signing, layout, or SAF-T export | Nothing is excluded, but everything you add is audited |
| Deployment | fiskaltrust cloud only | Cloud, self-hosted, or on-device (e.g. Android launcher) |
| Functional scope | The certified scope of the CloudCashBox (see [Certification](../certification/certification.md)) | Extendable, e.g. transport documents, own layout engine |
| Time to market | Integration and onboarding only | Integration plus a certification procedure with the AT |
| Choose it when | You want the fastest and lowest-risk entry and the certified scope covers your use case | You need a deployment or functionality outside the certified scope, or you want to hold the certificate yourself |

- [Route 1: Using the fiskaltrust certificate](./route-1-fiskaltrust-certificate.md)
- [Route 2: Certifying your own solution](./route-2-own-certificate.md)

The [Certification](../certification/certification.md) chapter of this appendix describes Route 1: it documents certificate 3535, the certified scope, and the components fiskaltrust takes care of. On Route 2 the certificate, its scope, and the responsibility towards the AT are yours.

:::note Route 2 is open for a first partner

fiskaltrust has gone through the certification for its own program but has not yet accompanied a partner through a certification of their own solution. We are looking for partners who want to take Route 2; contact [sales@fiskaltrust.pt](mailto:sales@fiskaltrust.pt).

:::

## What is the same on both routes

Whichever route you take, the fiskaltrust.Middleware does the fiscal heavy lifting: it validates the request against the Portuguese business rules, assigns the document number in a registered series with its ATCUD, signs the document and chains it to the previous one, generates the QR code content, and produces the SAF-T (PT) export. The [Portugal appendix](../appendix-pt.md) describes these mechanisms; they do not differ between the routes.

What differs is **who is responsible for the certified program as a whole**, and therefore who has to answer to the AT for the parts around the Middleware: the rendered document, the protection of master data and print format, user management, and operational measures such as backups.

## Frequently asked questions

**Can I start on Route 1 and move to Route 2 later?**
Yes. The API integration is the same. Moving to Route 2 adds the certification procedure and, if you self-host, the deployment work. Documents already issued under certificate 3535 remain valid.

**Can I use fiskaltrust's certificate number on a self-hosted installation?**
No. Certificate 3535 covers the fiskaltrust.CloudCashBox as operated by fiskaltrust. A self-hosted or on-device installation is a different program and needs its own certificate (Route 2).

**Does Route 1 restrict how my POS looks?**
No. The certificate covers the fiscal document, not your user interface. Your POS can look and behave as you like; the document handed to the customer is the one rendered by fiskaltrust.

**Has a partner already been certified on Route 2?**
Not yet. fiskaltrust holds certificate 3535 for its own program and knows the procedure from that experience, but no partner has certified a solution built on the Middleware so far. We are looking for a first partner; contact [sales@fiskaltrust.pt](mailto:sales@fiskaltrust.pt).

**Who does the merchant deal with?**
On both routes the merchant is the taxpayer and remains responsible for issuing documents and submitting the SAF-T (PT). See [What this means for PosOperators](../certification/certification.md#what-this-means-for-posoperators).
