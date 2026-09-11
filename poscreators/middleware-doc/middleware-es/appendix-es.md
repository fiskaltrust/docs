---
slug: /poscreators/middleware-doc/spain
title: Introduction
---

# Appendix: Spain

This appendix expands on the General Part's information by adding details specific to the Spanish market. This additional information is provided only where applicable. The remaining chapters, for which there is no further information required, were omitted.

:::caution

Please note that this information is only complete when combined with the **General** part. To implement the Middleware, users should get themselves familiar with the general information first and then refer to the country-specific details listed here.

:::

## Declared and registered invoicing system

Spain has two fiscal frameworks: in the common territory every *Sistema Informático de Facturación* must comply with the VERI\*FACTU regulation (*Real Decreto 1007/2023*, *Orden HAC/1177/2024*), and the producer certifies this in a signed *declaración responsable*; in the Basque provinces of Araba, Bizkaia and Gipuzkoa the software is registered with a provincial tax authority under **TicketBAI**. The fiskaltrust.Middleware for Cloud implements both: fiskaltrust has declared the Middleware towards the AEAT and has submitted its TicketBAI software registration. The [Declaration and Registration](./declaration/declaration.md) chapter describes what this covers, which document types are issued, where the identifiers appear on the document and where the boundaries of the implementation are. The [Receipt Printing](./receipt-printing/receipt-printing.md) chapter lists the mandatory elements of the printed or digital document.

PosCreators can enter the Spanish market either under fiskaltrust's declaration and registration or by declaring and registering their own solution built on the fiskaltrust.Middleware. The [Go-to-Market](./go-to-market/go-to-market.md) chapter compares the two routes and summarises the key factors of the market; for the second route fiskaltrust is looking for a first partner (contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu)).
