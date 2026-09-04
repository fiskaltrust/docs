---
slug: /poscreators/middleware-doc/greece
title: Introduction
---

# Appendix: Greece

This appendix expands on the General Part's information by adding details specific to the Greek market. This additional information is provided only where applicable. The remaining chapters, for which there is no further information required, were omitted.

## How fiscalization works in Greece

Greek fiscalization runs through **myDATA** (*my Digital Accounting and Tax Application*), the platform of the Greek tax authority **AADE**. Every invoice and receipt is transmitted to myDATA, which validates it, registers it, and returns a unique registration number — the **MARK**.

Two consequences shape an integration in Greece:

- **There is no fiscal device.** Unlike Germany or Austria, no signature card, box, or TSE is involved. The Signature Creation Unit is a connector to the myDATA REST API, so fiscalization depends on an online call to AADE rather than on local hardware.
- **Every document has a type and, where no VAT is charged, a reason.** myDATA expects a document type (a sales invoice, a retail receipt, a delivery note, and so on) and, on lines without VAT, the legal ground for the exemption. Both are derived from the tagging system described in the [Reference Tables](reference-tables/reference-tables.md).

## Where to start

| Chapter | What it covers |
|---|---|
| [Terminology](terminology/terminology.md) | The myDATA vocabulary — AADE, MARK, document types, VAT categories, and the transport documents |
| [Cash Register Integration](cash-register-integration/cash-register-integration.md) | Greek specifics of the integration flow |
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
