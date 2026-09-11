---
slug: /poscreators/middleware-doc/spain/declaration
title: Declaration and Registration
---

# Declaration and Registration of the fiskaltrust.Middleware

Spain has no single certification of invoicing programs. Two frameworks apply, depending on where the merchant is taxed:

- In the **common territory** (all of Spain except the Basque Country and Navarre) every *Sistema Informático de Facturación* (SIF) must fulfil the requirements of *Real Decreto 1007/2023* (Reglamento SIF, based on art. 29.2.j of the *Ley General Tributaria*) and the technical specification *Orden HAC/1177/2024*. There is no register and no approval by the tax authority (*Agencia Estatal de Administración Tributaria*, AEAT). Instead, the **producer** of the SIF certifies its compliance in a **declaración responsable** (responsible declaration) that is handed to the merchant and shown to the AEAT on request. Invoice records can be transmitted to the AEAT in real time (**VERI\*FACTU**) or kept locally with an electronic signature (*No VERI\*FACTU*).
- In the three provinces of the **Basque Country** (Araba/Álava, Bizkaia, Gipuzkoa) the **TicketBAI** system applies. The software developer registers the software in the register of *software garante* of one of the three provincial tax authorities (*Haciendas Forales*), submits a technical description (*memoria descriptiva*) and a responsible declaration, and receives a **TicketBAI licence code** (`LicenciaTBAI`) that is transmitted with every invoice.

The fiskaltrust.Middleware implements both frameworks. This page describes what fiskaltrust holds and does today, which document types the Middleware issues, where the identifiers appear on documents, and where the boundaries of the implementation are.

:::info This chapter describes Route 1 of the Go-to-Market

Everything on this page applies when your POS system integrates with the **fiskaltrust.Middleware for Cloud** and issues documents under **fiskaltrust's declaración responsable** (VERI\*FACTU) and **fiskaltrust's TicketBAI software registration**. This is [Route 1](../go-to-market/route-1-fiskaltrust-declaration.md) of the [Go-to-Market](../go-to-market/go-to-market.md) chapter.

If you declare or register your own solution built on top of the fiskaltrust.Middleware ([Route 2](../go-to-market/route-2-own-declaration.md)), you sign your own declaration and hold your own TicketBAI licence. This page then only tells you what the Middleware brings into your procedure.

:::

## What fiskaltrust holds

### VERI\*FACTU: declaración responsable of the producer

fiskaltrust has prepared the responsible declaration of the *Sistema Informático de Facturación* for the fiskaltrust.Middleware in accordance with chapter IV of *Orden HAC/1177/2024*. The draft was sent to the AEAT for review in spring 2025; the AEAT answered that the declaration "appears to be correct" apart from one wording on the hash (*huella*), which was corrected. The declaration was then signed by fiskaltrust's managing director and resubmitted. The declaration identifies:

| Field | Value |
| ----- | ----- |
| Producer (*productor*) | fiskaltrust consulting GmbH, Alpenstraße 99a, 5020 Salzburg, Austria, VAT ID `ATU68541544` |
| System name (*nombre del sistema informático*) | `fiskaltrust.Middleware` |
| System identification code (*IdSistemaInformatico*) | `00` |
| System version (*versión*) | `2.0` |
| Operating mode | VERI\*FACTU (verifiable invoices, transmitted to the AEAT) |

Because the AEAT keeps no register of declared systems, the declaration itself is the proof of compliance. It has to be available to the merchant who uses the system and to the AEAT on request. How the signed PDF is made available to PosCreators and merchants (download in the fiskaltrust.Portal or on request from fiskaltrust) is being clarified; until then, ask [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) for a copy.

:::caution Your POS is a component of the SIF

*Orden HAC/1177/2024* treats an invoicing system that consists of components from different producers as one SIF with one declaration per component. fiskaltrust's declaration covers the fiskaltrust.Middleware (record generation, hash chain, transmission, storage and export). The POS software that captures the sale and prints the document is a component of its own. fiskaltrust provides a **supplement template** for PosCreators that describes the POS as the upstream component of the Middleware (user interface, data capture, secure transmission to the Middleware, printing of the returned data). PosCreators complete and sign this supplement for their product; see [Route 1](../go-to-market/route-1-fiskaltrust-declaration.md#what-you-declare).

:::

### TicketBAI: software registration

