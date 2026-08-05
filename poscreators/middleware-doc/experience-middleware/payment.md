---
title: Payment
slug: /poscreators/experience-middleware/payment
---

# Payment

The **Payment** component of the Experience Middleware allows POS systems to integrate payments through fiskaltrust without being tied to a single payment service provider.

Rather than replacing existing POS payment logic, fiskaltrust provides a **unified payment endpoint** that can be used alongside fiscalization and digital receipt features. This keeps integrations flexible and avoids vendor lock-in.

Payments are integrated through the **InStore App** and the POS System API, allowing transactions, fiscal receipts, and optional digital receipts to be handled in a coordinated flow.

## Key Design Principles

The payment solution follows these core principles:

- **Single POS integration**: POS systems integrate once with the fiskaltrust payment endpoint and remain independent of specific payment providers.

- **Optional usage**: Payments can be used with or without fiskaltrust fiscalization, depending on the market and setup.

- **No mandatory lock-in**: Merchants and partners are not forced into a single PSP (Payment Service Provider) or hardware setup.

- **Experience-driven**: Payment flows can be combined with digital receipts and InStore App interactions to create a smoother checkout experience.

## Payment Integration Flow in the Experience Stack

A typical payment-enabled flow consists of the following steps:

1. The POS initiates a payment using the unified fiskaltrust payment endpoint.
2. The selected payment provider processes the transaction.
3. fiskaltrust links payment data with the fiscalized receipt.
4. The receipt can optionally be displayed or handed over via InStore App, QR code, or Digital receipt channels.

This approach ensures that fiscalization, receipts, and payments remain technically linked while staying modular.

## Intended Audience for Payment Integration

Payment integration is primarily relevant for:

- **PosCreators** who want to support multiple payment providers with a single integration.
- **PosDealers** managing merchant rollouts across markets.
- **PosOperators** who want simpler setups, fewer devices, or hardware-free payment options where available.

## Payment Service Provider (PSP) Feature Matrix

The matrix below shows which payment features are supported per vendor. Use it to plan integrations and to spot gaps where fiskaltrust can help.

| PSP | payment | refund | unreferenced-refund | cancel | Transaction Status Check | TIP<br />(pay-app → fiskaltrust) | TIP<br />(fiskaltrust → pay-app) | under-payment | batch processing<br />(close-batch) | merchant receipt support<br />(in addition to customer receipt) |
| --- | ------- | ------ | ------------------- | ------ | -------------------------- | ---------------------------------- | ---------------------------------- | --------------- | -------------------------------------- | ----------------------------- |
| Viva | 1.2.5+ | 1.3.0+ | – | 1.3.0+ | ? | 1.3.0+ | – | ? | ? | ? |
| Hobex POSit | 1.2.8+ | 1.3.0+ | – | 1.3.0+ | 1.3.0+ | 1.3.0+ | ? | ? | yes (auto) | ? |
| Hobex ECR | 1.2.5+ | 1.3.0+ | – | 1.3.0+ | 1.3.0+ | 1.3.0+ | ? | ? | ? | ? |
| Worldline / PayOne WPI<br />(TOM + SmartPOS) | 1.2.5+ | 1.3.0+ | n/a | 1.3.0+ | 1.3.0+ | 1.3.0+ | – | ? | n/a | ? |
| Softpay\.io | 1.2.8+ | 1.3.0+ | – | 1.3.0+ | 1.3.0+ | 1.3.0+ | ? | ? | yes (auto) | ? |
| Global Payments<br />GPtom | 1.2.5+ | 1.3.0+ | ? | 1.3.0+ | 1.2.8+ | 1.3.0+ | ? | ? | – | ? |
| Global Payments<br />GP Pay | 1.2.5+ | 1.3.0+ | ? | 1.3.0+ | ? | 1.3.0+ | ? | ? | ? | ? |
| Shift4 | 1.2.8+ | 1.2.8+ | n/a | 1.2.8+ | 1.3.0+ | 1.3.0+ | – | – | n/a | ? |
| SumUp (PaymentSwitch) <sup>1)</sup> | 1.3.2+ | 1.3.2+ | ? | 1.3.2+ | ? | ? | ? | ? | ? | ? |
| Nexi SoftPOS<br />(MyPayments) | 1.3.2+ | 1.3.2+ | ? | 1.3.2+ | ? | ? | ? | ? | ? | ? |

### Notes

**1) SumUp**

- `payment` is performed via the installed [SumUp Android app](https://play.google.com/store/apps/details?id=com.kaching.merchant) (see also [SumUp: download the app](https://help.sumup.com/en-US/articles/7mfghXVvILv2QJW3RyJlF9-app-herunterladen)).
- `refund` and `cancel` are performed via the SumUp cloud API, which requires a configured API key (see [SumUp: API keys](https://developer.sumup.com/tools/authorization/api-keys)).
- The extended receipt information required in most countries is also retrieved via the SumUp cloud API and therefore also requires an API key.
- Without a configured API key, only the `payment` action is supported via the installed SumUp app.

:::tip Recommended setup

Install the SumUp Android app and configure the merchant's API key for the full feature support. See the [SumUp documentation](https://developer.sumup.com/) for further details.

:::

### Legend

| Value | Meaning |
| ----- | ------- |
| `1.x.y+` | Available from this InStore App release onwards. |
| `yes (auto)` | Supported and handled automatically by the PSP; no configuration in fiskaltrust required. |
| `–` | Supported by the PSP, but not yet implemented by fiskaltrust and not currently planned. |
| `?` | Not yet confirmed with the PSP. |
| `n/a` | Not supported by the PSP. |
