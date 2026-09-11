---
slug: /poscreators/middleware-doc/greece/go-to-market/own-licence
title: 'Route 2: Obtaining your own provider licence'
---

# Route 2: Obtaining your own provider licence

On this route you build your product on top of the fiskaltrust.Middleware and obtain **your own licence as electronic invoicing provider** (ΥΠΑΗΕΣ) from AADE under *Α.1035/2020*. You are the licensee, you hold the provider credentials for myDATA, you talk to AADE, and you are responsible for everything AADE audits around the Middleware: the receipt and its provider texts, the merchant onboarding and statements, the handling of offline cases and open orders, data access for merchants and auditors, and the availability of your platform.

Choose this route when you need a self-hosted or on-device deployment, functionality outside the [supported scope](../licensing/licensing.md#boundaries) of the fiskaltrust.Middleware for Cloud, or when you want to hold the provider licence yourself.

:::info fiskaltrust is looking for partners on this route

fiskaltrust has so far implemented and operated the provider platform under a partner's licence (see [Licensing](../licensing/licensing.md)); it has **not yet accompanied a PosCreator through its own AADE licensing procedure**. The description below is therefore based on the AADE requirements fiskaltrust encountered while building and operating the platform, not on a completed procedure with a partner. fiskaltrust is looking for partners who want to go this way and will support them with the documentation of the Middleware's behaviour, sample requests for the AADE demonstration scenarios and the experience from operating the platform. Contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu).

:::

## Division of responsibilities

| Area | Provided by the fiskaltrust.Middleware | Provided by you |
| ---- | -------------------------------------- | --------------- |
| Provider licence and credentials | Configurable myDATA endpoint and provider credentials per deployment | The licence itself, the AADE user ID and subscription key, their safekeeping |
| Mapping to myDATA | Invoice types, income and expense classifications, VAT and exemption categories, payment methods, special taxes, transport details, overrides | Correct master data in the request: type of service, VAT nibble and nature of VAT, customer, terminal data |
| Document numbering | Series and sequential number per queue, duplicate handling against myDATA, handwritten series | Nothing; numbering is managed by the Middleware |
| Transmission | Synchronous transmission, MARK/UID/authentication code, myDATA QR URL, full myDATA XML in the response | Monitoring and retransmission procedure for transmission failure 2, availability of the platform |
| Payment terminal | Transmission of payment signature, transaction ID and tip; provider ID as signing author | Interconnection with the acquirers you support; the provider ID in the payment signature must be yours |
| Receipt | All mandatory identifiers as signature items with a defined format; the fiskaltrust rendering if you use it | Your receipt layout with every mandatory element and your provider footer |
| Corrections | Refunds, credit notes, order cancellation, delivery-note cancellation, all with the required checks | UI that only offers these operations, never editing or deleting documents |
| Merchant obligations | Master data per queue | Provider statements to AADE, ISP details, authorisation through gov.gr, blocking of merchants with open orders older than 24 hours |
| Data access | Journal and myDATA XML per document, portal export | Invoice history, search and export for merchants and auditors, validation of the authentication code |
| Operations | Cloud or self-hosted Middleware | Backup and continuity plan, protection of credentials, system time control |

## Settings that must change for your licence

Several values are fixed in the fiskaltrust.Middleware for Cloud because they belong to the licence it operates under. For your product they must be replaced before the first test with AADE:

- the **provider ID** used as `SigningAuthor` in the payment signature of card payments (currently `126`),
- the **provider footer** returned as signature items (legal name, web address, licence identifier),
- the **myDATA endpoint and provider credentials** (AADE user ID and subscription key) for the test and the production environment,
- the **receipt base address** used for the QR code and the document download URL transmitted to myDATA.

Contact fiskaltrust before you apply to AADE so that these can be provisioned for your deployment.

## The licensing procedure