For the Basque provinces fiskaltrust has prepared the *memoria descriptiva técnica* and the responsible declaration of the *software garante* in accordance with articles 10 and 11 of the Bizkaia *Orden Foral 1482/2020* (the corresponding orders of Araba and Gipuzkoa contain the same requirements). It describes the fiskaltrust.Middleware as a **distributed-architecture application** hosted in the fiskaltrust cloud, the XAdES signature of the TicketBAI files, the chaining of invoices, the TBAI identifier and QR code, the on-site verification data and the storage of the files. The developer identification used in the registration and in every TicketBAI file is:

| Field | Value |
| ----- | ----- |
| Developer (*entidad desarrolladora*) | fiskaltrust consulting GmbH, Spanish NIF `N0286342A` |
| Software name (*nombre del software*) | `fiskaltrust.Middleware` |
| Software version | `2.0` |
| Licence code (*LicenciaTBAI*) | One licence code per province, configured in the fiskaltrust cloud signing service. The values are not published on this page. |

Registration in **one** province is sufficient for all three provinces; fiskaltrust submitted the registration to the *Hacienda Foral de Bizkaia* in December 2025. The first submission was answered with findings, and the *memoria descriptiva* was revised until April 2026. The current status of the registration and the final licence codes are being confirmed with the Spanish market team; until they are published here, ask [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) before your first productive TicketBAI document.

## Where the identifiers appear on documents

The Middleware returns everything that must appear on the document as signature items (see [Type of Signature: ftSignatureType](../reference-tables/type-of-signature-ftsignaturetype.md) and [Receipt Printing](../receipt-printing/receipt-printing.md)):

**VERI\*FACTU (common territory)**

- The **QR code** (*QR tributario*) with the AEAT verification URL, containing the issuer NIF, the series and number, the issue date and the total amount of the invoice.
- The legend **`Factura verificable en la Sede electrónica de la AEAT`**, which identifies the document as issued by a VERI\*FACTU system.
- The **huella** (SHA-256 hash of the invoice record) and the **issuer NIF** (*IDEmisorFactura*) as text items.
- Inside the transmitted record, the `SistemaInformatico` block identifies the system (`fiskaltrust.Middleware`, code `00`) and the installation (*NumeroInstalacion* = the cash box identification of the queue). The alignment of the version and producer fields in this block with the signed declaration is being finalised.

**TicketBAI (Basque Country)**

- The **TBAI identifier** (*código identificativo TicketBAI*), a 39-character code of the form `TBAI-<issuer NIF>-<ddMMyy>-<13 signature characters>-<CRC>`.
- The **TicketBAI QR code** with the verification URL containing the TBAI identifier, series, number, total amount and a CRC. The Middleware currently uses the Batuz verification address (`batuz.eus/QRTBAI/`) for all three provinces; the province-specific addresses of Araba and Gipuzkoa are being aligned.
- Inside the signed XML file, the `Software` block carries the licence code, the developer NIF, the software name and version, and the device serial number (*NumSerieDispositivo* = the cash box identification).

PosCreators must print these values exactly as returned and must not replace them with their own texts.

:::caution Sandbox

Sandbox queues transmit to the **test environments** of the AEAT and of the provincial tax authorities. The QR codes point to the verification pages of these test environments, the TicketBAI files carry the test licence codes of the provinces, and the response carries an additional `S A N D B O X` signature item. Sandbox documents are never valid invoices.

:::

## What fiskaltrust takes care of

With the fiskaltrust.Middleware for Cloud, the whole fiscal flow happens inside the Middleware and the fiskaltrust cloud signing service (`signing.fiskaltrust.es`, sandbox `signing-sandbox.fiskaltrust.es`). Based on the existing implementation, fiskaltrust takes care of:

- **Validation.** Every request is checked against the Spanish rules before anything is signed or transmitted (see [Boundaries](#boundaries)); non-compliant requests are rejected with a validation code and message.
- **Numbering and series.** Each queue owns two numbering sequences that are created with the initial-operation receipt: one for simplified invoices (POS receipts) and one for complete invoices. Every document receives the next number of its sequence; the series and number are appended to `ftReceiptIdentification` after the `#` (for example `ft2A#fktAbCdEfGhIjK0000-17`).
- **Hash chain (VERI\*FACTU).** For every record the Middleware calculates the *huella* according to the AEAT specification (SHA-256 over issuer NIF, series and number, issue date, invoice type, total VAT, total amount, previous hash and generation timestamp) and chains it to the previous record of the sequence (*Encadenamiento*, with `PrimerRegistro` for the first record).
- **Signature and chain (TicketBAI).** Every TicketBAI file (schema 1.2) is signed with an XAdES enveloped signature (SHA-256, the signature policy of the province) using the certificate configured for the merchant, and chained to the previous invoice (series, number, date and the first 100 characters of the previous signature value).
- **Record generation.** POS receipts and invoices are converted into the *registro de facturación de alta* (VERI\*FACTU) or the TicketBAI *alta* file, including the VAT breakdown per rate, the exemption and not-subject reasons derived from the nature-of-VAT segment of the `ftChargeItemCase`, the tax regime key (*ClaveRegimen*), the applied tax (*Impuesto*: VAT, IPSI or IGIC, from the queue configuration) and the customer data of invoices.
- **Transmission.** Records are transmitted synchronously: VERI\*FACTU records through the AEAT SOAP web service (*SistemaFacturacion*), TicketBAI files through the web services of Araba and Gipuzkoa or, for Bizkaia, wrapped in the *LROE modelo 240* message of the **Batuz** system. The response of the authority decides whether the document is issued; rejections are returned to the POS.
- **QR codes and legends.** The AEAT QR URL and the VERI\*FACTU legend, or the TBAI identifier and the TicketBAI QR URL, are generated and returned as signature items.
- **Certificates.** The electronic certificates used to authenticate against the AEAT and to sign TicketBAI files are stored in the fiskaltrust cloud (per merchant account or cash box, uploaded through the fiskaltrust.Portal); they never reach the POS.
- **Storage and export.** The transmitted XML and the response of the authority are stored with every document and returned to the POS in `ftStateData` (`ES.GovernmentAPI`). The VERI\*FACTU journal type of the journal endpoint is defined for the export of these records; see [Type of Journal: ftJournalType](../reference-tables/type-of-journal-ftjournaltype.md) for its current status. Exports for tax audits are additionally provided through the fiskaltrust.Portal.
- **Event log.** The initial-operation and out-of-operation receipts are recorded in the action journal of the queue as the start and stop events of the system.
- **Regulatory updates.** Changes of the AEAT or provincial specifications (for example the TicketBAI schema 1.2.2 or the exemption keys) are implemented by fiskaltrust without changes on the POS side, unless new data is required from the POS.

:::caution Scope

The certificates, the licence codes and the endpoints of the tax authorities are part of the fiskaltrust cloud deployment. Self-hosted or on-device installations of the Middleware are not available for Spain under fiskaltrust's declaration and registration. PosCreators who need such a deployment must declare and register their own solution (see [Route 2](../go-to-market/route-2-own-declaration.md)).

:::

### What has been verified with the tax authorities

- **AEAT.** The responsible declaration was reviewed by the AEAT's customer service (see above). The transmission of VERI\*FACTU records was developed against the AEAT pre-production environment; the acceptance tests of the Middleware replay standard sales, exempt, not-subject, reverse-charge, export, IPSI and IGIC cases against it. The AEAT does not certify or audit SIF producers; there is therefore no approval beyond the declaration.
- **Basque provinces.** The Middleware was developed against the TicketBAI test environments of Araba, Bizkaia and Gipuzkoa with the test licence codes and test certificates of the provinces; the acceptance tests submit invoices to all three environments and compare the generated XML with the reference samples of the provinces for every exemption and not-subject case. The review of the *memoria descriptiva* by the Hacienda Foral de Bizkaia is the registration procedure described above.

## Supported document types

The following document types are produced by the Middleware from the `ftReceiptCase` values described in [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md).

| Document | `ftReceiptCase` (txcc) | VERI\*FACTU record | TicketBAI file | Notes |
| -------- | ---------------------- | ------------------ | -------------- | ----- |
| Simplified invoice (*factura simplificada*) | `0x0001` POS receipt (`0x0000` is treated the same) | *Registro de alta*, `TipoFactura` `F2` | *Alta*, `FacturaSimplificada` = `S` | Numbered in the simplified-invoice sequence. A customer is optional. |
| Complete invoice (*factura completa*) | `0x1000`, `0x1001`, `0x1002`, `0x1003` | *Registro de alta*, currently `TipoFactura` `F2` without recipient data | *Alta*, `FacturaSimplificada` = `N`, with *Destinatarios* from `cbCustomer` | Numbered in the invoice sequence. Pass the recipient in `cbCustomer` with name, street and postcode; Spanish customers need a NIF in a valid format, foreign customers are identified by VAT ID, tax ID or passport. TicketBAI files carry the recipient; the VERI\*FACTU record is currently transmitted as `F2` without *Destinatarios*. The mapping of complete invoices to `TipoFactura` `F1` with recipient data is being completed. |
| Cancellation (*anulación*) | Any of the above with flag `0x0004` (IsVoid) and `cbPreviousReceiptReference` | *Registro de anulación* referencing the original record | Not yet available (see [Boundaries](#boundaries)) | The void must repeat the original document exactly; only one void per document. |
| Refund / return (*devolución*) | Any of the above with flag `0x0100` (IsRefund) and `cbPreviousReceiptReference` | *Registro de alta* with negative amounts | *Alta* with negative amounts | The refund references the original document; send the returned lines with negative quantities and amounts (all lines for a full refund, the affected lines with the charge-item refund flag for a partial refund). Corrective invoice types (`R1` to `R5`, *factura rectificativa*) are not emitted yet; see [Boundaries](#boundaries). |

The following operations are accepted but do not create a fiscal document:

| Operation | `ftReceiptCase` | Result |
| --------- | --------------- | ------ |
| Payment transfer, POS receipt without fiscalization, e-commerce, delivery note, table check, pro forma | `0x0002` to `0x0007` | Stored in the queue without number, record or transmission. They have no fiscal effect in Spain; use them only for documents that are not invoices. |
| Zero receipt, daily operations | `0x2000` to `0x2013` | Accepted as no-ops; Spain has no closing obligation through the SIF. |
| Protocol / audit log, order, pay, copy | `0x3000` to `0x3010` | Stored in the queue, no transmission. A copy (`0x3010`) reprints the original signature items. |
| Initial / out-of-operation | `0x4001`, `0x4002` | Queue lifecycle. The initial-operation receipt activates the queue and creates the two numbering sequences; both are recorded as events. |
| SCU switch | `0x4011`, `0x4012` | Accepted as no-ops. |

## Boundaries

The Middleware actively rejects requests that fall outside the supported scope or that the tax authority would reject. Requests that fail one of these checks are not transmitted; the response carries the error state `EEEE_EEEE` (see [Service Status: ftState](../reference-tables/service-status-ftstate.md)) and a `FAILURE` signature item with the validation code and message (`Validation error [<code>]: <message> (Field: <field>, Index: <item index>)`), or the error list returned by the AEAT or the provincial web service.

**Document types and corrections**

- Only simplified invoices (`0x0001`) and complete invoices (`0x1xxx`) are fiscal documents. All other receipt cases are stored without transmission.
- Cancellations (`IsVoid`) are transmitted to the AEAT as *registro de anulación*. For TicketBAI the cancellation file (*anulación*) is not yet implemented; a void on a TicketBAI queue is rejected by the provincial web service.
- Refunds are transmitted as ordinary records with negative amounts. The corrective invoice types of VERI\*FACTU (`R1` to `R5`, *rectificativa por sustitución o por diferencias*) and the TicketBAI *factura rectificativa* are not emitted yet. Whether refunds have to be issued as *facturas rectificativas* for your use case is being clarified with the Spanish market team; ask fiskaltrust before you go live with returns.
- Invoices issued by a third party or by the recipient (*EmitidaPorTercerosODestinatario* `T` / `D`) and invoices with several recipients are not supported.

**Amounts, currency and tax**

- Only `EUR` is supported.
- The VAT nibble of the `ftChargeItemCase` must match the rate: `1` and `2` are 10 %, `4` and `5` are 4 %, `3` is 21 %, `7` and `8` are 0 %. The nibbles `0` (unknown) and `6` (parking rate) are rejected. The `VATAmount` must match the rate within 0.01. See [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md).
- 0 % lines must carry a supported nature-of-VAT value (`NN`) so that the exemption (`E1` to `E6`) or not-subject reason (`N1`, `N2`, `OT`, `RL`, `IE`, `VT`) can be transmitted; an unknown value is rejected.
- Only the types of service *unknown*, *delivery*, *other service*, *tip*, *catalog service* and *receivable* are accepted. Vouchers, sales on behalf of third parties, own consumption, grants and cash transfers are rejected.
- The equivalence surcharge (*recargo de equivalencia*) and the special regimes of *ClaveRegimen* beyond the general regime and exports are not supported.
- The sum of the charge items must equal the sum of the pay items (tolerance 0.01). Negative quantities and amounts are only allowed for discounts, refunds and voids; a discount must not exceed the amount of the article it belongs to.

**Data quality rules**

- All charge items need a description, a VAT amount and a non-zero amount.
- A `cbCustomer`, when provided, must carry name, street and postcode. A Spanish customer (country `ES` or no country) must carry a NIF in a valid format (for example `B12345678`, `12345678A` or `X1234567A`). Foreign customers are identified by `CustomerVATId`, `CustomerTaxId` or `CustomerIdentifier`. The presence of a customer on complete invoices is checked by the extended validation and reported as a warning; making it a hard requirement is being clarified.
- Refunds and voids require exactly one `cbPreviousReceiptReference`; grouped references are not supported. A document that has been voided cannot be referenced again, and a second void of the same document is rejected. A void must repeat the charge items and pay items of the original exactly (same lines, quantities, amounts, VAT rates and positions). The lines of a refund are not yet compared with the original document.
- All `ftReceiptCase`, `ftChargeItemCase` and `ftPayItemCase` values must carry the Spanish country code `0x4553`.

**Operational boundaries**

- Series, numbers, certificates and licence codes are managed by fiskaltrust; there is no way for a PosCreator or merchant to set the document number or to sign records locally. The series currently generated by the Middleware contain lower-case letters; the AEAT recommends upper-case characters only, and the format is being reviewed.
- Training mode is not supported in Spain.
- The Middleware operates in **VERI\*FACTU mode** only: every record is transmitted to the AEAT. The alternative *No VERI\*FACTU* mode (signed records kept locally, event log export) is not offered.
- Sandbox queues transmit to the test environments of the authorities and must not be used for productive documents.
- Documents can only be numbered while the Middleware is reachable. The handling of an outage between the POS and the Middleware is described under [Offline handling](../go-to-market/go-to-market.md#key-factors-for-the-spanish-market).
- SII (*Suministro Inmediato de Información*), B2G e-invoicing (Facturae / FACe) and the upcoming mandatory B2B e-invoice are not part of the current scope.

## What this means for PosCreators

- **You integrate a declared and registered system; you do not build one.** Your POS sends the business case to the fiskaltrust.Middleware for Cloud through the [PosSystem API](../../possystem-api/introduction.md). The Middleware numbers the document, calculates the hash or signature, transmits the record and returns the QR code, the legend or the TBAI identifier. Your software must not number, hash, sign or transmit invoices itself.
- **Declare your component.** Complete and sign the PosCreator supplement to fiskaltrust's declaración responsable for your product, and keep it available for your merchants and the AEAT. See [Route 1](../go-to-market/route-1-fiskaltrust-declaration.md#what-you-declare).
- **Print what you receive, unchanged.** The QR code, the VERI\*FACTU legend, the TBAI identifier and the series and number must be reproduced exactly as returned. See [Receipt Printing](../receipt-printing/receipt-printing.md).
- **Send complete and valid requests.** The Middleware rejects requests that would produce a non-compliant record, and the tax authority rejects what the Middleware cannot catch. Show the returned error to the operator and correct the request; do not retry with altered fiscal data.
- **Respect the document flow.** Refunds and voids reference the original document; issued documents cannot be edited or deleted. Series and numbers are assigned by the Middleware.
- **Know the territory of your merchant.** A merchant taxed in the common territory needs a VERI\*FACTU queue; a merchant with an establishment in Araba, Bizkaia or Gipuzkoa needs a TicketBAI queue of that province. The queue type is set up in the fiskaltrust.Portal and cannot be changed afterwards.
- **Sandbox is not production.** Sandbox documents point to the test verification pages and are never valid invoices.
- **Cloud only.** Self-hosted or on-device installations are not available under fiskaltrust's declaration and registration.

## What this means for PosOperators

- **You remain the taxpayer.** The documents are issued in your name, with your NIF, and transmitted to the AEAT or to your provincial tax authority. You are responsible for handing them to your customers and for keeping them for the statutory retention period.
- **You need an electronic certificate.** The transmission to the AEAT and the signature of TicketBAI files require a qualified electronic certificate: a company seal certificate, a legal-representative certificate or, for TicketBAI, a device certificate issued by Izenpe. The certificate is uploaded to the fiskaltrust.Portal during onboarding. Whether fiskaltrust can transmit on your behalf as *colaborador social* or by power of attorney is being clarified.
- **Keep the declarations.** You must be able to show the responsible declarations of your invoicing system (fiskaltrust's declaration and the supplement of your POS provider) to the AEAT on request.
- **Corrections go through the POS.** A wrong document is voided or refunded through the POS, which creates the corresponding record referencing the original. Documents cannot be edited or deleted.
- **Bizkaia has additional obligations.** Under Batuz, the TicketBAI files are transmitted as part of the *LROE* (*Libro Registro de Operaciones Económicas*, modelo 240). Whether fiskaltrust also files the remaining LROE chapters for you, or provides exports for your accountant, is being clarified.
- **Limits you will encounter.** Only EUR, only the standard VAT regimes, no vouchers, no equivalence surcharge, no corrective invoices yet, no TicketBAI cancellations yet. Ask your POS provider before relying on one of these features.
