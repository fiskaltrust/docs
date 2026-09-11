---
slug: /poscreators/middleware-doc/greece
title: Introduction
---

# Appendix: Greece

This appendix expands on the General Part's information by adding details specific to the Greek market. This additional information is provided only where applicable. The remaining chapters, for which there is no further information required, were omitted.

## How fiscalization works in Greece

Greek fiscalization runs through **myDATA** (*my Digital Accounting and Tax Application*), the platform of the Greek tax authority **AADE**. Every invoice and receipt is transmitted to myDATA, which validates it, registers it, and returns a unique registration number — the **MARK**.

The following points shape an integration in Greece:

- **Two issuance models coexist in Greece.** Retail has traditionally used hardware fiscal devices (ΦΗΜ — fiscal printers / tax mechanisms), which remain in use and must interconnect with POS card terminals. On top of this, myDATA is the mandatory reporting layer: whether a document originates from a hardware fiscal printer or from a software solution, it is transmitted to AADE and stamped with a MARK.
- **The fiskaltrust Middleware follows the software model.** Our Signature Creation Unit is a connector to the myDATA REST API — no signature card, box, or TSE is involved, unlike Germany or Austria. Fiscalization therefore depends on an online call to AADE rather than on local hardware. See [Cash Register Integration](cash-register-integration/cash-register-integration.md) for how this relates to fiscal printers and the POS-interconnection mandate.
- **Every document has a type and, where no VAT is charged, a reason.** myDATA expects a document type (a sales invoice, a retail receipt, a delivery note, and so on) and, on lines without VAT, the legal ground for the exemption. Both are derived from the tagging system described in the [Reference Tables](reference-tables/reference-tables.md).

## Licensed e-invoicing provider

The fiskaltrust.Middleware for Cloud implements the provider model and currently issues Greek documents under the AADE e-invoicing provider licence of its partner Viva (provider ID 126). The [Licensing](./licensing/licensing.md) chapter describes what this covers, which myDATA document types are issued, where the identifiers appear on the document and where the boundaries of the implementation are. The [Receipt Printing](./receipt-printing/receipt-printing.md) chapter lists the mandatory elements of the printed or digital receipt.

Documents can reach myDATA on two routes: through a licensed provider, which is what the fiskaltrust.Middleware for Cloud does today, or through the myDATA ERP API under the merchant's own credentials, which is planned for the Middleware. The [Go-to-Market](./go-to-market/go-to-market.md) chapter compares the two routes and summarises the key factors of the market.

## Where to start

| Chapter | What it covers |
|---|---|
| [Go-to-Market](go-to-market/go-to-market.md) | The two routes into the Greek market and the key factors of the market |
| [Licensing](licensing/licensing.md) | The provider licence the Middleware operates under, the supported myDATA document types and the boundaries |
| [Terminology](terminology/terminology.md) | The myDATA vocabulary — AADE, MARK, document types, VAT categories, and the transport documents |
| [Cash Register Integration](cash-register-integration/cash-register-integration.md) | Greek specifics of the integration flow |
| [Receipt Printing](receipt-printing/receipt-printing.md) | Mandatory content of the receipt and the signature items that carry it |
| [Data Structures](data-structures/data-structures.md) | Greek fields of the request and response structures |
| [Receipt Case Definitions](receipt-case-definitions/receipt-case-definitions.md) | Greek business cases and how to express them |
| [Reference Tables](reference-tables/reference-tables.md) | The Greek values for `ftReceiptCase`, `ftChargeItemCase`, `ftPayItemCase` and the signature and journal types |

*Table 1. Greek market chapters of this appendix.*

## Further information

- [myDATA overview](https://www.aade.gr/en/mydata) — AADE, in English
- [myDATA technical specifications](https://www.aade.gr/en/mydata/technical-specifications-versions-mydata) — the REST API documentation and the reference-table appendices this chapter maps onto

:::caution

Please note that this information is only complete when combined with the **General** part. To implement the Middleware, users should get themselves familiar with the general information first and then refer to the country-specific details listed here.

:::
