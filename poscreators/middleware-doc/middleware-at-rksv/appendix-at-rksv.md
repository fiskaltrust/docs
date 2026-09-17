---
slug: /poscreators/middleware-doc/austria
title: Introduction
---

# Introduction

This section expands on the [General Part](../general/general.md) with the information that is specific to the Austrian market (RKSV). It is only complete in combination with the General Part: get familiar with the general information first, then use the Austrian pages for the country-specific details. Chapters that need no Austrian specifics are omitted here.

## What is required for the Austrian market

Austria requires a POS system to fulfil three obligations. The fiskaltrust.Middleware covers all three; the pages linked below hold the details.

### Signing cash transactions

Every cash transaction must be recorded by a cash register with a tamper protection device that signs each transaction with a signature creation device and chains it to the previous receipt, so that the receipt chain cannot be changed afterwards (§131b Abs 2 BAO, §§9 and 10 RKSV); the requirements for the signature creation device itself are laid down in §§12 to 14 RKSV. In the Middleware, the Queue records and chains the receipts and the Signature Creation Unit (SCU) drives the signature creation device (SSCD).

See [Operation Modes](operation-modes/operation-modes.md) for the components and the supported signature creation devices, and [Cash Register Integration](cash-register-integration/cash-register-integration.md) for the receipt workflows, including the zero-amount receipts the RKSV requires (start, monthly, annual, end-of-failure and stop receipt) and the handling of signature creation device failures.

### Data collection log and exports (DEP-7)

Every cash register must keep a data collection log (RKSV-DEP, also referred to as DEP-7 after §7 RKSV) of all cash transactions and be able to export it in the export format defined in the annex to the RKSV. In the Middleware the fiskaltrust.SecurityMechanism manages this log, and the fiskaltrust.Journal extracts it.

See [Data Collection Log](cash-register-integration/cash-register-integration.md#data-collection-log) for the two logs kept in Austria (RKSV-DEP and E131-DEP) and [RKSV-DEP Export](function-structures/function-structures.md#rksv-dep-export) for the corresponding journal call. Records must be retained for seven years (§132 BAO); creating exports in the fiskaltrust.Portal is described in [Exports](../../../posdealers/technical-operations/maintenance/exports.md), and the cloud-based storage options in [Revision-safe archiving](../../../posdealers/buy-resell/products/revision-safe-archiving.md).

### FinanzOnline registration

The signature creation unit and the cash register must be registered with the tax authority through [FinanzOnline](https://finanzonline.bmf.gv.at/), together with the user key used to encrypt the cumulative sales counter (§16 RKSV), and immediately after the registration the start receipt must be used to check the signature creation and the encryption of the cumulative sales counter (§6 Abs 4 RKSV). This is done by the PosOperator or the PosDealer in the fiskaltrust.Portal, not by the POS system - see [FinanzOnline Management](../../../posdealers/buy-resell/products/3rd-party/finanzonline-management.md).

## Where to start

1. [Terminology](terminology/terminology.md) - the Austrian terms and abbreviations used throughout these pages.
2. [Operation Modes](operation-modes/operation-modes.md) - the Middleware components, the signature creation devices and the configuration scenarios to choose from.
3. [Installation](installation/installation.md) - installing the chosen signature creation device.
4. [Cash Register Integration](cash-register-integration/cash-register-integration.md) - the receipt workflows, special receipts, receipt structure and data collection log your POS system has to implement.

The remaining Austrian pages - [Data Structures](data-structures/data-structures.md), [Function Structures](function-structures/function-structures.md), [Communication](communication/communication.md), [Receipt Case Definitions](receipt-case-definitions/receipt-case-definitions.md) and [Reference Tables](reference-tables/reference-tables.md) - are references to use while implementing.

:::info Upgrading to PosSystem API (v2)

New features such as eInvoicing are available exclusively through the **PosSystem API (v2)**. If you are currently using the v0 interface (WCF/REST), see the [Migrating from API v0 to PosSystem API (v2)](../possystem-api/migration-guide.md) guide.

:::

## Legal sources and further reading

- [Registrierkassensicherheitsverordnung (RKSV)](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=20009390) - German version in the Austrian legal information system (RIS).
- [Bundesabgabenordnung (BAO)](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=10003940) - German version in the RIS.
- [Security device in cash registers](https://www.bmf.gv.at/en/topics/taxation/cash-register/security-device-in-cash-registers.html) - the Federal Ministry of Finance (BMF) explanation, in English, of how the security device signs and chains cash transactions and how the machine-readable code on the receipt is formed.
- Ritz/Koran/Kutschera/Knasmüller, [Handbuch Registrierkassen- und Belegerteilungspflicht](https://www.lindeverlag.at/onlineprodukt/handbuch-registrierkassen-und-belegerteilungspflicht-2989), 2. Auflage 2019, Linde Verlag Wien. ISBN: 9783707335910.
