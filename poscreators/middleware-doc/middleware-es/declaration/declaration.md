---
slug: /poscreators/middleware-doc/spain/declaration
title: Declaration and Registration
---

# Declaration and Registration of the fiskaltrust.Middleware

In Spain the producer of the invoicing software is responsible for its compliance. For the fiskaltrust.Middleware, fiskaltrust has taken on this responsibility:

- In the **common territory** (VERI\*FACTU) the producer signs a **declaración responsable** stating that the system complies with *Real Decreto 1007/2023* and *Orden HAC/1177/2024*. There is no approval and no register; the declaration is handed to the merchant and shown to the AEAT on request.
- In the **Basque Country** (TicketBAI) the software is registered as *software garante* with a provincial tax authority and receives a **licence code** (`LicenciaTBAI`) that is transmitted with every invoice.

This page lists what fiskaltrust holds, which document types the fiskaltrust.Middleware issues and where the boundaries of the implementation are.

## What fiskaltrust holds

### VERI\*FACTU: declaración responsable

fiskaltrust has signed the declaración responsable for the fiskaltrust.Middleware. The declaration identifies:

| Field | Value |
| ----- | ----- |
| Producer (*productor*) | fiskaltrust consulting GmbH, Alpenstraße 99a, 5020 Salzburg, Austria, VAT ID `ATU68541544` |
| System name (*nombre del sistema informático*) | `fiskaltrust.Middleware` |
| System identification code (*IdSistemaInformatico*) | `00` |
| Operating mode | VERI\*FACTU (verifiable invoices, transmitted to the AEAT) |

The merchant must be able to show the declaration to the AEAT on request. Ask [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) for a copy of the signed declaration.

### TicketBAI: software registration

fiskaltrust has registered the fiskaltrust.Middleware as *software garante* with the *Hacienda Foral de Bizkaia*; registration in one province is valid in all three. The identification used in every TicketBAI file is:

| Field | Value |
| ----- | ----- |
| Developer (*entidad desarrolladora*) | fiskaltrust consulting GmbH, Spanish NIF `N0286342A` |
| Software name (*nombre del software*) | `fiskaltrust.Middleware` |
| Licence code (*LicenciaTBAI*) | One licence code per province, configured by fiskaltrust. See the registers of the provinces below. |

