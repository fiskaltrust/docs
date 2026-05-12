---
title: Introduction
slug: /poscreators/experience-middleware/introduction
---

# Introduction

The **Experience Middleware** extends the fiskaltrust.Middleware with features that improve the checkout experience for merchants and consumers, without changing existing POS workflows.

While the compliance stack focuses on fiscal requirements such as receipt signing, journaling, and reporting, the Experience Middleware builds on top of these core capabilities to enable modern, customer-facing features, such as **digital receipts**, **customer interaction**, and **integrated payment flows**.

## Included Experience Components

The Experience Middleware consists of the following components:

- **Payment**: Integrates payment flows into the fiskaltrust platform using a unified payment endpoint, while keeping POS systems independent of specific payment providers.

- **Delivery**: Defines how receipts and invoices are handed over after checkout, including digital receipt, printed receipt, structured invoice, and upcoming e-invoicing flows.

- **Digital Receipt**: Enables receipts to be delivered digitally via QR code, link, message, or other channels after a transaction has been fiscalized.

- **InStore App**: A customer-facing application that displays receipts, QR codes, and receipt interaction options at the point of sale.

Each component can be used independently or combined, depending on the business case and market requirements.

## Intended Audience

This documentation is primarily for **PosCreators** and integrators who want to:
- Enhance checkout flows with digital receipts and customer interactions.
- Integrate customer-facing devices or displays.
- Combine fiscalization and payments through a single middleware layer.
