---
slug: /poscreators/middleware-doc/greece/licensing
title: Licensing
---

# Licensing of the fiskaltrust.Middleware (e-invoicing provider)

In Greece there is no register of certified invoicing programs as in Portugal. Instead, a business may issue its retail receipts and invoices either through a certified fiscal device (*Φορολογικός Ηλεκτρονικός Μηχανισμός*, ΦΗΜ) or through a **licensed electronic invoicing provider** (*Υπηρεσίες Παρόχου Ηλεκτρονικής Έκδοσης Στοιχείων*, ΥΠΑΗΕΣ, licensed by the Independent Authority for Public Revenue, AADE, under decision *Α.1035/2020*). The provider issues the document, transmits it to AADE's **myDATA** platform (*Α.1138/2020*), receives the registration number (**MARK**) and returns the document with its QR code. A POS system that uses a provider needs no fiscal device.

The fiskaltrust.Middleware implements this provider flow. Every request sent to a Greek queue is mapped to a myDATA document, transmitted through the provider API (`/myDataProvider/SendInvoices`, myDATA API for providers, schema version 2.0.2) and enriched with the identifiers myDATA returns.

:::info Under whose licence documents are issued today

The fiskaltrust.Middleware for Cloud currently issues Greek documents under the AADE provider licence of **Viva** (licensee *VIVABANK ΑΝΩΝΥΜΗ ΤΡΑΠΕΖΙΚΗ ΕΤΑΙΡΕΙΑ*, product *Viva Fiscal*), **provider ID 126**, licence identifier `2024_12_126VIVA_001_ Viva Fiscal_V1_23122024`. fiskaltrust operates the technical platform behind this licence: the mapping to myDATA, the transmission with the provider credentials, the provider signature on card payments and the digital receipt.

fiskaltrust's **own** AADE provider licence for B2C/B2B documents, and a separate licence for B2G e-invoicing, are being pursued but have not been granted yet. Until then, the licence identifiers on the documents are Viva's, and the Middleware is available for the Greek market through the fiskaltrust.Middleware for Cloud only. PosCreators who want to enter the Greek market should contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) to clarify the contractual setup.

:::

This page describes only the setup in which the PosCreator uses the licence that the fiskaltrust.Middleware for Cloud operates under. The alternative, obtaining a provider licence of your own on top of the Middleware, is described in [Route 2](../go-to-market/route-2-own-licence.md).

## Where the licence appears on documents

The provider identifiers are part of every successfully transmitted document and are returned as signature items (see [Type of Signature: ftSignatureType](../reference-tables/type-of-signature-ftsignaturetype.md)):

- The **provider footer**, three lines that AADE requires at the bottom of every receipt (*Α.1112/2025*, art. 7 par. 5): the legal name of the licensee, the provider web address and the licence identifier. They are returned as two `ProviderSignature` items (`sss` = `011`): one with the caption `VIVABANK ΑΝΩΝΥΜΗ ΤΡΑΠΕΖΙΚΗ ΕΤΑΙΡΕΙΑ` and empty data, and one with the caption `www.viva.com` and the data `2024_12_126VIVA_001_ Viva Fiscal_V1_23122024`.
- The **provider ID** `126` as `SigningAuthor` of the payment signature inside the myDATA payload for every card payment that carries the terminal's `aadeProviderSignature` (*Α.1155/2023*, *Α.1048/2024*).
- The **MARK**, **UID** and **authentication code** assigned by myDATA, the **unique document identifier** and the **QR code** that links to the digital receipt. See [Receipt Printing](../receipt-printing/receipt-printing.md).

PosCreators must print these values exactly as returned and must not replace them with their own texts.

:::caution Sandbox

Sandbox queues transmit to the myDATA test environment. They return the **same** provider footer and the same kind of MARK, UID and QR code as production, so a sandbox document cannot be told apart by its footer. Sandbox documents are never valid fiscal documents. The sandbox additionally returns the raw myDATA request and response in `ftStateData` (`GR.GovernmentApi`) to ease integration; production does not.