The licence codes are not listed on this page. Each provincial tax authority publishes the registered software, with its licence code, in its register of *software garante*: [Araba](https://web.araba.eus/es/hacienda/ticketbai/listado-de-software), [Bizkaia](https://www.batuz.eus/es/registro-de-software) and [Gipuzkoa](https://www.gipuzkoa.eus/es/web/ogasuna/ticketbai/listado-software). To find the entry of the fiskaltrust.Middleware, look up the developer *fiskaltrust consulting GmbH* (NIF `N0286342A`) or the software name `fiskaltrust.Middleware` in these lists.

## What the fiskaltrust.Middleware takes care of

The whole fiscal flow happens inside the fiskaltrust.Middleware and the fiskaltrust cloud:

- **Validation.** Every request is checked against the Spanish rules before anything is signed or transmitted (see [Boundaries](#boundaries)); non-compliant requests are rejected with a validation code and message.
- **Numbering and series.** Each queue owns two numbering sequences, created with the initial-operation receipt: one for simplified invoices and one for complete invoices. The series and number are appended to `ftReceiptIdentification` after the `#` (for example `ft2A#fktAbCdEfGhIjK0000-17`).
- **Record, hash and signature.** POS receipts and invoices are converted into the VERI\*FACTU record with its hash chain, or into the TicketBAI file with its XAdES signature and chaining, including the VAT breakdown, the exemption and not-subject reasons, the applied tax (VAT, IGIC or IPSI) and the customer data of invoices.
- **Transmission.** Records are transmitted synchronously to the AEAT or to the web service of the province (for Bizkaia through the *Batuz* system). The response of the authority decides whether the document is issued; rejections are returned to the POS.
- **Document elements.** The QR code, the VERI\*FACTU legend or the TBAI identifier are generated and returned as signature items; see [Receipt Printing](../receipt-printing/receipt-printing.md).
- **Certificates.** The merchant's certificates are stored in the fiskaltrust cloud (uploaded through the fiskaltrust.Portal) and never reach the POS.
- **Storage and export.** The transmitted XML and the response of the authority are stored with every document and returned to the POS in `ftStateData` (`ES.GovernmentAPI`). The VERI\*FACTU journal type of the journal endpoint exports these records; see [Type of Journal: ftJournalType](../reference-tables/type-of-journal-ftjournaltype.md). Exports for tax audits are additionally provided through the fiskaltrust.Portal.
- **Regulatory updates.** Changes of the AEAT or provincial specifications are implemented by fiskaltrust without changes on the POS side, unless new data is required from the POS.

:::caution Sandbox

Sandbox queues transmit to the **test environments** of the AEAT and of the provincial tax authorities. The QR codes point to the verification pages of these test environments and the response carries an additional `S A N D B O X` signature item. Sandbox documents are never valid invoices.

:::

## Supported document types

The following document types are produced by the fiskaltrust.Middleware from the `ftReceiptCase` values described in [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md).

| Document | `ftReceiptCase` (txcc) | VERI\*FACTU record | TicketBAI file | Notes |
| -------- | ---------------------- | ------------------ | -------------- | ----- |
| Simplified invoice (*factura simplificada*) | `0x0001` POS receipt (`0x0000` is treated the same) | *Registro de alta*, `TipoFactura` `F2` | *Alta*, `FacturaSimplificada` = `S` | Numbered in the simplified-invoice sequence. A customer is optional. |
| Complete invoice (*factura completa*) | `0x1000`, `0x1001`, `0x1002`, `0x1003` | *Registro de alta*, currently `TipoFactura` `F2` without recipient data | *Alta*, `FacturaSimplificada` = `N`, with *Destinatarios* from `cbCustomer` | Numbered in the invoice sequence. Pass the recipient in `cbCustomer` with name, street and postcode; Spanish customers need a NIF in a valid format, foreign customers are identified by VAT ID, tax ID or passport. TicketBAI files carry the recipient; the VERI\*FACTU record is currently transmitted as `F2` without *Destinatarios*. |
| Cancellation (*anulación*) | Any of the above with flag `0x0004` (IsVoid) and `cbPreviousReceiptReference` | *Registro de anulación* referencing the original record | Not yet available (see [Boundaries](#boundaries)) | The void must repeat the original document exactly; only one void per document. |
| Refund / return (*devolución*) | Any of the above with flag `0x0100` (IsRefund) and `cbPreviousReceiptReference` | *Registro de alta* with negative amounts | *Alta* with negative amounts | The refund references the original document; send the returned lines with negative quantities and amounts (all lines for a full refund, the affected lines with the charge-item refund flag for a partial refund). Corrective invoice types (`R1` to `R5`, *factura rectificativa*) are not emitted yet; see [Boundaries](#boundaries). |

The following operations are accepted but do not create a fiscal document:

| Operation | `ftReceiptCase` | Result |
| --------- | --------------- | ------ |
| Payment transfer, POS receipt without fiscalization, e-commerce, delivery note, table check, pro forma | `0x0002` to `0x0007` | Stored in the queue without number, record or transmission. They have no fiscal effect in Spain; use them only for documents that are not invoices. |
| Zero receipt, daily operations | `0x2000` to `0x2013` | Accepted as no-ops; Spain has no closing obligation. |
| Protocol / audit log, order, pay, copy | `0x3000` to `0x3010` | Stored in the queue, no transmission. A copy (`0x3010`) does not return the original signature items; the POS reprints them from its stored response. |
| Initial / out-of-operation | `0x4001`, `0x4002` | Queue lifecycle. The initial-operation receipt activates the queue and creates the two numbering sequences. |
| SCU switch | `0x4011`, `0x4012` | Accepted as no-ops. |

## Boundaries

The fiskaltrust.Middleware rejects requests that fall outside the supported scope or that the tax authority would reject. Such requests are not transmitted; the response carries the error state `EEEE_EEEE` (see [Service Status: ftState](../reference-tables/service-status-ftstate.md)) and a `FAILURE` signature item with the validation code and message (`Validation error [<code>]: <message> (Field: <field>, Index: <item index>)`), or the error list returned by the AEAT or the provincial web service.

**Document types and corrections**

- Only simplified invoices (`0x0001`) and complete invoices (`0x1xxx`) are fiscal documents. All other receipt cases are stored without transmission.
- Cancellations (`IsVoid`) are transmitted to the AEAT as *registro de anulación*. For TicketBAI the cancellation file (*anulación*) is not yet implemented; a void on a TicketBAI queue is rejected by the provincial web service.
- Refunds are transmitted as ordinary records with negative amounts. Corrective invoice types (*facturas rectificativas*) are not emitted yet. Ask fiskaltrust before you go live with returns whether this covers your use case.
- Invoices issued by a third party or by the recipient and invoices with several recipients are not supported.

**Amounts, currency and tax**

- Only `EUR` is supported.
- The VAT nibble of the `ftChargeItemCase` must match the rate: `1` and `2` are 10 %, `4` and `5` are 4 %, `3` is 21 %, `7` and `8` are 0 %. The nibbles `0` (unknown) and `6` (parking rate) are rejected. The `VATAmount` must match the rate within 0.01. See [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md).
- 0 % lines must carry a supported nature-of-VAT value (`NN`) that identifies the exemption or not-subject reason; an unknown value is rejected.
- Only the types of service *unknown*, *delivery*, *other service*, *tip*, *catalog service* and *receivable* are accepted. Vouchers, sales on behalf of third parties, own consumption, grants and cash transfers are rejected.
- The equivalence surcharge (*recargo de equivalencia*) and special tax regimes beyond the general regime and exports are not supported.
- The sum of the charge items must equal the sum of the pay items (tolerance 0.01). Negative quantities and amounts are only allowed for discounts, refunds and voids; a discount must not exceed the amount of the article it belongs to.

**Data quality rules**

- All charge items need a description, a VAT amount and a non-zero amount.
- A `cbCustomer`, when provided, must carry name, street and postcode. A Spanish customer (country `ES` or no country) must carry a NIF in a valid format (for example `B12345678`, `12345678A` or `X1234567A`). Foreign customers are identified by `CustomerVATId`, `CustomerTaxId` or `CustomerIdentifier`. The presence of a customer on complete invoices is checked by the extended validation and reported as a warning.
- Refunds and voids require exactly one `cbPreviousReceiptReference`; grouped references are not supported. A document that has been voided cannot be referenced again, and a second void of the same document is rejected. A void must repeat the charge items and pay items of the original exactly (same lines, quantities, amounts, VAT rates and positions).
- All `ftReceiptCase`, `ftChargeItemCase` and `ftPayItemCase` values must carry the Spanish country code `0x4553`.

**Operation**

- Series, numbers, certificates and licence codes are managed by fiskaltrust; a PosCreator or merchant cannot set the document number or sign records locally.
- Training mode is not supported in Spain.
- Documents can only be numbered while the fiskaltrust.Middleware is reachable; see [What you need to know](../go-to-market/go-to-market.md#what-you-need-to-know).
- SII (*Suministro Inmediato de Información*) and e-invoicing (Facturae / FACe, the upcoming mandatory B2B e-invoice) are not part of the current scope.

## What this means for PosOperators

- **You remain the taxpayer.** The documents are issued in your name, with your NIF, and transmitted to the AEAT or to your provincial tax authority. You hand them to your customers and keep them for the statutory retention period.
- **You need an electronic certificate.** A qualified electronic certificate accepted by the tax authority of your territory (for example a company seal or legal-representative certificate, or for TicketBAI a device certificate issued by Izenpe) is uploaded to the fiskaltrust.Portal during onboarding.
- **Keep fiskaltrust's declaration.** You must be able to show the declaración responsable of the fiskaltrust.Middleware to the AEAT on request.
- **Corrections go through the POS.** A wrong document is voided or refunded through the POS. Documents cannot be edited or deleted.
- **Bizkaia.** The fiskaltrust.Middleware transmits the TicketBAI files as part of the *LROE* (modelo 240); the remaining LROE chapters are not filed by the fiskaltrust.Middleware. Ask fiskaltrust about the available exports for your accountant.
