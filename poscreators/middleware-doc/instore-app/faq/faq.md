---
slug: /poscreators/middleware-doc/instore-app/faq
title: FAQ
---

# Frequently Asked Questions (FAQ)

This page collects the questions that come up most often when partners evaluate, demo, or roll out the fiskaltrust InStore App. It is intended for PosCreators, PosDealers, and fiskaltrust customer success teams. For step-by-step instructions, follow the links to the detailed guides in each answer.

## Onboarding and Setup

**Q: How does the setup of the InStore App work, step by step?**

A: The setup consists of three parts: installing the app, pairing it with a CashBox, and configuring the device.

1. **Install the app** on the Android device. Use the [installation guides](../installation-guides/installation-guides.md) for a manual APK install (stable or preview channel), the Google Play Store, or a partner device-management portal such as Orderman SystemCenterNext, the Sunmi Partner Portal, or the PAX stores.
2. **Start the app and grant permissions**. Enable **Display over other apps** when prompted, and allow Bluetooth if a Bluetooth printer is used.
3. **Pair the app with a CashBox**. In the fiskaltrust.Portal (sandbox or production), open **Configuration** > **CashBox**, select the CashBox, and generate a **PIN for InStore App**. The PIN is valid for five minutes. Enter it in the app and tap **Pair**. See [Getting Started](../Setup-guide/setup.md) and [Pairing InStore App](../introduction/introduction.md#pairing-instore-app).
4. **Configure the device** in the app settings: choose the [Operation Mode](../available-settings/settings.md#operation-mode) (Consumer or Merchant), set a [Terminal ID Filter](../available-settings/settings.md#terminal-id-filter) when more than one device is connected to the CashBox, enable [running in the background](../available-settings/settings.md#enable-running-in-background) (mandatory on Android 15 and later), and set up the [printer](../printer-guide/printer.md) and the [payment provider](../available-settings/settings.md#payment-settings) if needed.
5. **Test**. Use **Print Demo** and **Test Communication** in the settings, and, in a sandbox, the [Dummy Payment Provider](../Setup-guide/dummy-payment-provider.md) to run payments without a real payment provider.

Once paired, the app listens to the CashBox and displays receipts or starts payments as soon as the POS system triggers them. See the [Available Settings](../available-settings/settings.md) page for all options.

**Q: What are the prerequisites for using the InStore App on a device?**

A: The following must be in place:

- An **Android device** with a touchscreen. An integrated or connected receipt printer is recommended for Consumer mode, but not required.
- A **permanent and stable internet connection**. The app receives its actions (show receipt, start payment) via push from the fiskaltrust backend.
- A **CashBox in the fiskaltrust.Portal** to pair with. For development and demos, use a sandbox CashBox. For the cloud-hosted POS System API, a Cloud CashBox is used; for local setups, the CashBox needs the corresponding helper (see [PosSystem API Platforms](../../../../posdealers/technical-operations/possystem-api-platforms/overview.md)).
- The **Display over other apps** permission, and Bluetooth for Bluetooth printers.
- Optionally, an **account with a supported payment provider** and, for software-based payment (SoftPOS), the provider's payment app installed on the same device.
- For digital receipts, **complete master data** in the fiskaltrust.Portal (outlet address and optional logo), as described in [Digital Receipt preparations](../../../../posdealers/buy-resell/products/digital-receipt.md).

**Q: Which devices are supported?**

A: The InStore App runs on Android devices. It is designed for touch-enabled devices with an integrated thermal printer, but it also works with external printers via Bluetooth, USB, or ESC/POS network printing. Devices in common use include:

- **Sunmi** Android POS devices (deployable via the Sunmi Partner Portal).
- **Orderman** Android devices such as the Orderman10 (deployable via Orderman SystemCenterNext).
- **PAX** payment terminals such as the A920Pro or A800 (deployable via the PAX, Viva Wallet, or Global Payments stores).
- Generic Android tablets and smartphones, for example as a customer display next to a stationary POS or as a waiter's handheld running both the POS app and the InStore App.

Some payment providers also expose the terminal's integrated printer to the app (for example Shift4). On Android 15 and later, **Enable running in Background** must be switched on. If you plan to use a specific device model, contact fiskaltrust support to confirm printer and payment provider support for that model.

## POS Integration

**Q: Which requirements must a POS system meet to use the InStore App?**

A: The POS system needs to be able to send HTTP/JSON requests to the [fiskaltrust POS System API](../../possystem-api/introduction.md) (v2). Every request carries the CashBox credentials from the fiskaltrust.Portal as headers (`x-cashbox-id`, `x-cashbox-accesstoken`, `x-possystem-id`) and a unique `x-operation-id` per operation so calls can be safely retried. The POS system should also be able to set a terminal identification (`cbTerminalID`) so that requests reach the right device in [multi-terminal setups](../multiterminal-settings/multiterminal.md).

No SDK, no device-side integration, and no direct network connection between the POS and the InStore App are needed. The app is paired with the CashBox and receives its actions from the fiskaltrust backend.

**Q: Is a connection to the fiskaltrust POS System API sufficient?**

A: Yes. All InStore App functionality is triggered through the POS System API: `/pay` starts a payment on the device, `/sign` fiscalizes the receipt, and `/issue` hands the signed receipt over to the InStore App for display, printing, or digital delivery. Which of these you use depends on the features you want (see [For Developers](#for-developers)).

For POS systems that are still integrated with the classic Middleware interface (`/sign` via IPOS v0 or the SignatureCloud API), receipts can also be shown in the InStore App without any POS change by activating the **POS API Helper** on the CashBox. See [Existing fiskaltrust Integrations](#existing-fiskaltrust-integrations) for the trade-offs.

**Q: Is fiscalization through fiskaltrust required, or can the InStore App be used without it?**

A: It depends on the feature:

- **Payment** can be used with or without fiskaltrust fiscalization. The `/pay` endpoint works independently of `/sign`, so a POS system can use the InStore App as its payment layer even in markets or setups where fiscalization is handled elsewhere. See [Payment](../../experience-middleware/payment.md).
- **Receipt display and digital receipts** always require the receipt to pass through the fiskaltrust.Middleware. The `/issue` endpoint takes the request and response pair returned by `/sign`, and the receipt document is rendered from that data. A standalone digital receipt API without a Middleware receipt is not available. In markets or business cases without a fiscalization obligation, the POS system still sends the receipt through `/sign` using the corresponding non-fiscal receipt case so the Middleware journals it and can issue it.

**Q: How much integration effort is required for a POS system that is already connected?**

A: This depends on the current integration:

- **Already on the POS System API (v2)**: Low effort. Add `/issue` after `/sign` to show receipts on the InStore App, and `/pay` before `/sign` to process payments. Pass the same `cbTerminalID` on all calls and reuse the `ftPayItems` returned by `/pay` as `cbPayItems` in `/sign`. The [Development Kit](https://github.com/fiskaltrust/possystemapi-devkit/blob/main/README.MD) provides C# samples for exactly this flow.
- **On the classic IPOS v0 or SignatureCloud interface**: Two options. Either activate the POS API Helper in the fiskaltrust.Portal to show receipts without any code change (no payment, no delivery status logging), or migrate to the POS System API v2 following the [Migration Guide](../../possystem-api/migration-guide.md). The migration is mostly a change of base URL and headers plus a remapping of the `ftReceiptCase`, `ftChargeItemCase`, and `ftPayItemCase` values.

## Existing fiskaltrust Integrations

**Q: Do existing fiskaltrust integrations need to be adapted?**

A: Not necessarily. For a pure receipt display, an existing `/sign` integration can be extended from the fiskaltrust.Portal by [configuring the POS API Helper](../introduction/introduction.md#configuring-pos-api-helper) on the CashBox. The POS software stays unchanged, and every signed receipt is pushed to the paired InStore App.

Note that the POS API Helper does not log delivery statuses (scanned, acknowledged, printed). In Austria, this logging is required to prove compliance with the obligation to issue and accept receipts, so for production rollouts the `/issue` endpoint of the POS System API is the recommended path. Payment via the InStore App also requires the POS System API. See the [Digital Receipt Implementation](../../digital-receipt/implementation/digital-receipt-implementation.md) page for details.

**Q: Which adaptations are typically required?**

A: For a full integration on the POS System API v2, the typical changes are:

- Switch the base URL to the v2 endpoint and send the `x-cashbox-id`, `x-cashbox-accesstoken`, `x-possystem-id`, and `x-operation-id` headers.
- Call `/issue` with the `/sign` request and response pair after each signed receipt, and optionally poll the delivery status.
- Call `/pay` for electronic payments and take over the returned `ftPayItems` into `cbPayItems`, including the handling of tips (a tip is reported as a second, negative pay item).
- Send a consistent `cbTerminalID` so that each request reaches the intended device.
- Implement idempotent retries: on a timeout, resend the same request with the same `x-operation-id` (for `/pay`, query `/PayResponse` with the original operation ID).
- Respect the `ftState` flags of the receipt response. If the security mechanism is out of service, print a paper receipt instead of issuing a digital one. See [Failure or disruption of internet connection](../../digital-receipt/implementation/digital-receipt-implementation.md#failure-or-disruption-of-internet-connection).

**Q: Can existing merchants activate the InStore App without major changes?**

A: Yes. For a merchant whose POS is already fiscalized through fiskaltrust, the activation path is:

1. Check the master data of the outlet in the fiskaltrust.Portal (address, legal name, optional logo).
2. On a local CashBox, add and activate the POS API Helper, rebuild the configuration, and restart the Middleware. On a Cloud CashBox with the POS System API, no additional helper is required.
3. Install the InStore App on the device and pair it with the CashBox via PIN.
4. Configure printer and Terminal ID in the app.

Digital receipt bundles are ordered per CashBox in the fiskaltrust.Portal, see [Bundles](../../digital-receipt/bundles.md). No change to the POS software is needed for this receipt-only scenario.

## Loyalty

**Q: Can existing loyalty programs be connected?**

A: There is currently no dedicated loyalty endpoint in the POS System API or the InStore App. The loyalty logic remains in the POS system or the loyalty provider's platform. What fiskaltrust provides today are touch points that a loyalty solution can build on:

- The **digital receipt** can be shared from the receipt page into third-party apps (for example ReceiptHero), and it can be retrieved programmatically by receipt identifier so a loyalty platform can import purchase data. See [Delivery](../../experience-middleware/delivery.md).
- The receipt request carries **customer and payment data**: `cbCustomer` for a customer reference, the pay item type "Loyalty Program/Customer Card", and voucher handling for redemptions. These are shown on the receipt where applicable.
- The InStore App can show a **merchant web page on its idle screen** via the [webview URL](../available-settings/settings.md#enable-webview-url) setting, for example a loyalty sign-up page.

If you need a specific loyalty integration, contact fiskaltrust to discuss the roadmap.

**Q: Are there restrictions when choosing a loyalty provider?**

A: No. Because fiskaltrust does not integrate a specific loyalty provider, the choice of provider is not restricted by the InStore App. The provider needs to be integrated by the POS system or use the digital receipt as its data source.

**Q: Which interfaces are available for integrating loyalty solutions?**

A: The interfaces available today are the POS System API receipt data (`/sign` and `/issue`, including `cbCustomer` and the pay item types), the digital receipt's share function and retrieval by receipt identifier, and the InStore App webview URL for merchant content. A dedicated loyalty API is not available yet.

## Payment

**Q: Is the InStore App required to use the payment functions?**

A: Yes. fiskaltrust's payment integration is delivered through the InStore App. The app hosts the connection to the payment provider, either by driving a SoftPOS payment app installed on the same device (for example Softpay.io, GP tom, Viva, Worldline Tap on Mobile) or by talking to a hardware terminal (for example Hobex ECR or Shift4). The POS system only calls the `/pay` endpoint; the InStore App executes the payment on the device identified by `cbTerminalID`. See [Payment](../../experience-middleware/payment.md) and the [PSP feature matrix](../../experience-middleware/payment.md#payment-service-provider-psp-feature-matrix).

**Q: Can payments be processed independently of the InStore App?**

A: Not through fiskaltrust. A POS system can of course keep its own direct payment provider integration and pass the payment result as `cbPayItems` (with the transaction data in `ftPayItemCaseData`) into `/sign`. Fiscalization and digital receipts work in the same way in that case. Only the unified `/pay` endpoint and the provider independence it brings require the InStore App.

**Q: Is there a central or single payment endpoint for the integration?**

A: Yes. The `/pay` endpoint of the POS System API is the single entry point for all payment providers. A request contains the `action` (`payment`, `refund`, or `cancel`), the `protocol` (`use_auto` to accept whichever provider is configured on the device, or a specific provider protocol), the `cbPayItem` with amount and description, and the `cbTerminalID`. The result of a payment that could not be received (for example after a connection loss) is retrieved via `/PayResponse` with the same `x-operation-id`. The sandbox base URL is `https://possystem-api-sandbox.fiskaltrust.eu/v2`, the production base URL is `https://possystem-api.fiskaltrust.eu/v2`.

**Q: What advantages does the InStore App offer in addition to a pure payment integration?**

A: The main benefits are:

- **Provider independence**: The POS integrates `/pay` once. The payment provider is selected in the InStore App settings and can be changed without touching the POS software.
- **One device for payment, customer display, and printing**: Receipt display, QR code, email, SMS, and paper printing run on the same device as the payment, which reduces hardware at the POS.
- **Linked payment and receipt data**: The `ftPayItems` returned by `/pay` (including tips) go straight into `/sign`, so the fiscal receipt and the digital receipt carry the payment details without manual mapping.
- **Multi-terminal routing**: Payments and receipts are routed to the right device via `cbTerminalID`, which supports mobile ordering, queue busting, and multiple checkouts on one CashBox.
- **Compliance logging**: Delivery statuses of digital receipts are logged, which is required in Austria and useful in Germany.
- **Easy demos and testing**: The Dummy Payment Provider in the sandbox lets you demonstrate and test the complete flow, including declines, timeouts, and tips, without a real payment provider.

## Receipt and Fiscalization

**Q: Where does the data for the digital receipt come from if no fiskaltrust fiscalization is used?**

A: The receipt data always comes from the POS system through the POS System API. The InStore App has no receipt data source of its own. The receipt document is rendered by fiskaltrust from the `/sign` request and response pair that the POS passes to `/issue`. Where no fiscal signature is legally required, the POS still sends the receipt through `/sign` with the applicable non-fiscal receipt case so that a receipt entry exists in the Middleware. A digital receipt without a Middleware receipt is not available (see [Getting Started](../../digital-receipt/implementation/getting-started.md)).

**Q: How is fiscalized receipt data provided for the receipt?**

A: After `/sign` returns the signed receipt, the POS calls `/issue` with the receipt request and receipt response. fiskaltrust stores the receipt document in the fiskaltrust.Cloud, returns the document URL to the POS, and pushes the receipt to the InStore App instances paired with the CashBox that match the `cbTerminalID`. The app then shows the receipt number, amount, and QR code and offers OK, Print, Email, and SMS. Every consumer action is logged. The POS can check whether the receipt was delivered via `GET /issue/{queueId}/{queueItemId}/delivered`, which returns `200` when delivered and `204` while still pending. Legacy POS API v0 integrations use the `/print` endpoint with the same request and response pair, as documented in the [Introduction](../introduction/introduction.md).

**Q: Which data must the POS system provide?**

A: At minimum, the receipt request must contain `cbTerminalID`, `cbReceiptReference`, `cbReceiptMoment` (in UTC), `ftReceiptCase`, the charge items (`Quantity`, `Description`, `Amount`, `VATRate`, `ftChargeItemCase`, `Moment`), and the pay items (`Quantity`, `Description`, `Amount`, `ftPayItemCase`). Card transaction details from the payment provider should be passed in `ftPayItemCaseData` so they appear on the receipt. Optional fields such as `cbReceiptAmount`, `cbCustomer`, additional receipt lines, and item lines improve the receipt. The merchant's address and logo come from the outlet master data in the fiskaltrust.Portal. See the [mandatory fields for digital receipt visualization](../../digital-receipt/implementation/digital-receipt-implementation.md#mandatory-fields-for-digital-receipt-visualization).

**Q: What role does fiskaltrust play in the receipt process without active fiscalization?**

A: fiskaltrust acts as the receipt platform: it stores the receipt document tamper-proof in the fiskaltrust.Cloud, renders it as a tracking-free HTML page behind a unique HTTPS link, delivers it through the selected channel (QR code, print, email, SMS), logs the delivery status, and orchestrates the payment through the InStore App. The receipt still passes through the fiskaltrust.Middleware so that it can be issued, even when no signature is legally required.

## For Developers

**Q: Which APIs must be integrated for the InStore App?**

A: Only the [fiskaltrust POS System API](../../possystem-api/introduction.md) (v2). There is no separate InStore App SDK. The relevant endpoints are `/echo` for the connectivity check, `/pay` for payments, `/sign` for fiscalization, and `/issue` for receipt delivery. `/journal` is used for exports and closings and is not InStore App specific. The [POS System API Development Kit](https://github.com/fiskaltrust/possystemapi-devkit/blob/main/README.MD) on GitHub contains C# how-tos for payment, signing, and the combined pay-sign-issue flow, plus a reusable client library and instructions for inspecting the traffic with mitmproxy. For Android POS apps running next to the local Middleware, the same endpoints are also reachable via [Android Intents](../../possystem-api/android-intent.md).

**Q: Which endpoints are relevant for Payment, Receipt, and Loyalty?**

A:

| Area | Endpoints | Notes |
|------|-----------|-------|
| Payment | `POST /pay`, `POST /PayResponse` | `action`: `payment`, `refund`, `cancel`. `protocol`: `use_auto` or a provider-specific value. `/PayResponse` returns the result of a `/pay` call by `x-operation-id`. |
| Receipt | `POST /sign`, `POST /issue`, `GET /issue/{queueId}/{queueItemId}/delivered`, `GET /issue/{queueId}/{queueItemId}/link/qrcode` | `/issue` takes the `/sign` request and response pair and returns the document URL. The delivered call returns `200` once the consumer received the receipt. |
| Loyalty | No dedicated endpoint | Use `cbCustomer` and pay item types in `/sign`, the digital receipt share function, and retrieval by receipt identifier. |

*Table 1. POS System API endpoints relevant for the InStore App.*

For request and response models, see the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api).

**Q: Which data flows exist between the POS system, the InStore App, and fiskaltrust?**

A: A complete checkout consists of three flows:

1. **Payment**: The POS sends `/pay` with amount, protocol, and `cbTerminalID` to the POS System API. fiskaltrust pushes the payment action to the InStore App on the matching device, which starts the payment app or terminal. The result, including tips, is returned to the POS as `ftPayItems`. If the POS loses the response, it queries `/PayResponse` with the same operation ID.
2. **Fiscalization**: The POS sends `/sign` with charge items and the pay items from step 1. The Middleware fiscalizes the receipt according to the market rules and returns the receipt response.
3. **Issuing**: The POS sends `/issue` with the request and response pair. fiskaltrust stores the receipt, returns the document URL, and pushes the receipt to the InStore App, which displays QR code, OK, Print, Email, and SMS. Consumer interactions are logged in the fiskaltrust backend, and the POS can poll the delivered status.

The InStore App never communicates with the POS directly. All communication runs through the fiskaltrust backend, and the `cbTerminalID` determines which device reacts. The architecture diagrams in the [Development Kit](https://github.com/fiskaltrust/possystemapi-devkit/blob/main/README.MD) illustrate the mobile-ordering and customer-display deployments.

**Q: How can an existing integration be extended to support the InStore App?**

A: Follow these steps:

1. If the integration still uses the v0 interface, migrate to the POS System API v2 according to the [Migration Guide](../../possystem-api/migration-guide.md). Cloud CashBoxes work without extra configuration; local CashBoxes need the LocalPosSystemApi helper (see [PosSystem API Platforms](../../../../posdealers/technical-operations/possystem-api-platforms/overview.md)).
2. Pair an InStore App with a sandbox CashBox and select the Dummy Payment Provider.
3. Add the `/issue` call after each successful `/sign` and pass the same `cbTerminalID`. Verify that the receipt appears on the device.
4. Add the `/pay` call before `/sign`, pass the returned `ftPayItems` into `cbPayItems`, and implement the retry via `/PayResponse`. Test the special amounts of the Dummy Payment Provider for declines, timeouts, and tips.
5. Handle the `ftState` flags for out-of-service situations and print a paper receipt in that case.
6. Configure the Terminal ID Filter on each device according to the [Multi-Terminal Setup](../multiterminal-settings/multiterminal.md) rules, then switch to a production CashBox and a real payment provider.
