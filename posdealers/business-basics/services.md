---
slug: /posdealers/business-basics/services
title: Services
description: fiskaltrust product portfolio for PosDealers — Middleware, Portal, revision-safe receipt archive, exports, hosted Middleware and signing.
tags: [Services, Middleware, Portal, Signature, PosDealers]
---
# Services

:::info summary

After reading this, you can explain what kind of products fiskaltrust offers.

:::

fiskaltrust offers an end-to-end solution that makes your POS system issue receipts in a legally and fiscally compliant way. The portfolio is a stack of software and services for **fiscal compliance** with a **unified approach** across countries and markets.

| Service | Purpose | Type |
|---|---|---|
| [Middleware](#middleware) | Signs and tracks receipts | Core component |
| [Portal](#portal) | Manages the service | Core component |
| [Revision-Safe Receipt Archive](#revision-safe-receipt-archive) | Stores receipts tamper-proof; enables exports and third-party interfaces | Optional, chargeable add-on |
| [Hosted Middleware](#hosted-middleware) | Runs the Middleware as [SaaS](https://en.wikipedia.org/wiki/Software_as_a_service) | Available in some countries |
| [Signing](#signing) | Provides the receipt signature required by national regulations | Subscription, where applicable |

*Table 1. Overview of fiskaltrust services.*

## Middleware

The fiskaltrust.Middleware is a **multi-platform** software that complements your POS system. It:

* **Signs POS receipts** using the signing mechanisms required in each country.
* **Tracks receipts** in a secure and auditable way.
* Keeps the related fiskaltrust.Portal information up to date.

The Middleware is available for all supported countries. It provides a **single, standardized communication interface**, which simplifies rollouts in new markets. Your POS system communicates with it via **gRPC, REST or SOAP (WCF)**.

| Deployment | Platforms |
|---|---|
| On-premise | Platforms supporting **.NET** and **Android** |
| Off-premise | SaaS; see [Hosted Middleware](#hosted-middleware) |

*Table 2. Deployment options of the fiskaltrust.Middleware.*

:::info Middleware versions

Austria and France continue to use Middleware version 1.2. A unified version for all markets is in development.

:::

For the Middleware components, see [Architecture](architecture.md).

## Portal

The fiskaltrust.Portal is the web-based management tool for the entire fiskaltrust stack. Use it to manage your account, configure your Middleware instances, download deployment packages, and access and process your business data. For more information, see [Management Portal](management-portal.md).

## Revision-Safe Receipt Archive

The **archive service** is an optional, chargeable add-on that enables archive functions in your Middleware instance.

* After you activate the archive service, the Middleware saves new receipts in the archive, which persists them in a **secure, tamper-proof receipt chain**.
* You can **retrieve and export** the receipt chain via the fiskaltrust.Portal at any time, for example for a tax audit.
* The archive stores receipts **as long as national regulations require**.

For more information, see [Revision-safe archiving](../buy-resell/products/revision-safe-archiving.md).

### Exports & third-party Interfaces

With an active archive service, you can export your data in the fiskaltrust.Portal in the **formats** required by the applicable national regulations. In `Tools` > `Exports`, you select the export type, the range by receipt date or number, and the `Export target`, for example `Azure Storage` or `DATEV MeinFiskal`. For more information, see [Exports](../technical-operations/maintenance/exports.md).

The fiskaltrust.Portal also connects to third-party services, for example DATEV MeinFiskal or FinanzOnline management (Austria only). Availability depends on the country, and some services require an additional subscription. For more information, see [Third party integrations](../buy-resell/products/3rd-party/3rd-party-overview.md).

## Hosted Middleware

In some countries, fiskaltrust offers the Middleware as SaaS. Your POS system signs and manages receipts **without installing or maintaining additional software**:

* The POS system connects to the fiskaltrust-hosted Middleware over an encrypted **HTTPS** Internet connection.
* You manage these setups exclusively in the fiskaltrust.Portal.

For more information, see [CloudCashbox](../technical-operations/middleware/launchers/cloudcashbox.md).

:::info Service Availability

Service availability is subject to national requirements and restrictions in each market.

:::

## Signing

Where applicable, fiskaltrust offers **signing services** as a backend for the Middleware. They provide the receipt signature data blocks required by national regulations. Signing services are subscription-based and come as either:

* leased hardware dongles ([SSCDs](https://en.wikipedia.org/wiki/Secure_signature_creation_device)), or
* access to SaaS platforms.

For more information, see [Signing devices and services](../buy-resell/products/signing/signing-overview.md).

:::info Service Availability

Service availability is subject to national requirements and restrictions in each market.

:::
