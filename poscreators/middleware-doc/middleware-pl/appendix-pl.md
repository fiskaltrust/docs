---
slug: /poscreators/middleware-doc/poland
title: Introduction
---

# Appendix: Poland

This appendix expands on the General Part's information by adding details specific to the Polish market. This additional information is provided only where applicable. The remaining chapters, for which there is no further information required, were omitted.

:::caution

Please note that this information is only complete when combined with the **General** part. To implement the Middleware, users should get themselves familiar with the general information first and then refer to the country-specific details listed here.

:::

:::info Preview

Support for the Polish market is currently in preview. Details on this page may change until the first general-availability release.

:::

## Market model at a glance

Polish fiscalization is built around the **certified cash register** (kasa rejestrująca): sales to natural persons must be recorded on an online cash register (kasa online) or a certified software register (kasa wirtualna), which reports to the Central Repository of Cash Registers (Centralne Repozytorium Kas, CRK) operated by the tax administration. The register — not the middleware — owns receipt numbering, the PTU (VAT) rate table, daily (Z) reports, and the CRK transmission.

Key differences from other fiskaltrust markets:

- **The register is the security mechanism.** The Middleware validates and forwards receipts to the certified register through the SCU; there is no middleware-side signing comparable to the German TSE or French chaining.
- **Invoices are fiscalized via KSeF, not via the register.** Invoice receipt cases (`0x1xxx`) are persisted by the Middleware and marked *"Stored, not fiscalized"* until a KSeF SCU is configured; they are never sent to the cash register.
- **PLN is mandatory.** The queue currency for Poland is PLN. Every receipt and every charge/pay item must carry the currency `PLN` explicitly (the data format defaults to EUR).
- **A non-working register means no sale.** Under Art. 111(3) of the Polish VAT Act, sales must not continue without a working register. When the register is unreachable, the Middleware responds with the dedicated state `0x504C_2001_EEEE_EEEE` so the POS can stop selling (see [Service Status: ftState](reference-tables/service-status-ftstate.md)).
