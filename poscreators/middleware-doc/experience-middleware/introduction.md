---
title: Introduction
slug: /poscreators/experience-middleware/introduction
---

# Introduction

The **Experience Middleware** extends the fiskaltrust.Middleware with features that improve the checkout experience for merchants and consumers, without changing existing POS workflows.

While the compliance stack focuses on fiscal requirements such as receipt signing, journaling, and reporting, the Experience Middleware builds on top of these foundations to enable modern, customer-facing features like **digital receipts**, **customer interaction**, and **integrated payment flows**.

The Experience Middleware is designed to be:
- **POS-agnostic** – works with existing POS systems
- **Optional and modular** – features can be enabled as needed
- **Compliance-aware** – all experience features are tied to fiscalized transactions

## Included Experience Components

The Experience Middleware currently consists of the following components:

- **Digital Receipt**  
  Enables receipts to be delivered digitally via QR code, link, message, or other channels after a transaction has been fiscalized.

- **InStore App**  
  A customer-facing application that displays receipts, QR codes, and receipt interaction options at the point of sale.

- **Payments (optional)**  
  Integrates payment flows into the fiskaltrust ecosystem using a unified payment endpoint, while keeping POS systems independent of specific payment providers.

Each component can be used independently or combined, depending on the business case and market requirements.

## Intended Audience

This documentation is primarily for **POS creators and integrators** who want to:
- Enhance checkout flows with digital receipts and customer interactions
- Integrate customer-facing devices or displays
- Optionally combine fiscalization and payments through a single middleware layer

The following sections describe each Experience component in detail and explain typical integration and usage scenarios.
