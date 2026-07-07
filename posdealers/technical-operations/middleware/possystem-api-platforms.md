---
slug: /posdealers/technical-operations/middleware/possystem-api-platforms
title: PosSystem API Platforms
---

# PosSystem API Platforms

The PosSystem API can be used as a cloud hosted service or run locally inside of a CashBox.

Each option has it's own usecases.

## Cloud PosSystem API

The Cloud hosted PosSystem API currently only works with the CloudCashbox.
It provides a fully manages solution and supports the full range of features the PosSystem API has to offer.

*This works with a normal CloudCashbox. No special setup is needed. The cloud possystem api is reachable at https://possystem-api-sandbox.fiskaltrust.eu for sandbox or https://possystem-api.fiskaltrust.eu for production.*

## Local PosSystem API

The local possystem api works offline or online and runs inside your CashBox next to your queue.

Currently only the `Echo`, `Sign` and `Journal` endpoints are supported when offline.

*The `LocalPosSystemApi` Helper has to be configured in the cashbox for the PosSystem API to be available locally.*

### Android

The full Local PosSystem API experience is also provided on android through our android launcher (currently in preview).

*No special configuration is needed. Communication works through [android intents](../../../poscreators/possystem-api/android-intent)*


## Setup Guides

We've prepared some getting started guides for the local possystem api/android launcher/cloudcashbox.
Depending on your market and mode of operation please choose the correct setup from the table below.

|             | AT                                                           | FR                                                       | DE                                                           | IT                                                           | GR, PT, ES, BE                                           |
|-------------|--------------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------|--------------------------------------------------------------|----------------------------------------------------------|
| **Local**   | [1.3 CashBox Setup](./localpossystemapi-helper.md)           | [1.2 CashBox Setup](./localpossystemapi-helper-1-2.md)   | [1.3 CashBox Setup](./localpossystemapi-helper.md)           | [1.3 CashBox Setup](./localpossystemapi-helper.md)           | Currently not available                                  |
| **Android** | [Android](../../../poscreators/possystem-api/android-intent) | Currently not available                                  | [Android](../../../poscreators/possystem-api/android-intent) | [Android](../../../poscreators/possystem-api/android-intent) | Currently not available                                  |
| **Cloud**   | [CloudCashbox](./launchers/cloudcashbox.md#introduction)     | [CloudCashbox](./launchers/cloudcashbox.md#introduction) | [CloudCashbox](./launchers/cloudcashbox.md#introduction)     | [CloudCashbox](./launchers/cloudcashbox.md#introduction)     | [CloudCashbox](./launchers/cloudcashbox.md#introduction) |


### Middleware 1.2 setups

:::info

Relevant only for the FR market aswell as for existing AT Queues.

We're working on unifying these two markets with the others.

:::

The setup of the LocalPosSystemAPI helper is a bit more involved for the middleware 1.2.

This is relevant for all local installations in the FR market and for existing 1.2 installations in the AT market.

:::tip

When starting a new implementation in the AT market it's already possible to use the 1.3 Middleware as per the table above.

:::

|           | AT, FR                                                 |
|-----------|--------------------------------------------------------|
| **Local** | [1.2 CashBox Setup](./localpossystemapi-helper-1-2.md) |

