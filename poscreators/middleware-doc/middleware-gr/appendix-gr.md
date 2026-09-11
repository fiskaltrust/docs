---
slug: /poscreators/middleware-doc/greece
title: Introduction
---

# Appendix: Greece

This appendix expands on the General Part's information by adding details specific to the Greek market. This additional information is provided only where applicable. The remaining chapters, for which there is no further information required, were omitted.

:::caution

Please note that this information is only complete when combined with the **General** part. To implement the Middleware, users should get themselves familiar with the general information first and then refer to the country-specific details listed here.

:::

## Licensed e-invoicing provider

In Greece, documents are transmitted in real time to AADE's myDATA platform, either through a certified fiscal device or through a licensed electronic invoicing provider. The fiskaltrust.Middleware for Cloud implements the provider flow and currently issues Greek documents under the AADE provider licence of its partner Viva (provider ID 126). The [Licensing](./licensing/licensing.md) chapter describes what this covers, which myDATA document types are issued, where the identifiers appear on the document and where the boundaries of the implementation are. The [Receipt Printing](./receipt-printing/receipt-printing.md) chapter lists the mandatory elements of the printed or digital receipt.

PosCreators can enter the Greek market either through the fiskaltrust.Middleware for Cloud or by obtaining their own provider licence on top of the fiskaltrust.Middleware. The [Go-to-Market](./go-to-market/go-to-market.md) chapter compares the two routes and summarises the key factors of the market.