The procedure is run by AADE on the basis of *Α.1035/2020* and the myDATA API documentation for providers. AADE publishes the [list of licensed e-invoicing service providers](https://www.aade.gr/en/mydata/e-invoicing-service-providers) and the [procedure for the certification of providers](https://www.aade.gr/en/mydata/procedure-providers-certification) on its website. In summary:

1. **Application.** The applicant submits the application and the supporting documents that *Α.1035/2020* requires (company data, technical description of the platform, security and availability measures, data access for AADE, the merchant and the recipient).
2. **Technical demonstration.** AADE prescribes demonstration scenarios that the platform has to perform against the myDATA test environment. The scenarios fiskaltrust was asked to demonstrate were:
   - a sales invoice (1.1) with five lines: goods at 24 % VAT, a service at 24 % VAT with 20 % withholding tax, and goods at 13 % VAT;
   - a retail receipt (11.1) with five lines at 24 % and 13 % VAT, paid through an emulated payment terminal, including the payload of a sale while the terminal is offline according to *Α.1155/2023*;
   - a POS payment receipt (8.4) with one line of 100 EUR net as an online transaction, classified as other income information without VAT and without E3 classification;
   - a retail receipt (11.1) with one line of 100 EUR net at 24 % VAT as an online transaction;
   - the signing request of an ERP for the provider signature, and the creation, encryption and transmission of the provider signature to the ERP;
   - the interconnection of the ERP with the payment terminal, its communication with the acquirer for the approval or rejection of the charge, and the creation of the unique payment ID;
   - the terminal's response to the ERP with provider signature, unique payment ID, amount and optional tip;
   - the transmission of the resulting data to myDATA.

   The demonstration focuses on the REST API of the provider service, the MARK/UID/authentication sequence, the mandatory invoice fields and the authenticity, integrity and legibility of the data (art. 15 of law 4308/2014), data access for the provider, its customer and the recipient of a wholesale invoice, QR code generation, online real-time transactions, anonymous retail receipts and the offline scenario.
3. **Licence.** After a successful demonstration AADE issues the licence with a provider ID and a licence identifier, and lists the provider on its website. The identifier is printed on every receipt.
4. **Ongoing obligations.** *Α.1112/2025* defines obligations of licensed providers, among them the provider footer with the legal name (art. 7 par. 5), the management of merchant statements (art. 6), the blocking of merchants with order slips open for more than 24 hours, and the handling of transmission failures. AADE also updates the provider API; version 2.0.2 was published in June 2026, and providers are expected to follow.

The fiskaltrust.Middleware performs the myDATA side of these scenarios today; the acceptance tests in the Middleware repository replay them against the myDATA test environment. On this route, the scenarios mainly concern the parts you build yourself: your credentials, your receipt, your terminal interconnection and your provider texts.

## What to expect

- **Terminal interconnection is part of the audit.** The demonstration includes the exchange of the provider signature and the unique payment ID between ERP, terminal and acquirer. You need at least one acquirer that supports this flow with your provider ID.
- **Offline behaviour is part of the audit.** Both the offline scenario of the terminal and the loss of connection to the provider have to be demonstrated, including the retransmission with `transmissionFailure` set.
- **Data access is part of the licence.** AADE expects the provider to give the merchant, the recipient of an invoice and AADE itself access to the documents (invoice history, validation of the authentication code, exports).
- **Provider obligations continue after the licence.** Statements, footer texts, open-order monitoring and API upgrades are recurring work.

## Effort

fiskaltrust cannot yet give a reliable figure for the duration of a partner's licensing procedure. The build-up of the platform and its alignment with the AADE requirements took fiskaltrust more than a year, most of it for the mapping, the terminal interconnection and the operational rules that the Middleware now provides. A partner that reuses the Middleware starts from a much better position but should plan for the application, the preparation of the demonstration scenarios with its own credentials, at least one demonstration session with AADE, and the implementation of the ongoing provider obligations.
