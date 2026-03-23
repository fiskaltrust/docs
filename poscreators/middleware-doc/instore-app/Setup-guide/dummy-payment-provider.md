---
slug: /poscreators/middleware-doc/instore-app/setup-guide/dummy-payment-provider
title: Dummy Payment Provider (Developer Mode)
---

# Dummy Payment Provider for Simplified Integration (InStore App Developer Mode)

:::info Important

This feature is available with InStore App v1.2.8-rc1 and later.

:::

The InStore App supports a developer mode. When enabled, a hidden **Dummy Payment Provider** can be configured, allowing easy integration and testing of different payment success and error scenarios without requiring access to a real payment provider. To enable the developer mode in the InStore App, complete the following steps:

1. Start the InStore App and navigate to the home screen.
2. At the bottom of the screen, tap the **fiskaltrust** logo five times to open the Developer Mode PIN entry dialog.
3. Enter the PIN: `4242`.
4. If successful, an information dialog will appear confirming that Developer Mode is enabled. Tap OK to close the dialog. The app will then exit automatically.

## Configuring the Dummy Payment Provider

1. Restart the InStore App.
2. Open **Settings** and navigate to the **Payment settings** section.
3. Tap **Payment entry** (the first item in **Payment Settings**) and select the **Dummy Payment Provider**, which is now visible because the developer mode is active.

## Using the Dummy Payment Provider

When executing a payment action with the `use_auto` or `test` protocol, payments will be processed by the Dummy Payment Provider, which is visible via the payment progress screen that appears when starting a payment action.

Any payment amount will return a SUCCESS response, except for the following defined special amounts:

| **Payment request** | **Result**      |
|---------------------|-----------------|
| 30000,10 | DECLINED |
| 30000,20 | TIMEOUT (returned as an error message as no other option is available yet) |
| 30000,40 | CANCELLED BY USER |
| 30000,50 | SUCCESS with added guest tip (see [HOWTO_01_Payment](https://github.com/fiskaltrust/possystemapi-devkit/blob/main/HOWTO_01_Payment_csharp/README.MD) for instructions on handling tips) |
| 30000,60 | SUCCESS after 1-minute delay |
| 30000,70 | SUCCESS after 3-minute delay |
| 30000,80 | SUCCESS after 6-minute delay |
| 30000,90 | SUCCESS, but only 15000,50 will be approved |

For more information, see the [fiskaltrust POS System API - Development Kit](https://github.com/fiskaltrust/possystemapi-devkit/blob/main/README.MD).
