---
slug: /posdealers/technical-operations/possystem-api-platforms/overview
title: Overview
---

# Overview 

The PosSystem API can be used as a cloud-hosted service or can run locally inside a CashBox. Each option has its own use cases.

## Cloud PosSystem API

The cloud-hosted PosSystem API currently works only with the CloudCashbox.
It provides a fully managed solution and supports the full range of PosSystem API features.

:::info

This works with a normal CloudCashbox. No additional configuration is required. The Cloud PosSystem API is available for [Sandbox](https://possystem-api-sandbox.fiskaltrust.eu) and [Production](https://possystem-api.fiskaltrust.eu).

:::

## Local PosSystem API

The Local PosSystem API works both online and offline and runs inside your CashBox alongside the Queue.

Currently, only the `Echo`, `Sign`, and `Journal` endpoints are supported while offline.

:::info

The `LocalPosSystemApi` Helper must be configured in the CashBox for the PosSystem API to be available locally.

:::

### Android

The full Local PosSystem API experience is also provided on Android through our Android launcher (currently in preview).

:::info

No additional configuration is required. Communication is handled through the [Android Intent Integration](../../../poscreators/possystem-api/android-intent).

:::


## Setup Guides

We've prepared a set of getting started guides for the Local PosSystem API, Android launcher, and CloudCashBox.
Depending on your market and mode of operation, choose the correct setup from the following table.

| | AT | FR | DE | IT | GR, PT, ES, BE |
|-|----|----|----|----|----------------|
| **Local** | [1.3 CashBox Setup](./localpossystemapi-helper.md) | [1.2 CashBox Setup](./localpossystemapi-helper-1-2.md) | [1.3 CashBox Setup](./localpossystemapi-helper.md) | [1.3 CashBox Setup](./localpossystemapi-helper.md) | Currently not available |
| **Android** | [Android](../../../poscreators/possystem-api/android-intent) | Currently not available | [Android](../../../poscreators/possystem-api/android-intent) | [Android](../../../poscreators/possystem-api/android-intent) | Currently not available |
| **Cloud** | [CloudCashbox](../middleware/launchers/cloudcashbox.md#introduction) | [CloudCashbox](../middleware/launchers/cloudcashbox.md#introduction) | [CloudCashbox](../middleware/launchers/cloudcashbox.md#introduction) | [CloudCashbox](../middleware/launchers/cloudcashbox.md#introduction) | [CloudCashbox](../middleware/launchers/cloudcashbox.md#introduction) |


### Middleware 1.2 Setups

:::info

Relevant only for the FR market and  existing AT Queues.

We're working on unifying these two markets with the others.

:::

Setting up the LocalPosSystemApi Helper is slightly more involved when using Middleware 1.2.

This is relevant for all local installations in the FR market and for existing 1.2 installations in the AT market.

:::tip

When starting a new implementation in the AT market, you can already use Middleware 1.3, as shown in the previous table.

:::

| | AT, FR |
|-|--------|
| **Local** | [1.2 CashBox Setup](./localpossystemapi-helper-1-2.md) |