:::

## What fiskaltrust takes care of

With the fiskaltrust.Middleware for Cloud, the whole provider flow happens inside the Middleware. Based on the existing implementation, fiskaltrust takes care of:

- **Mapping to myDATA.** Receipt cases, charge items and pay items are mapped to the myDATA invoice type, income classifications (E3 categories and types), VAT categories and exemption categories, payment methods, withholding taxes, fees, stamp duty and other taxes. The mapping rules are described in the [reference tables](../reference-tables/reference-tables.md).
- **Document numbering.** Every queue owns an invoice series (by default the cash box identification) and a sequential number (`aa`) that the Middleware reserves for each document and commits only when myDATA returns a MARK. Duplicate-number rejections by myDATA are healed automatically. The series and number are appended to `ftReceiptIdentification` after the `#`.
- **Transmission and identifiers.** The document is transmitted synchronously to myDATA with the provider credentials. MARK, UID, authentication code and the myDATA QR URL are returned as signature items, together with the full myDATA XML for audit purposes.
- **Provider signature and EFTPOS data.** For card payments through an interconnected terminal (Viva protocols `viva_eft_pos`, `viva_eft_pos_implicit`, the Viva App2App flow, or the generic `aadeSignatureData` payload), the payment signature, the AADE transaction ID and the tip amount are transmitted with the document, with the provider ID as signing author.
- **QR code and digital receipt.** The QR code content is the URL of the digital receipt rendered by fiskaltrust (`https://receipts.fiskaltrust.eu/{ftQueueID}/{ftQueueItemID}`; the `receipts-sandbox` host in the sandbox, or a partner-specific receipt host configured for the queue). This URL is also transmitted to myDATA as the document download URL.
- **Customer and master data.** The issuer (VAT number, branch) comes from the master data configured in the fiskaltrust.Portal; the counterpart of invoices from `cbCustomer`, including the country category (domestic, EU, third country) that drives the invoice type and classification.
- **Offline handling.** Receipts sent with the *late signing* flag are transmitted with `transmissionFailure = 1` (loss of connection between the entity and the provider) and carry the corresponding notice. Handwritten receipts issued during an outage can be recovered with their own series.
- **Corrections.** Retail credit receipts (11.4) and credit notes (5.1, 5.2) reference the original document by its MARK; restaurant orders (8.6) can be cancelled; delivery notes can be cancelled through the myDATA cancellation call.
- **Provider validation rules.** The Middleware validates every request before it is transmitted (see [Boundaries](#boundaries)) and returns myDATA's own validation errors unchanged.
- **Regulatory updates.** Changes to the myDATA API (for example the schema upgrade to 2.0.2) are implemented by fiskaltrust without changes on the POS side, unless new data is required from the POS.

:::caution Scope

The provider credentials that authenticate against myDATA are held by fiskaltrust and are part of the cloud deployment. Self-hosted or on-device installations of the Middleware are therefore not available for Greece under this licence. PosCreators who need such a deployment must obtain their own provider licence (see [Route 2](../go-to-market/route-2-own-licence.md)).

:::

### What has been verified with AADE

The licensing of the provider platform was carried out with AADE on the basis of demonstration scenarios prescribed by AADE: a sales invoice (1.1) with goods and services, withholding tax and several VAT rates; a retail receipt (11.1) with an interconnected payment terminal, online and in the offline scenario of *Α.1155/2023*; a POS payment receipt (8.4) classified as other income information without VAT; the creation, encryption and transmission of the provider signature to the ERP and the terminal; the exchange of the unique payment ID between terminal and ERP; the MARK, UID and authentication sequence; QR code generation; anonymous retail receipts; and data access for the provider, the provider's customer and the recipient of a wholesale invoice. The same scenarios are kept as acceptance tests in the Middleware repository and are re-run against the myDATA test environment.

Which of the myDATA document types beyond these scenarios were part of the licence audit, as opposed to being supported by the implementation and accepted by myDATA, is being clarified with the Greek market team.

## Supported document types

The following myDATA invoice types are produced by the Middleware from the `ftReceiptCase` values described in [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md). The type is derived from the receipt case, its flags, the type of service of the charge items and the customer's country.

| myDATA type | Greek name | `ftReceiptCase` (txcc) | Notes |
| ----------- | ---------- | ---------------------- | ----- |
| `11.1` | ΑΛΠ, Απόδειξη Λιανικής Πώλησης | `0x0001` POS receipt (`0x0000` is treated the same) | Retail receipt for goods. Default for every POS receipt that contains at least one delivery item. |
| `11.2` | ΑΠΥ, Απόδειξη Παροχής Υπηρεσιών | `0x0001` with only service items (`S` = `2`) | Retail receipt for services. |
| `11.4` | Πιστωτικό Στοιχείο Λιανικής | `0x0001` with flag `0x0100` (IsRefund) | Retail credit receipt. The original documents are referenced via `cbPreviousReceiptReference` or by MARK and transmitted as connected marks. |
| `11.5` | ΑΛΠ για Λογαριασμό Τρίτων | `0x0001` with only *not own sales* items (`S` = `6`) | Retail receipt on behalf of third parties. |
| `1.1`, `1.2`, `1.3` | Τιμολόγιο Πώλησης (domestic, intra-EU, export) | `0x1000` to `0x1003` | Sales invoice for goods. The variant follows the customer country. A customer with VAT number is mandatory. |
| `2.1`, `2.2`, `2.3` | Τιμολόγιο Παροχής Υπηρεσιών (domestic, intra-EU, third country) | `0x1000` to `0x1003` with only service items | Service invoice. |
| `1.4` | Τιμολόγιο για Λογαριασμό Τρίτων | `0x1xxx` with only *not own sales* items | Invoice on behalf of third parties. |
| `5.1` | Πιστωτικό Τιμολόγιο Συσχετιζόμενο | `0x1xxx` with flag `0x0100` and a reference to the original invoice | Correlated credit note. The reference can be `cbPreviousReceiptReference` or an external MARK in `ftReceiptCaseData`. |
| `5.2` | Πιστωτικό Τιμολόγιο Μη Συσχετιζόμενο | `0x1xxx` with flag `0x0100` without reference | Non-correlated credit note. |
| `6.1` | Στοιχείο Αυτοπαράδοσης | `0x0001` or `0x1xxx` with only *own consumption* items (`S` = `7`) | Self-supply / own use. |
| `8.4` | Απόδειξη Είσπραξης POS | `0x0002` Payment transfer | POS payment receipt, classified as other income information (`category1_95`). |
| `8.5` | Απόδειξη Επιστροφής POS | `0x0002` with flag `0x0100` | POS refund receipt. |
| `8.6` | Δελτίο Παραγγελίας Εστίασης | `0x3004` Order | Restaurant order slip. `cbArea` is transmitted as table number. Not a fiscal receipt; the response carries the informational notice that must be printed. With flag `0x0004` (IsVoid), a reference to the original order and `cbArea`, the order is cancelled. |
| `9.3` | Δελτίο Αποστολής | `0x0005` Delivery note with flag `0x0400` (HasTransportInformation) | Delivery note with transport details (dispatch date and time, vehicle, addresses, purpose of movement) from `ftReceiptCaseData`. With flag `0x0100` a reverse delivery note is issued; with flag `0x0004` the referenced delivery note is cancelled. Sale documents that carry flag `0x0400` are transmitted as combined document and delivery note. |
| Payment methods | Μέθοδοι πληρωμής (`SendPaymentsMethod`) | `0x3005` Pay with a Greek pay item flag and `cbPreviousReceiptReference` | Reports a payment for an already transmitted invoice (for example a card payment after an invoice on credit). No MARK of its own. |

Every other myDATA invoice type (for example `1.5`, `1.6`, `2.4`, `3.1`, `3.2`, `6.2`, `7.1`, `8.1`, `8.2`, `11.3`) can be requested explicitly through the `invoiceType` override in `ftReceiptCaseData` (`GR.mydataoverride.invoice.invoiceHeader.invoiceType`), together with the matching income or expense classification on every charge item. These types are accepted by myDATA in the acceptance tests of the Middleware, but the POS is responsible for choosing them correctly; ask fiskaltrust before using them productively.

In addition, the following operations are supported but do not create a myDATA document:

| Operation | `ftReceiptCase` | Result |
| --------- | --------------- | ------ |
| Late signing | Any of the above with flag `0x0001` | Transmitted with `transmissionFailure = 1` and the notice *Απώλεια Διασύνδεσης Οντότητας - Παρόχου*. |
| Handwritten receipt | Any of the above with flag `0x0008` | Transmitted with the series and number of the handwritten document from `ftReceiptCaseData.GR` (`Series`, `AA`, `MerchantVATID`, `HashAlg`, `HashPayload`). |
| E-commerce | `0x0004` | Transmitted only when an `invoiceType` override is present; otherwise the receipt is stored without myDATA transmission. |
| Protocol / audit log | `0x3000`, `0x3001`, `0x3002` | Stored in the queue, no transmission. |
| Copy / reprint | `0x3010` | Stored in the queue, no transmission. Reprint the original signature items. |
| Zero receipt, daily operations | `0x2000` to `0x2013` | Accepted as no-ops; Greece has no closing obligation through the provider. |
| Initial / out-of-operation | `0x4001`, `0x4002` | Queue lifecycle. The initial-operation receipt initialises the invoice series of the queue. |

## Boundaries

The Middleware actively rejects requests that fall outside the supported scope or that myDATA would reject. Requests that fail one of these checks are not transmitted; the response carries the error state (see [Service Status: ftState](../reference-tables/service-status-ftstate.md)) and the reason in the `ftSignatures`, either as a Middleware validation message or as the error list returned by myDATA.

**Receipt cases that are not supported**

- POS receipt without fiscalization obligation (`0x0003`), table check (`0x0006`), pro forma (`0x0007`) and internal usage / material consumption (`0x3003`) are rejected. Use an order (`0x3004`) for restaurant order slips and own-consumption charge items for self-supply.
- A delivery note (`0x0005`) without the `HasTransportInformation` flag is rejected.
- Voids (flag `0x0004`) are only supported for restaurant orders (8.6) and delivery notes (9.3). This is an AADE rule, not a limitation of the Middleware: the myDATA API for providers offers cancellation only for these two non-fiscal documents, while the generic `CancelInvoice` call is reserved for ERP users transmitting their own books. Every other correction is a refund (flag `0x0100`) that creates a credit document referencing the original; issued documents cannot be edited or deleted.

**Amounts, currency and tax**

- Only `EUR` is transmitted.
- Supported VAT rates are 24 %, 13 %, 6 %, 17 %, 9 %, 4 %, 3 % and 0 %; the VAT rate must match the VAT nibble of the `ftChargeItemCase` (see [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md)). Other combinations are rejected.
- A 0 % line must carry a supported nature-of-VAT value (`NN`) so that the exemption category can be transmitted; unknown values are rejected.
- The sum of the charge items must equal the sum of the pay items, except for log receipts and delivery notes.
- Items on behalf of third parties (`S` = `6`) and own-consumption items (`S` = `7`) cannot be mixed with other items in one receipt.
- Withholding taxes, fees, stamp duty and other taxes are recognised by the exact Greek description of the charge item; an unknown description is rejected.
- Document-level (entire-sum) discounts are not supported; discounts are line discounts.

**Data quality rules**

- The account master data in the fiskaltrust.Portal must contain the merchant's VAT number; without it every request is rejected.
- Invoices (`0x1xxx`) require a customer with a VAT number and country in `cbCustomer`; retail receipts (`0x0001`) carry no counterpart.
- Handwritten receipts must use a series different from the queue's own series, and the hash payload must match the transmitted data exactly.
- The series and number of a document cannot be set by the POS (except for handwritten documents); overrides of `series` or `aa` are rejected.
- A classification override on one charge item requires a classification override on every charge item and an `invoiceType` override.
- Orders (8.6) that are voided require a reference to the original order and the table number in `cbArea`.

**Operational boundaries**

- The provider credentials, the invoice series and the numbering are managed by fiskaltrust; there is no way for a PosCreator or merchant to configure them.
- Sandbox queues transmit to the myDATA test environment and must not be used for productive documents.
- The journal endpoint returns no market-specific export yet (see [Type of Journal: ftJournalType](../reference-tables/type-of-journal-ftjournaltype.md)); exports for tax audits are provided through the fiskaltrust.Portal, and the complete myDATA XML of every document is returned in the response.
- B2G e-invoicing (transmission to the public sector through the national interoperability centre) is not part of the current scope.
- Phase B of the digital delivery note (movement tracking through the Digital Shipping Note API, inbound documents) is not yet implemented.

## What this means for PosCreators

- **You integrate a licensed provider platform; you do not become one.** Your POS sends the business case to the fiskaltrust.Middleware for Cloud through the [PosSystem API](../../possystem-api/introduction.md). The Middleware maps, numbers and transmits the document and returns MARK, UID, authentication code, QR code and the provider footer. Your software must not transmit to myDATA itself and must not generate its own MARK, QR code or provider texts.
- **Print what you receive, unchanged.** Every visible signature item (MARK, UID, authentication code, unique document identifier, QR code, provider footer, informational notices) must be reproduced exactly as returned. See [Receipt Printing](../receipt-printing/receipt-printing.md).
- **Send complete and valid requests.** The Middleware rejects requests that would produce a non-compliant document, and myDATA rejects what the Middleware cannot catch. Show the returned error to the operator and correct the request; do not retry with altered fiscal data.
- **Connect the payment terminal.** For card payments the terminal's payment signature and AADE transaction ID must be handed over in `ftPayItemCaseData`, so that the Middleware can transmit them with the document. Without them the receipt is not compliant with *Α.1155/2023*.
- **Respect the document flow.** Refunds and credit notes reference the original document; orders are cancelled, not deleted; payments on invoices are reported through the pay case. Series and numbers are assigned by the Middleware.
- **Handle outages correctly.** Receipts issued while the Middleware was unreachable are sent afterwards with the late-signing flag; handwritten receipts with the handwritten flag and their own series. Restaurant orders must be turned into a fiscal document within 24 hours (*Α.1112/2025*).
- **Sandbox is not production.** Sandbox documents carry the same footer as production documents but are transmitted to the myDATA test environment and are never valid.
- **Cloud only.** Self-hosted or on-device installations are not available under the current licence.

## What this means for PosOperators

- **You remain the taxpayer.** The documents are issued in your name, with your VAT number, and transmitted to your myDATA books. You are responsible for handing them to your customers and for keeping them for the statutory retention period.
- **You must declare the provider.** A business that issues its documents through a licensed provider must submit the corresponding statement to AADE within ten days of starting (*Α.1112/2025*, art. 6; myDATA call `SendStatement`). fiskaltrust intends to submit this statement on your behalf as part of the onboarding; until this is live, the statement has to be submitted through myDATA, so ask your PosDealer before the first productive document.
- **Your master data must be complete.** Your VAT number and, where applicable, the branch number must be configured in the fiskaltrust.Portal before the first document is issued.
- **Corrections go through the POS.** A wrong document is refunded or credited through the POS, which creates the corresponding credit document referencing the original. Documents cannot be edited or deleted.
- **Card payments need an interconnected terminal.** The payment signature and the unique payment ID of the terminal are part of your receipts and are transmitted to myDATA.
- **Exports for audits** are available through the fiskaltrust.Portal, or on request from fiskaltrust's Greek support.
- **Limits you will encounter.** Only EUR, no document-level discounts, no B2G invoicing, no voids except for orders and delivery notes. Ask your POS provider to issue a credit document when a correction is needed.
