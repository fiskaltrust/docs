---
title: Payment
slug: /poscreators/experience-middleware/payment
---

# Payment

The **Payment** component of the Experience Middleware allows POS systems to integrate payments through fiskaltrust without being tied to a single payment service provider.

Rather than replacing existing POS payment logic, fiskaltrust provides a **unified payment endpoint** that can be used alongside fiscalization and digital receipt features. This keeps integrations flexible and avoids vendor lock-in.

Payments are integrated through the **InStore App** and the fiskaltrust.Middleware, allowing transactions, fiscal receipts, and optional digital receipts to be handled in a coordinated flow.

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
