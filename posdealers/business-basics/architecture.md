---
slug: /posdealers/business-basics/architecture
title: Architecture
description: The three-tier fiskaltrust setup of POS system, Middleware, and Portal, and the roles of CashBox, launcher, Queue, SCU, and helpers.
tags: [Architecture, Middleware, Queue, SCU, CashBox, PosDealers]
---

# Architecture

:::info summary

After reading this, you can explain the basic architecture of the fiskaltrust.Middleware and the purpose of a Queue, an SCU, a CashBox and a Launcher.

:::

A fiskaltrust setup consists of three tiers:

1. **Your POS system**
2. **fiskaltrust.Middleware**, which runs your **CashBox** and provides the service
3. **fiskaltrust.Portal**, which manages your setup

![Diagram: the POS system connects to the fiskaltrust.Middleware via the IPOS interface; the Middleware runs Queue, SCU and optional Helpers and connects to the fiskaltrust.Portal](./images/architecture.svg)

*Figure 1. The three tiers of a fiskaltrust setup: POS system, fiskaltrust.Middleware and fiskaltrust.Portal.*

The fiskaltrust.Middleware is the autonomous service that provides the **core fiscalization functionality**:

* Your POS system connects to the Middleware to **sign and persist its receipts**.
* The Middleware uploads its receipt chain to fiskaltrust.
* The Launcher fetches the CashBox configuration you set in the fiskaltrust.Portal each time the Middleware starts. Configuration changes take effect after a restart.

| Component | Purpose |
|---|---|
| [Portal](#portal) | Management hub for accounts, CashBoxes and updates |
| [CashBox](#cashbox) | Configuration set of a Middleware instance |
| [Launcher](#launcher) | Bootstraps the Middleware instance |
| [Queue](#queue) | Communication interface, receipt datastore and signing requests |
| [SCU](#scu) | Creates the legally compliant receipt signature |
| [Helpers](#helpers) | Additional components, for example data upload to fiskaltrust |

*Table 1. Components of a fiskaltrust setup.*

## Portal

The fiskaltrust.Portal is the central **management hub**. In it, you:

* Control your fiskaltrust account and, subject to their authorization, the accounts of your associated PosOperators.
* Set up and update your Middleware instances (**CashBoxes**).

The **Middleware** fetches the CashBox configuration you set in the Portal and uploads its receipt chain to fiskaltrust.

:::info

fiskaltrust operates a Portal in each country at `https://portal.fiskaltrust.[CCTLD]`. For more information, see [Countries](countries.md).

:::

## CashBox

The CashBox is the **configuration set** of a Middleware instance. It contains all details the Middleware needs to run.

* You **configure CashBoxes in the fiskaltrust.Portal**.
* The Launcher fetches the latest CashBox configuration on each start. If the download fails, it uses the locally cached configuration.
* Configuration changes take effect after the Middleware restarts.

For more information, see [CashBox](../technical-operations/middleware/cashbox.md).

## Middleware

The Middleware is the **fiskaltrust service** your POS system uses directly. It is modular: you combine components in a Middleware instance (**CashBox**) to fit your setup and requirements.

### Launcher

The Launcher is the bootstrap component of a Middleware instance. On start, it:

1. Downloads the **latest CashBox configuration**.
2. Downloads the required **packages** and **updates itself** if a new version is available.
3. **Starts** the configured components.

| Launcher | Use case |
|---|---|
| [Desktop Launchers](../technical-operations/middleware/launchers/desktop.md) | On-premise installation on Windows, Linux and macOS |
| [Android Launcher](../technical-operations/middleware/launchers/android.md) | On-premise installation on Android |
| [Custom data center (Helm chart)](../technical-operations/middleware/launchers/custom-data-center.md) | Germany: **Bring your own data center** product, in Kubernetes clusters |

*Table 2. Launcher types.*

:::info Middleware and Launcher versions

* Austria and France continue to use Middleware version 1.2. A unified version for all markets is in development.
* The desktop Launcher 2.0 is a release candidate. A migration path from Launcher 1.3 is described in the [middleware-launcher repository](https://github.com/fiskaltrust/middleware-launcher).

:::

Wherever legally possible, fiskaltrust also offers a fully cloud-based, hosted Middleware. For more information, see [CloudCashbox](../technical-operations/middleware/launchers/cloudcashbox.md).

### Queue

The Queue is the **central component** of your fiskaltrust setup. It:

* Provides the **communication interface** (gRPC, REST or SOAP) for your POS system.
* Manages the **receipt datastore**.
* Handles the signing requests from your POS system.

### SCU

The **Signature Creation Unit** (SCU) supports the Queue. It provides the Queue with the **legally compliant receipt signature** required by national regulations.

:::info

Depending on your market's regulations, the SCU may require an additional [SSCD](https://en.wikipedia.org/wiki/Secure_signature_creation_device). Typically, an externally attached hardware dongle or a third-party SaaS platform provides the signature to the SCU.

:::

### Helpers

Depending on the use case, you can configure helper components in addition to Queues and SCUs. The **Helipad** helper is deployed by default and uploads the Middleware's Queue and SCU data to fiskaltrust. For more information, see [Helper](../technical-operations/middleware/helper.md).
